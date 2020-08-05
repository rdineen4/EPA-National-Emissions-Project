#Question:
#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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

#Filter for Baltimore City only and find sum of emissions by year
library(dplyr)
sums <- mergedData %>% filter(fips == "24510") %>% group_by(year) %>% summarize(total_emissions = sum(Emissions))

#Plot data to .png file
library(ggplot2)
png("plot5.png")
ggplot(sums, aes(year, total_emissions)) +
    geom_line() +
    geom_point() +
    labs(x = "Year", y = "Ton of Emissions", title = "Motor Vehicle PM2.5 Emissions in Baltimore City") +
    theme_bw()
dev.off()