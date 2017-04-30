library(ggmap)

raw_catapult_data <- read.csv(file='data/killester_block_catapult.csv')
sampled_catapult_data <- raw_catapult_data[seq(1,nrow(catapult_data),1000),]

# Calculate a midpoint to center the map around
midpoint <- nrow(sampled_catapult_data) / 2
midpoint = sampled_catapult_data[midpoint,]

# Get the map using the midpoint as location
ggmap(get_map(location=c(lon = midpoint$Longitude, lat=midpoint$Latitude), zoom=15)) + 
  # Plot the sampled points onto the map
  geom_point(data=sampled_catapult_data, aes(x=Longitude, y=Latitude), color="red", size=2, alpha=0.5)

