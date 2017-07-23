# Coursera-Getting-and-Cleaning-Data-Project

One of the most exciting areas in all of data science right now is wearable computing.  Companies like fitbit, Kike, and Jawbone Up are
racing to develop the most advanced algorithms to attract new users. The data linked for this project represents data collected from the 
accelerometers from the Samsung Galaxy S smartphone. 

The purpose of this project is to collect, work with, and clean a dataset. 

The steps used to complete the project are given below.

1. Unzip and download the file given below using the r script 

  zipurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


  library(data.table)
  library(dplyr)
  temp <- tempfile()


  download.file(zipurl, temp)
  unzip(temp,exdir="./course3")
  rm(temp)


2. Read the features and activity files for Labeling test/train

  trainfeat<-read.table("./course3/UCI HAR Dataset/features.txt",header=FALSE)
  trainactivities<-read.table("./course3/UCI HAR Dataset/activity_labels.txt",header=FALSE)
  colnames(trainactivities)<-c("activityID","activityname")

3. Read the files for the training set and set column names

  Xtrain<-read.table("./course3/UCI HAR Dataset/train/X_train.txt",header=FALSE)
  Ytrain<-read.table("./course3/UCI HAR Dataset/train/Y_train.txt",header=FALSE)
  trainsubjects<-read.table("./course3/UCI HAR Dataset/train/subject_train.txt",header=FALSE)

  colnames(Ytrain)<-"activityID"
  colnames(Xtrain)<-trainfeat[,2]
  colnames(trainsubjects)<-"subjectid"

4. Read read files for the test set and set column names

  Xtest<-read.table("./course3/UCI HAR Dataset/test/X_test.txt",header=FALSE)
  Ytest<-read.table("./course3/UCI HAR Dataset/test/Y_test.txt",header=FALSE)
  testsubjects<-read.table("./course3/UCI HAR Dataset/test/subject_test.txt",header=FALSE)


  colnames(Ytest)<-"activityID"
  colnames(Xtest)<-trainfeat[,2]
  colnames(testsubjects)<-"subjectid"

5. Merge desired data into one dataset

  traindata<-cbind(Ytrain,trainsubjects,Xtrain)
  testdata<-cbind(Ytest,testsubjects,Xtest)
  alldata<-rbind(traindata,testdata)


  colnames(alldata)<-tolower(names(alldata))

6. Extract the desired mean and standard deviation from the full dataset

  desiredcol<- grepl(".*mean.*.|.*std|activityid|subjectid*.",colnames(alldata))
  desData<-alldata[,desiredcol==TRUE]

7. Replace activityid with the name of the activity

  desData[,1]<-sub("1",trainactivities[1,2],desData[,1])
  desData[,1]<-sub("2",trainactivities[2,2],desData[,1])
  desData[,1]<-sub("3",trainactivities[3,2],desData[,1])
  desData[,1]<-sub("4",trainactivities[4,2],desData[,1])
  desData[,1]<-sub("5",trainactivities[5,2],desData[,1])
  desData[,1]<-sub("6",trainactivities[6,2],desData[,1])

8. Rename columns to tidy desctiptive names

  desdatacol<-colnames(desData)
  desdatacol<-gsub("[\\(\\)-]","",desdatacol)
  colnames(desData)<-desdatacol

9. Create tidy data of means by subject and activity and write to a file

  meandata <- aggregate(. ~subjectid + activityid, desData, mean)
  write.table(meandata,"./course3/tidy.txt",row.names=FALSE)

