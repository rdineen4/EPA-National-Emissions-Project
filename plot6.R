#Question:
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle
#sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes
#over time in motor vehicle emissions?

#Download and unzip the data
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./zipdata")
unzip("zipdata")

#Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Find all data in SCC about vehicles
vehicleEntries <- grep("Vehicles", SCC$EI.Sector)
vehicleData <- SCC[vehicleEntries, c("SCC", "EI.Sector")]

#Merge vehicleData with NEI
mergedData <- merge(NEI, vehicleData)

#Filter for Baltimore City and Los Angeles and find sum of emissions by year for each
library(dplyr)
sums <- mergedData %>% filter(fips %in% c("24510", "06037")) %>%
    group_by(fips, year) %>%
    summarize(total_emissions = sum(Emissions))

#Plot the data to a .png file
library(ggplot2)
fips.labs <- c("Los Angeles", "Baltimore City")
names(fips.labs) <- c("06037", "24510")
locations <- data.frame(x = c(2004, 2004), y = c(3750, 400), fips = c("06037", "24510"), labs = c("+170.2", "-258.5"))
png("plot6.png")
ggplot(sums, aes(year, total_emissions)) +
    geom_line() +
    geom_line(data = subset(sums, year %in% c(1999, 2008)), aes(year, total_emissions), lty = 2, col = "blue") +
    geom_point() +
    facet_wrap(. ~ fips, labeller = labeller(fips = fips.labs)) +
    labs(x = "Year", y = "Tons of Emissions", title = "Motor Vehicle PM2.5 Emissions in Los Angeles and Baltimore City") +
    geom_text(data = locations, aes(x, y, label = labs), col = "blue") +
    theme_bw()
dev.off()