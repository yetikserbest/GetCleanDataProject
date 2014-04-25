## This script creates a tidy data set from "Human Activity Recognotion
## Using Smartphone Data". Test and Train Data are compbined and only means of
## mean and std statistics are provided at the end with the granularity of 
## subject (smartphone user) and his/her activity.
##
## This script expects the "test" and "train" data to be in the same named
## directories, which are required to b e present in the current working
## directory of R. 

## read statistics names, they will be the column names
colnames <- read.table("features.txt")
## read activity names
activityNames <- read.table("activity_labels.txt")
## give column names to activity data frame
names(activityNames) <- c("activity_number","activity_name")
## give column names to stats names data frame
names(colnames) <- c("VariableNumber", "StatsName")
##
## Below we process the test data first
##
## read the subject numbers for each observation
subjectTest <- read.table("test/subject_test.txt")
## read data for each test observation
statsTest <- read.table("test/X_test.txt")
## read activity number for each observation
activityTest <- read.table("test/y_test.txt")
## give column names to test activity data frame
names(activityTest) <- "activity"
## give column names to test subject data frame
names(subjectTest) <- "subject"
## assign stats names as column names to test data 
names(statsTest) <- colnames$StatsName
## create a regular expression to find "mean()" and "std()
## in stats names
toMatch <- c(".*mean\\(\\).*$", ".*std\\(\\).*$")
## find the column numbers whose names include mean() or std()
meanstdIndex <- grep(paste(toMatch,collapse="|"),colnames$StatsName)
## eliminate other stats which don't include mean() or std() 
meanstdTest <- statsTest[,meanstdIndex]
## create mean() and std() test data frame including subject and activity number
data <- cbind(subjectTest,activityTest,meanstdTest)
data_test<-data
##
## Below we process the train data first
##
## read the subject numbers for each observation
subjectTrain <- read.table("train/subject_train.txt")
## read data for each test observation
statsTrain <- read.table("train/X_train.txt")
## read activity number for each observation
activityTrain <- read.table("train/y_train.txt")
## give column names to test activity data frame
names(activityTrain) <- "activity"
## give column names to test subject data frame
names(subjectTrain) <- "subject"
## assign stats names as column names to test data
names(statsTrain) <- colnames$StatsName
## eliminate other stats which don't include mean() or std()
meanstdTrain <- statsTrain[,meanstdIndex]
## create mean() and std() test data frame including subject and activity number
data <- cbind(subjectTrain,activityTrain,meanstdTrain)
data_train <- data
##
## Below we merge test and train data, calculate means of stats and generate
## the tidy data
##
## merge test and train data
mergedData <- rbind(data_test,data_train)
require(reshape2)
## rearrange data so that each subject and a single activity is in a row
## as an observation
meltedData <- melt(mergedData,(id.vars=c("subject","activity")))
## calculate column means per subject and activity, this is the tidy data
tidiedData <- dcast(meltedData, subject + activity ~ variable, mean)
## create labels factor with activity names for each tidy data row
labels <- activityNames$activity_name[tidiedData$activity]
## assign activity lables to tidy data's activity column, which was integer 
tidiedData$activity <- labels
## write the tidy data as .txt and .csv fiels in the working directory.
write.table(tidiedData,file="tidiedData.csv",sep=",",row.names=F)
write.table(tidiedData,file="tidiedData.txt",sep="\t",row.names=F)