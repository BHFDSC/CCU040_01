# Code

Analysis and curation code related to the analysis conducted for this project.

## Data curation

The following files are the data curation pipeline and can be found in Databricks.

| File                                                                                                                                       | Description                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| [CCU040_01--01-define-cohort.template.sql](./data-curation/CCU040_01--01-define-cohort.template.sql)                                       | Initial cohort definition for the cohort defined by GP recorded COVID tests |
| [CCU040_01--02-perform-matching.template.py](./data-curation/CCU040_01--02-perform-matching.template.py)                                   | Creating the matched cohort for the GP defined cohort                       |
| [CCU040_01--03-collate-remaining-data.template.sql](./data-curation/CCU040_01--03-collate-remaining-data.template.sql)                     | Collate the remaining data required e.g. covariates                         |
| [CCU040_01--04-define-cohort-with-sgss.template.sql](./data-curation/CCU040_01--04-define-cohort-with-sgss.template.sql)                   | Cohort definition for the cohort defined by SGSS COVID tests                |
| [CCU040_01--05-perform-matching-with-sgss.template.py](./data-curation/CCU040_01--05-perform-matching-with-sgss.template.py)               | Creating the matched cohort for the SGSS defined cohort                     |
| [CCU040_01--06-collate-remaining-data-with-sgss.template.sql](./data-curation/CCU040_01--06-collate-remaining-data-with-sgss.template.sql) | Collate the remaining data required e.g. covariates                         |
| [CCU040_01-lsoa.template.sql](./data-curation/CCU040_01-lsoa.template.sql)                                                                 | Obtain the LSOA for each patient                                            |
| [CCU040_01-smoking-status.template.sql](./data-curation/CCU040_01-smoking-status.template.sql)                                             | Obtain the smoking status for each patient                                  |
| [CCU040_01-townsend.template.sql](./data-curation/CCU040_01-townsend.template.sql)                                                         | Obtain the Townsend index for each patient                                  |

The actual SNOMED codes are not included, but there are references to the code sets in the phenotypes directory e.g. `/*--diabetes--*/` would be replaced with the list of SNOMED codes for diabetes. The culmination of the 3 files:

- `CCU040_01--01`
- `CCU040_01--02`
- `CCU040_01--03`

is a table:

- `dars_nic_391419_j3w9t_collab.CCU040_01_Output_Cohort_Table`

which contains all the data necessary for the analysis on the cohort defined by COVID tests in the GP record.

The culmination of the 3 files:

- `CCU040_01--04`
- `CCU040_01--05`
- `CCU040_01--06`

is a table:

- `dars_nic_391419_j3w9t_collab.CCU040_01_SGSS_Output_Cohort_Table`

which contains all the data necessary for the analysis on the cohort defined by COVID tests in the SGSS dataset.

## Analysis

The following files were used for the analysis of the data curated in the phase above.

| File                                                                                                                                       | Description                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| [data-cleaning-1.R](./data-analysis/data-cleaning-1.R)                                                                                     | First data cleaning script                                                                                             |
| [data-cleaning-2.R](./data-analysis/data-cleaning-2.R)                                                                                     | Second data cleaning script                                                                                            |
| [1.Table-One.Rmd](./data-analysis/1.Table-One.Rmd)                                                                                         | Produces the classis "table 1" for the manuscript                                                                      |
| [2.KM-plots.Rmd](./data-analysis/2.KM-plots.Rmd)                                                                                           | Kaplan maier plots of time to hospitalisation                                                                          |
| [3.1.Univariate-Analysis-T1DM.Rmd](./data-analysis/3.1.Univariate-Analysis-T1DM.Rmd)                                                       | Univariate analysis for T1DM patients using GP data for COVID tests                                                    |
| [3.2.Univariate-Analysis-T2DM.Rmd](./data-analysis/3.2.Univariate-Analysis-T2DM.Rmd)                                                       | Univariate analysis for T2DM patients using GP data for COVID tests                                                    |
| [3.3.Univariate-Analysis-T1DM-SGSS.Rmd](./data-analysis/3.3.Univariate-Analysis-T1DM-SGSS.Rmd)                                             | Univariate analysis for T1DM patients using SGSS data for COVID tests                                                  |
| [3.4.Univariate-Analysis-T2DM-SGSS.Rmd](./data-analysis/3.4.Univariate-Analysis-T2DM-SGSS.Rmd)                                             | Univariate analysis for T2DM patients using SGSS data for COVID tests                                                  |
| [4.1.Logistic-Regression-T1DM.Rmd](./data-analysis/4.1.Logistic-Regression-T1DM.Rmd)                                                       | Initial logistic regression for T1DM patients using GP data for COVID tests                                            |
| [4.2.Logistic-Regression-T2DM.Rmd](./data-analysis/4.2.Logistic-Regression-T2DM.Rmd)                                                       | Initial logistic regression for T2DM patients using GP data for COVID tests                                            |
| [4.3.Logistic-Regression-T1DM-SGSS.Rmd](./data-analysis/4.3.Logistic-Regression-T1DM-SGSS.Rmd)                                             | Initial logistic regression for T1DM patients using SGSS data for COVID tests                                          |
| [4.4.Logistic-Regression-T2DM-SGSS.Rmd](./data-analysis/4.4.Logistic-Regression-T2DM-SGSS.Rmd)                                             | Initial logistic regression for T2DM patients using SGSS data for COVID tests                                          |
| [5.1.Final-Logistic-Regression-T1DM.Rmd](./data-analysis/5.1.Final-Logistic-Regression-T1DM.Rmd)                                           | Final logistic regression for T1DM patients using GP data for COVID tests                                              |
| [5.2.Final-Logistic-Regression-T2DM.Rmd](./data-analysis/5.2.Final-Logistic-Regression-T2DM.Rmd)                                           | Final logistic regression for T2DM patients using GP data for COVID tests                                              |
| [5.3.Final-Logistic-Regression-T1DM-SGSS.Rmd](./data-analysis/5.3.Final-Logistic-Regression-T1DM-SGSS.Rmd)                                 | Final logistic regression for T1DM patients using GP data for COVID tests                                              |
| [5.3b.Final-Logistic-Regression-T1DM-SGSS-extra-analysis.Rmd](./data-analysis/5.3b.Final-Logistic-Regression-T1DM-SGSS-extra-analysis.Rmd) | Final logistic regression for T1DM patients using SGSS data for COVID tests - with slight modification for final paper |
| [5.4.Final-Logistic-Regression-T2DM-SGSS.Rmd](./data-analysis/5.4.Final-Logistic-Regression-T2DM-SGSS.Rmd)                                 | Final logistic regression for T2DM patients using SGSS data for COVID tests                                            |
