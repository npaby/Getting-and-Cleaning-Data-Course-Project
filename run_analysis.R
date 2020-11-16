## Import dyplyr library

library(dplyr)

## Read data from local

feature        <- read.table("./UCI HAR Dataset/UCI HAR Dataset/features.txt",col.names = c("function"))
activity_labels<- read.table("./UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

x_test         <- read.table("./UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",col.names = feature[,2])
y_test         <- read.table("./UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",col.names = "Ycode")
subject_test   <- read.table("./UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",col.names = "Subject")

x_train        <- read.table("./UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",col.names = feature[,2])
y_train        <- read.table("./UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",col.names = "Ycode")
subject_train  <- read.table("./UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",col.names="Subject")

## Merges the training and the test sets to create one data set.

X_data       <- rbind(x_test,x_train)
Y_data       <- rbind(y_test,y_train)
Subject_data <- rbind(subject_test,subject_train)
DataMatrix   <- cbind(Subject_data,X_data,Y_data)

## Extracts only the measurements on the mean and standard deviation for each measurement.

TData        <- DataMatrix %>% select(Subject,Ycode, contains("mean"), contains("std"))

## Uses descriptive activity names to name the activities in the data set

TData$Ycode  <- activity_labels[TData$Ycode,2]

## Appropriately labels the data set with descriptive variable names.

names(TData) <- gsub("^t","time",names(TData))
names(TData) <- gsub("^f","frequency",names(TData))
names(TData) <- gsub("Acc","Accelerometer",names(TData))
names(TData) <- gsub("Gyro","Gyroscope",names(TData))
names(TData) <- gsub("Mag","Magnitude",names(TData))
names(TData) <- gsub("BodyBody","Body",names(TData))

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

simplifiedData <- TData %>%
    group_by(Subject, Ycode) %>%
    summarise_all(funs(mean))
head(simplifiedData)

## Export the data

write.table(simplifiedData, "ExportedData.txt", row.name=FALSE)



