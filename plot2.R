#Question:
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#Use the base plotting system to make a plot answering this question.

#Download and unzip the data
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./zipdata")
unzip("zipdata")

#Read in data
NEI <- readRDS("summarySCC_PM25.rds")

#Subset the NEI data only from Baltimore City using the fips code then find the sum of emissions grouped by year
library(dplyr)
baltdata <- NEI %>% filter(fips == "24510") %>%
    group_by(year) %>%
    summarize(total_emissions = sum(Emissions))

#Plot total emissions per year in a .png file
png("plot2.png")
with(baltdata, plot(year, total_emissions, type = "b", xlab = "Year", ylab = "Tons of Emissions",
                       main = "Total PM2.5 Emissions from Baltimore City, Maryland"))
dev.off()