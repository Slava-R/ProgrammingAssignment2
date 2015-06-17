##This is a code book that describes the variables, the data, and the transformations performed to clean up the data and to prepare a tidy data set as described below 

##Getting and Cleaning Data Course Project (Coursera)
- The goal is to prepare tidy data that can be used for later analysis.
Create one R script called run_analysis.R that does the following: 
1.Merges the training and the test sets to create one data set;
2.Extracts only the measurements on the mean and standard deviation for each measurement;
3.Uses descriptive activity names to name the activities in the data set;
4.Appropriately labels the data set with descriptive variable names;
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##run_analysis.R (scipt description)
This R script gets and cleans pre-processed sensor signal (embedded accelerometer and gyroscope) data 
from a smartphone (Samsung Galaxy S II) worn on the waist by 30 volunteers,each performing six activities.

##Human Activity Recognition Using Smartphones Dataset
- The (total) sensor acceleration signal was separated into gravitational and body motion components.
- From each sampling window (128 readings per window), a normalized-feature vector was obtained;
each feature vector is a row in a text file. Frequency-domain features are Fast Fourier Transform (FFT)
products of the corresponding time-domain features.
- For each record, a 561-feature vector, subject ID and activity label were provided. The raw data on
total and estimated body acceleration (for three axes) and triaxial angular velocity were not required.

##The data is split into training and test sets and reported in the following files
- 'train/subject_train.txt': Each row identifies a subject who performed the activity for each window sample;
- 'train/X_train.txt': Training set// Each row is a 561-feature vector of time- and frequency-domain variables;
- 'train/y_train.txt': Training labels corresponding to six activities;
- and similarly for the test data.

##A full description of the data is available at the website where the original data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##The source of the data for the Course Project is here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##The R script does the following transformations:
1. Gets the data from the source and unzips it into a local directory folder;
2. Reads and binds training and test datasets;
3. Decodes activity labels and generates a corresponding descriptive activity-name object;
4. Gets the variable names;
5. Merges the data with the labels, to create a single dataset;
6. Extracts the mean and standard deviation (std) values calculated for each sampling window;
7. Cleans all column names to appropriately label them with descriptive variable names;
8. Calculates the averages by activity and subject for the mean and std of 33 variables;
9. Re-orders and outputs the calculations as "UCIHAR_tidy_dataset.txt" with a character vector of the column names.

In the output dataset, the activity and subject serve as ID for the mean and standard deviation of
the following variables:
- acceleration (triaxial total body acceleration signal and its magnitude)
- Gravity (triaxial estimated gravity acceleration and its magnitude)
- Jerk (triaxial estimated body jerk component and its magnitude)
- angularVelocity (triaxial angular velocity signal and its magnitude)
- angularJerk (triaxial angular body jerk and its magnitude)
- FFT- (Fast Fourier Transform into frequency domain for the above except 'Gravity' and 'angularJerk' triaxial signal)
