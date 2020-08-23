Lesson 12: R as GIS
===================

- 12.1: Basic mapping and adding features
    - Learn: [Videos \& script](#introduction-to-mapping)
    - Do: [Homework assignment](#mapping)
    - [Tips on using Natural Earth data](#map-data)
- 12.2: Spatial analysis 
    - Learn: [Video \& script](#spatial-data-analysis)
    - [Vignette on the interpolation example](https://github.com/devanmcg/categorical-spatial-interpolation/blob/IntroRangeR/README.md), including step-by-step discussion of the script used in the lecture. 
    This was modified from the [original blog post](https://timogrossenbacher.ch/2018/03/categorical-spatial-interpolation-with-r/) by [Timo Grossenbacher](https://timogrossenbacher.ch).  
    - Do: [Homework assignment](#interpolation)


Learn.
------

*Lectures*

## Introduction to mapping

* 12.1.1: Basic mapping with `ggplot2`
  - [Video available here on YouTube](https://youtu.be/bXAaAAWSb_E)
  - Script: [IntroMapping.R](https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/IntroMapping.R)
* 12.1.2: Adding features to maps with `ggplot2` and `sf`
  - [Video on YouTube](https://youtu.be/HOQEtTofbjg)
  - Script: [AddingMapFeatures.R](https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/AddingMapFeatures.R)

## Spatial data analysis

* 12.2: Interpolation
    - [Video on YouTube](https://youtu.be/pqQ7i5zA898)
    - Script: [Interpolation.R](https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/Interpolation.R)

# Do. 

*Homework assignments*

## Mapping

### The assignment

Reproduce, as closely as possible, each of the following maps. 
Data and tips are below.

* A national map of Canada
  - Provincial boundaries overlaid over Level 1 EPA ecoregions
  - Projection accommodating curvature of the Earth
  - Dissolved internal Level 2 boundaries

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/national-1.png" width="600" >

* A map of provinces Alberta and Saskatchewan
  - Provincial boundaries overlaid over Level 2 EPA ecoregions
  - Projection accommodating curvature of the Earth
  - Identify the provinces with a font that contrasts with the fill
  - Indicate the location of these eight `Populated Places` and identify them with a label that does not obscure the location marker.

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/provincial-1.png" width="600">

### Map data

*Highly recommend* downloading these data once to your local machine and calling the `.shp` files individually using a full file path when you knit your submission document. 
Downloading each time you knit will slow it down substantially and repeatedly add pretty decent-sized files to the temp folder. 

* Canadian borders (national and provincial):
  - Especially if you think you'll be making a fair number of maps, I recommend downloading the Natural Earth dataset to a local directory using `rnaturalearth::ne_download`and accessing the data with `read_sf`:

``` r
# Hard-code to *your* local directory to store (and retrieve) geo data
  ne_dir = "C:/R/data/gis/NaturalEarth"
# Run this once in the console and don't put in a .Rmd file
  ne_download(scale = 10, # finest scale, largest file (14MB download)
              type = 'states', 
              category = 'cultural', 
              returnclass = "sf",
              destdir = ne_dir, 
              load = FALSE)
# Use this in any .Rmd file you want geo data for
    ne_sf <- read_sf(ne_dir, "ne_10m_admin_1_states_provinces_lakes")
# Then filter for the country you need
  canada <- 
    ne_sf %>%
      filter(admin == "Canada")
# States and provinces stored in the 'names' column
```

* North American EPA Ecoregions, Levels 1 and 2: [`NA_CEC_Eco_Level2.shp`](http://ecologicalregions.info/data/cec_na/NA_CEC_Eco_Level2.zip) (`.zip`)
* [Canada geographical place name data](https://www.nrcan.gc.ca/earth-sciences/geography/download-geographical-names-data/9245). 
These are organized by province. 
Access the SHP files for Alberta and Saskatchewan (unfortunately can't provide hot ftp links here):
  - Alberta: `cgn_ab_shp_eng.shp` in `ftp://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_cgn_toponyme/prov_shp_eng/cgn_ab_shp_eng.zip`  
  - Saskatchewan: `cgn_sk_shp_eng.shp` in `ftp://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_cgn_toponyme/prov_shp_eng/cgn_sk_shp_eng.zip`
  
### Tips 

* Download the data above to your machine and unzip to a folder like `R > data`.
   `read_sf` can load them when given the full file path to the `.shp` file in the local directory. 
   See `?read_sf`. 
* Regarding Natural Earth data: 
  - The steps below have already caused some folks problems. 
  You might as well just download and save the global file as described above.
  - To complete the assignment with Natural Earth data, you will need a different `rnaturalearth` function and an additional package.
 Recommend using the `ne_states` function, which requires the `rnaturalearthhires` package. 
  - I was unable to get `rnaturalearthhires` from *r-cran* but successfully installed it from its [github page](https://github.com/ropensci/rnaturalearthhires/) using `pacman::p_load_current_gh("ropensci/rnaturalearthhires")`. 
 Note that you might be prompted to have a recent version of the `sp` package, for which you can use `install.packages("sp")`.
  - If you have trouble with `pacman::p_load_current_gh`, you can also use `devtools::install_github("ropensci/rnaturalearthhires")` on your first attempt and use `library(rnaturalearthhires)` thereafter. 
* Remember to avoid using `install.packages` or `install_github` in an `.Rmd` file. 
 You don't want it to re-install every time you try to knit. 

## Interpolation 

### NDAWN data

The North Dakota Agricultural Weather Network, or [NDAWN](https://ndawn.ndsu.nodak.edu/), collects hourly weather data across North Dakota and the sugar beet/potato-producing regions in the Red River Valley, Minnesota, and the Yellowstone River Valley, Montana. 
Current conditions are available online (updated every 5 min), and historical data can be downloaded. 

Prior to writing this assignment, I downloaded all station data for 20 April 2020 and posted them to github as [NDAWN_2020_04_20.csv](https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/NDAWN_2020_04_20.csv). 
[NDAWN_2020_04_26.csv](https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/NDAWN_2020_04_26.csv) is also available.

### The assignment

Create, as closely as possible, the following three maps: 

* The location of all NDAWN station locations, plus a few towns in North Dakota:
<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/maps/StationLocations-1.png" width="600" >

* Maximum temperature values for each station location:
<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/maps/StatewidePoints-1.png" width="600" >

* Estimated maximum temperatures for the entire state of North Dakota determined through interpolation. 
Include a few towns, as well: 
<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/maps/StatewideInterpolation-1.png" width="600" >

Provide responses to these questions: 

* On the day you mapped (April 20 or 26), which parts of the state were...
    - the warmest? 
    - the coolest? 
* Do the interpolated data agree with the actual NDAWN data?
How might you test or verify that (don't need to do it, just speculate)?

General tips:

* North Dakota boundaries can be filtered out of the Natural Earth data described above. 
* Projection: I recommend EPSG 26914 when mapping North Dakota.
* Differences in these data vs. [example using German linguistic data](https://github.com/devanmcg/categorical-spatial-interpolation/blob/IntroRangeR/README.md):
    - There aren't nearly as many data points, so thinning isn't necessary. 
    - The temperature data are continuous, not categorical. 
    Therefore, ensure that data are stored `as.numeric`. 
    The `prob` element of the `kknn` object will also be empty, and does not need to be extracted (and thus cannot be plotted).
* With fewer data, we can alter the following parameters for the interpolation function `kknn`:
    - `width_in_pixels` can be increased to 500. 
    - `k` must be substantially lower than in the example. 
    For best results I recommend `knn = 10` but you should play around with the differences in 5, 10, and 20.
