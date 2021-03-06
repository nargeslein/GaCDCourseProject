library(dplyr)

#read files
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#add variable names to datasets
names(train_set) <- features[,2]
names(test_set) <- features[,2]

#replace code by activity description
test_labels$Description <- activity_labels[match(test_labels[,1],activity_labels[,1]),2]
train_labels$Description <- activity_labels[match(train_labels[,1],activity_labels[,1]),2]

#columns based on mean() or std()
columns <- grep("(mean|std)\\(\\)", features[,2], ignore.case = TRUE, value=TRUE)

#merge sets with labels and select columns
total_test_data <- cbind(test_labels[,2],test_subjects[,1], test_set[,columns])
colnames(total_test_data)[1] <- "Activity"
colnames(total_test_data)[2] <- "Subject"


total_train_data <- cbind(train_labels[,2],train_subjects[,1], train_set[,columns])
colnames(total_train_data)[1] <- "Activity"
colnames(total_train_data)[2] <- "Subject"
#merge both dataset 
total_data <- rbind(total_test_data, total_train_data)

#create final dataset with averages
average <- total_data %>% group_by(Activity,Subject) %>% summarize_all(funs(mean))

write.table(average,file ="tidydataset.txt",row.names = FALSE)