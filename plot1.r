#Download and unzip file, and read into dataframe
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
df <- read.table(unz(temp, "household_power_consumption.txt"), header = TRUE, sep = ";", stringsAsFactors = FALSE)

#Convert columns from character to date class
df$Date <- as.Date(df$Date, "%d/%m/%Y")
df$Time <- as.Date(df$Time, "%H/%M/%S")

#Subset to 2007-02-01:02 time frame
df1 <- subset(df, format.Date(df$Date, "%Y") == "2007" & format.Date(df$Date, "%m") == "02")
df2 <- subset(df1, format.Date(df1$Date, "%d") == "01" | format.Date(df1$Date, "%d") == "02")

#Conversion to numeric class
df2$Global_active_power <- as.numeric(df2$Global_active_power)

#Figure out max value for y-axis
#y <- hist(df2$Global_active_power)
#str(y)

#Plotting data
png(file = "plot1.png")
hist(df2$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power", yaxt = 'n', xaxt = 'n')
axis(1, at = seq(0, 6, 2), labels = seq(0, 6, 2))
axis(2, at = seq(0, 1200, 200), label = seq(0, 1200, 200))
dev.off()

