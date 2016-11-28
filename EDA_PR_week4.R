#manually download and unzip data.  
#Read in as follows, assuming data is in working directory...
NEI <- readRDS("summarySCC_PM25.rds") #main pollution data
SCC <- readRDS("Source_Classification_Code.rds") #pollution code decoded

#explore before plotting
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
# 2 - Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question. 
balt<-NEI[NEI$fips == "24510",]
png(filename = "plot2.png")
boxplot(Emissions ~ year, data = balt, col = rgb(0,.5,.5, .2), ylim = c(0,5), 
        main = "Baltimore City, MD Emissions by Year", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 95% confidence interval, outliers off scale")
dev.off()
# 3 - Of the four types of sources indicated by the
# type (point, nonpoint, onroad, nonroad) variable, which of these four sources
# have seen decreases in emissions from 1999–2008 for Baltimore City? Which have
# seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to
# make a plot answer this question. 
library(ggplot2)
png(filename = "plot3.png")
qplot(year, Emissions, data = balt, geom = "point", facets = .~type, asp = 2, 
      main = "Emissions by year and type for Baltimore, MD") + 
    geom_smooth(method = "lm") + 
    coord_cartesian(ylim = c(0,50))
dev.off()
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

# 5 - How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?
#Get the SCC codes associated with auto vehicles
View(SCC)                                    #scan it over, EI.Sector has Vehic
Vehic_codes <- grepl("Vehic", SCC$EI.Sector) #is each row from Vehic?
sum(Vehic_codes)                             #1138 Entries TRUE
plot(Vehic_codes)                            #all are in ~500-1800
View(SCC)                                    #scan it over, looks about right
VehicSCC<-SCC[Vehic_codes==TRUE,1]           #Vehic SCC codes

#Narrow in on Baltimore
balt<-NEI[NEI$fips == "24510",]              #balt is dataframe, subset of NEI based on fips
Vehicbalt <- balt$SCC %in% VehicSCC          #balt rows that are associated with Vehic codes
Vehicb <-subset(NEI, Vehicbalt==TRUE)          #portion of balt df with coal sites

#plot Baltimore Vehicular emissions
png(filename = "plot5.png")
boxplot(Emissions ~ year, data = Vehicb, col = rgb(0,.5,.5, .2), ylim = c(0,1), 
        main = "Total Emissions by Year, Baltimore, MD - Vehicular", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 75% confidence interval, outliers off scale")
dev.off()
points(Emissions ~ year, data = Vehicb)

# 6 - Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips ==
# "06037"). Which city has seen greater changes over time in motor vehicle
# emissions?


Vehic_codes <- grepl("Vehic", SCC$EI.Sector) #is each row from Vehic?
VehicSCC<-SCC[Vehic_codes==TRUE,1]         #Subset of SSC realted to vehicles

#Narrow in on Baltimore
balt<-NEI[NEI$fips == "24510",]              #balt is dataframe, subset of NEI based on fips
Vehicbalt <- balt$SCC %in% VehicSCC          #balt rows that are associated with Vehic codes
Vehicb <-subset(NEI, Vehicbalt==TRUE)          #portion of balt df with coal sites
#Narrow in on LA
LA<-NEI[NEI$fips == "06037",]              #LA is dataframe, subset of NEI based on fips
VehicLA <- LA$SCC %in% VehicSCC            #LA rows that are associated with Vehicle codes
VehicL <-subset(NEI, VehicLA==TRUE)        #NEI rows associated with LA, Vehicle codes

#Make Plot
png(filename = "plot6.png")
par(mfrow = c(2, 1), mar = c(2, 2, 4, 0), oma = c(0, 0, 2, 1))
boxplot(Emissions ~ year, data = VehicL, col = rgb(0,.5,.5, .2), ylim = c(0,1), 
        main = "Total Emissions by Year, Los Angeles, CA - Vehicular", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 75% confidence interval, outliers off scale")
boxplot(Emissions ~ year, data = Vehicb, col = rgb(0,.5,.5, .2), ylim = c(0,1), 
        main = "Total Emissions by Year, Baltimore, MD - Vehicular", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 75% confidence interval, outliers off scale")
dev.off()
#the two cities have very similar patterns