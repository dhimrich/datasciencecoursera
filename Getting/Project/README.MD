---
title: "Getting Data Project"
author: "David Himrich"
date: "Saturday, September 20, 2014"
output: html_document
---

I prepared only one script to fulfill the requirements of this project, run_analysis.R. It assembles data from the files in the UCI HAR Dataset zip file according to the diagram provided by David Hood in this thread on the course discussion forums.

https://class.coursera.org/getdata-007/forum/thread?thread_id=49#comment-570
![data file diagram](File Diagram - David Hood.png)

I ignored the inertial signals data in the zip file as the project requirements only specify that the mean and standard deviation variables from the processed "features" vectors are to be summarized.

The run_analysis.R script specifies the files that it requires. These should be placed in the working directory. The script assembles sets for the training and test data with Activity and Subject columns added. It combines those two data sets together and adds descriptive column names for the measured variables extracted from the features.txt file provided with the data. See CODEBOOK.MD for the details of these variables.

The run_analysis script selects the variables to be summarized as those which contain "mean()" or "std()" in the column names. There are 79 such columns among the measured variables. 

With a combined data set that includes descriptive variable names and descriptive labels for Activities, the script uses the melt() function and ddply() function to calculate means for all the measured variables. Then the script uses the reshape() function to create a "wide" data frame with a row for each Activity and Subject and the mean values of the measured variables in the columns. The script writes this wide data frame out to a text file as required.
