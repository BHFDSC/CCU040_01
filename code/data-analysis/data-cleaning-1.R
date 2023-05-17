##############################################
## 1) First load the libraries that we need ##
##############################################
library(dplyr)
library(here)
library(furniture)

# Recommended best practice - clears all values from the environment
rm(list = ls())

## Set working directory to current file (only works in RStudio)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

####################################################################################
## 2) Connect to database and load output from table into a dataframe             ##
## When prompted enter this key as password: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ##
## If it fails then goto Databricks > Settings > User Settings > Access tokens    ##
## Generate a new token and copy it above.                                        ##
####################################################################################
con <- DBI::dbConnect(odbc::odbc(),
                      "Databricks",
                      timeout = 60,
                      PWD = rstudioapi::askForPassword("Password please:"))

tableCovidFromGPData <- "CCU040_01_Output_Cohort_Table"
tableCovidFromSGSS <- "CCU040_01_SGSS_Output_Cohort_Table"

# Change this in order to change between data using GP data for COVID tests (as per original study)
# or SGSS data which is the pillar X testing database
#table <- tableCovidFromGPData
table <- tableCovidFromSGSS

type1FileName <- if(table==tableCovidFromGPData) "t1d_df_eth.rds" else "t1d_df_sgss_eth.rds"
type2FileName <- if(table==tableCovidFromGPData) "t2d_df_eth.rds" else "t2d_df_sgss_eth.rds"

df <- DBI::dbGetQuery(con, paste0("SELECT * FROM dars_nic_391419_j3w9t_collab.", table))

# Takes less than 1 minute to populate the dataframe


###################################################################
## 3) Tidy up some of the columns, casting to correct types etc. ##
###################################################################
# Change dates from chr to date
df$COVIDPositiveTestDate <- as.Date(df$COVIDPositiveTestDate)

df$DeathDate <- as.Date(df$DeathDate)
df$daystodeath <- difftime(df$DeathDate, df$COVIDPositiveTestDate, units = "days")


df$FirstAdmissionPostCOVIDTest <- as.Date(df$FirstAdmissionPostCOVIDTest)
df$admissiondate <- as.Date(df$FirstAdmissionPostCOVIDTest)
df$timetoadmission <- difftime(df$admissiondate, df$COVIDPositiveTestDate, units = "days")

df$DeathDate <- as.Date(df$DeathDate)
df$daystodeath <- difftime(df$DeathDate, df$COVIDPositiveTestDate, units = "days")

df$FirstDiagnosisDate <- as.Date(df$FirstDiagnosisDate)
df$FirstT1DiagnosisDate <- as.Date(df$FirstT1DiagnosisDate)
df$FirstT2DiagnosisDate <- as.Date(df$FirstT2DiagnosisDate)

# Change chr to integer 
#df[,c(2, 3, 8, 9, 15, 17:25)] <- sapply(df[,c(2, 3, 8, 9, 15, 17:25)],as.numeric)
df$YearOfBirth <- substr(df$YearOfBirth,0,4)
df[,c(3,8, 9, 15, 17:25)] <- sapply(df[,c(3,8, 9, 15, 17:25)],as.numeric)
# TODO don't rely on numbers of columns - use names instead
# Change chr to factor
df[,c(5, 6, 16, 26:35)] <- lapply(df[,c(5, 6, 16, 26:35)],as.factor)

# Generate NAs where values out of limits
# HBA1C (200), LDL(15), HDL(5), vitamin (300), testosterone (80), SHBG and cholesterol(40)
df$LatestBMIValue <- ifelse(df$LatestBMIValue < 80 & df$LatestBMIValue >12 , df$LatestBMIValue, NA)
df$LatestHBA1CValue <- ifelse(df$LatestHBA1CValue < 200 , df$LatestHBA1CValue, NA)
df$LatestCHOLESTEROLValue <- ifelse(df$LatestCHOLESTEROLValue < 40 , df$LatestCHOLESTEROLValue, NA)
df$LatestLDLValue <- ifelse(df$LatestLDLValue < 15 , df$LatestLDLValue, NA)
df$LatestHDLValue <- ifelse(df$LatestHDLValue < 5 , df$LatestHDLValue, NA)
df$LatestVITAMINDValue <- ifelse(df$LatestVITAMINDValue < 300 , df$LatestVITAMINDValue, NA)
df$LatestTESTOSTERONEValue <- ifelse(df$LatestTESTOSTERONEValue < 80 , df$LatestTESTOSTERONEValue, NA)
df$LatestEGFRValue <- ifelse(df$LatestEGFRValue < 250 , df$LatestEGFRValue, NA)

# Generate age
df$age <- 2021 - df$YearOfBirth

###############################################
## 4) Generate the 2 data sets (t1d and t2d) ##
###############################################
# First identify those with t1 and t2 diabetes
df$diab <- 0
df2 <- df %>% filter(is.na(FirstDiagnosisDate) == "FALSE" )

df2$diab1 <- ifelse(df2$FirstDiagnosisDate==df2$FirstT1DiagnosisDate,1,0)
df2$diab1 <- ifelse(is.na(df2$diab1)=="TRUE",0,df2$diab1)
df2$diab2 <- ifelse(df2$FirstDiagnosisDate==df2$FirstT2DiagnosisDate,2,0)
df2$diab2 <- ifelse(is.na(df2$diab2)=="TRUE",0,df2$diab2)

table(df2$diab1)
table(df2$diab2)

df2$diab <- ifelse(df2$diab1==1,1,0)
df2$diab <- ifelse(df2$diab2==2,2,df2$diab) # if t1d and t2d then pick first. If same day then label as t2d
df_diab <- df2

df2 <- df_diab %>% filter(diab==2)
t2 <- df[which(df$MainCohortMatchedPatientId %in% df2$PatientId),]
t2 <- rbind(t2, df2[which(df2$diab==2),-46:-47])
table(t2$diab)

## This code takes 3 of the 5 matches and is from the original study
# df1 <- df_diab %>% filter(diab==1)
# t1 <- df[which(df$MainCohortMatchedPatientId %in% df1$PatientId),]
# t1 <- t1[order(t1[,2],-t1[,45]),]
# test <- t1 %>% group_by(MainCohortMatchedPatientId) %>% slice(1:3)
# test <- ungroup(test)
# t1 <- rbind(test, df1[which(df1$diab==1),-48:-49])

## df1 is just T1DM
df1 <- df_diab %>% filter(diab==1)
t1 <- df[which(df$MainCohortMatchedPatientId %in% df1$PatientId),]
t1 <- rbind(t1, df1[which(df1$diab==1),-46:-47])
table(t1$diab)


###################################################################################
## 5) Add named ethnic groups rather than the existing NHS letter classification ##
###################################################################################
t1$ethnicity <- ifelse(t1$EthnicCategoryDescription %in% c('A','B','C'),'White',NA)
t1$ethnicity <- ifelse(t1$EthnicCategoryDescription %in% c('D','E','F','G'),'Mixed',t1$ethnicity)
t1$ethnicity <- ifelse(t1$EthnicCategoryDescription %in% c('H','J','K','L'),'Asian',t1$ethnicity)
t1$ethnicity <- ifelse(t1$EthnicCategoryDescription %in% c('M','N','P'),'Black',t1$ethnicity)
t1$ethnicity <- ifelse(t1$EthnicCategoryDescription %in% c('R','S'),'Other',t1$ethnicity)

t2$ethnicity <- ifelse(t2$EthnicCategoryDescription %in% c('A','B','C'),'White',NA)
t2$ethnicity <- ifelse(t2$EthnicCategoryDescription %in% c('D','E','F','G'),'Mixed',t2$ethnicity)
t2$ethnicity <- ifelse(t2$EthnicCategoryDescription %in% c('H','J','K','L'),'Asian',t2$ethnicity)
t2$ethnicity <- ifelse(t2$EthnicCategoryDescription %in% c('M','N','P'),'Black',t2$ethnicity)
t2$ethnicity <- ifelse(t2$EthnicCategoryDescription %in% c('R','S'),'Other',t2$ethnicity)

saveRDS(t1, file = here("dars_nic_391419_j3w9t_collab", "CCU040", "data", type1FileName))
saveRDS(t2, file = here("dars_nic_391419_j3w9t_collab", "CCU040", "data", type2FileName))

