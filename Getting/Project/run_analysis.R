# Getting and Cleaning Data, Course Project
# 
# Place the following files from the uCI HAR data set in the working directory:
#   X_train.txt
#   y_train.txt
#   subject_train.txt
#   X_test.txt
#   y_test.txt
#   subject_test.txt
#   features.txt
#   activity_labels.txt
#
# Read the files for the test data set into data frames
X_test.df <- read.table("X_test.txt")
y_test.df <- read.table("y_test.txt")
subject_test.df <- read.table("subject_test.txt")
#
# Read the variable names in from features.txt
features.df <- read.table("features.txt")

# Build the completed test data set with features vector, subjects, 
# and Activities
test_set.df <- cbind(X_test.df, subject_test.df, y_test.df)
#
# Assign variable names to the Subject and Activity columns
colnames(test_set.df)[562:563] <- c("Subject", "Activity")
#
# Assign the names from features.txt as the column names for the first
# 561 columns in the test set data frame
colnames(test_set.df)[1:561] <- as.character(features.df[,2])
#
# Build the same format data frame with the training data set
# Read the files for the training data set into data frames
X_train.df <- read.table("X_train.txt")
y_train.df <- read.table("y_train.txt")
subject_train.df <- read.table("subject_train.txt")
#
# Build the completed test data set with features vector, subjects, 
# and Activities
train_set.df <- cbind(X_train.df, subject_train.df, y_train.df)
#
# Assign variable names to the Subject and Activity columns
colnames(train_set.df)[562:563] <- c("Subject", "Activity")
#
# Assign the names from features.txt as the column names for the first
# 561 columns in the training set data frame
colnames(train_set.df)[1:561] <- as.character(features.df[,2])
#
# Row bind the training and test sets together
smartphone.df <- rbind(train_set.df, test_set.df)
#
# I will use the dplyr, reshape2, and plyr packages for the remaining operations
library(dplyr)
library(plyr)
library(reshape2)
#
# I have interpreted the project requirements to require only the variables
# with names that include "mean()" or "std()" to be summarized.
#
# Create a vector of the mean and std variables
mean_std_cols <- grep("mean()|std()", colnames(smartphone.df))
# Create a data frame table from the combined data set, keeping only the mean
# and std columns, as well as the Subject and Activity columns (562:563)
smartphone_df <- tbl_df(smartphone.df[,c(mean_std_cols,562,563)])
#
# Add a column based on the Activity column with descriptive activity names
# using the values in activity_labels.txt
activity_labels <- read.table("activity_labels.txt")
smartphone_df$Activity2 <- factor(smartphone_df$Activity, 
                                  labels=(activity_labels[,2]))
#
# Create a molten data frame of the mean and std variables, identified by
# Activity2 and Subject
tmp <- melt(smartphone_df, id.vars=c("Activity2", "Subject"), 
            measure.vars = 1:79)


# Summarize the molten data frame by Activity2, Subject and variable
# by calculating the mean of each grouping
out <- ddply(tmp, .(Activity2, Subject, variable), summarize, avg=mean(value))
#
# Reshape the output into wide format, Activity2 and Subject identify the groups,
# the variable names are the "time" variables that will be reshaped wide
out.rs <- reshape(out, idvar=c("Activity2", "Subject"), timevar="variable", 
                  direction="wide")
#
# Clean up
rm(tmp, out)
#
# Write the output wide data frame out as text according to the project
# requirements
write.table(out.rs, file="smartphone_data.txt", row.names=FALSE)
