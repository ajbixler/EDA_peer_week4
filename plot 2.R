#manually download and unzip data.  Read in as follows...
NEI <- readRDS("summarySCC_PM25.rds") #main pollution data
SCC <- readRDS("Source_Classification_Code.rds") #pollution code decoded

head(NEI)
table(NEI$year) #has four years, 1999, 2002, 2005, 2008
table(NEI$Pollutant) #all values are PM25-REI
test <- NEI[sample(nrow(NEI), 100000), ] #a random subset for faster plotting
# ASSIGNMENT

# 2 - Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question. 
balt<-NEI[NEI$fips == "24510",]
png(filename = "plot2.png")
boxplot(Emissions ~ year, data = balt, col = rgb(0,.5,.5, .2), ylim = c(0,5), 
        main = "Baltimore City, MD Emissions by Year", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 95% confidence interval, outliers off scale")
dev.off()
