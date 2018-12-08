# GettingAndCleaning_Final
Final project for the Getting and Cleaning Data course.
-------------------------------------------------------------------------------------------------------------------
The script run_analysis.R works by:

    - running script from directory where the "UCI HAR Dataset" file is located
    
    - getting a list of all installed packages and checking for the "dplyr" package
        - if the "dplyr" package is not there then it attempts to install it
    
    - loading the dplyr library
    
    - defining a function which is later used to "recode" the activity files
    
    - reading the labels ("activity_labels.txt", and "features.txt") which are used to name the rows and columns
    
    - reading the test and train data files 
    
    - using the recodeFunction() to change the activity ID numbers (in activity_labels.txt) to their respective names
    
    - c-binding the columns of test and train files into two parts
    
    - r-binding those 2 parts to combine all of the data into one set
    
    - selecting from the total set only the variables which contain "mean()" and "std()"
        -this ignores the "meanFunc()" and "angle()" measurements in the features.txt file
    
    - finally grouping the mean/ std selection first by subject, then by activity, 
      then summarizing by taking the mean of each variable, giving a tidy data set of
      180 observations X 68 variables
    
    - and creates a .txt file of this tidy data set (finalSet.txt)
-------------------------------------------------------------------------------------------------------------------
See *theCodeBook.md* contained in this repo for Study Design and Variable Information.

