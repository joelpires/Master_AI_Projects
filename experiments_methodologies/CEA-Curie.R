library(ggplot2)
library(lubridate)
library(anytime)
library(tidyr)

col_name <- c("Job Number", "Submit Time", "Wait Time", "Run Time", "Num of Allocated Processors",
              "Average CPU Time Used", "Used Memory", "Requested Num of Processors", "Requested Time",
              "Requested Memory","Status","User ID","Group ID","Executable Number", "Queue Number",
              "Partition Number","Preceding Job Number","Think Time from Preceding Job")


mydata <- read.table("CEA-Curie.txt", col.names = col_name)

mydata$Finish.Time <- mydata$Submit.Time + mydata$Run.Time + mydata$Wait.Time

#remove irrelevant cols and rows
mydata$Average.CPU.Time.Used <- NULL
mydata$Used.Memory <- NULL
mydata$Requested.Memory <- NULL
mydata$Preceding.Job.Number <- NULL
mydata$Executable.Number <- NULL
mydata$Think.Time.from.Preceding.Job <- NULL
mydata$Queue.Number <- NULL

#add day, month, year and weekday to mydata
UnixStartTime <- 1296571124
mydata$Date <- as.Date(as.POSIXct(UnixStartTime + mydata$Submit.Time, origin = "1970-01-01"))
mydata$WeekNumber <- week(mydata$Date)
mydata$Weekday <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                    "Saturday") [as.POSIXlt(UnixStartTime + mydata$Submit.Time, origin = "1970-01-01")$wday+1]
mydata$FinishWeekNumber <- week(as.Date(as.POSIXct(UnixStartTime + mydata$Finish.Time, origin = "1970-01-01")))


Failed.Jobs = mydata[mydata$Status == 0,]
Completed.Jobs = mydata[mydata$Status == 1,]


#----------------------------------------------#
#-------------Analyse all the data-------------#
#----------------------------------------------#

#number of jobs per user
p1 <- ggplot(mydata, aes(x = User.ID)) + geom_histogram(binwidth = 0.4, position = position_dodge(width = 0.8)) +
  coord_cartesian(xlim = c(0,722)) + xlab("User ID")
p1 + ggtitle("Number of jobs per user")

#status distribution of jobs
ggplot(mydata, aes(x = Status, fill = as.factor(Status))) + geom_histogram(binwidth = 0.1) +
  geom_text(stat = "count", size = 4, aes(label = ..count..), vjust = 2) +
  xlab("Status") + ylab("Number of Jobs") + labs(fill = "Status") + 
  ggtitle("Job distribution by Status") + theme(plot.title = element_text(hjust = 0.5))

#status distribution per user
ggplot(mydata, aes(x = User.ID, fill = as.factor(Status))) + geom_histogram(binwidth = 10.0) +
  xlab("User ID") + ylab("Number of Jobs") + labs(fill = "Status") + 
  ggtitle("Status distribution per User") + theme(plot.title = element_text(hjust = 0.5))

#number of jobs finished per week
ggplot(mydata, aes(x = factor(FinishWeekNumber))) + geom_histogram(stat = "count") + 
  xlab("Week Number") + ylab("Number of jobs") + ggtitle("Finished Jobs per Week") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_text(stat = "count", size = 3.5, aes(label = ..count..), vjust = -0.5)


#percentage of succeded jobs per week
percentage <- function(){
  temp <- vector()
  aux <- NULL
  for(i in 5:42){
    aux <- length(Completed.Jobs$Status[Completed.Jobs$WeekNumber == i]) / length(mydata$Status[mydata$WeekNumber == i])
    temp <- c(temp, aux)
  }
  return(temp)
}

vec = percentage()

plot(x = 5:42, y = vec*100, type = "h", xlab = "Week Number", ylab = "Percentage of Success",main = "Percentage of Success in each Week" ,lwd = 6)
axis(side = 1, at=seq(5,42, by = 3))



#------------------------------------------------------------------#
#-------------Analyse Failed Jobs (with Status = 0)----------------#
#------------------------------------------------------------------#

#number of jobs with status = 0 per week
ggplot(Failed.Jobs, aes(x = factor(FinishWeekNumber))) + geom_histogram(stat = "count") + 
  xlab("Week Number") + ylab("Number of jobs") + ggtitle("Finished Jobs with Status = 0 per Week") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_text(stat = "count", size = 3.5, aes(label = ..count..), vjust = -0.5)

#failed jobs per user
ggplot(Failed.Jobs, aes(x = User.ID)) + geom_bar() + 
  xlab("User ID") + ylab("Number of Jobs") + labs(fill = "User ID")

#------------------------------------------------------------------#
#-------------Analyse Completed Jobs (with Status = 1)-------------#
#------------------------------------------------------------------#

#number of jobs with status = 1 per week
ggplot(Completed.Jobs, aes(x = factor(WeekNumber))) + geom_histogram(stat = "count") + 
  xlab("Week Number") + ylab("Number of Jobs") + ggtitle("Finished Jobs with Status = 1 per Week") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_text(stat = "count", size = 3, aes(label = ..count..), vjust = -0.5)


#simultaneous jobs

aux_data <- Completed.Jobs[,1:2]  
aux_data$Job.Number <- aux_data$Submit.Time
aux_data$Submit.Time <- Completed.Jobs$Finish.Time
aux_data$Allocated.Processors <- Completed.Jobs$Num.of.Allocated.Processors
aux_data$Job.Life <- +1
aux_data$Sum.Processors <- 0
aux_data<-do.call("rbind", replicate(2,aux_data, simplify = FALSE))

aux_data$Job.Number[(nrow(aux_data)/2+1):nrow(aux_data)] = aux_data$Submit.Time 
aux_data$Submit.Time <- NULL
aux_data$Job.Life[(nrow(aux_data)/2+1):nrow(aux_data)] = -1
colnames(aux_data)[colnames(aux_data) == "Job.Number"] <- "Time"


new_data <- aux_data[order(aux_data$Time),]
new_data$Sum.Jobs <- sum(new_data$Job.Life[1:5])


#função que determina numero de Jobs a decorrer em simultaneo e o numero de processadores alocados
job_sum <- function(){
  temp <- NULL
  temp2 = 0
  for(i in 1:length(new_data[,1])){
    temp <- sum(new_data$Job.Life[1:i])
    new_data$Sum.Jobs[i] <- temp
    if(new_data$Job.Life[i] == 1){
      temp2 = temp2 + new_data$Allocated.Processors[i]
    }
    else temp2 = temp2 - new_data$Allocated.Processors[i]
    print(i)
    new_data$Sum.Processors[i] <- temp2
  }
  return(new_data)
} 

new_data = job_sum()
