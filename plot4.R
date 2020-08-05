#Question:
#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

#Download and unzip the data
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./zipdata")
unzip("zipdata")

#Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Identify the names of levels in SCC$EI.Sector that relate to coal combustion
coalLevels <- levels(SCC$EI.Sector)[grep("Fuel Comb .*Coal$", levels(SCC$EI.Sector))]

#Filter SCC data by coalLevels
coalSCC <- subset(SCC, EI.Sector %in% coalLevels, c("SCC", "EI.Sector"))

#Merge coalSCC and NEI by SCC
mergedData <- merge(NEI, coalSCC, by = "SCC")

#Find sum of emissions grouped by year
library(dplyr)
totalSums <- mergedData %>% group_by(year) %>% summarize(total_emissions = sum(Emissions), EI.Sector = "Total")

#Find sum of emissions grouped by year and EI.Sector
groupedSums <- mergedData %>% group_by(year, EI.Sector) %>% summarize(total_emissions = sum(Emissions))

#Combine totalSums and GroupedSums
combinedRows <- rbind(totalSums, groupedSums)

#Plot the data in a .png file
png("plot4.png")
ggplot(combinedRows, aes(year, total_emissions)) +
    geom_line() +
    facet_wrap(. ~ EI.Sector, nrow = 2) +
    xlab("Year") +
    scale_y_continuous(name = "Tons of Emissions (square root transformation)", labels = scales::comma, trans = "sqrt") +
    ggtitle("PM2.5 Emissions from Coal Combustion-Related Sources") +
    theme_bw()
dev.off()