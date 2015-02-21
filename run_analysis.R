# this script assumes that the project data has been
# downloaded and unzipped in the working directory.
# Hence, the "UCI HAR Dataset" must be available

dataSetPath <- "./UCI HAR Dataset";

if (!file.exists(dataSetPath))
  stop("The UCI HAR dataset is not in the working directory")

# checking that the dplyr package is available; if not, install it
if (!( "dplyr" %in% rownames(installed.packages())))
    install.packages("dplyr")
    
library(dplyr)

# setting file names
trainingDataFileName <- paste(dataSetPath, "/train/X_train.txt", sep="")
testingDataFileName <- paste(dataSetPath, "/test/X_test.txt", sep="")
trainingLabelsFileName <- paste(dataSetPath, "/train/y_train.txt", sep="")
testingLabelsFileName <- paste(dataSetPath, "/test/y_test.txt", sep="")
trainingSubjectsFileName <- paste(dataSetPath, "/train/subject_train.txt", sep="")
testingSubjectsFileName <- paste(dataSetPath, "/test/subject_test.txt", sep="")
featuresFileName <- paste(dataSetPath, "/features.txt", sep="")
activityLabelsFileName <- paste(dataSetPath, "/activity_labels.txt", sep="")

# read feature indices and names
featureList <- read.table(featuresFileName, col.names=c("id", "name"))
nrFeatures <- dim(featureList)[1]

# retrieve only the features related to the mean and standard deviation of the measurements
selectedFeaturesLogical <- grepl("mean()", featureList$name, fixed=TRUE) | grepl("std()", featureList$name, fixed=TRUE)
colClassesVector <- ifelse(selectedFeaturesLogical, "numeric", "NULL")

# provide descriptive variable names in the dataset
colNamesVector <- rep("NULL", nrFeatures)
colNamesVector[selectedFeaturesLogical] <- as.character(featureList$name[selectedFeaturesLogical])

# preprocessing feature names
# replacing empty brackets with empty strings, 
# dashes with underscores
# and "BodyBody" with "Body"
colNamesVector <- gsub("()","", colNamesVector, fixed=TRUE)
colNamesVector <- gsub("-","_", colNamesVector, fixed=TRUE)
colNamesVector <- gsub("BodyBody","Body", colNamesVector, fixed=TRUE)

# reading only selected features for the data and activity files (both training and test sets)
trainingData <- read.table(trainingDataFileName, colClasses = colClassesVector, col.names=colNamesVector)
testData <- read.table(testingDataFileName, colClasses = colClassesVector, col.names=colNamesVector)
trainingActivities <- read.table(trainingLabelsFileName, col.names="activity_id")
testActivities <- read.table(testingLabelsFileName, col.names="activity_id")

# reading subject files (both training and test sets)
trainingSubjects <- read.table(trainingSubjectsFileName, col.names="subject_id")
testSubjects <- read.table(testingSubjectsFileName, col.names="subject_id")

# merge training and test sets (data, activities and subjects)
# with "id"  and "activity_id" columns
wholeDataSet <- data.frame(rbind(trainingActivities, testActivities), rbind(trainingSubjects, testSubjects), rbind(trainingData, testData))

# read activity labels
activityLabels <- read.table(activityLabelsFileName, col.names=c("activity_id", "activity_name"))

# use descriptive activity names to name the activities in the data set
myDataFrame <- merge(activityLabels, wholeDataSet, sort=FALSE)
# drop the common "activity_id" field and only retain the "activity_name"
myDataFrame$activity_id <- NULL

# group by subject_id and activity_name,
# then compute the average of each variable 
# by each <subject_id, activity_name> combination

variableMeans <- (myDataFrame %>% group_by(subject_id, activity_name) %>%
summarise_each(funs(mean)))

# save the 'variableMeans' data frame as a text file
write.table(variableMeans, "./output.txt", row.names=FALSE)
