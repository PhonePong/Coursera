# theCodeBook

Study Design
-------------------------------------------------------------------------------------------------------------------
1. The data was downloaded and un-zipped to the working directory clicking on the given link:
 ```
  - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 ```

2. By reading the 'features.txt' first, I am able to label the 'X_test.txt' and 'X_train.txt' variables at the same time I read them. See step 5. *__See the Variable Information below for detailed variable descriptions.__*
3. Read the 'activity_labels.txt' for later use.
4. Read all 6 text files from 'test' and 'train' (X_test, y_test, subject_test, X_train, y_train, subject_train)
5. For the 'X_test.txt' and 'X_train.txt' I used:
 ```
 > read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features.txt$V2)
 > read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features.txt$V2)
 ```
 
6. I then recode the activity lists (y_test, and y_train) to be a list of descriptive names instead of numbers.
7. I then used chained cbind() functions on both test set, and train set to have to sets.
 ```
  > testData <- subject_test %>% cbind(y_test) %>% cbind(X_test)
  > trainData <- subject_train %>% cbind(y_train) %>% cbind(X_train)
 ```
 
8. Next I rbind() these 2 data sets, to create 1 big data set with 10299 observations, and 563 variables (561 are features, add 2 for the subject and activity variables). 
 ```
 > bindData <- rbind(testData, trainData)
 ```
 
9. By using a grepl() command, I successfully select the features that contain only the mean measurement, and standard deviation. When selecting the mean measurements, special attention was given to avoid selecting the following features:
 ```
 294 fBodyAcc-meanFreq()-X
 295 fBodyAcc-meanFreq()-Y
 296 fBodyAcc-meanFreq()-Z
 373 fBodyAccJerk-meanFreq()-X
 374 fBodyAccJerk-meanFreq()-Y
 375 fBodyAccJerk-meanFreq()-Z
 452 fBodyGyro-meanFreq()-X
 453 fBodyGyro-meanFreq()-Y
 454 fBodyGyro-meanFreq()-Z
 513 fBodyAccMag-meanFreq()
 526 fBodyBodyAccJerkMag-meanFreq()
 539 fBodyBodyGyroMag-meanFreq()
 552 fBodyBodyGyroJerkMag-meanFreq()
 ```
 
10. This was achieved by specifying word boundaries (\\b) around the string 'mean' in the regex within the grepl() command:
 ```
 > meanStd <- bindData[,grepl("SubjectID|Activity|\\bmean\\b|std", colnames(bindData))]
 ```
 
11. Since the regex specified only 'mean' and not '[Mm]ean' (with capitol M), no further changes were needed to avoid selecting the following observations:
 ```
 555 angle(tBodyAccMean,gravity)
 556 angle(tBodyAccJerkMean),gravityMean)
 557 angle(tBodyGyroMean,gravityMean)
 558 angle(tBodyGyroJerkMean,gravityMean)
 559 angle(X,gravityMean)
 560 angle(Y,gravityMean)
 561 angle(Z,gravityMean)
 ```

12. This 'mean()' and 'std()' selection produced a data set with 10299 observations, and 68 variables (66 are features, add 2 for the subject and activity variables).
13. The final step produced the independent tidy data set with the average of each variable for each activity and each subject. This was achieved in one line of code using chaining.

 ```
 > finalSet <- meanStd %>% group_by(SubjectID, Activity) %>% summarise_each(funs(mean))
 ```
 
We can see the 'meanStd' data set from step 10 is grouped first by subject, then activity. Finally the 'mean()' function is applied to summarize each variable for each unique occurence of subject *and* activity. The final data set contains 180 observations, and 68 variables. 

To check results, the 180 observations can be realized even before the final step.
```
> count(unique(meanStd[c("SubjectID", "Activity")]))
Source: local data frame [1 x 1]

      n
  (int)
1   180
>
```

##Variable Information

######**- All following variable information is taken from the 'README.txt' located in the 'UCI HAR Dataset' file.**
-------------------------------------------------------------------------------------------------------------------
>
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
>
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.
>
For each record it is provided:
>
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
>
The dataset includes the following files:
>
- 'README.txt'
>
- 'features_info.txt': Shows information about the variables used on the feature vector.
>
- 'features.txt': List of all features.
>
- 'activity_labels.txt': Links the class labels with their activity name.
>
- 'train/X_train.txt': Training set.
>
- 'train/y_train.txt': Training labels.
>
- 'test/X_test.txt': Test set.
>
- 'test/y_test.txt': Test labels.
>
- [In 'subject_train.txt' and 'subject_test']: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
>
- The acceleration signal from the smartphone accelerometer X, Y and Z axis [is] in standard gravity units 'g'. Every row shows a 128 element vector.  
>
- The body acceleration signal obtained by subtracting the gravity from the total acceleration. [possibly m/s^2 ?]
>
- The angular velocity vector measured by the gyroscope for each window sample [are measured in] radians/second. 
>
These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
>
Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
>
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
>
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

