# setting working directory
setwd("set working directory")

# saving url adress and downloading the data
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataUrl, "household_power_consumption.zip")

# reading data (only from 2007-02-01 and 2007-02-02)
dataName <- "household_power_consumption.txt"
colNames <- colnames(read.table(unz("household_power_consumption.zip", dataName),
                       nrows = 1, header = TRUE, sep=";"))
rowNumber <- 60*24*2

HHPCdata <- read.table(unz("household_power_consumption.zip", dataName),
                   skip = grep("31/1/2007;23:59:00", readLines(dataName)),
                   col.names = colNames,
                   nrows = 2880, header = FALSE, sep=";")
head(HHPCdata)
tail(HHPCdata)

## merging Date and Time columns
library("tidyr")
HHPCdata$Date2 <- HHPCdata$Date
HHPCdata <- unite(HHPCdata,
                  col = "Time",
                  Date2, Time,
                  sep = " ") 
head(HHPCdata)

## changing Date and Time columns into Date/Time classes
HHPCdata$Date <- as.Date(strptime(as.character(HHPCdata$Date), "%d/%m/%Y"))
HHPCdata$Time <- strptime(as.character(HHPCdata$Time), "%d/%m/%Y %H:%M:%S")

head(HHPCdata)
str(HHPCdata)
summary(HHPCdata)


## plot4
## setting frame for showing plots and then drawing each plot
## copying plot into file device at the end
par(mfrow = c(2, 2))
with(HHPCdata, {
    plot(HHPCdata$Time, HHPCdata$Global_active_power,
         ylab = "Global Active Power (kilowatts)",
         xlab = "",
         type = "l")
    
    plot(HHPCdata$Time, HHPCdata$Voltage,
         ylab = "Voltage",
         xlab = "datetime",
         type = "l")
    
    plot(HHPCdata$Time, HHPCdata$Sub_metering_1,
         ylab = "Energy sub metering",
         xlab = "",
         type = "n")
    lines(HHPCdata$Time, HHPCdata$Sub_metering_1, col = "black")
    lines(HHPCdata$Time, HHPCdata$Sub_metering_2, col = "red")
    lines(HHPCdata$Time, HHPCdata$Sub_metering_3, col = "blue")
    legend("top",
           col = c("black", "red", "blue"),
           legend = colnames(HHPCdata[7:9]),
           lty = c(1, 1, 1), lwd = 2,
           box.lty = 0,
           bg="transparent")
    
    plot(HHPCdata$Time, HHPCdata$Global_reactive_power,
         ylab = "Global_reactive_power",
         xlab = "datetime",
         type = "l")
})
dev.copy(png, file = "plot4.png")  
dev.off()

