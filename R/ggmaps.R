# devtools::install_github("hadley/precis")
library(precis)
library(ggmap)
library(tidyverse)

raw_catapult_data <- read.csv(file='data/killester_block_catapult.csv')
sampled_catapult_data <- raw_catapult_data[seq(1,nrow(catapult_data),1000),]
sampled_catapult_data <- sampled_catapult_data %>% mutate(km = (as.integer(Odometer / 1000) + 1))
sampled_catapult_data$km <- as.factor(sampled_catapult_data$km)
precis(sampled_catapult_data)

# Calculate a midpoint to center the map around
midpoint <- nrow(sampled_catapult_data) / 2
midpoint = sampled_catapult_data[midpoint,]

png("docs/Rplot.png")

# Get the map using the midpoint as location
ggmap(get_map(location=c(lon = midpoint$Longitude, lat=midpoint$Latitude), zoom=15)) + 
  # Plot the sampled points onto the map
  geom_point(data=sampled_catapult_data, aes(x=Longitude, y=Latitude, color = km), size=3) +
  scale_color_brewer(palette="Dark2")

dev.off()