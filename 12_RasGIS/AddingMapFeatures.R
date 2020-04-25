# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 12.1.2: Adding map features
#
# Some script credit: https://philmikejones.me/tutorials/2015-09-03-dissolve-polygons-in-r/
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, sf, rnaturalearth, rnaturalearthdata)

# Load Natural Earth data for South America as sf
  sa_countries <- ne_countries(continent = "South America", 
                               returnclass = "sf")
  names(sa_countries)
  
  sa_countries %>%
    select(name, economy)
  
  # View in ggplot
    ggplot() +
      geom_sf(data=sa_countries) 

# Dissolve internal divisions with tidyverse
  sa_cont <- 
    sa_countries %>%
      mutate(area = st_area(.) ) %>% 
        summarise(area = sum(area)) 
    
    # View in ggplot
    ggplot() +
      geom_sf(data=sa_cont) 
    
# Combine layers
    ggplot() +
      geom_sf(data=sa_cont, fill="white") + 
      geom_sf(data=sa_countries, color="darkgrey", fill=NA) 
    
# Add information
    # Fill by an existing data column
      ggplot() +
        geom_sf(data=sa_cont, fill="white") + 
        geom_sf(data=sa_countries, 
                aes(fill=pop_est), 
                color="darkgrey") 
    
    # Calculate a new data column
      sa_countries <-
        sa_countries %>%
          mutate(area = st_area(.) / 1000000, 
                 density = pop_est / area, 
                 density = as.numeric(density)) 

        ggplot() +
          geom_sf(data=sa_cont, fill="white") + 
          geom_sf(data=sa_countries,
                  aes(fill=density), 
                  color="darkgrey") +
          scale_fill_viridis_c("Human population\ndensity (sq. km)")
 
    # sf objects convert easily to tibbles for other analysis       
      sa_countries %>%
        as_tibble %>% 
          select(name, density) %>%
            arrange(desc(density)) 

# use tidyverse verbs to focus on one country
    sa_countries %>%
      filter(name == "Argentina") %>%
        ggplot() +
          geom_sf() 
#
# Add features from other data sources
#
# Cities: These ESRI shapefile vector data are stored online in a .zip
#
  # Download layer with South American cities to temporary file
    sa_cities_url = "https://github.com/devanmcg/IntroRangeR/raw/master/data/SouthAmericanCities.zip"
    tmp_dir = tempdir()
    tmp     = tempfile(tmpdir = tmp_dir, fileext = ".zip")
    download.file(sa_cities_url, tmp) 
  # Unzip and load shapefile as sf object
    unzip(tmp, exdir = tmp_dir)
    sa_cities <- read_sf(tmp_dir, "South_America_Cities") 
  
  sa_cities 
  
  ggplot() +
    geom_sf(data=sa_cont, fill="white") + 
    geom_sf(data=sa_countries, color="darkgrey", fill=NA) +
    geom_sf(data=sa_cities)
  
  # Use tidyverse verbs to subset all datasets
    ggplot() + 
      geom_sf(data=sa_countries  %>% 
                filter(name == "Argentina"),
              color="darkgrey", fill="white") +
      geom_sf(data=sa_cities %>%
                filter(COUNTRY == "Argentina")) +
      geom_sf_label(data=sa_cities %>%
                filter(COUNTRY == "Argentina"), 
                aes(label=NAME), nudge_y = 1.5 ) +
      theme(axis.title = element_blank())

# Get EPA ecoregions for Central & South America
# Download
  EPA_URL = "http://www.ecologicalregions.info/data/sa/sa_eco_l3.zip"
  tmp_dir = tempdir()
  tmp     = tempfile(tmpdir = tmp_dir, fileext = ".zip")
  download.file(EPA_URL, tmp) 
# Unzip and load 
  unzip(tmp, exdir = tmp_dir)
  EPA_SCA <- read_sf(tmp_dir, "sa_eco_l3")

  EPA_SCA 

  # View in ggplot
    ggplot(EPA_SCA) +
      geom_sf() 

  # View the ecological regions
    EPA_SCA %>%
      mutate_at(vars(LEVEL3:LEVEL1), as.factor) %>% 
      ggplot() +
        geom_sf(aes(fill=LEVEL1)) 
  
  # Crop to SA (remove Central America)
    # First we must get them into the same projection
      EPA_SCA %>%
        st_transform(4326) %>%
        ggplot() +
        geom_sf() 
    
    # Find intersection with continent layer boundaries
      sa_epa <- EPA_SCA %>%
                 mutate_at(vars(LEVEL3:LEVEL1), as.factor) %>% 
                  st_transform(4326) %>%
                    st_intersection(sa_cont)
  
  # Features represent Level 3 Ecoregions
    ggplot(sa_epa) +
      geom_sf(aes(fill=LEVEL3), show.legend = FALSE ) 
    
    # Dissolve features to Level 1
      sa_epa_L1 <- sa_epa %>%
                    mutate(area = st_area(.) ) %>% 
                      group_by(LEVEL1) %>% 
                      summarise()     
      
      ggplot(sa_epa_L1) +
        geom_sf(aes(fill=LEVEL1)) 
  
  # Add meaningful values for legend
    # Download from external source (course github page)
    L1_names_URL = "https://raw.githubusercontent.com/devanmcg/IntroRangeR/master/12_Mapping/SouthAmericaLevel1Names.csv"
    sa_L1_names <- read_csv(L1_names_URL) %>%
                    mutate(Level1 = as.factor(Level1))
    
    # Add to sf object with tidyverse join
      sa_epa_L1 <-
        sa_epa_L1 %>%
          left_join(sa_L1_names, by=c("LEVEL1"="Level1"))
  
      sa_epa_L1
      
      sa_L1_gg <-
        ggplot() +
          geom_sf(data=sa_epa_L1, aes(fill=`Level 1 Ecoregion`))
    
      sa_L1_gg
    
  # Add country boundaries & specify fill gradient  
    sa_L1_gg +
      geom_sf(data=sa_countries, fill=NA, color="white") +
      scale_fill_viridis_d(alpha=0.75)
    