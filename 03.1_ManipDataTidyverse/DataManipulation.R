# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
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
  mtcars_origins <- read.csv("./data/mtcars_origins.csv")
  
  # Read from a Google Sheets file published  
    # online in .csv format:
  URL <- url("https://docs.google.com/spreadsheets/d/e/2PACX-1vRBNT5RoZ1AXpUHC-b5cCSe7GEj4x9lhwh5FeNV-NQDrB5G9qa1gTPAhigq0gh7WFHicfBrT7s-rx3q/pub?gid=1985705954&single=true&output=csv")
  mtcars_origins <- read.csv(URL)

#
# Data manipulation 
#
#
  head(mtcars)    

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

  mtcars <- mutate_at(mtcars, vars(cyl, vs, gear, carb, am), as.character)
  mtcars <- mutate(mtcars, am = recode(am, "0"="Automatic",   
                                           "1"="Manual")) 
  mtcars <-  rename(mtcars, transmission = am)

  str(mtcars)

# Merge (combine) columns from two data.frames into one:

  mtcars2 <- full_join(mtcars, mtcars_origins, by="make.model" )
  str(mtcars2)

# Add a variable using a logical string.
# ifelse reads as "if X, then Y; otherwise Z (because not X)"

  mtcars2 <- mutate(mtcars2, origin = ifelse((country=="USA"), 
                                             "domestic", "foreign"))

# although ifelse first appears either/or, ifelse statements
# can be nested to add a series of options: 

  mtcars2 <- mutate(mtcars2, continent =  ifelse((country=="USA"), 
                                                "North America", 
                                            ifelse((country=="Japan"), 
                                                   "Asia", "Europe")))

# Calculate descriptive statistics

# base function aggregate() uses standard R formula format (y ~ x, data) 
# to define relationships between variables one wants to calculate. 
# This function is analogous to making a PivotTable in Excel.

  means <-  aggregate(hp ~ continent, data=mtcars2, FUN=mean) 
  means
  
  # Add means to a base plot. 
  # Note plot behavior differs between characters and factors.
    boxplot(hp ~ continent, mtcars2, las=1)
      points(hp ~ as.factor(continent), means, 
             pch=24, bg="blue", cex=2)

# The tidy way is to group and summarize:
  
  mtcars2 %>% # pipe operator 'pours' data down
    group_by(cyl) %>%
      summarize(mean_hp = mean(hp)) 

# Easy to add another level: 
  
  mtcars2 %>% 
    group_by(transmission, cyl) %>%
      summarize(mean_hp = mean(hp)) 
  
  # Just as easy to add another operation, too: 
  
  mtcars2 %>% 
    group_by(transmission, cyl) %>%
      summarize(mean_hp = mean(hp), 
                sd_hp = sd(hp)) 

# After all that work - make sure to save!

  getwd()
  save(mtcars2, file="./data/mtcars2.Rdata") 
# or
  save(mtcars2, file=file.choose()) 