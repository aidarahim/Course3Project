# 1. Merges the training and the test sets to create one data set.
# First download the .zip file and move it into the working directory
# Then unzip the .zip file

unzip("getdata_projectfiles_UCI HAR Dataset.zip")

# This results in a folder called "UCI HAR Dataset"
# In this folder are:
# .txt files with information on activity labels and features
# 2 folders, called "test" and "train" with accelerometer measurements

# Read in the test data to figure out what it looks like
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("UCI HAR Dataset/test/y_test.txt")
SubjTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read in the training data to figure out what it looks like
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
SubjTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

# It looks like X has accelerometer measurements and associated variables
# i.e. the '561-feature vector'
# It looks like subject has information about which measurement set is from which subject
# It looks like Y has information about which activity is associated with that measurement set

# Read in the features and activity labels
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Merge test and train data sets
AllX <- rbind(XTest,XTrain)
AllY <- rbind(YTest,YTrain)
AllSubj <- rbind(SubjTest,SubjTrain)

# This results in data sets with 10299 rows each
##

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Figure out which columns correspond to measurements of mean and std
# Remember that parantheses are special characters

meanstd <- grep("mean\\(\\)|std\\(\\)",features[,2])

# This results in 33 elements each
# Makes sense that the number of mean() and std() features are the same
# Because when you calculate mean, you typically also calculate std

# Extract only measurements with mean() and std()
Xmeanstd <- AllX[,meanstd]

# Results in a data set of dimention 10299 x 66
##

# 3. Uses descriptive activity names to name the activities in the data set
# Replace the factor associated with each activity, with the actual activity name
AllY[,1] <- activity[AllY[,1],2]

##

# 4. Appropriately labels the data set with descriptive variable names.
featurenames <- features[meanstd,2]
names(Xmeanstd) <- featurenames # add column names to mean() and std() features
names(AllSubj) <- "SubjectIdentifier"
names(AllY) <- "Activity"

# Combine all columns into 1 data set
labeledData <- cbind(AllSubj, AllY, Xmeanstd)

##

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
# With 30 participants and 6 activities, expect to end up with 
# data set with 180 rows
# convert data frame to data table for ease of calculating means
install.packages("data.table")
library(data.table)
MeasData <- data.table(labeledData)
IndependentData <- MeasData[,lapply(.SD,mean),by='SubjectIdentifier,Activity']

write.table(IndependentData, file = "IndependentData.txt", row.names = FALSE)

# This method was extracted from Zzhuk
