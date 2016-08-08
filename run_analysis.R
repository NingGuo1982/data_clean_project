getwd()
setwd(paste0(getwd(),"/UCI HAR Dataset"))
list.files(, recursive = TRUE)
## Read data from the files into the variables
activitytest<- read.table("test/y_test.txt", header = FALSE)
activitytrain<- read.table("train/y_train.txt", header = FALSE)
subjecttest<- read.table("test/subject_test.txt", header = FALSE)
subjecttrain<- read.table("train/subject_train.txt", header = FALSE)
featuretest<- read.table("test/x_test.txt", header = FALSE)
featuretrain<- read.table("train/x_train.txt", header = FALSE)
## Merge the data tables by rows
activity<- rbind(activitytest, activitytrain)
subject<- rbind(subjecttest, subjecttrain)
feature<- rbind(featuretest,featuretrain)
str(activity)
str(subject)
str(feature)
## Set names to variable before merge and labels the data set with descriptive variable names.
names(activity)<- c("activity")
names(subject)<- c("subject")
datafeaturenames<- read.table("features.txt", header = FALSE)
names(feature)<- datafeaturenames$V2
## Merge the data tables by columns
datacombine<- cbind(subject, activity, feature)
str(datacombine)
head(datacombine)

##Subset Name of Features by measurements on the mean and standard deviation
subdatafeaturenames<- datafeaturenames$V2[grep("mean\\(\\)|std\\(\\)", datafeaturenames$V2)]
str(subdatafeaturenames)
selectednames<- c("subject", "activity", as.character(subdatafeaturenames))
subdatacombine<- subset(datacombine, select = selectednames)
str(subdatacombine)

##Uses descriptive activity names to name the activities in the data set
activitylabels<- read.table("activity_labels.txt", header = FALSE)
activitylabels
subdatacombine$activity[subdatacombine$activity == 1]<- c("WALKING")
subdatacombine$activity[subdatacombine$activity == 2]<- c("WALKING_UPSTAIRS")
subdatacombine$activity[subdatacombine$activity == 3]<- c("WALKING_DOWNSTAIRS")
subdatacombine$activity[subdatacombine$activity == 4]<- c("SITTING")
subdatacombine$activity[subdatacombine$activity == 5]<- c("STANDING")
subdatacombine$activity[subdatacombine$activity == 6]<- c("LAYING")
str(subdatacombine)

## creates a second, independent tidy data set with the average of each variable for each activity 
## and each subject.
library(plyr)
subdatacombine2<- aggregate(. ~ subject + activity, subdatacombine, mean)
str(subdatacombine2)
write.table(subdatacombine2, file = "tidydata.txt",row.name=FALSE)

