## Griffin Shelor-- SNOTEL Analysis
## This script will be used to analyze the data that has been cleaned up and processed in SNOTEL_Downloads.R
## Analyzing Peak SWE in Water Year 2023 (2022-10-01 to 2023-09-30)

## loading packages
## install.packages("snotelr")
library(pacman)
pacman::p_load(snotelr, sf, terra, tidyterra, tidyverse, here, crsuggest, rstac, leaflet, lubridate, splancs, spatstat, maptools, gstat, rgeoda, spdep, spatialreg, RColorBrewer, gt, gtExtras)

##### Reading in data #####
## reading in snotel sites info
# snotelinfo <- snotel_info()

## reading in snoteldata_conus, snotelconus_phenology, ecoregions, and DEM, saved in SNOTEL_Downloads
# snotelconus_phenology <- read_csv(here("Project", "Data", "SNOTEL", "snotelconus_phenology.csv"))
snoteldata_conus_2023WY <- read_csv(here("Project", "Data", "SNOTEL", "SNOTELdata_CONUS_dropNA.csv"))
## formatting date column as date
# snoteldata_conus$date <- as.Date(snoteldata_conus$date, format = "%Y-%m-%d")
## filtering snoteldata_conus to only include first snow accumulation date of 2022 water year through last snow melt of water year
# snoteldata_conus <- snoteldata_conus |>
#   filter(date >= "2022-10-01" & date <= "2023-09-30")
# snoteldata_conus_2023WY <- snoteldata_conus |>
#   group_by(site_id) |>
#   filter(snow_water_equivalent == max(snow_water_equivalent)) |>
#   filter(date == max(date))
# snoteldata_conus_2023WY$latitude_copy <- snoteldata_conus_2023WY$latitude

## converting to sf object
snoteldata_conus_sf <- st_as_sf(snoteldata_conus_2023WY, coords = c("longitude", "latitude"), crs = 4326)
snoteldata_conus_sf <- st_transform(snoteldata_conus_sf, 6341)
## converting sf to spatvector for initial plot
snoteldata_conus_vect <- vect(snoteldata_conus_sf)
## reading in ecoregions
ecoregions_vect_subset <- vect(here("Project", "Data", "L3_Ecoregions", "L3_Ecoregions_Subset", "ecoregions_subset_v2.shp"))
## converting ecoregions to sf
ecoregions_sf_subset <- st_as_sf(ecoregions_vect_subset)
## loading in raster since it has already been mosaiced and reprojected
# dem_rast <- rast(here("Project", "Data", "DEM", "snotel_conus_DEM.tif"))
## trying different DEM from Copernicus with 90m resolution since 30m appears to be too computationally intensive for my computer
dem_rast <- rast(here("Project", "Data", "DEM", "Copernicus", "snotel_conus_90mDEM.tif"))
## checking crs
crs(snoteldata_conus_sf, describe = TRUE)
crs(ecoregions_sf_subset, describe = TRUE)
crs(dem_rast, describe = TRUE)

## converting dem_rast to vector
# dem_mask <- terra::mask(dem_rast, ecoregions_vect_subset)
# dem_poly <- as.polygons(dem_mask)
# dem_pts <- terra::as.points(dem_rast)

## Extracting elevation to SNOTEL points
snoteldata_conus_vect$elevation <- terra::extract(dem_rast, snoteldata_conus_vect)[,2]
snoteldata_conus_sf <- st_as_sf(snoteldata_conus_vect)

##### Linear model of SWE as function of elevation and latitude #####
# set.seed(802)
# swe_model <- lm(snow_water_equivalent ~ elevation, data = snoteldata_conus_sf)
# summary(swe_model)

##### plotting data before analysis #####
## creating plot of max_swe
max_swe_plot <- ggplot() +
  theme_bw() +
  geom_spatraster(data = dem_rast, show.legend = FALSE) +
  #scale_fill_hypso_c(palette = "dem_poster", na.value = NA) +
  scale_fill_wiki_c(na.value = NA) +
  geom_sf(data = ecoregions_sf_subset, fill = NA, color = "black") +
  #geom_sf(data = snoteldata_conus_sf, mapping = aes(color = max_swe)) +
  geom_spatvector(data = snoteldata_conus_vect, mapping = aes(color = snow_water_equivalent)) +
  scale_color_whitebox_c(palette = "viridi", direction = -1, name = "SWE (mm)") +
  ggtitle("Max SWE Values at Conterminous US\n SNOTEL Points in Water Year 2023") +
  theme(plot.title = element_text(hjust = 0.5))
max_swe_plot
ggsave(here("Project", "Outputs", "MaxSWE2023WY.png"))


##### Examining Clustering of SNOTEL points #####
set.seed(802)
## converting to PPP
snoteldata_conus_ppp <- as.ppp(snoteldata_conus_sf)
snoteldata_conus_envg <- envelope(snoteldata_conus_ppp, fun = Gest, nsim = 250, savefuns = TRUE)
snoteldata_conus_envk <- envelope(snoteldata_conus_ppp, fun = Kest, nsim = 250, savefuns = TRUE)

## plotting envelopes
plot(snoteldata_conus_envg, main = "Gest Envelope")
plot(snoteldata_conus_envk, main = "Kest envelope")
## Statistical Results (Median Absolute Deviation test)
snoteldata_conus_gtest <- mad.test(snoteldata_conus_envg)
snoteldata_conus_gtest
snoteldata_conus_ktest <- mad.test(snoteldata_conus_envk)
snoteldata_conus_ktest

## SNOTEL points demonstrate statistically significant levels of clustering, not spatially random
## going to fit a variogram to my SWE data, examine potential spatial autocorrelation
set.seed(802)
swe_variogram <- variogram(snow_water_equivalent ~ 1, snoteldata_conus_sf, cutoff = 25000)
# plot(swe_variogram, main = "Semivariogram")
swe_vgm <- vgm(110000, "Exp", 2400, 0)
swe_vgm_fit <- fit.variogram(swe_variogram, swe_vgm)
swe_vgm_fit
# plot(swe_variogram, model = swe_vgm_fit)

## trying rgeoda
snotel_distthres <- min_distthreshold(snoteldata_conus_sf)
snotel_distweights <- distance_weights(snoteldata_conus_sf, snotel_distthres)
summary(snotel_distweights)
snotel_localmoran <- local_moran(snotel_distweights, snoteldata_conus_sf["snow_water_equivalent"])
snotel_localmoran_pvals <- lisa_pvalues(snotel_localmoran)
snotel_localmoran_sigpvals <- subset(snotel_localmoran_pvals, snotel_localmoran_pvals < 0.05)
length(snotel_localmoran_sigpvals) / length(snotel_localmoran_pvals)
# plot(lisa_pvalues(snotel_localmoran))
snoteldata_conus_sf$local_moran_pvals <- snotel_localmoran_pvals

snotel_localgeary <- local_geary(snotel_distweights, snoteldata_conus_sf["snow_water_equivalent"])
snotel_localgeary_pvals <- lisa_pvalues(snotel_localgeary)
snotel_localgeary_sigpvals <- subset(snotel_localgeary_pvals, snotel_localgeary_pvals < 0.05)
length(snotel_localgeary_sigpvals) / length(snotel_localgeary_pvals)
# plot(lisa_pvalues(snotel_localgeary))
snoteldata_conus_sf$local_geary_pvals <- snotel_localgeary_pvals

## converting snoteldata_conus_sf to terra spatvector to I can plot it as a spatvector if needed
snoteldata_conus_vect <- vect(snoteldata_conus_sf)

## plotting local moran's p-values
localmoran_plot <- ggplot() +
  theme_bw() +
  geom_spatvector(data = ecoregions_vect_subset, fill = NA, color = "black") +
  geom_sf(snoteldata_conus_sf, mapping = aes(color = local_moran_pvals)) +
  scale_color_whitebox_c(palette = "bl_yl_rd", direction = -1, name = NULL) +
  ggtitle("Local Moran's I p-values") +
  theme(plot.title = element_text(hjust = 0.5))
localmoran_plot
ggsave(here("Project", "Outputs", "localmoran_plot.png"))

## Moran's I for Point Data
snotel_dnn <- dnearneigh(snoteldata_conus_sf, 0, 200000)
mt1 <- moran.test(snoteldata_conus_sf$snow_water_equivalent, nb2listw(snotel_dnn), alternative = "two.sided")
mt1
snotel_mantel <- sp.mantel.mc(snoteldata_conus_sf$snow_water_equivalent, listw = nb2listw(snotel_dnn), nsim = 5000, type = "moran", alternative = "two.sided")
snotel_mantel

## SWE demonstrates spatial autocorrelation, moving on to kriging/IDW
## IDW model
## aggregating DEM to decrease resolution so that I can use it in my IDW model without it crashing my R session
dem_agg <- terra::aggregate(dem_rast, fact = 10)
dem_rast_cellsize <- cellSize(dem_rast)
dem_agg_cellsize <- cellSize(dem_agg)
# dem_pts <- terra::as.points(dem_agg)
## st_as_sf took forever and I gave up, trying to write out dem_pts as a shapefile and then read it back in as an sf object for the idw function
# terra::writeVector(dem_pts, here("Project", "Data", "DEM", "Points", "dem_pts.shp"), overwrite = TRUE)
# dem_pts_sf <- read_sf(here("Project", "Data", "DEM", "Points", "dem_pts.shp"))
# names(dem_pts_sf) <- c("elevation", "geometry")
# dem_pts_sf <- st_as_sf(dem_pts)
# dem_pts <- terra::as.points(dem_rast)

##### testing idw on ecoregions_dissolve
# set.seed(802)
# swe_idw <- gstat::idw(snow_water_equivalent ~ 1, snoteldata_conus_sf, ecoregions_sf_subset, idp = 2)
# swe_idw_vect <- vect(swe_idw)
# swe_idw_rast <-  rasterize(swe_idw_vect, dem_agg, field = 'var1.pred', touches=T)
# plot(swe_idw_rast)

# set.seed(802)
# swe_idw_2 <- gstat::idw(snow_water_equivalent ~ 1, snoteldata_conus_sf, dem_pts_sf, idp = 2.5)
# swe_idw_vect_2 <- vect(swe_idw_2)
# swe_idw_rast_2 <-  rasterize(swe_idw_vect_2, dem_agg, field = 'var1.pred', touches=T)
# swe_idw2_plot <- ggplot() +
#   theme_bw() +
#   geom_spatraster(data = swe_idw_rast_2) +
#   scale_fill_whitebox_c(palette = "deep") +
#   geom_sf(data = ecoregions_sf_subset)
  #geom_sf(data = snoteldata_conus_sf)
# swe_idw2_plot
# writeRaster(swe_idw_rast_2, here("Project", "Data", "WY23SWE_2_5IDW.tif"))
swe_idw_finalrast <- rast(here("Project", "Data", "SWERaster", "WY23SWE_2_5IDW.tif"))
swe_idw_plot <- ggplot() +
  theme_bw() +
  geom_spatraster(data = swe_idw_finalrast) +
  scale_fill_whitebox_c(palette = "deep", name = "SWE (mm)") +
  geom_sf(data = ecoregions_sf_subset, fill = NA, color = "black") +
  # geom_sf(data = snoteldata_conus_sf)
  ggtitle("SWE IDW Output", subtitle = "IDP = 2.5") +
  theme(plot.title = element_text(hjust = 0.5))
swe_idw_plot
ggsave(here("Project", "Outputs", "SWE_IDW.png"))

# set.seed(802)
# swe_idw_3 <- gstat::idw(snow_water_equivalent ~ 1, snoteldata_conus_sf, dem_pts_sf, idp = 3)
# swe_idw_vect_3 <- vect(swe_idw_3)
# swe_idw_rast_3 <-  rasterize(swe_idw_vect_3, dem_agg, field = 'var1.pred', touches=T)
# swe_idw3_plot <- ggplot() +
#   theme_bw() +
#   geom_spatraster(data = swe_idw_rast_3) +
#   scale_fill_whitebox_c(palette = "deep")
# swe_idw3_plot

# set.seed(802)
# swe_idw_4 <- gstat::idw(snow_water_equivalent ~ elevation, snoteldata_conus_sf, dem_pts_sf, idp = 3)
# swe_idw_vect_4 <- vect(swe_idw_4)
# swe_idw_rast_4 <-  rasterize(swe_idw_vect_4, dem_agg, field = 'var1.pred', touches=T)
# plot(swe_idw_rast_4)

# set.seed(802)
# swe_idw_5 <- gstat::idw(snow_water_equivalent ~ 1, snoteldata_conus_sf, dem_pts_sf, idp = 4)
# swe_idw_vect_5 <- vect(swe_idw_5)
# swe_idw_rast_5 <-  rasterize(swe_idw_vect_3, dem_agg, field = 'var1.pred', touches=T)
# plot(swe_idw_rast_5)

## Extracting IDW values from swe_idw_2 model with idp of 2.5
ecoregions_vect_subset$idw_SWE <- terra::zonal(swe_idw_finalrast, ecoregions_vect_subset, fun = "mean")
ecoregions_vect_subset$elevation <- terra::zonal(dem_rast, ecoregions_vect_subset, fun = "mean")
ecoregions_sf_subset <- st_as_sf(ecoregions_vect_subset)
## attempting to add latitude as a standard column to my ecoregions_sf object so I can test it as a predictor variable in the CAR model
centroids <- st_coordinates(st_centroid(ecoregions_sf_subset))
ecoregions_sf_subset$latitude_cent <- centroids[,"Y"]



## For some reason one of the ecoregions has a mean IDW value of NA???
## Northwestern Glaciated Plains
## just going to drop it since it's on the outer edge of the AOI and does not contain any points
ecoregions_sf_subset2 <- ecoregions_sf_subset |>
  drop_na()

## testing plot
zonalswe_ecoregion_plot <- ggplot() +
  theme_bw() +
  geom_sf(data = ecoregions_sf_subset2, mapping = aes(fill = idw_SWE)) +
  scale_fill_whitebox_c(palette = "deep", name = "SWE (mm)") +
  geom_sf(data = snoteldata_conus_sf, pch = 1) +
  ggtitle("SWE IDW Output Aggregated to L3 Ecoregions") +
  theme(plot.title = element_text(hjust = 0.5))
zonalswe_ecoregion_plot
ggsave(here("Project", "Outputs", "ecoregionSWE_plot.png"))

## Since Local Moran's I indicates high local spatial autocorrelation and IDW shows limited ranges of high SWE values around SNOTEL stations, choosing CAR model over SAR for areal analysis of ecoregions

##### Setting up and running CAR models #####
## calculating neighbors, distances, and creating IDW function to test out for CAR model
ecoregion_neighbors <- knn2nb(knearneigh(st_centroid(ecoregions_sf_subset2), k = 4))
dsts <- nbdists(ecoregion_neighbors, st_geometry(st_centroid(ecoregions_sf_subset2)))
idw <- lapply(dsts, function(x) 1/(x*100))
ecoregionSWE_lw_B <- nb2listw(ecoregion_neighbors, style = "B")
ecoregionSWE_lw_idwB <- nb2listw(ecoregion_neighbors, glist = idw, style = "B")
ecoregionSWE_lw_W <- nb2listw(ecoregion_neighbors, style = "W")
summary(unlist(ecoregionSWE_lw_idwB$weights))
summary(unlist(ecoregionSWE_lw_B$weights))
summary(unlist(ecoregionSWE_lw_W$weights))

## running a Moran's I test to look at spatial autocorrelation again
set.seed(802)
mantel_idwB <- sp.mantel.mc(ecoregions_sf_subset2$idw_SWE, type = 'moran', listw = ecoregionSWE_lw_idwB, nsim=1000)
mantel_B <- sp.mantel.mc(ecoregions_sf_subset2$idw_SWE, type = 'moran', listw = ecoregionSWE_lw_B, nsim = 1000)
mantel_W <- sp.mantel.mc(ecoregions_sf_subset2$idw_SWE, type = 'moran', listw = ecoregionSWE_lw_W, nsim = 1000)
mantel_idwB
mantel_B
mantel_W

## CAR Models
set.seed(802)
## taking out as.factor(US_L3NAME) as a predictor variable to see influence of just elevation
# ecoregionSWE_splm_idwB_CAR <- spautolm(idw_SWE ~ elevation, data= ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_idwB)
# summary(ecoregionSWE_splm_idwB_CAR)
ecoregionSWE_splm_B_CAR <- spautolm(idw_SWE ~ elevation, data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_B)
summary(ecoregionSWE_splm_B_CAR)
ecoregionSWE_splm_W_CAR <- spautolm(idw_SWE ~ elevation, data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_W)
summary(ecoregionSWE_splm_W_CAR)

## elevation has statistical significance as sole predictor
## testing out including latitude in model
## idwB model below does not run "non-symmetric spatial weights" error produced
# ecoregionSWE_splm_add_idwB_CAR <- spautolm(idw_SWE ~ elevation + latitude_cent, data= ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_idwB)
# summary(ecoregionSWE_splm_add_idwB_CAR)
ecoregionSWE_splm_add_B_CAR <- spautolm(idw_SWE ~ elevation + as.factor(US_L3NAME), data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_B)
summary(ecoregionSWE_splm_add_B_CAR)
ecoregionSWE_splm_add_W_CAR <- spautolm(idw_SWE ~ elevation + as.factor(US_L3NAME), data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_W)
summary(ecoregionSWE_splm_add_W_CAR)

## testing out including interaction between elevation and latitude in model
## none of these models run, all produce the "non-symmetric spatial weights error"
# ecoregionSWE_splm_int_idwB_CAR <- spautolm(idw_SWE ~ elevation * latitude_cent, data= ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_idwB)
# summary(ecoregionSWE_splm_int_idwB_CAR)
# ecoregionSWE_splm_int_B_CAR <- spautolm(idw_SWE ~ elevation * latitude_cent, data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_B)
# summary(ecoregionSWE_splm_int_B_CAR)
# ecoregionSWE_splm_int_W_CAR <- spautolm(idw_SWE ~ elevation * latitude_cent, data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_W)
# summary(ecoregionSWE_splm_int_W_CAR)

## testing out including only latitude in model
## model with idw below also does not run
# ecoregionSWE_splm_lat_idwB_CAR <- spautolm(idw_SWE ~ latitude_cent, data= ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_idwB)
# summary(ecoregionSWE_splm_lat_idwB_CAR)
# ecoregionSWE_splm_lat_B_CAR <- spautolm(idw_SWE ~ latitude_cent, data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_B)
# summary(ecoregionSWE_splm_lat_B_CAR)
# ecoregionSWE_splm_lat_W_CAR <- spautolm(idw_SWE ~ latitude_cent, data = ecoregions_sf_subset2, family = "CAR", listw = ecoregionSWE_lw_W)
# summary(ecoregionSWE_splm_lat_W_CAR)


## reprinting summaries of significant models, for me
summary(ecoregionSWE_splm_B_CAR)
summary(ecoregionSWE_splm_W_CAR)

## AIC
swe_mods <- ls(pattern='ecoregionSWE_splm_')
myaic <- data.frame(model=NA, AIC=0, DAIC=0, LambdaP=0)
for(i in 1:length(swe_mods)){
  tmp <- summary(get(swe_mods[i]))
  myaic[i,1] <- swe_mods[i]
  myaic[i,2] <- AIC(get(swe_mods[i]))
  myaic[i,4] <- tmp$LR1$p.value[1][[1]]
}
myaic$DAIC <- myaic$AIC - min(myaic$AIC)
myaic <- myaic[order( myaic$AIC),]
myaic
## AIC table
myaic_table <- myaic |>
  gt() |> # use 'gt' to make an awesome table...
  gt_theme_538() |>
  tab_header(
    title = "AIC Values for my CAR Model", # ...with this title
    subtitle = "Latitude as the Sole Predictor Demonstrated the Lowest AIC")  |>  # and this subtitle
  ## tab_style(style = cell_fill("bisque"),
  ##           locations = cells_body()) |>  # add fill color to table
  fmt_number( # A column (numeric data)
    columns = c(AIC),
    decimals = 5 # With four decimal places
  ) |> 
  fmt_number( # Another column (also numeric data)
    columns = c(DAIC),
    decimals = 5 # I want this column to have 5 decimal places
  ) |>
  data_color( # Update cell colors, testing different color palettes
    columns = c(AIC),
    fn = scales::col_numeric( # <- bc it's numeric
      palette = brewer.pal(2, "RdBu"), # A color scheme (gradient)
      domain = c(), # Column scale endpoints
      reverse = FALSE
    )
  ) |>
  cols_label(AIC = "AIC", DAIC = "Delta AIC") |> # Update labels
  cols_move_to_end(columns = "DAIC") |>
  cols_hide(LambdaP)
myaic_table
## saving AIC table
myaic_table |>
  gtsave(
    "EcoregionSWE_CARAIC.png", expand = 5,
    path = here("Project", "Outputs")
  )

## Plotting CAR Trend
ecoregions_sf_subset2$CAR_IDW_fitted <- ecoregionSWE_splm_W_CAR$fit$fitted.values
ecoregionSWE_trend_plot <- ggplot() +
  theme_bw() +
  geom_sf(ecoregions_sf_subset2, mapping = aes(fill = CAR_IDW_fitted)) +
  scale_fill_viridis_c() +
  ggtitle('CAR W Weighted Model') +
  guides(fill = guide_colourbar(title = 'SWE (mm)')) +
  theme(plot.title = element_text(hjust = 0.5))
ecoregionSWE_trend_plot
ggsave(here("Project", "Outputs", "EcoregionSWE_trendplot.png"))
