#manually download and unzip data.  Read in as follows...
NEI <- readRDS("summarySCC_PM25.rds") #main pollution data
SCC <- readRDS("Source_Classification_Code.rds") #pollution code decoded

head(NEI)
table(NEI$year) #has four years, 1999, 2002, 2005, 2008
table(NEI$Pollutant) #all values are PM25-REI
test <- NEI[sample(nrow(NEI), 100000), ] #a random subset for faster plotting
# ASSIGNMENT
# 1 - Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.
#plot(test$year, test$Emissions, pch=19, col = rgb(0,.5,.5, .2), ylim = c(0,100))
png(filename = "plot1.png")
boxplot(Emissions ~ year, data = NEI, col = rgb(0,.5,.5, .2), ylim = c(0,.8), 
        main = "Total Emissions by Year", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 95% confidence interval, outliers off scale")
dev.off()