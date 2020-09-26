# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# Course website: https://www.introranger.org 
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 6: More data manipulation with tidyverse and friends
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, readxl)
#  
  setwd("../R") # Remember not to use setwd() in a .Rmd file, use full file paths
# 
# Load data
#
  # Note: Data are online at https://github.com/devanmcg/IntroRangeR/blob/master/data/VareExample.xlsx
  #
  # New tricks!
  #
  # Why export and save each sheet in your Excel file as single .csv files 
  # when you can just go in and get them from the .xlsx file with readxl?
  
  # Often convenient to set the file path as an object
    xl_file = "./data/VareExample.xlsx" # Use full path (no .) in .Rmd file

  # Make tibbles from specific worksheets in the .xlsx file 
    spp_tbl <-  readxl::read_excel(xl_file, "SpeciesData") # Note brevity of path argument
    man_tbl <- read_excel(xl_file, "Management")
   
    
  # Compare data structure 
    spp_tbl     # tibble = no need for str() or head()
    man_tbl     # same
    
# Add a unique sample ID column to spp_d

  spp_tbl <- unite(data=spp_tbl,    # Identify the data
                   col="SampleID",  # Name the new column
                   c("Pasture", "Treatment", "Point"), # original columns to combine
                   sep=".") # what's between the labels in the merged column
  spp_tbl 

    # check out the reverse:
      separate(spp_tbl,  # data set
               SampleID, # existing column to split up
               c("Pasture","Treatment","Point"))  # new columns to create

# Data formats: Wide vs long 
  # spp_tbl in wide format--column for each species values. 
  # gather into long format: 
    spp_long <-pivot_longer(spp_tbl, 
                            names_to = 'species', 
                            values_to = 'abundance', 
                            -SampleID) 
    spp_long 
  
  # spread them back out: 
    pivot_wider(spp_long, 
                names_from = 'species', 
                values_from = 'abundance')

# Uh oh:
  man_tbl # what's with BareSoil??

   # Break out multiple entries w/ two new tidyverse functions: 
    # stringr::str_split
    # tidyr::unnest 
    man_tbl <-  
      man_tbl %>% 
        mutate(BareSoil = str_split(BareSoil, ",")) %>% 
          unnest(BareSoil) 
    man_tbl
    
    man_tbl <- mutate(man_tbl, BareSoil = as.numeric(BareSoil))
    man_tbl 
  
  # Reduce to single variable 
    man_tbl <- 
      man_tbl %>%
        group_by(SampleID, PastureName, BurnSeason) %>%
          summarise(BareSoil = mean(BareSoil)) %>%
            ungroup 
    man_tbl

# Associate species and management info & plot
    full_join(man_tbl, spp_tbl, by="SampleID")
    
    full_join(man_tbl, spp_tbl, "SampleID") %>%
      filter(BurnSeason != "Fall") %>% 
      ggplot(aes(x=(100-BareSoil), y=Empenigr)) + # Note X transformation 
        theme_bw(16) +
          geom_smooth(method="lm", se=F) +
          geom_point(size=3) + 
        facet_wrap(~BurnSeason, scales = "free_x") + # Note scales argument
        labs(x = "Soil coverage (%)", 
             y = "Empetrum nigrum", 
             title = "E. nigrum abundance by ground cover & burn season")
    