## 1 - Downloading and unzipping dataset

if(!file.exists("./getdata")){dir.create("./getdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./getdata/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./getdata/Dataset.zip",exdir="./getdata")

## 2 - Merging the training set and the test sets to create one dataset
# Reading trainings tables:
x_train <- read.table("./getdata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getdata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getdata/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./getdata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getdata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getdata/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./getdata/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./getdata/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

## 3 - Extracting only the measurements on the mean and standard deviation for easy measurement
colNames <- colnames(setAllInOne)

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

## 4 - Using descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
## 5 - Creating a record, independent tidy data set witth the average of each variable for each activity abd each subject
# making second tidy dataset

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# writing second tidy dataset in txt file
write.table(secTidySet, "2ndTidySet.txt", row.name=FALSE)

