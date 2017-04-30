# devtools::install_github("hadley/precis")
library(precis)
library(ggmap)
library(tidyverse)

raw_catapult_data <- read.csv(file='data/killester_block_catapult.csv')
sampled_catapult_data <- raw_catapult_data[seq(1,nrow(catapult_data),1000),]
sampled_catapult_data <- sampled_catapult_data %>% mutate(km = (as.integer(Odometer / 1000) + 1))
# Filter out just the first 5km
sampled_catapult_data <-sampled_catapult_data %>% filter(km <= 5)

# Summary of the filtered and mutated dataset
precis(sampled_catapult_data)


# Calculate the center of the map from the mean lat/long
center <- c(lon = mean(sampled_catapult_data$Longitude), 
            lat = mean(sampled_catapult_data$Latitude))

png("docs/Rplot.png")

sampled_catapult_data$km <- as.factor(sampled_catapult_data$km)
# Get the map using the midpoint as location
map <-  get_map(
  location=center, 
  zoom=15,
  source='google',
  maptype='satellite')

ggmap(map) + 
  # Plot the sampled points onto the map
  geom_point(data=sampled_catapult_data, aes(x=Longitude, y=Latitude, color = km), size=3) +
  scale_color_brewer(palette="Dark2")

dev.off()