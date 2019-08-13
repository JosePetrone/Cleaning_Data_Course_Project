
## Download the file from web

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

## Unzip file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## list of files in the unzipped folder
path_course_files <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_course_files, recursive=TRUE)
files

## read data from the files into variables

## Read from activity files

dataActTest  <- read.table(file.path(path_course_files, "test" , "Y_test.txt" ),header = FALSE)
dataActTrain <- read.table(file.path(path_course_files, "train", "Y_train.txt"),header = FALSE)

## Read from subject files

dataSubTest  <- read.table(file.path(path_course_files, "test" , "subject_test.txt"),header = FALSE)
dataSubTrain <- read.table(file.path(path_course_files, "train", "subject_train.txt"),header = FALSE)

## Read from Features files
dataFeatTest  <- read.table(file.path(path_course_files, "test" , "X_test.txt" ),header = FALSE)
dataFeatTrain <- read.table(file.path(path_course_files, "train", "X_train.txt"),header = FALSE)
dataFeatNames <- read.table(file.path(path_course_files, "features.txt"),head=FALSE)

## ************************************
## 1. Merges the training and the test sets to create one data set
## ************************************
## Concatenate the data tables by rows
dataSubject <- rbind(dataSubTrain, dataSubTest)
dataActivity<- rbind(dataActTrain, dataActTest)
dataFeatures<- rbind(dataFeatTrain, dataFeatTest)

## Set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
names(dataFeatures)<- dataFeatNames$V2

## Merge columns to get the data frame Data for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## *************************************
## 2. Extracts only the measurements on the mean and standard deviation for each measurement
## *************************************
## Take Names of Features with "mean" or "std"
subdataFeatNames<-dataFeatNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeatNames$V2)]

## Subset the data frame Data by selected names of Features
selectedNames<-c(as.character(subdataFeatNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)


## *************************************
## 3.Uses descriptive activity names to name the activities in the data set
## *************************************

## REad descriptive activity names from "activity_labels.txt"

activityLabels <- read.table(file.path(path_course_files, "activity_labels.txt"),header = FALSE)

## Factorize Variale activity in the data frame Data using descriptive activity names
head(Data$activity,30)


## *************************************
## 4. Appropriately labels the data set with descriptive variable names
## *************************************

## prefix t is replaced by time
## Acc is replaced by Accelerometer
## Gyro is replaced by Gyroscope
## prefix f is replaced by frequency
## Mag is replaced by Magnitude
## BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)


## *************************************
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject.
## *************************************

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

str(Data2)









