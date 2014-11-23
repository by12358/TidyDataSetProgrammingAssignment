Instructions to Use the R Code
------------------------------

1. Download the data for the study from the following url:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Store the corresponding zip file whereever you like.  We will refer to the directory where you have
saved the zip files as the $BASE directory.

2. Unzip the dataset zip file.  Be sure to allow it to unzip all of the files in the $BASE directory, and
be sure to set the Path mode to "Full pathnames" to preserve the directory structure of the zip file.

3. In R change the working directory to be the "UCI HAR Dataset" directory created by unzipping the data file.
Use the following command in R:

> setwd("$BASE/getdata_projectfiles/UCI HAR Dataset")

Be sure to replace $BASE with the actual path to the directory where you unzipped the data file.

4. Source the run_analysis.R script.

5. Be sure that the "reshape2" package has been installed in your instance of R.  If it has not, you must
install it, or the script will not fully run.

6. Create the tidy data set from the raw data in the zip file by executing the following command:

> tidy_df <- CreateTidyDF()

A dataframe containing the tidy data set will be returned from CreateTidyDF().

7. Create the tidy data set of means of each of the variables in the tidy data frame created in the last step
by executing the following command:

> tidy_mean_df <- CreateMeanDF( tidy_df )

Note that the tidy data frame created by CreateTidyDF() must be passed into CreateMeanDF as an argument.  The
table created by CreateMeanDF is what is stored in the tidy_mean_dataset.txt file included in the GitHub
repository.

Loading the Tidy Mean Dataset into R from the tidy_mean_dataset.txt file
------------------------------------------------------------------------

1. Copy the tidy_mean_dataset.txt file into your current working directory.

2. Execute the following command in R:

> tidy_mean_df <- read.table("./tidy_mean_dataset.txt", header=T)

