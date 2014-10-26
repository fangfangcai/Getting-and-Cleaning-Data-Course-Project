##Getting and Cleaning Data Course Project
##Files Location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##Please download and unzip the files in the working directory
##Some packages required: reshape2, plyr

##Reading files
Test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE) #read the test set file
TestLabels <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE) #read the test labels file
TestSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE) #read the test subjects file
Training <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE) #read the training set file
TrainingLabels <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE) #read the training labels file
TrainingSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE) #read the training subjects file
Activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character") #read the activities file
Features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character") #read the features file

##Give column names to the data 
colnames(Test) <- Features$V2
colnames(Training) <- Features$V2
colnames(TestLabels) <- c("ActivityID")
colnames(TrainingLabels) <- c("ActivityID")
colnames(TestSubjects) <- c("Subject")
colnames(TrainingSubjects) <- c("Subject")
colnames(Activities) <- c("ActivityID", "Activity")

##Combine files (by columns)
Test <- cbind(Test,TestLabels)
Test <- cbind(Test,TestSubjects)
Training <- cbind(Training,TrainingLabels)
Training <- cbind(Training,TrainingSubjects)

##Combine test and training data (by rows)
TestAndTraining <- rbind(Test,Training)

##Merge combined data with activities
TestAndTraining <- merge(TestAndTraining,Activities,by.x="ActivityID",by.y="ActivityID",all=TRUE)

##Melting the data
IDs <- c("Subject", "Activity")
measures <- setdiff(colnames(TestAndTraining), IDs)
TestAndTraining <- melt(TestAndTraining, id = IDs, measure.vars = measures)

##Obtain the average of each variable for each activity and each subject
Data <- dcast(TestAndTraining, Subject + Activity ~ variable, mean)

##Output
write.table(Data, file = "./Data.txt")
