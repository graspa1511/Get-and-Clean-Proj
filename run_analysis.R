# Coursera: Getting and Cleaning Data Assignment 

run_analysis <- function(){
  # loading test 
  subject_test = read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/test/subject_test.txt")
  X_test = read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/test/X_test.txt")
  Y_test = read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/test/Y_test.txt")
  
  # loading train
  subject_train = read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/train/subject_train.txt")
  X_train = read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/train/X_train.txt")
  Y_train = read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/train/Y_train.txt")
  
  # load features info
  features <- read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
  activities <- read.table("C:/Users/Guillermo/Documents/UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
  activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
  includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
  
  # merge test & train to then name them
  subject <- rbind(subject_test, subject_train)
  names(subject) <- "subjectId"
  X <- rbind(X_test, X_train)
  X <- X[, includedFeatures]
  names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
  Y <- rbind(Y_test, Y_train)
  names(Y) = "activityId"
  activity <- merge(Y, activities, by="activityId")$activityLabel
  
  # merge different column data frames and build one data table
  data <- cbind(subject, X, activity)
  write.table(data, "merged_tidy_data.txt")
  
  # write a tidy dataset after applying std dev and average calc.
  library(data.table)
  dataDT <- data.table(data)
  calculatedData <- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
  write.table(calculatedData, "calculated_tidy_data.txt")
}
