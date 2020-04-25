# Learn.

*Lectures*

# Do. 

*Homework assignments*

## Background 


<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/national-1.png" width="500" >

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/12_RasGIS/provincial-1.png" width="500">


## The assignment

### Data

* North American EPA Ecoregions, Levels 1 and 2: [`NA_CEC_Eco_Level2.shp`](http://ecologicalregions.info/data/cec_na/NA_CEC_Eco_Level2.zip) (`.zip`)
* [Canada geographical place name data](https://www.nrcan.gc.ca/earth-sciences/geography/download-geographical-names-data/9245) (by province)
  - Alberta: [`cgn_ab_shp_eng.shp`](ftp://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_cgn_toponyme/prov_shp_eng/cgn_ab_shp_eng.zip) (`.zip`)
  - Saskatchewan: [`cgn_sk_shp_eng.shp`](ftp://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_cgn_toponyme/prov_shp_eng/cgn_sk_shp_eng.zip) (`.zip`)
  

### Hints 

 * Different scales of time can be `format`ted differently. 
 * You'll need to implement `summarize` at least twice on different `group_by` constructions. 
 * You'll likely need to use `as.POSIXct` again after other manipulations. 
 * Check out various `scale_x_` options when you get to your `ggplot`
