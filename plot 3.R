#manually download and unzip data.  Read in as follows...
NEI <- readRDS("summarySCC_PM25.rds") #main pollution data
SCC <- readRDS("Source_Classification_Code.rds") #pollution code decoded

head(NEI)
table(NEI$year) #has four years, 1999, 2002, 2005, 2008
table(NEI$Pollutant) #all values are PM25-REI
test <- NEI[sample(nrow(NEI), 100000), ] #a random subset for faster plotting
# ASSIGNMENT

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
