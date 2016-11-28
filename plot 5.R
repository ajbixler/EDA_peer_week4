#manually download and unzip data.  Read in as follows...
NEI <- readRDS("summarySCC_PM25.rds") #main pollution data
SCC <- readRDS("Source_Classification_Code.rds") #pollution code decoded

head(NEI)
table(NEI$year) #has four years, 1999, 2002, 2005, 2008
table(NEI$Pollutant) #all values are PM25-REI
test <- NEI[sample(nrow(NEI), 100000), ] #a random subset for faster plotting
# ASSIGNMENT

# 5 - How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?
View(SCC)                                    #scan it over, EI.Sector has Vehic
Vehic_codes <- grepl("Vehic", SCC$EI.Sector) #is each row from Vehic?
sum(Vehic_codes)                             #1138 Entries TRUE
plot(Vehic_codes)                            #all are in ~500-1800
View(SCC)                                    #scan it over, looks about right
VehicSCC<-SCC[Vehic_codes==TRUE,1]           #coal SCC codes
VehicNEI <- balt$SCC %in% VehicSCC            #NEI rows that are associated with coal codes
Vehic <-subset(NEI, VehicNEI==TRUE)          #portion of NEI df with coal sites

#plot coal emissions
png(filename = "plot5.png")
boxplot(Emissions ~ year, data = Vehic, col = rgb(0,.5,.5, .2), ylim = c(0,.3), 
        main = "Total Emissions by Year, Baltimore, MD - Vehicular", xlab = "Year", ylab = "PM2.5, Tons")
mtext("Scale set for 75% confidence interval, outliers off scale")
dev.off()
