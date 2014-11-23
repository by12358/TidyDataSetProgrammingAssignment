
# Function:     CreateTidyDF
# Arguments:    (none)
# Returns:      a dataframe representing a tidy data set created from
#               the wearable technology data set
# Description:  Loads each of the data files from both the train and 
#               test directories, as well as the data files containing
#               the subject, label, and activity information from the
#               top-level base directory.  The function then merges the
#               information into one tidy data set, which is returned.
# Note:         The function must be run from the top-level base
#               directory created from unzipping the file.

CreateTidyDF <- function() {
    
    ## Load Test Data, three data frames:
    ##    1. the X_test frame, containing all of the data,
    ##    2. the y_test frame, containing the activity codes, and
    ##    3. the subject_test frame, containing the subjects.
    print("Reading test data...")
    if (!("./test" %in% list.dirs())) 
        stop("\"./test\" directory not found.")
    X_test <- read.table("./test/X_test.txt")
    y_test <- read.table("./test/y_test.txt")
    subject_test <- read.table("./test/subject_test.txt")
    
    ## Load Training Data, three data frames:
    ##    1. the X_train frame, containing all of the data,
    ##    2. the y_train frame, containing the activity codes, and
    ##    3. the subject_train frame, containing the subjects.
    print("Reading train data...")
    if (!("./train" %in% list.dirs())) 
        stop("\"./train\" directory not found.")
    X_train <- read.table("./train/X_train.txt")
    y_train <- read.table("./train/y_train.txt")
    subject_train <- read.table("./train/subject_train.txt")

    ## Loan Base Data, two data frames:
    ##    1. the features frame, containing a descriptive name for each
    ##       variable, and
    ##    2. the activity_label frame, containing the activity labels
    print("Reading base data...")
    features <- read.table("features.txt")
    activity_label <- read.table("activity_labels.txt")
    
    ## We now have all the data we need - just need to clean it up,
    ## and then merge it together into one tidy data set.
    print("Cleaning and merging...")
    X1 <- CleanAndMerge(subject_train, y_train, X_train, 
                        activity_label, features)
    X2 <- CleanAndMerge(subject_test, y_test, X_test, 
                        activity_label, features)
    rbind(X1, X2)
}

#-*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*-

# Function:     CreateMeanDF
# Arguments:    a dataframe created by CreateTidyDF
# Returns:      a dataframe representing an independent tidy data set
#               containing the average of each variable for each sub-
#               ject and each activity.
# Description:  Melts the data contained in the tidy data set created
#               by CreateTidyDF, and then recasts the data using dcast
#               from the reshape2 package.
# Note:         This function requires the reshape2 package which is
#               not included in the standard R installation, and must
#               be installed by the user.

CreateMeanDF <- function(tidy_df) {

    ## Check if the reshape2 package has been installed and loaded
    if (!require("reshape2", quietly=T))
        stop("Package \"reshape2\" must be installed.")
    md <- melt(tidy_df, id=(c("Subject","Activity")))
    dcast(md, Subject+Activity~variable,mean)
}

#-*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*-

# Function:     ReplaceActivityLabels
# Arguments:    a vector of activity codes and a dataframe containing
#               the mapping of activity codes to activity labels
# Returns:      a vector containing activity labels matching the 
#               activity codes from the vector passed into the function
# Description:  Used to change the activity codes to descriptive 
#               activity labels
# Note:         This function is only intended for use by the 
#               CleanAndMerge function

ReplaceActivityLabels <- function(vals, label_df) {
    v2 <- rep("a", length(vals))
    for (i in 1:nrow(label_df)) {
        v2[vals == i] <- as.character(label_df$V2[label_df$V1 == i])
    }
    v2
}

#-*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*--*-+-*-

# Function:     CleanAndMerge
# Arguments:    Five dataframes, containing (in order)
#               1. The subjects for each row of data
#               2. The activity codes for each row of data
#               3. The body data collected from the Galaxy S smartphone
#               4. The activity code/label mapping
#               5. Descriptive names for the variables in the data
#                  collected in the data frame passed in as the 3rd
#                  argument
# Returns:      a dataframe representing a tidy data set of the 
#               wearable technology data, including a column containing
#               the subject for each measurement, an activity label
#               for that measurement, and descriptive column names for
#               each variable.
# Description:  The function replaces the activity codes with descript-
#               ive labels, adds column names the are descriptive of
#               data variable being collected, removes all columns that
#               are not a mean or standard deviation, and finally binds
#               the data corresponding to the subject, the activity
#               label, and the mean and std data collected into one
#               dataframe.
# Note:         This function is only intended for use by the 
#               CreateTidyDF function

CleanAndMerge <- function(sbj_df, act_df, x_df, labels, features) {
    act_df <- ReplaceActivityLabels(act_df, labels)
    names(x_df) <- features[,2]
    new_df <- cbind(x_df[,grep("-mean()", names(x_df))],
                    x_df[,grep("-std()", names(x_df))])
    new_df <- cbind(sbj_df, act_df, new_df)
    names(new_df)[1:2] <- list("Subject", "Activity")
    new_df
}
