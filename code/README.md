# Code

Analysis and curation code related to the analysis conducted for this project.

## Data curation

The following files are the data curation pipeline and can be found in Databricks. The actual SNOMED codes are not included, but there are references to the code sets in the phenotypes directory e.g. `/*--diabetes--*/` would be replaced with the list of SNOMED codes for diabetes. The culmination of files `CCU040_01--01`, `CCU040_01--02` and `CCU040_01--03` is a table `dars_nic_391419_j3w9t_collab.CCU040_01_Output_Cohort_Table` which contains all the data necessary for the analysis on the cohort defined by COVID tests in the GP record. The culmination of files `CCU040_01--04`, `CCU040_01--05` and `CCU040_01--06` is a table `dars_nic_391419_j3w9t_collab.CCU040_01_SGSS_Output_Cohort_Table` which contains all the data necessary for the analysis on the cohort defined by COVID tests in the SGSS dataset.

| File                                                                                                                         | Description                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [CCU040_01--01-define-cohort.template.sql](./CCU040_01--01-define-cohort.template.sql)                                       | Initial cohort definition for the cohort defined by GP recorded COVID tests |
| [CCU040_01--02-perform-matching.template.py](./CCU040_01--02-perform-matching.template.py)                                   | Creating the matched cohort for the GP defined cohort                       |
| [CCU040_01--03-collate-remaining-data.template.sql](./CCU040_01--03-collate-remaining-data.template.sql)                     | Collate the remaining data required e.g. covariates                         |
| [CCU040_01--04-define-cohort-with-sgss.template.sql](./CCU040_01--04-define-cohort-with-sgss.template.sql)                   | Cohort definition for the cohort defined by SGSS COVID tests                |
| [CCU040_01--05-perform-matching-with-sgss.template.py](./CCU040_01--05-perform-matching-with-sgss.template.py)               | Creating the matched cohort for the SGSS defined cohort                     |
| [CCU040_01--06-collate-remaining-data-with-sgss.template.sql](./CCU040_01--06-collate-remaining-data-with-sgss.template.sql) | Collate the remaining data required e.g. covariates                         |
| [CCU040_01-lsoa.template.sql](./CCU040_01-lsoa.template.sql)                                                                 | Obtain the LSOA for each patient                                            |
| [CCU040_01-smoking-status.template.sql](./CCU040_01-smoking-status.template.sql)                                             | Obtain the smoking status for each patient                                  |
| [CCU040_01-townsend.template.sql](./CCU040_01-townsend.template.sql)                                                         | Obtain the Townsend index for each patient                                  |

## Analysis

The following files were used for the analysis of the data curated in the phase above.
