#Question:
#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
#Which have seen increases in emissions from 1999–2008?
#Use the ggplot2 plotting system to make a plot answer this question.

#Download and unzip the data
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(URL, destfile = "./zipdata")
unzip("zipdata")

#Read in data
NEI <- readRDS("summarySCC_PM25.rds")

#Subset the NEI data only from Baltimore City using the fips code then find the sum of emissions grouped by type and year
library(dplyr)
baltdata <- NEI %>% filter(fips == "24510") %>%
    group_by(type, year) %>%
    summarize(total_emissions = sum(Emissions))

#Plot the data with each type on a different graph to a .png file
library(ggplot2)
png("plot3.png")
ggplot(baltdata, aes(year, total_emissions)) +
    geom_line() +
    geom_point() +
    geom_hline(data = subset(baltdata, year == 1999), aes(yintercept = total_emissions), col = "blue", lty = 2) +
    facet_wrap(. ~ type, nrow = 2) +
    xlab("Year") +
    ylab("Total Emissions") +
    ggtitle("Total PM2.5 Emissions by Source") +
    theme_bw()
dev.off()