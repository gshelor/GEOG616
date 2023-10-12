## SNOTEL Project
## install.packages("snotelr")
library(snotelr)
library(sf)
snotelinfo <- snotel_info()
# snoteldownloads <- snotel_download(internal = TRUE)
# allsites <- snotel_download(snotelinfo$site_id, internal = TRUE)
snotel_sf <- st_as_sf(allsites, coords = c("longitude", "latitude"))
plot(snotel_sf[7])
