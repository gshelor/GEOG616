## Griffin Shelor-- SNOTEL Project
## This script will be used to download and process the data from snotelr, EPA ecoregions, and elevation from rstac
## install.packages("snotelr")
library(pacman)
pacman::p_load(snotelr, sf, terra, tidyterra, tidyverse, here, crsuggest, rstac, leaflet)

##### SNOTEL data download #####
## reading in snotel sites
snotelinfo <- snotel_info()

## line below mostly just serving as a record of SNOTEL sites that don't return any data
# snoteldata_nodata <- snotel_download(201, 1315, internal = TRUE)
## filtering info for snotel sites that don't return any data
# nodata_snotelinfo <- snotelinfo |>
#   filter(site_id == 201 | site_id == 1315)

# start_time <- Sys.time()
## downloading snotel data (SWE, temp, precip)
# snoteldata_allsites <- snotel_download(c(301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,373,374,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,398,399,400,401,402,403,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,442,443,444,445,446,448,449,375,450,451,452,453,454,455,457,458,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,568,569,570,571,572,573,574,575,576,577,578,579,580,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,599,600,601,602,603,604,605,606,607,608,609,610,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,660,661,662,663,664,665,666,667,668,669,670,671,672,673,675,676,677,679,680,681,682,683,684,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,759,760,761,762,763,764,765,766,767,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,797,798,800,801,802,803,804,805,806,807,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,893,895,896,897,898,899,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,966,967,968,969,970,971,972,973,974,975,977,978,979,981,982,983,984,985,986,987,988,989,990,991,992,998,999,1000,1001,1002,1003,1005,1006,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1077,1078,1079,1080,1081,1082,1083,1084,1085,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1158,1159,1160,1161,1162,1163,1164,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1194,1195,1196,1197,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1221,1222,1223,1224,1225,1226,1227,1228,1231,1236,1242,1243,1244,1247,1248,1249,1251,1252,1254,1256,1257,1258,1259,1260,1261,1262,1263,1265,1266,1267,1268,1269,1270,1271,1272,1275,1277,1278,1280,1285,1286,1287,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1314,1316,1317,2029,2044,2065,2080,2081,2170,2210,2222), internal = TRUE)
# end_time <- Sys.time()
# downloadtime <- end_time - start_time
# downloadtime

## dropping NAs
# snoteldata_dropNA <- snoteldata_allsites |>
#   drop_na()

## filtering alaska out of other snotel sites so I only have sites within contiguous US
# snoteldata_conus <- snoteldata_dropNA |>
#   filter(state != "AK")

# snotelconus_phenology <- snotel_phenology(snoteldata_conus)
## writing phenology to csv because the function takes a while
# write_csv(snotelconus_phenology, here("Project", "Data", "SNOTEL", "snotelconus_phenology.csv"))

## formatting date column as date
snoteldata_conus$date <- as.Date(snoteldata_conus$date, format = "%Y-%m-%d")
## filtering snoteldata_conus to only include first snow accumulation date of 2022 water year through last snow melt of water year
snoteldata_conus <- snoteldata_conus |>
  filter(date >= "2022-10-01" & date <= "2023-09-30")
snoteldata_conus_2023WY <- snoteldata_conus |>
  group_by(site_id) |>
  filter(snow_water_equivalent == max(snow_water_equivalent)) |>
  filter(date == max(date))
snoteldata_conus_2023WY$latitude_copy <- snoteldata_conus_2023WY$latitude

## writing snoteldata_conus to csv so I don't have to run the code above again
# commented out so it doesn't run again
# write_csv(snoteldata_conus_2023WY, here("Project", "Data", "SNOTEL", "SNOTELdata_CONUS_dropNA.csv"))


## reading in snoteldata_conus
snoteldata_conus_2023WY <- read_csv(here("Project", "Data", "SNOTEL", "SNOTELdata_CONUS_dropNA.csv"))

##### grouping data by snotel site in order to plot max SWE at each site #####
snoteldata_conus_grp <- snoteldata_conus |>
  dplyr::group_by(site_id) |>
  summarise(max_swe = max(snow_water_equivalent))

snotelinfo_conus_grp <- snotelinfo |>
  filter(site_id %in% snoteldata_conus_grp$site_id)

snoteldata_conus_grp <- merge(snoteldata_conus_grp, snotelinfo_conus_grp, by = "site_id") |>
  select(site_id, site_name, max_swe, longitude, latitude)

## converting df of max swe to sf object
snoteldata_conus_grp_sf <- st_as_sf(snoteldata_conus_grp, coords = c("longitude", "latitude"))
## using median longitude and latitude to find appropriate crs
#crsuggest::guess_crs(snoteldata_conus_grp_sf, target_location = c(-111.93, 42.14))
## setting CRS with best guess
st_crs(snoteldata_conus_grp_sf) <- 4326

## transforming snotel data
snoteldata_conus_grp_sf <- st_transform(snoteldata_conus_grp_sf, 6341)

##### Ecoregion stuff #####
## reading in ecoregions with state boundaries
# ecoregions_usb_sf <- read_sf(here("Project","Data", "L3_Ecoregions_USB", "us_eco_l3_state_boundaries.shp")) |>
#   filter(STATE_NAME == "California" | STATE_NAME == "Oregon" | STATE_NAME == "Colorado" | STATE_NAME == "Idaho" | STATE_NAME == "Wyoming" | STATE_NAME == "New Mexico" | STATE_NAME == "Montana" | STATE_NAME == "Arizona" | STATE_NAME == "South Dakota" | STATE_NAME == "Nevada" | STATE_NAME == "Utah" | STATE_NAME == "Washington")
# crs(ecoregions_usb_sf, describe = TRUE)
#crsuggest::suggest_crs(ecoregions_usb_sf)

## reading in ecoregions without state boundaries
# ecoregions_sf <- read_sf(here("Project","Data", "L3_Ecoregions", "us_eco_l3.shp"))
# ecoregions_plot <- ggplot() +
#   geom_sf(data = ecoregions_sf)
# ecoregions_plot

## transforming ecoregions to use same crs
# ecoregions_usb_sf <- st_transform(ecoregions_usb_sf, 6341)
# ecoregions_sf <- st_transform(ecoregions_sf, 6341)

## checking CRS
# crs(snoteldata_conus_grp_sf, describe = TRUE)
# crs(ecoregions_usb_sf, describe = TRUE)
# crs(ecoregions_sf, describe = TRUE)

# ecoregions_vect <- vect(ecoregions_sf)
snoteldata_conus_grp_vect <- vect(snoteldata_conus_grp_sf)
# terra::project(ecoregions_vect, "epsg:6341")
# crs(ecoregions_vect, describe = TRUE)
crs(snoteldata_conus_grp_vect, describe = TRUE)

## the subset that seems to have worked
## subsets ecoregion polygons based on whether they intersect the extent of the SNOTEL points
# ecoregions_vect_subset <- terra::subset(ecoregions_vect, is.related(ecoregions_vect, ext(snoteldata_conus_grp_vect), relation = "intersects"))
## writing this subset to a shapefile so I can bring it into QGIS/ArcPro and manually edit the data
# terra::writeVector(ecoregions_vect_subset, here("Project", "Data", "L3_Ecoregions", "ecoregions_subset.shp"))

## reading in new ecoregion subset shapefile
## deleted some ecoregions along the southwestern, southern, and eastern edges of the ecoregion layer since they did not have any SNOTEL points in them. The exceptions were polygons in the Southwestern Tablelands and Chihuahuan Deserts ecoregions, which were included but clipped by a convex hull minimum bounding geometry to preserve continuity of the landscape
# ecoregions_vect_subset_v2 <- vect(here("Project", "Data", "L3_Ecoregions", "L3_Ecoregions_Subset", "ecoregions_subset_v2.shp"))

## converting to sf object to use in querying ot STAC API to download SRTM data
ecoregions_sf_subset_v2 <- st_as_sf(ecoregions_vect_subset_v2)


## plotting to see what happens
# max_swe_plot <- ggplot() +
#   theme_bw() +
#   #geom_sf(data = ecoregions_sf_subset) +
#   #geom_spatvector(data = ecoregions_vect_subset) +
#   #geom_spatvector(data = ecoregions_vect_subset_v2) +
#   geom_sf(data = ecoregions_sf_subset_v2) +
#   geom_sf(data = snoteldata_conus_grp_sf, mapping = aes(color = max_swe))
# max_swe_plot
# ggsave(here("Project", "Outputs", "maxsweplot_ecoregionsubset_test3.png"))


##### DOWNLOADING ELEVATION BY STATE #####
## reading in clipped shapefile of ecoregions separated by USB
## going to filter by state after reading in as sf object
# ecoregions_usb_clip <- read_sf(here("Project", "Data", "L3_Ecoregions_USB", "ecoregions_USB_clip", "ecoregions_USB_clip.shp"))
# washington_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Washington") |>
#   st_transform(4326) |>
#   st_bbox()
# oregon_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Oregon") |>
#   st_transform(4326) |>
#   st_bbox()
# california_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "California") |>
#   st_transform(4326) |>
#   st_bbox()
# arizona_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Arizona") |>
#   st_transform(4326) |>
#   st_bbox()
# newmexico_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "New Mexico") |>
#   st_transform(4326) |>
#   st_bbox()
# wyoming_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Wyoming") |>
#   st_transform(4326) |>
#   st_bbox()
# colorado_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Colorado") |>
#   st_transform(4326) |>
#   st_bbox()
# nevada_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Nevada") |>
#   st_transform(4326) |>
#   st_bbox()
# idaho_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Idaho") |>
#   st_transform(4326) |>
#   st_bbox()
# montana_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Montana") |>
#   st_transform(4326) |>
#   st_bbox()
# southdakota_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "South Dakota") |>
#   st_transform(4326) |>
#   st_bbox()
# utah_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Utah") |>
#   st_transform(4326) |>
#   st_bbox()
# northdakota_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "North Dakota") |>
#   st_transform(4326) |>
#   st_bbox()
# nebraska_eco_clip <- ecoregions_usb_clip |>
#   filter(STATE_NAME == "Nebraska") |>
#   st_transform(4326) |>
#   st_bbox()

##### Washington elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "nasadem",
  bbox = washington_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "nasadem",
  bbox = washington_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "zarr-https", output_dir = here("Project", "Data"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime


##### Oregon Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "nasadem",
  bbox = oregon_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "nasadem",
  bbox = oregon_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Oregon"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### California Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "nasadem",
  bbox = california_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "nasadem",
  bbox = california_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "California"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime


##### Arizona Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)

# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = arizona_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = arizona_eco_clip)

# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Arizona"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### New Mexico Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = newmexico_eco_clip) |>
#   rstac::get_request()

# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = newmexico_eco_clip)

# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "NewMexico"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Wyoming Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = wyoming_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = wyoming_eco_clip)

# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Wyoming"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Colorado Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)

# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = colorado_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = colorado_eco_clip)
# 
# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Colorado"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Nevada Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = nevada_eco_clip) |>
#   rstac::get_request()

# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = nevada_eco_clip)

# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Nevada"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Idaho Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)

# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = idaho_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = idaho_eco_clip)

# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Idaho"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Montana Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = montana_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = montana_eco_clip)
# 
# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Montana"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### South Dakota Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = southdakota_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = southdakota_eco_clip)
# 
# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "SouthDakota"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Utah Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)

# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
#   sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = utah_eco_clip) |>
#   rstac::get_request()


# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = utah_eco_clip)
# 
# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Utah"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### North Dakota Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)
# 
# collections_query <- stac_source |>
#   rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
#   sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = northdakota_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = northdakota_eco_clip)
# 
# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "NorthDakota"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Nebraska Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

# rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

# class(stac_source)
# class(collections_query)
# 
# available_collections <- rstac::get_request(collections_query)
# available_collections

## setting up STAC search for NASA DEM data
# rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = nebraska_eco_clip) |>
#   rstac::get_request()
# 
# stac_query <- rstac::stac_search(
#   q = stac_source,
#   collections = "nasadem",
#   bbox = nebraska_eco_clip)
# 
# executed_stac_query <- rstac::get_request(stac_query)
# executed_stac_query

## signing in to MPC in order to access STAC with rstac
# signed_stac_query <- rstac::items_sign(
#   executed_stac_query,
#   rstac::sign_planetary_computer())
# signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "elevation", output_dir = here("Project", "Data", "DEM", "Nebraska"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime
##### END OF ELEVATION GRAB #####

##### reading in elevation tifs downloaded by state from MPC via rstac #####
# rastlist <- list.files(path = here("Project", "Data", "DEM", "Washington", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist2 <- list.files(path = here("Project", "Data", "DEM", "Oregon", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist3 <- list.files(path = here("Project", "Data", "DEM", "California", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist4 <- list.files(path = here("Project", "Data", "DEM", "NewMexico", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist5 <- list.files(path = here("Project", "Data", "DEM", "Arizona", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist6 <- list.files(path = here("Project", "Data", "DEM", "Colorado", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist7 <- list.files(path = here("Project", "Data", "DEM", "Wyoming", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist8 <- list.files(path = here("Project", "Data", "DEM", "Nevada", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist9 <- list.files(path = here("Project", "Data", "DEM", "Utah", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist10 <- list.files(path = here("Project", "Data", "DEM", "Idaho", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist11 <- list.files(path = here("Project", "Data", "DEM", "Montana", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist12 <- list.files(path = here("Project", "Data", "DEM", "SouthDakota", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist13 <- list.files(path = here("Project", "Data", "DEM", "NorthDakota", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rastlist14 <- list.files(path = here("Project", "Data", "DEM", "Nebraska", "nasadem-cog", "v001"), pattern='.tif$', all.files= T, full.names= T)
# rasts <- lapply(c(rastlist, rastlist2, rastlist3, rastlist4, rastlist5, rastlist6, rastlist7, rastlist8, rastlist9, rastlist10, rastlist11, rastlist12, rastlist13, rastlist14), rast)
# dem_rast <- rasts[[1]]
## making a spatraster collection
# dem_sprc <- sprc(rasts)
## mosaicing dem_sprc instead of using for loop to merge
# dem_rast <- mosaic(dem_sprc)

## reprojecting to be in same CRS as rest of data
# dem_rast <- terra::project(dem_rast, "epsg:6341")
# writeRaster(dem_rast, here("Project", "Data", "DEM", "snotel_conus_DEM.tif"))
## loading in raster since it has already been mosaiced and reprojected
dem_rast <- rast(here("Project", "Data", "DEM", "snotel_conus_DEM.tif"))


##### DOWNLOADING COPERNICUS 90m ELEVATION BY STATE #####
## reading in clipped shapefile of ecoregions separated by USB
## going to filter by state after reading in as sf object
ecoregions_usb_clip <- read_sf(here("Project", "Data", "L3_Ecoregions_USB", "ecoregions_USB_clip", "ecoregions_USB_clip.shp"))
washington_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Washington") |>
  st_transform(4326) |>
  st_bbox()
oregon_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Oregon") |>
  st_transform(4326) |>
  st_bbox()
california_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "California") |>
  st_transform(4326) |>
  st_bbox()
arizona_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Arizona") |>
  st_transform(4326) |>
  st_bbox()
newmexico_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "New Mexico") |>
  st_transform(4326) |>
  st_bbox()
wyoming_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Wyoming") |>
  st_transform(4326) |>
  st_bbox()
colorado_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Colorado") |>
  st_transform(4326) |>
  st_bbox()
nevada_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Nevada") |>
  st_transform(4326) |>
  st_bbox()
idaho_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Idaho") |>
  st_transform(4326) |>
  st_bbox()
montana_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Montana") |>
  st_transform(4326) |>
  st_bbox()
southdakota_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "South Dakota") |>
  st_transform(4326) |>
  st_bbox()
utah_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Utah") |>
  st_transform(4326) |>
  st_bbox()
northdakota_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "North Dakota") |>
  st_transform(4326) |>
  st_bbox()
nebraska_eco_clip <- ecoregions_usb_clip |>
  filter(STATE_NAME == "Nebraska") |>
  st_transform(4326) |>
  st_bbox()

##### Washington elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = washington_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = washington_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Washington"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime


##### Oregon Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = oregon_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = oregon_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Oregon"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### California Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = california_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = california_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "California"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime


##### Arizona Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = arizona_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = arizona_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Arizona"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### New Mexico Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = newmexico_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = newmexico_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "NewMexico"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### Wyoming Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = wyoming_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = wyoming_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Wyoming"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### Colorado Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = colorado_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = colorado_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Colorado"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### Nevada Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = nevada_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = nevada_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Nevada"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### Idaho Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = idaho_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = idaho_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Idaho"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### Montana Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = montana_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = montana_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Montana"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### South Dakota Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
# sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = southdakota_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = southdakota_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "SouthDakota"))
demdownloadendtime <- Sys.time()
demdownloadendtime - demdownloadstarttime

##### Utah Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
#   sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = utah_eco_clip) |>
  rstac::get_request()


stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = utah_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Utah"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### North Dakota Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## putting ecoregions in WGS 84 and getting a bounding box for the STAC query of SRTM data
# ecoregion_bbox <- ecoregions_sf_subset_v2 |>
#   sf::st_transform(4326) #|>
#   sf::st_bbox()
# ecoregion_bbox

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = northdakota_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = northdakota_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "NorthDakota"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime

##### Nebraska Elevation #####
## Elevation, STAC method
## establishing which API I will use to access DEM data from the STAC
## querying the collections endpoint
## commented out because I only have to do this once
stac_source <- rstac::stac("https://planetarycomputer.microsoft.com/api/stac/v1")
# stac_source

rstac::get_request(stac_source)

collections_query <- stac_source |>
  rstac::collections()
# collections_query

class(stac_source)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
# available_collections

## setting up STAC search for NASA DEM data
rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = nebraska_eco_clip) |>
  rstac::get_request()

stac_query <- rstac::stac_search(
  q = stac_source,
  collections = "cop-dem-glo-90",
  bbox = nebraska_eco_clip)

executed_stac_query <- rstac::get_request(stac_query)
executed_stac_query

## signing in to MPC in order to access STAC with rstac
signed_stac_query <- rstac::items_sign(
  executed_stac_query,
  rstac::sign_planetary_computer())
signed_stac_query

## start time for download
demdownloadstarttime <- Sys.time()
## downloading elevation data
# rstac::assets_download(signed_stac_query, "data", output_dir = here("Project", "Data", "DEM", "Copernicus", "Nebraska"))
# demdownloadendtime <- Sys.time()
# demdownloadendtime - demdownloadstarttime
##### END OF ELEVATION GRAB #####

##### reading in elevation tifs downloaded by state from MPC via rstac #####
rastlist <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Washington", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist2 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Oregon", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist3 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "California", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist4 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "NewMexico", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist5 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Arizona", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist6 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Colorado", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist7 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Wyoming", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist8 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Nevada", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist9 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Utah", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist10 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Idaho", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist11 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Montana", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist12 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "SouthDakota", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist13 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "NorthDakota", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rastlist14 <- list.files(path = here("Project", "Data", "DEM", "Copernicus", "Nebraska", "copernicus-dem", "COP90_hh"), pattern='.tif$', all.files= T, full.names= T)
rasts <- lapply(c(rastlist, rastlist2, rastlist3, rastlist4, rastlist5, rastlist6, rastlist7, rastlist8, rastlist9, rastlist10, rastlist11, rastlist12, rastlist13, rastlist14), rast)
dem_rast <- rasts[[1]]
## making a spatraster collection
dem_sprc <- sprc(rasts)
## mosaicing dem_sprc instead of using for loop to merge
# dem_rast <- mosaic(dem_sprc)

## reprojecting to be in same CRS as rest of data
# dem_rast <- terra::project(dem_rast, "epsg:6341")
# writeRaster(dem_rast, here("Project", "Data", "DEM", "Copernicus", "snotel_conus_90mDEM.tif"))
## loading in raster since it has already been mosaiced and reprojected
dem_rast <- rast(here("Project", "Data", "DEM", "Copernicus", "snotel_conus_90mDEM.tif"))

## converting snoteldata_conus_grp_sf to a spatvector
snoteldata_conus_grp_vect <- vect(snoteldata_conus_grp_sf)

## creating plot of max_swe
max_swe_plot <- ggplot() +
  theme_bw() +
  geom_spatraster(data = dem_rast, show.legend = FALSE) +
  scale_fill_wiki_c(na.value = NA) +
  geom_sf(data = ecoregions_sf_subset_v2, fill = NA, color = "black") +
  #geom_sf(data = snoteldata_conus_grp_sf, mapping = aes(color = max_swe)) +
  geom_spatvector(data = snoteldata_conus_grp_sf, mapping = aes(color = max_swe)) +
  scale_color_whitebox_c(palette = "muted")
  #scale_color_viridis_c()
max_swe_plot
