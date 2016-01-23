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
df2$Sub_metering_1 <- as.numeric(df2$Sub_metering_1)
df2$Sub_metering_2 <- as.numeric(df2$Sub_metering_2)
df2$Sub_metering_3 <- as.numeric(df2$Sub_metering_3)
df2$Global_reactive_power <- as.numeric(df2$Global_reactive_power)
df2$Voltage <- as.numeric(df2$Voltage)

#Plotting data
png(file = "plot4.png")
par(mfrow = c(2,2))
with(df2, {

plot(Datetime, Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")

plot(Datetime, Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

plot(Datetime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
lines(df2$Datetime, df2$Sub_metering_2, col = "red")
lines(df2$Datetime, df2$Sub_metering_3, col = "blue")
legend("topright", bty = "n", lty = c(1, 1, 1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

plot(Datetime, Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "datetime")
})
dev.off()