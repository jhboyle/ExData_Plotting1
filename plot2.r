library(lubridate)
library(dplyr)

#Download and unzip file, and read into dataframe
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
df <- read.table(unz(temp, "household_power_consumption.txt"), header = TRUE, sep = ";", stringsAsFactors = FALSE)

#Merge date and time columns, and mutate new column into dataframe 
Datetime <- as.POSIXct(paste(df$Date, df$Time), format="%d/%m/%Y %H:%M:%S")
df <- mutate(df, Datetime)

#Convert columns from character to date class
df$Date <- as.Date(df$Date, "%d/%m/%Y")
#df$Time <- strptime(x = df$Time, format = "%H:%M:%S")

#Subset to 2007-02-01:02 time frame
df1 <- subset(df, format.Date(df$Date, "%Y") == "2007" & format.Date(df$Date, "%m") == "02")
df2 <- subset(df1, format.Date(df1$Date, "%d") == "01" | format.Date(df1$Date, "%d") == "02")

#Conversion to numeric class
df2$Global_active_power <- as.numeric(df2$Global_active_power)

#Determine weekdays
#wday(df2$Date, label = TRUE)

#Plotting data
png(file = "plot2.png")
with(df2, plot(Datetime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = ""))
dev.off()