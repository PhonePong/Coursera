
#this function gets a list of all installed packages 
ip <- as.data.frame(installed.packages()[,c(1,3:4)])
rownames(ip) <- NULL
ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]

#this function checks the list for the dplyr package. if it does not exist, then it installs it, then loads it.
if("dplyr" %in% ip$Package){
  library(dplyr)
  }else {
    print("dplyr package not installed!")
    install.packages("dplyr")
    library(dplyr)
  #quit() #this exits R session, which is undesirable since all we want is to stop the script
}


#this function is so that I can take the names from activity_labels.txt and 
# matches/ replaces the y_test.txt and y_train.txt numbers later.

recodeFunction <- function(data, indexValues, newValues){
  #convert any factors to characters
  if(is.factor(data)) data <- as.character(data)
  if(is.factor(indexValues)) indexValues <- as.character(indexValues)
  if(is.factor(newValues)) newValues <- as.character(newValues)
  
  #create the return vector
  newVector <- data
  
  #put values into the correct position in the return vector
  for(i in unique(indexValues)) newVector[data == i] <- newValues[indexValues == i]
  
  newVector
}

#reading labels
activityNames <- read.table("./UCI HAR Dataset/activity_labels.txt")
columnFeatures <- read.table("./UCI HAR Dataset/features.txt")#, colClasses = c(rep("character", 2)))
columnFeatures$V1 <- NULL #dont need this column for col.names()


#> sapply(activityNames, class)
#       V1        V2 
#"integer"  "factor"

#reading test data (./UCI HAR Dataset/test/...)
test_activiT <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
test_Measures <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = columnFeatures$V2)
test_Subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "SubjectID")

#reading train data (./UCI HAR Dataset/train/...)
train_activiT <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
train_Measures <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = columnFeatures$V2)
train_Subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "SubjectID")

#recoding the activity lists to give descriptive names instead of numbers 
test_activiT <- recodeFunction(test_activiT, activityNames$V1, activityNames$V2)
train_activiT <- recodeFunction(train_activiT, activityNames$V1, activityNames$V2)

#C binding the test and train columns by chaining 
chained1 <- test_Subjects %>% cbind(test_activiT) %>% cbind(test_Measures)
chained2 <- train_Subjects %>% cbind(train_activiT) %>% cbind(train_Measures)

#merging both vertically (using rbind() not merge())
bindData <- rbind(chained1, chained2)

#selecting only the mean/std variables for part 4 (with SubjectID and Activity)
meanStd <- bindData[,grepl("SubjectID|Activity|\\bmean\\b|std", colnames(bindData))]

finalSet <- meanStd %>% group_by(SubjectID, Activity) %>% summarise_each(funs(mean))
write.table(finalSet, file = "finalSet.txt")

