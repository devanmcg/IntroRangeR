# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# Course website: https://www.introranger.org 
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 3: Intro to data manipulation with tidyverse
#
# Packages
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse) 
#
#
# Data loading 
#
# two options: 
  # Read from a locally-saved .csv file:
  setwd(".../R") 
  mtcars_origins <- read_csv("./data/mtcars_origins.csv")
  
  # Read from a Google Sheets file published  
    # online in .csv format:
  URL <- url("https://docs.google.com/spreadsheets/d/e/2PACX-1vRBNT5RoZ1AXpUHC-b5cCSe7GEj4x9lhwh5FeNV-NQDrB5G9qa1gTPAhigq0gh7WFHicfBrT7s-rx3q/pub?gid=1985705954&single=true&output=csv")
  mtcars_origins <- read.csv(URL) 
  class(mtcars_origins)
  # convert to tibble
  mtcars_origins <- as_tibble(mtcars_origins)
  class(mtcars_origins)
  
  mtcars_origins
  
# Adding variables 

# The mtcars dataset is a tad wonky. 
# Notice how the makes and models for the cars isn't actually
# a variable column (info isn't in str(mtcars)), but is rather
# assigned to the names of the rows:

  rownames(mtcars) 

# Assign row names to a new column called make.model:

  mtcars <- rownames_to_column(mtcars, var = "make.model")
  str(mtcars)

# Changing component classes with as. fun via mutate verb

  mtcars <- mutate_at(mtcars, vars(cyl, vs, 
                                   gear, carb, am),
                      as.character)
  mtcars <- mutate(mtcars, am = recode(am, "0"="Automatic",   
                                           "1"="Manual")) 
  mtcars <-  rename(mtcars, transmission = am)

  str(mtcars)

# Merge (combine) columns from two data.frames into one:

  str(mtcars_origins)
  mtcars2 <- full_join(mtcars, 
                       mtcars_origins, 
                       by="make.model" )
  str(mtcars2)

# Add a variable using a logical string.
# ifelse reads as "if X, then Y; otherwise Z (because not X)"

  mtcars2 <- mutate(mtcars2, origin = ifelse((country=="USA"), 
                                             "domestic", 
                                              "foreign"))

# although ifelse first appears either/or, ifelse statements
# can be nested to add a series of options: 

  mtcars2 <- mutate(mtcars2, continent =  ifelse((country=="USA"), 
                                                "North America", 
                                            ifelse((country=="Japan"), 
                                                   "Asia", 
                                                      "Europe")))
  
# More complicated distinctions can be sorted with case_when() : 
  mtcars2 <- mutate(mtcars2, 
                      sportiness = case_when(
                        make.model %in% c("Pontiac Firebird", 
                                          "Camero Z28", 
                                          "Maserati Bora", 
                                          "Duster 360", 
                                          "Dodge Challenger",  
                                          "AMC Javelin", 
                                          "Lotus Europa", 
                                          "Ford Pantera L", 
                                          "Ferrari Dino", 
                                          "Porsche 914-2") ~ "Pretty sporty", 
                        make.model %in% c("Fiat X1-9", 
                                          "Hornet Sportabout", 
                                          "Datsun 710", 
                                          "Mazda RX4", 
                                          "Merc 450SLC") ~ "Kinda sporty", 
                        make.model %in% c("Chrysler Imperial", 
                                          "Lincoln Continental", 
                                          "Cadillac Fleetwood", 
                                          "Merc 450SE") ~ "Total boat", 
                        TRUE ~ "Not sporty"  ))
  
  str(mtcars2)

# Calculate descriptive statistics

# base function aggregate() uses standard R formula format (y ~ x, data) 
# to define relationships between variables one wants to calculate. 
# This function is analogous to making a PivotTable in Excel.

  means <-  aggregate(hp ~ sportiness, data=mtcars2, FUN=mean) 
  means
  
# The tidy way is to group and summarize:
  
  mtcars2 %>% # pipe operator 'pours' data down
    group_by(sportiness) %>%
      summarize(mean_hp = mean(hp)) 

# Easy to add another level: 
  mtcars2 %>% 
    group_by(transmission, sportiness) %>%
      summarize(mean_hp = mean(hp)) 
  
# Just as easy to add another operation, too: 
  mtcars2 %>% 
    group_by(transmission, sportiness) %>%
      summarize(mean_hp = mean(hp), 
                sd_hp = sd(hp)) 
  
# Modify data and pour into function to create nice table: 
  mtcars2 %>% 
    mutate(transmission = str_c(transmission, " shifter")) %>%
    group_by(sportiness, transmission) %>%
    summarize(mean_hp = mean(hp), 
              sd_hp = sd(hp)) %>%
    mutate_at(vars(mean_hp, sd_hp), ~round(., 0)) %>%
    mutate(`HP (mean ± sd)` = str_c(mean_hp, " ± ", sd_hp)) %>%
    select(-mean_hp, -sd_hp) %>%
    knitr::kable(caption="Average horsepower by sportiness category.")
  
# After all that work - make sure to save!

  getwd()
  save(mtcars2, file="./data/mtcars2.Rdata") 
# or
  save(mtcars2, file=file.choose()) 