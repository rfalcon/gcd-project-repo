Course Project Submission Guide
===========

This is a guide for my fellow classmates in the "Getting and Cleaning Data" course who will be grading my project submission.

In the following sections I will provide some instructions on the different project deliverables.

### The tidy data set

The file name is **output.txt** and has been generated according to the specifications described in the project guidelines, i.e.:

* it is a TXT file
* it has been created with the write.table() function
* and using row.name=FALSE

To load the data set, simply copy the following code snippet and paste it into a new R script, then source the script.

```R
address <- "https://s3.amazonaws.com/coursera-uploads/user-ad4b6720cb2285f561db5a51/973498/asst-3/45651c40ba0311e4b6ed11ed03707633.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE)
View(data)
```

You should be able to see a dataset with 180 observations of 68 variables. 

The 180 observations come from the combination of 6 activities and 30 subjects participating in the Samsung study.

The first two columns in the data set represent the ID of the subject and the description of the activity for which the means of the different variables were computed. 

The remaining 66 columns are the variables under consideration in this course project, i.e., the means of those variables in the original data set (both training and testing) that reflect the means and standard deviations of the original measurement variables. It was assumed that any attribute that contains the terms "mean()" or "std()" as part of its name is one that should be taken into account.

* The names of these variables have been taken from the 'features.txt' file provided as part of the project data. 

* The original names of the attributes in the 'features.txt' file have undergone a fairly simple preprocessing (empty brackets have been replaced with empty strings, dashes with underscores and the feature names containing 'BodyBody' have been corrected to 'Body') in order to make them more descriptive and use them as the headers of the generated wide tidy data set. 

* Although the last 66 variables in the tidy data set are the means of the original variables along each (subject id, activity id) combination, the attribute names do not bear an extra "mean" or "average" in order to avoid confusion, as some of the original attributes already have a "mean" as part of their name.

More importantly, the **output.txt** file contains a tidy data set according to the principles laid out by [Hadley Wickham](http://had.co.nz/) in [this paper](http://vita.had.co.nz/papers/tidy-data.pdf)
and [this video](http://vimeo.com/33727555). This means that:

1. Each variable measured should be in one column
1. Each different observation of that variable should be in a different row

The tidy data set is of the "wide" type (as described by the project rubric, i.e., each of the 66 variables representing the means per subject per activity is found in a separate column).

Other project requirements, such as providing descriptive activity names (WALKING, LAYING, SITTING, etc. instead of 1,2,3) and labeling the data set with descriptive variable names, have also been fulfilled.

### The code book

Please see the file **Codebook.md** that accompanies this submission. It contains the following information about the variables in the (wide) tidy data set:  

* index = the column index in the data set
* field = name of the column header
* description = what the variable is about
* type = nominal or numerical
* units = the unit system employed to measure this variable; or N/A if variable is unitless
* values = the set of values in the nominal attribute's domain
* range = the range of values [min;max] in the numerical attribute's domain


### The instruction list/script

Please see the file **run_analysis.R** that accompanies this submission. This is the R script that takes the raw Samsung data and generates the tidy data set **output.txt**

The workflow of the analysis R file is given below:

1. It assumes the project's raw data folder (**UCI HAR Dataset**) is located in the working directory. If not, the execution will halt.

1. It assumes the **dplyr** package is installed. If not, it will try to install it before proceeding.

1. It reads raw data files like the textual description of the activities, the feature names, and the training and test data for the "y" activities and the subjects participating in the Samsung study. It does NOT, however, read or use any information from the **Inertial Signals** folders.

1. It retrieves only those variables corresponding to the means and standard deviations of the original measurements. It was assumed that any attribute in the "X" data set (training or testing) that contains the terms "mean()" or "std()" as part of its name is one that should be taken into account in the subsequent analysis. The rest of the attributes are simply not read from the file.

1. It performs a simple preprocessing of the attribute names read from the raw *features.txt* file (such as removal of empty brackets) in order to provide a more descriptive name as header for each variable in the tidy data set.

1. It merges (through rbind) the training and testing data sets for the "X" measurement data, the "y" activity data and the subject data, and brings everything into a single data set.

1. It merges the activity labels and activity numbers based on the numerical IDs. This step is needed to provide more descriptive names for the activities later on. Notice that the numerical activity ID is dropped from the data set as per the indication by the [Leek Group](http://biostat.jhsph.edu/%7Ejleek/) not to treat categorical variables as numbers. With the subject IDs we had no choice as there were no descriptive names for these subjects other than their IDs. This gives rise to the data set in Step 4 of the project guidelines.

1. It groups by subject ID and activity name (6 x 30 = 180 groups) and summarizes each of the 66 variable columns using the **dplyr** package's *summarise_each()* function. 

1. Finally, it writes the summarized data set using *write.table()* with the specified instructions. This generates the tidy data set stored in the **output.txt** file.



