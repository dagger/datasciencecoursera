## Course project for "Getting and Cleaning data"
## This script depends on the following libraries:
## 1- dplyr

# Downloading the data set
dataSetName <- "dataset.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dataSetName)
unzip(dataSetName)

# Read the feature info file
features <- read.table("./UCI HAR Dataset/features.txt")
colnames(features) <- c("index", "name")

## Step 1, merging training and test data sets 
library(dplyr)
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
allData <- bind_rows(train, test)
colnames(allData) <- features$name

# Step 2 keep only the std and mean columns
meanAndStdColumns <- features$index[grep("std()|mean()", features$name)]
onlyMeanAndStdData <- allData[, meanAndStdColumns]

## Step 3, Adding labels with human readable activity names
# read labels and activity name mappings
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels) <- c("id", "name")
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
allLabels <- bind_rows(trainLabels, testLabels)
colnames(allLabels) <- c("label")
# replace ids with proper names
properName <- function(label){return(as.character(activityLabels$name[activityLabels$id == label]))}
properName <- Vectorize(properName)
allLabels <- mutate(allLabels, label = properName(label))
## Step 4, Add the appropriate activity column to the data set
onlyMeanAndStdData$activity <- allLabels$label

## Step 5, creates the second data set with averages of each activity-subject pair
# read subject data (only test data has subjects)
testSubjects <- trainSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt") 
colnames(testSubjects) <- c("id")
onlyMeanAndStdDataTest <- tail(onlyMeanAndStdData, nrow(testSubjects))
onlyMeanAndStdDataTest$subject <- testSubjects$id

# here is your new data
newData <- onlyMeanAndStdDataTest %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# written to tidy.txt
write.table(newData, row.names = FALSE, "tidy.txt")

