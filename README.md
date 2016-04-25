
Final Project, Getting and Cleaning Data
========================================

the run_analysis.R script will do everything for you, in the following steps:
* Downloads the data from the internet.
* Uncompresses the zip archive.
* Reads and joins test and train data.
* Replaces variable names with proper feature names.
* Filters out variables that do not have anything to do with mean() and std()
* Averages the variables, grouped by subject-activity pairs
* Writes the tidy Data to tidy.txt

Data
====
Use the files features.txt and features_info.txt to understand the features in the generated output.

Requirements
============
* Internet connection
* dplyr library installed on R

How to run
==========
You just need to run the script and will have the results in a few seconds.
You can do this through R UI/Studio or using the source() function.
