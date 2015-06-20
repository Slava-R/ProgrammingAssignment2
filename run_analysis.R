## This R script gets and cleans pre-processed sensor signal (embedded accelerometer and gyroscope) data 
## from a smartphone (Samsung Galaxy S II) worn on the waist by 30 volunteers,each performing six activities.

## The sensor acceleration signal was separated into gravitational and body motion components.
## From each sampling window, a normalized feature vector (time and frequency domain variables) was obtained;
## each feature vector is a row in a text file.
## For each record, total and estimated body acceleration (for three axes), triaxial angular velocity,
## a 561-feature vector, subject ID and activity label are provided.

## The data is split into training and test sets and reported in the following files
## - 'train/subject_train.txt': Each row identifies a subject who performed the activity for each window sample;
## - 'train/X_train.txt': Training set// Each row is a 561-feature vector of time- and frequency-domain variables;
## - 'train/y_train.txt': Training labels corresponding to six activities;
## - and similarly for the test data.

## The script below does the following transformations:
## 1. Gets the data from the source and unzips it into a local directory folder;
## 2. Reads and binds training and test datasets;
## 3. Decodes activity labels and generates a corresponding activity-name object;
## 4. Gets the variable names;
## 5. Merges the data with the labels, to create a single dataset;
## 6. Extracts the mean and standard deviation (std) values calculated for each sampling window;
## 7. Cleans all column names;
## 8. Calculates averages by activity and subject for mean and std of 33 variables;
## 9. Re-orders and outputs the calculations as "tidy_dataset.txt" with a character vector of the column names.

## Create a designatated data folder in the working directory
if(!file.exists("./data")){
    dir.create("./data")
}

## Get the data file and unzip it internally
if(file.exists("./UCI_HAR_Dataset.zip")){      ## check if the Samsung data is already in the working directory
    unzip(zipfile="./UCI_HAR_Dataset.zip", exdir="./data")      ## and unzip the data file in the local 'data' folder
} else {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile="./data/UCI_HAR_Dataset.zip", cacheOK = FALSE)  ## fetch the data from the source
    unzip(zipfile="./data/UCI_HAR_Dataset.zip", exdir="./data") ## and unzip in the local 'data' folder
    rm(fileUrl)
}

path_ds <- file.path("./data/UCI HAR Dataset")
## Read the unzipped data files into R variables
XTrain <- read.table(file.path(path_ds, "train", "X_train.txt" ), header = FALSE)   ## featured training data
XTest <- read.table(file.path(path_ds, "test", "X_test.txt" ), header = FALSE)      ## featured test data

yTrain <- read.table(file.path(path_ds, "train", "y_train.txt" ), header = FALSE)   ## training activity labels
yTest <- read.table(file.path(path_ds, "test", "y_test.txt" ), header = FALSE)      ## test activity labels

STrain <- read.table(file.path(path_ds, "train", "subject_train.txt" ), header = FALSE)
STest <- read.table(file.path(path_ds, "test", "subject_test.txt" ), header = FALSE)

## Bind the training and test datasets
X <- rbind(XTrain, XTest)
Activity <- rbind(yTrain, yTest)
Subject <- rbind(STrain, STest)
## Remove temporary data objects from memory
rm(XTrain,XTest,yTrain,yTest,STrain,STest)

Features <- read.table(file.path(path_ds, "features.txt"), header=FALSE)    ## read the feature names
names(X) <- Features$V2 ## match the 561-feature vector variables and feature names

ALabels <- read.table(file.path(path_ds, "activity_labels.txt"), header=FALSE)  ## decode the activity label names
## Factorize variable 'Activity' by matching its numeric labels to the levels' ordering in 'ALabels'
Activity$activity <- ALabels[Activity$V1,2] ## add the matching activity name variable to the 'Activity' data frame
ActivityName <- data.frame(Activity[,"activity"])   ## replace the numeric labels with activity names in the dataset
names(ActivityName) <- c("activity")

names(Subject) <- c("subject")

tidyData <- cbind(X, ActivityName, Subject) ## merge the data with the labels, to create a single dataset

# subFeature <- Features$V2[grep("mean\\(\\)|std\\(\\)", Features$V2)]
subFeature <- Features$V2[grep("mean[()]|std[()]", Features$V2)]    ## extract the mean and standard deviation features

selectNames <- c(as.character(subFeature), "activity", "subject")
subData <- subset(tidyData, select=selectNames)

## Call 'str(subData)' to look into the column names

## Clean up the column names
colnames(subData) <- gsub("[()]", "", colnames(subData))
colnames(subData) <- gsub("-", ".", colnames(subData))
colnames(subData) <- gsub("^t", "", colnames(subData))
colnames(subData) <- gsub("^f", "FFT-", colnames(subData)) ## FFT- prefix denotes Fast Fourier Transform of variables
colnames(subData) <- gsub("Body", "", colnames(subData)) ## remove redundant common descriptors
colnames(subData) <- gsub("GravityAcc", "Gravity", colnames(subData))
colnames(subData) <- gsub("AccJerk", "Jerk", colnames(subData))
colnames(subData) <- gsub("GyroJerk", "angularJerk", colnames(subData)) ## label with descriptive variable names
colnames(subData) <- gsub("Gyro", "angularVelocity", colnames(subData))
colnames(subData) <- gsub("Acc", "acceleration", colnames(subData))
colnames(subData) <- gsub("Mag", "Magnitude", colnames(subData))

library(plyr)
avgData <- aggregate(. ~activity+subject, subData, mean)        ## calculate variable averages by activity and subject
avgData <- avgData[order(avgData$activity, avgData$subject),]   ## sort the rows by activity
rownames(avgData) <- NULL
## Export to tab-delimited file
write.table(avgData,file="./data/UCI HAR Dataset/UCIHAR_tidy_dataset.txt",sep="\t",row.names=FALSE)