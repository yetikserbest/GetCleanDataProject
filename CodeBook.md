### Introduction

This document explains the data, the variables, how the data is processed. This project processes data set from "Human Activity Recognotion Using Smartphone Data" and creates a summary tidy data set. 

### Description of the original data 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Summary of original data explanation -- for data processing 

There are two data sets: 1. train, 2. test. For this reason, when the original data is unzipped, you will see two directories with the same name. 

30 subjects are randomly divided into test and train. Hence, subject do not provide both test and train data, only one of them.

In the parent directory, 

- you will see "features.txt", which is loaded in "colnames" dataframe with 561 rows (which is number of statistics collected. 

- you will see "activity_labels.txt", which is loaded in "activityNames" data frame with 6 rows (activities of subjects during the study). "activity" name is assigned to the column for readability.

In the test directory,

- you will see X_test.txt. This is the statistics collected. It has no column names, and hard to read. Therefore it is loaded to "statsTest" data frame and "colNames" added for easy readability. This data frame has 2947 rows and 561 columns.

- you will see y_test.txt. This is the activities of test data. Basically, it has 2947 rows and one column. It is loaded to "activityTest" data frame. Each row corresponds to one row in "statsTest". For readability, we added column name "activity" to 
the data frame.

- you will see subject_test.txt. This is the subjects of test data. Basically, it has 2947 rows and one column. It is loaded to "subjectTest" data frame. Each row corresponds to one row in "statsTest". For readability, we added column name "subject" to 
the data frame.

In the train directory,

- you will see X_train.txt. This is the statistics collected. It has no column names, and hard to read. Therefore it is loaded to "statsTrain" data frame and "colNames" added for easy readability. This data frame has 7532 rows and 561 columns.

- you will see y_train.txt. This is the activities of train data. Basically, it has 7532 rows and one column. It is loaded to "activityTrain" data frame. Each row corresponds to one row in "statsTrain". For readability, we added column name "activity" to 
the data frame.

- you will see subject_train.txt. This is the subjects of train data. Basically, it has 7532 rows and one column. It is loaded to "subjectTrain" data frame. Each row corresponds to one row in "statsTrain". For readability, we added column name "subject" to 
the data frame.

## Eliminate unnecessary data

During processing, as it is required, we need only stats with "mean()" and "std()" in their names. Hence, we eliminated other stats (i.e., columns) from "statsTest" and "statsTrain" data frames and we created "meanstdTest" and "meanstdTrain" data frames respectively. These data frames have 2947 and 7532 rows respectively as before, but they have now 66 columns. 

## Nice Data 

After these cleaning mentioned above two nice tidy data frames created for processing.

1. "data_test". This is combination of "subjectTest", "activityTest", and "meanstdTest" data frames. We used cbind in that order.

2. "data_train". This is combination of "subjectTrain", "activityTrain", and "meanstdTrain" data frames. We used cbind in that order.

3. Since data_test and data_train have the same columns and different subject we simply use rbind the combine them to create "mergedData" data frame, which has 10299 rows and 68 columns.

## Calculate means of stats per (subject,activity) pair.    

We melted (rehape2 package) and then dcast them to calculate mean of stats to have one (subject,activity) pair per row. Each pair is unique in this final data frame, and we called it "tidiedData", which has 180 (30 subjects x 6 activities) rows and 68 columns.

## Replace activity integer values with human readable strings

Finally, we replaced integers in the "activity" column of "tidiedData" with human readable activity names provided and stored in "activityNames" data frame.

## Store created tidy data set in files

At the last step, one csv one tab separated file is created by writing "tidiedData" data frame in files. row.names=FALSE is important, otherwise the files are were showing shifted columns to gthe right.
