## input zip data to R 

zipurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


library(data.table)
library(dplyr)
temp <- tempfile()


download.file(zipurl, temp)
unzip(temp,exdir="./course3")
rm(temp)


##read features and activity files for Labeling test/train
trainfeat<-read.table("./course3/UCI HAR Dataset/features.txt",header=FALSE)
trainactivities<-read.table("./course3/UCI HAR Dataset/activity_labels.txt",header=FALSE)
colnames(trainactivities)<-c("activityID","activityname")

##read files for the training set and set column names
Xtrain<-read.table("./course3/UCI HAR Dataset/train/X_train.txt",header=FALSE)
Ytrain<-read.table("./course3/UCI HAR Dataset/train/Y_train.txt",header=FALSE)
trainsubjects<-read.table("./course3/UCI HAR Dataset/train/subject_train.txt",header=FALSE)

colnames(Ytrain)<-"activityID"
colnames(Xtrain)<-trainfeat[,2]
colnames(trainsubjects)<-"subjectid"

##read files for the test set and set column names
Xtest<-read.table("./course3/UCI HAR Dataset/test/X_test.txt",header=FALSE)
Ytest<-read.table("./course3/UCI HAR Dataset/test/Y_test.txt",header=FALSE)
testsubjects<-read.table("./course3/UCI HAR Dataset/test/subject_test.txt",header=FALSE)


colnames(Ytest)<-"activityID"
colnames(Xtest)<-trainfeat[,2]
colnames(testsubjects)<-"subjectid"

##merge desired data into one dataset

traindata<-cbind(Ytrain,trainsubjects,Xtrain)
testdata<-cbind(Ytest,testsubjects,Xtest)
alldata<-rbind(traindata,testdata)


colnames(alldata)<-tolower(names(alldata))

##extract the desired mean and std data

desiredcol<- grepl(".*mean.*.|.*std|activityid|subjectid*.",colnames(alldata))
desData<-alldata[,desiredcol==TRUE]

##replace activityid with name activityname
desData[,1]<-sub("1",trainactivities[1,2],desData[,1])
desData[,1]<-sub("2",trainactivities[2,2],desData[,1])
desData[,1]<-sub("3",trainactivities[3,2],desData[,1])
desData[,1]<-sub("4",trainactivities[4,2],desData[,1])
desData[,1]<-sub("5",trainactivities[5,2],desData[,1])
desData[,1]<-sub("6",trainactivities[6,2],desData[,1])

##remain columns to tidy desctiptive names

desdatacol<-colnames(desData)

desdatacol<-gsub("[\\(\\)-]","",desdatacol)

colnames(desData)<-desdatacol

# create tidy data of means by subject and activity

meandata <- aggregate(. ~subjectid + activityid, desData, mean)

write.table(meandata,"./course3/tidy.txt",row.names=FALSE)

