### Introduction

This script (run_analysis.R) creates a tidy data set from "Human Activity Recognotion Using Smartphone Data". Test and Train Data are compbined and only means of mean and std statistics are provided at the end with the granularity of subject (smartphone user) and his/her activity. This script expects the "test" and "train" data to be in the same named directories, which are required to be present in the current working directory of R.

### Description of the project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 You should create one R script called run_analysis.R that does the following. 

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement. 
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive activity names. 
    Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Script explanation

Three main blocks for the script:
1. Test data processing
	a. Read the test data: subject, activity, stats data
	b. Add column names to data frames
	c. combine data frames to create a single test data frame
2. Train data processing
	a. Read the train data: subject, activity, stats data
	b. Add column names to data frames
	c. combine data frames to create a single train data frame
3. Create the tidy data
	a. merge test and train data frames
	b. reshape the data frame so that each row is an observation for a (subject,activity) pair
	c. calculate means of each statistics for each (subject,activity) pair.
	d. relabeled activity column with activity names
	e. write the resul data frame to a file, both csv and tab separated text files.

### Script Implementation
 
read statistics names, they will be the column names

<!-- -->

	colnames <- read.table("features.txt")

read activity names

<!-- -->

	activityNames <- read.table("activity_labels.txt")

 give column names to activity data frame

<!-- -->

	names(activityNames) <- c("activity_number","activity_name")

give column names to stats names data frame

<!-- -->

	names(colnames) <- c("VariableNumber", "StatsName")

Below we process the test data first
read the subject numbers for each observation

<!-- -->

	subjectTest <- read.table("test/subject_test.txt")

read data for each test observation

<!-- -->

	statsTest <- read.table("test/X_test.txt")

read activity number for each observation

<!-- -->

	activityTest <- read.table("test/y_test.txt")

give column names to test activity data frame

<!-- -->

	names(activityTest) <- "activity"

give column names to test subject data frame

<!-- -->

	names(subjectTest) <- "subject"

assign stats names as column names to test data 

<!-- -->

	names(statsTest) <- colnames$StatsName

create a regular expression to find "mean()" and "std() in stats names

<!-- -->

	toMatch <- c(".*mean\\(\\).*$", ".*std\\(\\).*$")

find the column numbers whose names include mean() or std()

<!-- -->

	meanstdIndex <- grep(paste(toMatch,collapse="|"),colnames$StatsName)

eliminate other stats which don't include mean() or std() 

<!-- -->

	meanstdTest <- statsTest[,meanstdIndex]

create mean() and std() test data frame including subject and activity number

<!-- -->

	data <- cbind(subjectTest,activityTest,meanstdTest)
data_test<-data


Below we process the train data first
read the subject numbers for each observation

<!-- -->

	subjectTrain <- read.table("train/subject_train.txt")

read data for each test observation

<!-- -->

	statsTrain <- read.table("train/X_train.txt")

read activity number for each observation

<!-- -->

	activityTrain <- read.table("train/y_train.txt")

give column names to test activity data frame

<!-- -->

	names(activityTrain) <- "activity"

give column names to test subject data frame

<!-- -->

	names(subjectTrain) <- "subject"

assign stats names as column names to test data

<!-- -->

	names(statsTrain) <- colnames$StatsName

eliminate other stats which don't include mean() or std()

<!-- -->

	meanstdTrain <- statsTrain[,meanstdIndex]

create mean() and std() test data frame including subject and 
activity number


<!-- -->

	data <- cbind(subjectTrain,activityTrain,meanstdTrain)
	data_train <- data

Below we merge test and train data, calculate means of stats and generate the tidy data
merge test and train data


<!-- -->

	mergedData <- rbind(data_test,data_train)
	require(reshape2)

rearrange data so that each subject and a single activity is in a row as an observation


<!-- -->

	meltedData <- melt(mergedData,(id.vars=c("subject","activity")))

calculate column means per subject and activity, this is the tidy data


<!-- -->

	tidiedData <- dcast(meltedData, subject + activity ~ variable, mean)

create labels factor with activity names for each tidy data row


<!-- -->

	labels <- activityNames$activity_name[tidiedData$activity]

assign activity lables to tidy data's activity column, which was integer 


<!-- -->

	tidiedData$activity <- labels

write the tidy data as .txt and .csv fiels in the working directory.


<!-- -->

	write.table(tidiedData,file="tidiedData.csv",sep=",",row.names=F)
	write.table(tidiedData,file="tidiedData.txt",sep="\t",row.names=F)

