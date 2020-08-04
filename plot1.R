#Question:
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from
#all sources for each of the years 1999, 2002, 2005, and 2008

#Download and unzip the data
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./zipdata")
unzip("zipdata")

#Read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Find the sum of emissions grouped by year, 
library(dplyr)
subdata <- NEI %>% group_by(year) %>% summarize(total_emissions = sum(Emissions)/1000000)

#Plot total emissions per year in a .png file
png("plot1.png")
with(subdata, plot(year, total_emissions, type = "b", xlab = "Year", ylab = "Tons of Emissions (in millions)",
                   main = "Total US PM2.5 Emissions"))
dev.off()