# Learn.

*Lectures*

# Do. 

*Homework assignments*

## 12.1: Mapping

### The assignment

Reproduce, as closely as possible, each of the following maps:

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/national-1.png" width="600" cap="National map" >

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/provincial-1.png" width="600">




### Data

* North American EPA Ecoregions, Levels 1 and 2: [`NA_CEC_Eco_Level2.shp`](http://ecologicalregions.info/data/cec_na/NA_CEC_Eco_Level2.zip) (`.zip`)
* [Canada geographical place name data](https://www.nrcan.gc.ca/earth-sciences/geography/download-geographical-names-data/9245). 
These are organized by province. 
Access the SHP files for Alberta and Saskatchewan (unfortunately can't provide hot ftp links here):
  - Alberta: `cgn_ab_shp_eng.shp` in `ftp://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_cgn_toponyme/prov_shp_eng/cgn_ab_shp_eng.zip`  
  - Saskatchewan: `cgn_sk_shp_eng.shp` in `ftp://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_cgn_toponyme/prov_shp_eng/cgn_sk_shp_eng.zip`
  

### Hints 

 * Different scales of time can be `format`ted differently. 
 * You'll need to implement `summarize` at least twice on different `group_by` constructions. 
 * You'll likely need to use `as.POSIXct` again after other manipulations. 
 * Check out various `scale_x_` options when you get to your `ggplot`
