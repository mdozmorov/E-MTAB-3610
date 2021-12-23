# https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-3610/
# Download the dada, ~5Gb
library(ArrayExpress)
getAE(accession = "E-MTAB-3610")
# E-MTAB-3610.raw.1.zip .. E-MTAB-3610.raw.25.zip - .cel files
for (f in list.files(pattern = "zip")) {
  unzip(f, junkpaths = TRUE) # Unzip, ignore folders
}

# Read the data
library(affy)
arrays <- read.affybatch(filenames = list.files(pattern = "cel"))
# Normalize
eset = rma(arrays)
# Get expression matrix
mtx <- exprs(eset)
# Clean up column names
colnames(mtx) <- sub(pattern = ".cel", "", colnames(mtx), fixed = TRUE)

# Cell annotations
library(readr)
sample_annotations <- read_tsv("E-MTAB-3610.sdrf.txt")
# Get common array names
common_colnames <- intersect(colnames(mtx), sample_annotations$`Assay Name`)
# Subset and match both matrices
mtx <- mtx[, colnames(mtx) %in% common_colnames]
sample_annotations <- sample_annotations[sample_annotations$`Assay Name` %in% common_colnames, ]
sample_annotations <- sample_annotations[match(colnames(mtx), sample_annotations$`Assay Name`), ]
all.equal(colnames(mtx), sample_annotations$`Assay Name`) # Check if matching worked

# Gene annotations
# BiocManager::install("hgu219.db", update = FALSE)
library(hgu219.db)
k <- keys(hgu219.db,keytype="PROBEID")
gene_annotations <- select(hgu219.db, keys=k, columns=c("SYMBOL","GENENAME"), keytype="PROBEID")
# Get common gene names
common_genes <- intersect(rownames(mtx), gene_annotations$PROBEID)
# Subset and match both matrices
mtx <- mtx[rownames(mtx) %in% common_genes, ]
gene_annotations <- gene_annotations[gene_annotations$PROBEID %in% common_genes, ]
gene_annotations <- gene_annotations[match(rownames(mtx), gene_annotations$PROBEID), ]
all.equal(rownames(mtx), gene_annotations$PROBEID)  # Check if matching worked

# Aggregate multiple gene IDs (rows) using the MaxMean method
# It will replace probe IDs with readable gene names
library(WGCNA)
mtx_collapsed <- collapseRows(datET = mtx, rowGroup = gene_annotations$SYMBOL, rowID = rownames(mtx))$datETcollapsed
# Replace array names with cell line names
colnames(mtx_collapsed) <- sample_annotations$`Characteristics[cell line]`

# Prepare data to save
# Add Probe IDs to the  matrices
mtx <- data.frame(PROBEID = rownames(mtx), mtx)
mtx_collapsed <- data.frame(GENE = rownames(mtx_collapsed), mtx_collapsed)
# Save summarized matrix
source("https://raw.githubusercontent.com/mdozmorov/MDmisc/master/R/round_df.R")
write_csv(round_df(mtx_collapsed), "E-MTAB-3610_matrix.csv")
R.utils::gzip("E-MTAB-3610_matrix.csv")
# Save cell annotations
write_csv(sample_annotations, "E-MTAB-3610_cell_annotations.csv")
R.utils::gzip("E-MTAB-3610_cell_annotations.csv")

# Save all data in Excel
library(writexl)
x <- list(Summarized = mtx_collapsed, Samples = sample_annotations, Original = mtx,  Genes = gene_annotations)
write_xlsx(x, "E-MTAB-3610_processed.xlsx")
