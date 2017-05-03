source('R/common.R')
library("xml2")
tcx_document <- read_xml('data/liffey_run_03052017.tcx')
trackpoints <- xml_find_all(tcx_document, './/d1:Trackpoint')

data <- data.frame(time = character(), 
                 distance = numeric(), 
                 altitude = numeric(), 
                 lat = numeric(), 
                 lon = numeric())

for(trackpoint in trackpoints) {
  timestamp <- strptime(xml_find_first(trackpoint, './/d1:Time') %>% xml_text(), "%FT%T")
  distance = as.double(xml_find_first(trackpoint, './/d1:DistanceMeters') %>% xml_text())
  altitude = as.double(xml_find_first(trackpoint, './/d1:AltitudeMeters') %>% xml_text())
  lat = as.double(xml_find_first(trackpoint, './/d1:Position/d1:LatitudeDegrees') %>% xml_text())
  lon = as.double(xml_find_first(trackpoint, './/d1:Position/d1:LongitudeDegrees') %>% xml_text())
  
  data <- rbind(data, data.frame(time = timestamp, 
                             distance = distance, 
                             km = as.factor(as.integer(distance / 1000)),
                             altitude = altitude, 
                             latitude = lat, 
                             longitude = lon))
}
  
# Summary of the filtered and mutated dataset
precis(data)

saveRDS(data, file="data/liffey_run)03052017.rds")

# Calculate the center of the map from the mean lat/long
center <- c(lon = mean(data$longitude, na.rm=TRUE), 
            lat = mean(data$latitude, na.rm=TRUE))

png("docs/liffey_run_km.png")
# Get the map using the midpoint as location
map <-  get_map(
  location=center, 
  zoom=14)

ggmap(map) + 
  # Plot the sampled points onto the map
  geom_point(data=data, aes(x=longitude, y=latitude, colour = km), size=2)

dev.off()

png("docs/liffey_run_altitude.png")
ggmap(map) + 
  # Plot the sampled points onto the map
  geom_point(data=data, aes(x=longitude, y=latitude, colour = altitude), size=2.5) +
  scale_colour_gradient(low = "green", high = "red")
dev.off()

png("docs/liffey_run_per_distance_point.png")
ggplot(data, aes(x=time)) + geom_point(aes(y=distance))
dev.off()

png("docs/liffey_run_per_altitude_point.png")
ggplot(data, aes(x=time)) + geom_point(aes(y=altitude)) + geom_smooth(aes(y=altitude))
dev.off()
