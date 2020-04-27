# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 12.2: Spatial analysis - Interpolation 
#
# Major credit to Timo Grossenbacher: https://timogrossenbacher.ch/2018/03/categorical-spatial-interpolation-with-r/
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, sf, kknn)
#
# Create a shorthand reference to Central European CRS
  crs_etrs = "+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs"
#
# Germany geo data
  # download
  gs_url <- "https://github.com/devanmcg/categorical-spatial-interpolation/raw/IntroRangeR/analysis/input/german_states.Rdata"
  load(url(gs_url))
  # change CRS
  german_st <- german_states %>%
                  st_transform(crs_etrs)
# View the German states
  ggplot(german_st) +
    geom_sf(fill="white") +
    geom_sf_label(aes(label=name_en), size=3) +
    labs(title="English names for German states")
# Dissolve internal boundaries 
  germany <- 
    german_st %>%
      group_by(iso_a2) %>% 
      summarize() 
#
# Download point data
#
# Survey data
#
  # Linguistic reference data
    lt_url = "https://raw.githubusercontent.com/devanmcg/categorical-spatial-interpolation/master/analysis/input/pronunciations.csv"
    lookup_table <- read_csv(lt_url,
                             col_names = c("pronunciation", 
                                           "phrase", 
                                           "verbatim", 
                                           "nil")) %>% 
                      filter(phrase == 7) # only the phrase we need
  # Survey responses
    resp_url = "https://github.com/devanmcg/categorical-spatial-interpolation/blob/master/analysis/input/phrase_7.csv?raw=true"  
    responses <- read_csv(resp_url)
# Merge point data for Phrase 7
  responses <- 
    responses %>%
      left_join(lookup_table, 
                by = c("pronunciation_id" = "pronunciation")) %>% 
        select(lat, lng, verbatim) %>% 
          rename(pronunciation_id = verbatim) %>% 
            mutate(pronunciation_id = as.factor(pronunciation_id))
  # Transform to sf object
    responses <-  
      responses %>%
      st_as_sf(coords = c("lng", "lat"),
               crs = 4326) %>%  
        st_transform(crs_etrs)
#
# Cities data (from Simple Maps https://simplemaps.com/data/world-cities)
#
  # load & pre-process
    cit_url = "https://raw.githubusercontent.com/devanmcg/categorical-spatial-interpolation/IntroRangeR/analysis/input/simplemaps-worldcities-basic.csv"
    cities <- read_csv(cit_url) %>% 
                filter(country == "Germany") %>% 
                  filter(city %in% c("Munich", "Berlin", "Hamburg", 
                                     "Cologne", "Frankfurt"))
  # Transform to sf object
    cities <-  
      cities %>%
        st_as_sf(coords = c("lng", "lat"),
                 crs = 4326) %>%  
          st_transform(crs_etrs)
#
# Prepare for interpolation
# 
# Buffer
  # Create a buffer around German border 
  # so interpolation of linguistic data -- 
  # which extend beyond German border --
  # doesn't look wonky at the edges 
    germ_buff <- germany %>%
                  st_buffer(dist = 10000)
# Crop (find intersection of two data layers)
  # Crop responses to Germany + buffer
    germ_resp <-
      responses %>%
        st_intersection(germ_buff)
#
# Create grid 
#
# Define parameters:
    width_in_pixels = 100 # 300 is better but slower 
  # dx is the width of a grid cell in meters
    dx <- ceiling( (st_bbox(germ_buff)["xmax"] - 
                    st_bbox(germ_buff)["xmin"]) / width_in_pixels)
  # dy is the height of a grid cell in meters
  # because we use quadratic grid cells, dx == dy
    dy = dx
  # calculate the height in pixels of the resulting grid
    height_in_pixels <- floor( (st_bbox(germ_buff)["ymax"] - 
                                st_bbox(germ_buff)["ymin"]) / dy)
# Make the grid   
  grid <- st_make_grid(germ_buff, 
                       cellsize = dx,
                       n = c(width_in_pixels, height_in_pixels),
                       what = "centers")
  # View grid
    ggplot() +
      geom_sf(data=grid) +
      geom_sf(data=germany, fill=NA, color="blue", lwd=2)
#
# Prepare data for interpolation
#
  # Create tibble of the German responses sf object
    dialects_input <- germ_resp %>%
                    tibble(dialect = .$pronunciation_id, 
                             lon = st_coordinates(.)[, 1], 
                             lat = st_coordinates(.)[, 2]) %>%
                      select(dialect, lon, lat)
  # Pare to 8 most prominent dialects
    dialects_input <- 
      dialects_input %>%
        group_by(dialect) %>% 
        nest() %>% 
        mutate(num = map_int(data, nrow)) %>% 
        arrange(desc(num)) %>% 
        slice(1:8) %>% 
        unnest(cols=c(data)) %>% 
        select(-num)
  #
  # Thin the dataset
    # The example dataset is huge. 
    # Use this script to 'thin' the data
    # and reduce processing time 
      dialects_thin <-
        dialects_input %>%
          filter(row_number() %% 5 == 1) # Pull out every 5th row
    
# Interpolation function 
  # define "k" for k-nearest-neighbour-interpolation
    knn = 1000 
    
    # create empty result tibble
    dialects_output <- tibble(dialect = as.factor(NA), 
                              lon = st_coordinates(grid)[, 1], 
                              lat = st_coordinates(grid)[, 2])
    # run KKNN interpolation function
    dialects_kknn <- kknn::kknn(dialect ~ ., 
                               train = dialects_thin, 
                               test = dialects_output, 
                               kernel = "gaussian", 
                               k = knn)
    # Extract results to output tibble
      dialects_output <-
        dialects_output %>%
          mutate(dialect = fitted(dialects_kknn),
                 # only retain the probability of the interpolated variable,
                 prob = apply(dialects_kknn$prob, 
                              1, 
                              function(x) max(x)))
#
# Map interpolated data
#
  # Transform interpolation tibble to sf
    dialects_raster <- st_as_sf(dialects_output, 
                                coords = c("lon", "lat"),
                                crs = crs_etrs,
                                remove = F)
  # Crop to Germany
    germ_rast <- 
      dialects_raster %>%
        st_intersection(germany)
  
# Create ggplot   
  # Basic view of rasterized data
    ggplot() + 
      geom_raster(data=germ_rast, 
                  aes(x=lon, y=lat, 
                      fill=dialect)) 
  # Condition density by probability 
    ggplot() + 
      geom_raster(data=germ_rast, 
                  aes(x=lon, y=lat, 
                      fill=dialect, 
                      alpha=prob))
  # Pretty map
    ggplot() + theme_minimal() + 
      geom_sf(data=germany, fill="white") +
      geom_raster(data=germ_rast, 
                  aes(x=lon, y=lat, 
                      fill=dialect, 
                      alpha=prob)) +
      geom_sf(data=german_st, fill=NA, color="white") +
      geom_sf(data=germany, fill=NA, color="black") +
      scale_alpha_continuous(guide="none") +
      scale_fill_viridis_d("German dialects of\nverb 'to chatter' ") +
      theme(axis.title = element_blank())
#
# Summarize data 
#
  # Return dominant dialect per state & frequency of use
    germ_rast %>%
      st_join(german_st) %>%
      as_tibble %>% 
      filter(prob >= 0.1) %>%
        select(dialect, name_en) %>%
          group_by(name_en, dialect) %>%
          summarize(n = n()) %>%
          mutate(freq = n / sum(n)*100) %>%
          arrange(desc(freq)) %>% 
          slice(1) 

      
    


