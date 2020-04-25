# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 12.1.1: Introduction to mapping with ggplot2 and sf 
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, sf)

# Basic mapping with maps data

  world <- map_data("world") 
  class(world)
  
  world %>%
    as_tibble 

# ~The key for ggplot is the group= aesthetic~
  
  # Outline of features with geom_path
    ggplot(world) +
      geom_path(aes(x=long, y=lat, group=group))
  
  # Fill features with geom_polygon
    world %>%
      filter(region == "Canada") %>%
        ggplot() + 
          geom_polygon(aes(x=long, y=lat, group=group), 
                    fill="red")
  
# Alter map projection through coordinate system
  world %>%
    filter(region == "Canada") %>%
    ggplot() + 
    geom_polygon(aes(x=long, y=lat, group=group), 
                 fill="red") +
    coord_map()  
  
  world %>%
    filter(region == "Canada") %>%
    ggplot() + 
    geom_polygon(aes(x=long, y=lat, group=group), 
                 fill="red") +
    coord_map("polyconic") 
  
# sf package combines geospatial analysis tools with tidyverse
# Two important components:
  # Stores spatial data in a light-weight tibble-type format
    world %>%
      st_as_sf(coords = c("long", "lat"))
  
  # geom_sf is a special geom for mapping.
  # It handles a lot of stuff automatically for you, i.e.
    # It reads `geometry` to determine if it should plot a 
      # point, polygon, or line
    # It automatically grabs essential aesthetics: group, x, y
  # Knows projection type (no coord_map)
  
    world %>%
      filter(region == "Canada") %>%
        st_as_sf(coords = c("long", "lat")) %>%
      ggplot() + 
        geom_sf() 
  
  # Alter projection through CRS
  # CRS = Coordinate Reference System
    # Data are in WGS 84 (EPSG:4326)
      world %>%
        filter(region == "Canada") %>%
          st_as_sf(coords = c("long", "lat"), crs=4326) %>%
      ggplot() + 
        geom_sf() 
    
    # Convert to Pseudo-Mercator (EPSG:3857)
      world %>%
        filter(region == "Canada") %>%
          st_as_sf(coords = c("long", "lat"), crs=4326) %>%
            st_transform(3857) %>%  
        ggplot() + 
          geom_sf() 
      
#
# Using other data sources
#
# Natural Earth - public domain geo data (http://www.naturalearthdata.com/)
#
# R packages connect to Natural Earth dataset
  pacman::p_load(rnaturalearth, rnaturalearthdata)

# R-Natural Earth functions play well with sf 
  canada_sf <- ne_countries(country = "Canada", 
                            returnclass = "sf")
  names(canada_sf) # Lots of information about Canada!
  canada_sf$economy
  canada_sf$pop_est
  
  # View in ggplot
    ggplot(canada_sf) +
      geom_sf() 
    
    canada_sf %>%
     st_transform(26913) %>% 
    ggplot() + theme_bw() + 
      geom_sf(fill="red") +
      theme(axis.text = element_blank(), 
            axis.ticks = element_blank())
    