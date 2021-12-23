# Download and process the E-MTAB-3610 dataset

[E-MTAB-3610 - Transcriptional Profiling of 1,000 human cancer cell lines](https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-3610/) - Basal expression profiles of 1,000 human cancer cell lines in the Genomics of Drug Sensitivity in Cancer (GDSC) panel, profiled using a diverse collection of 265 compounds.

The data is large, 5.11Gb, raw .cel files. [Processing_E-MTAB-3610.R](Processing_E-MTAB-3610.R) script downloads the data and annotations, normalizes, summarizes and saves the gene x cell expression matrix and the matched cell annotations.

Summarized log2-transformed data snippet from [E-MTAB-3610_matrix.csv.gz](E-MTAB-3610_matrix.csv.gz):

```
         CAL-120  DMS-114   CAL-51    H2869     H290
A1BG    6.199325 5.016096 5.512254 4.204612 3.399536
A1CF    3.046332 3.061568 3.077774 3.071189 3.093294
A2M     2.894157 3.047268 2.792587 2.933927 2.937153
A2ML1   2.774854 2.766677 4.194688 2.677076 2.807157
A3GALT2 2.751217 2.855706 3.012403 2.630588 2.685035
```

Cell annotation snippet from [E-MTAB-3610_cell_annotations.csv.gz](E-MTAB-3610_cell_annotations.csv.gz)

```
                        Source Name Characteristics[organism] Characteristics[cell line] Material Type Protocol REF...5
1 J132_EPA01P1_CAL-120_Breast_906826              Homo sapiens                    CAL-120          cell     P-MTAB-44941
2   J132_EPA02P1_DMS-114_Lung_687983              Homo sapiens                    DMS-114          cell     P-MTAB-44941
3  J132_EPA03P1_CAL-51_Breast_910927              Homo sapiens                     CAL-51          cell     P-MTAB-44941
4    J132_EPA04P1_H2869_Lung_1240138              Homo sapiens                      H2869          cell     P-MTAB-44941
5     J132_EPA05P1_H290_Lung_1240139              Homo sapiens                       H290          cell     P-MTAB-44941
```

# Notes

Some `.zip` files appear incomplete (E-MTAB-3610.raw.2.zip, 9, 12, 20, 23). 

811 `.cel` files extracted successfully.


