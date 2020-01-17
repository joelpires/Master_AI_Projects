library(ggplot2)
library(lubridate)
library(anytime)
library(tidyr)

col_name <- c("Job Number", "Submit Time", "Wait Time", "Run Time", "Num of Allocated Processors",
              "Average CPU Time Used", "Used Memory", "Requested Num of Processors", "Requested Time",
              "Requested Memory","Status","User ID","Group ID","Executable Number", "Queue Number",
              "Partition Number","Preceding Job Number","Think Time from Preceding Job")

mydata <- read.table("UniLu-Gaia.txt", col.names = col_name)


col_name2 <- c("Job Number", "Sum Job Reads Kb", "Sum Job Writes Kb")

mydata.IO <- read.table("UniLu-Gaia-IO.txt", col.names = col_name2)


#add Finish.Time column to mydata
mydata$Finish.Time <- mydata$Submit.Time + mydata$Wait.Time + mydata$Run.Time

#add day, month, year and weekday to mydata
UnixStartTime <- 1400749079
mydata$Date <- as.Date(as.POSIXct(UnixStartTime + mydata$Submit.Time, origin = "1970-01-01"))
mydata$WeekNumber <- week(mydata$Date)
mydata$FinishWeekNumber <- week(as.Date(as.POSIXct(UnixStartTime + mydata$Finish.Time, origin = "1970-01-01")))
mydata$Weekday <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                    "Saturday") [as.POSIXlt(UnixStartTime + mydata$Submit.Time, origin = "1970-01-01")$wday+1]


#add 2 variables from mytable.IO to mytable
mydata$Sum.Job.Reads.Kb <- mydata.IO[,"Sum.Job.Reads.Kb"]
mydata$Sum.Job.Writes.Kb <- mydata.IO[,"Sum.Job.Writes.Kb"]


#remove irrelevant cols and rows

mydata$Requested.Memory <- NULL
mydata$Preceding.Job.Number <- NULL
mydata$Partition.Number <- NULL
mydata$Think.Time.from.Preceding.Job <- NULL

#Jobs with Run Time = -1 
Failed.Jobs <- mydata[mydata$Run.Time == -1,]
#Jobs with Status 0
Failed.Status <- mydata[mydata$Status == 0,]
#Jobs with status 1
Completed.Status <- mydata[mydata$Status == 1,]

#----------------------------------------------#
#-------------Analyse all the data-------------#
#----------------------------------------------#


#Number of jobs by Status
ggplot(mydata, aes(x = as.factor(Status), fill = as.factor(Status))) + geom_bar() +
  geom_text(stat = "count", size = 4, aes(label = ..count..), vjust = -0.5) + 
  xlab("Status") + ylab("Count") + labs(fill = "Status")  + ylab("Number of Jobs") + 
  ggtitle("Job distribution by Status") + theme(plot.title = element_text(hjust = 0.5))



#number of jobs per user
ggplot(mydata, aes(x = User.ID)) + geom_histogram(binwidth = 0.4, position = position_dodge(width = 0.8)) +
  geom_text(stat = "bin",size = 3, aes(label = ..count..), vjust = -1.5) +
  coord_cartesian(xlim = c(0,85)) +
  xlab("User ID") + scale_x_continuous(breaks = seq(1,84,by=2))

#Number of jobs per week
ggplot(mydata, aes(x = factor(FinishWeekNumber))) + geom_histogram(stat = "count") + 
  xlab("WeekNumber") + ylab("Number of jobs") + labs(fill = "User ID") + ggtitle("Finished Jobs per Week") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_text(stat = "count", size = 4, aes(label = ..count..), vjust = -0.5)


#------------------------------------------------------------------#
#-------------Analyse Failed Jobs (with Run Time = -1)-------------#
#------------------------------------------------------------------#

#status distribution of failed jobs
ggplot(Failed.Jobs, aes(x = Status, fill = as.factor(Status))) + geom_histogram(binwidth = 0.1) +
    geom_text(stat = "count", size = 4, aes(label = ..count..), vjust = 2) +
    xlab("Status") + ylab("Number of Jobs") + labs(fill = "Status")

#number of failed jobs per week (grouped by user id)
ggplot(Failed.Jobs, aes(x = FinishWeekNumber, fill = factor(User.ID))) + geom_histogram(binwidth = 1) + 
  xlab("Week Number") + ylab("Number of Jobs") + labs(fill = "User ID") + ggtitle("Failed jobs per Week (Grouped by User ID)") + 
  theme(plot.title = element_text(hjust = 0.5))

#------------------------------------------------------------------#
#-------------Analyse Failed Jobs (with Status = 0)----------------#
#------------------------------------------------------------------#

#number of jobs with status = 0 per week
ggplot(Failed.Status, aes(x = factor(FinishWeekNumber))) + geom_histogram(stat = "count") + 
  xlab("WeekNumber") + ylab("Number of jobs") + labs(fill = "User ID") + ggtitle("Finished Jobs with Status = 0 per Week") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_text(stat = "count", size = 4, aes(label = ..count..), vjust = -0.5)

#------------------------------------------------------------------#
#-------------Analyse Completed Jobs (with Status = 1)-------------#
#------------------------------------------------------------------#

#number of jobs with status = 1 per week
ggplot(Completed.Status, aes(x = factor(FinishWeekNumber))) + geom_histogram(stat = "count") + 
  xlab("WeekNumber") + ylab("Number of Jobs") + labs(fill = "User ID") + ggtitle("Jobs with Status = 1 per Week") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_text(stat = "count", size = 4, aes(label = ..count..), vjust = -0.5)

#percentage of succeded jobs per week
percentage <- function(){
    temp <- vector()
    aux <- NULL
    for(i in 21:33){
      aux <- length(Completed.Status$Status[Completed.Status$WeekNumber == i]) / length(mydata$Status[mydata$WeekNumber == i])
      temp <- c(temp, aux)
    }
    return(temp)
  }

vec = percentage()

plot(x = 21:33, y = vec*100, type = "h", xlab = "Week Number", ylab = "Percentage of Success",main = "Percentage of Success in each Week" ,lwd = 6)
axis(side = 1, at=21:33, cex.axis = 1)

Completed.Status$WeekNumber[which(!duplicated(Completed.Status$WeekNumber))]

################################################################

#simultaneous jobs

aux_data <- Completed.Status[,1:2]  
aux_data$Job.Number <- aux_data$Submit.Time
aux_data$Submit.Time <- Completed.Status$Finish.Time
aux_data$Allocated.Processors <- Completed.Status$Num.of.Allocated.Processors
aux_data$WeekNumber <- Completed.Status$WeekNumber
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
    
    new_data$Sum.Processors[i] <- temp2
  }
  return(new_data)
} 

new_data = job_sum()

#number of jobs running at the same time
ggplot(new_data, aes(x = Time, y = Sum.Jobs)) + geom_line(colour = "#56B4E9") + 
  xlab("Time (seconds)") + ylab("Number of Jobs") + ggtitle("Number of jobs running at the same time") + 
  theme(plot.title = element_text(hjust = 0.5)) 

#number of processors allocated by time
Max <- data.frame(x = c(-Inf, Inf), y = 2004, Max = factor(2004))
ggplot(new_data, aes(x = Time, y = new_data$Sum.Processors)) + geom_line(colour = "#56B4E9") + 
  xlab("Time (seconds)") + ylab("Number of Processors") + 
  ggtitle("Number of processors allocated") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_line(aes( x, y, linetype = Max),size = 1.5, colour = "red", Max)
