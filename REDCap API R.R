
rm(mydata,myData)

setwd("C:/Users/Zhuang49/Desktop/CDM/Redcap API")

test<-read.csv(text=paste0(head(readLines("workqueue_ILLINOIS_20170705-164315.csv"),-2)), skip=2,header=TRUE, sep=",",fileEncoding="UTF-8-BOM")

mydata<-read.csv(file="workqueue_ILLINOIS_20170705-164315_Copy.csv",header=TRUE, sep=",",fileEncoding="UTF-8-BOM")

summary(mydata)
names(mydata) <- gsub(x = names(mydata),pattern = "\\.", replacement = "_")
names(mydata)<- tolower(names(mydata))
mydata$record_id<-substr(mydata$pmi_id,2,10)

mydata1<-subset(mydata, select=-c(language,cabor_consent_status,cabor_consent_date,street_address,gender_identity,sexual_orientation,education,income))

mydata1<-mydata1[c(55,1,2:54)]
str(mydata1)
mydata1$date_of_birth <-as.Date(mydata1$date_of_birth,format="%m/%d/%Y")
cols <- c("general_consent_date", "ehr_consent_date", "withdrawal_date", "basics_ppi_survey_completion_date", "health_ppi_survey_completion_date", "lifestyle_ppi_survey_completion_date", "hist_ppi_survey_completion_date", 
          "meds_ppi_survey_completion_date", "family_ppi_survey_completion_date", "access_ppi_survey_completion_date", "physical_measurements_completion_date",
          "x8_ml_sst_collection_date", "x8_ml_pst_collection_date", "x4_ml_na_hep_collection_date", "x4_ml_edta_collection_date" ,
          "x1st_10_ml_edta_collection_date", "x2nd_10_ml_edta_collection_date", "urine_10_ml_collection_date" ,"saliva_collection_date")
mydata1[cols] <- lapply(mydata1[cols], factor)
mydata1[cols] <- lapply(mydata1[cols], as.Date)
str(mydata1)

library("redcapAPI")
rcon3 <- redcapConnection(url='https://www.redcap.ihrp.uic.edu/api/', token='XXXX')
importRecords(rcon3,mydata1)