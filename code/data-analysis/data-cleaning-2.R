# Another data processing file
library(here)

## Set working directory to current file (only works in RStudio)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

processFile <- function(filename) {

  dm_df <- readRDS(file=here(getwd(),"data", filename))
  
  dm_df$admission <- ifelse(as.numeric(dm_df$timetoadmission<29), 1, 0)
  dm_df$admission <- ifelse(is.na(dm_df$admission)==TRUE,0, dm_df$admission)
  
  dm_df$ethnicity <- relevel(as.factor(dm_df$ethnicity), ref = "White")
  
  levels(dm_df$CurrentSmokingStatus)[levels(dm_df$CurrentSmokingStatus)=="non-trivial-smoker"] <- "trivial-smoker"
  
  dm_df$IsOnACEI <- as.factor(ifelse(is.na(dm_df$IsOnACEI)==TRUE,"N",dm_df$IsOnACEI))
  
  
  dm_df$IsOnAspirin <- as.factor(ifelse(is.na(dm_df$IsOnAspirin)==TRUE,"N",dm_df$IsOnAspirin))
  dm_df$IsOnClopidogrel <- as.factor(ifelse(is.na(dm_df$IsOnClopidogrel )==TRUE,"N",dm_df$IsOnClopidogrel ))
  dm_df$IsOnMetformin <- as.factor(ifelse(is.na(dm_df$IsOnMetformin)==TRUE,"N",dm_df$IsOnMetformin))
  
  dm_df <- dm_df[which(is.na(dm_df$TownsendScoreHigherIsMoreDeprived)==FALSE),]
  
  dm_df$adtime <- ifelse(is.na(dm_df$timetoadmission)==TRUE, 365, as.numeric(dm_df$timetoadmission))
  
  dm_df$admiss <- ifelse(is.na(dm_df$admissiondate) ==TRUE, 0,1)
  
  
  dm_df$admissionmonth <- as.numeric(format(dm_df$admissiondate, "%m"))
  dm_df$admissiony <- as.numeric(format(dm_df$admissiondate, "%y"))
  dm_df$COVIDPositiveTesty <- as.numeric(format(dm_df$COVIDPositiveTestDate, "%y"))
  dm_df$COVIDPositiveTestmonth <- as.numeric(format(dm_df$COVIDPositiveTestDate, "%m"))
  dm_df$admissionmonth <- ifelse(dm_df$admissiony==21,12+dm_df$admissionmonth, dm_df$admissionmonth)
  dm_df$COVIDPositiveTestmonth <- ifelse(dm_df$COVIDPositiveTesty==21,12+dm_df$COVIDPositiveTestmonth, dm_df$COVIDPositiveTestmonth)
  dm_df$timetoadmission_m <- dm_df$admissionmonth - dm_df$COVIDPositiveTestmonth
  dm_df$timetoadmission_m <- ifelse(is.na(dm_df$timetoadmission_m)==TRUE, 19,dm_df$timetoadmission_m)
  dm_df$LengthOfStay[dm_df$LengthOfStay < 0] <- NA
  
  saveRDS(dm_df, file = here(getwd(), "data", paste0("processed-",filename)))
}

processFile("t1d_df_eth.rds")
processFile("t2d_df_eth.rds")
processFile("t1d_df_sgss_eth.rds")
processFile("t2d_df_sgss_eth.rds")