install.packages("ggmap")
library(ggmap)

data = read.csv(file='data/coords.csv')
midpoint <- nrow(data) / 2

midpoint = data[midpoint,]

ggmap(get_map(location=c(lon = midpoint$lon, lat=midpoint$lat), zoom=15)) + 
  geom_point(data=data, aes(x=lon, y=lat), color="red", size=2, alpha=0.5)