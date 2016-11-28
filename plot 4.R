#manually download and unzip data.  Read in as follows...
NEI <- readRDS("summarySCC_PM25.rds") #main pollution data
SCC <- readRDS("Source_Classification_Code.rds") #pollution code decoded

head(NEI)
table(NEI$year) #has four years, 1999, 2002, 2005, 2008
table(NEI$Pollutant) #all values are PM25-REI
test <- NEI[sample(nrow(NEI), 100000), ] #a random subset for faster plotting
# ASSIGNMENT

# 4 - Across the United States, how have emissions
# from coal combustion-related sources changed from 1999–2008? 

#subset data to look just at coal emissions
View(SCC)                                    #scan it over, EI.Sector has Coal
coal_codes2 <- grepl("Coal", SCC$EI.Sector)  #is each row from coal?
sum(coal_codes2)                             #99 Entries TRUE
plot(coal_codes2)                            #all are in the first few hundred
View(SCC)                                    #scan it over, looks about right
coalSCC<-SCC[coal_codes2==TRUE,1]            #coal SCC codes
coalNEI <- NEI$SCC %in% coalSCC              #NEI rows that are associated with coal codes
coal <-subset(NEI, coalNEI==TRUE)            #portion of NEI df with coal sites

#plot coal emissions
png(filename = "plot4.png")
boxplot(Emissions ~ year, data = coal, col = rgb(0,.5,.5, .2), ylim = c(0,10), 
        main = "Total Emissions by Year", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 75% confidence interval, outliers off scale")
dev.off()
