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