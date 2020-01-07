# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 3: Data manipulation I

#
# Data loading 
#
# two options: 
  # Read from a locally-saved .csv file:
  setwd(".../R") 
  mtcars.origins <- read.csv("./data/mtcars_origins.csv")
  
  # Read from a Google Sheets file published  
    # online in .csv format:
  URL <- url("https://docs.google.com/spreadsheets/d/e/2PACX-1vRBNT5RoZ1AXpUHC-b5cCSe7GEj4x9lhwh5FeNV-NQDrB5G9qa1gTPAhigq0gh7WFHicfBrT7s-rx3q/pub?gid=1985705954&single=true&output=csv")
  mtcars.origins <- read.csv(URL)

#
# Data manipulation 
#
#
str(mtcars)       # A more complex dataset

# Changing component classes with as. functions

  mtcars$cyl <- as.factor(mtcars$cyl)
  mtcars$vs <- as.factor(mtcars$vs)
  mtcars$gear <- as.factor(mtcars$gear)
  mtcars$carb <- as.factor(mtcars$carb)
  str(mtcars)

# Change column data to something more useful
pacman::p_load(plyr) 

mtcars$am <- revalue(as.factor(mtcars$am), c("0"="Automatic", 
                                             "1"="Manual"))

# Adding variables 

# First, the mtcars dataset is a tad wonky. 
# Notice how the makes and models for the cars isn't actually
# a variable column (info isn't in str(mtcars)), but is rather
# assigned to the names of the rows:

rownames(mtcars)

# We can assign row names to a new column called make.model:

mtcars$make.model <- factor(rownames(mtcars) ) 
str(mtcars)

# This gives us a reference point to automatically look up 
# a variable from one data.frame in another data.frame
# using the merge function (similar to HLOOKUP in Excel)

mtcars2 <- merge(x=mtcars.origins, y=mtcars, 
                 by.x="make.model", by.y="make.model")
str(mtcars2)

# Add a variable using a logical string.
# ifelse reads as "if X, then Y; otherwise Z (because not X)"

mtcars2[,"origin"] <- with(mtcars2, ifelse((country=="USA"), 
                                           "domestic", "foreign"))

# although ifelse first appears either/or, ifelse statements
# can be nested to add a series of options: 

mtcars2[,"continent"] <- with(mtcars2, ifelse((country=="USA"), 
                                              "North America", 
                                              ifelse((country=="Japan"), 
                                                     "Asia", "Europe")))

# Calculate descriptive statistics

# function aggregate() uses standard R formula format (y ~ x, data) 
# to define relationships between variables one wants to calculate. 
# This function is analogous to making a PivotTable in Excel.

aggregate(hp ~ cyl, data=mtcars2, FUN=mean)  
options(digits=3) # Set sig. figs. for session 
aggregate(hp ~ origin + cyl, data=mtcars2, FUN=mean)  
aggregate(cbind(mpg, hp) ~ origin + cyl, data=mtcars2, FUN=mean) 

# function ddply in the plyr package is another option. 
# it is preferred because it is vectorized but note: 
# plyr functions use a different grammar: 

ddply(mtcars2, .(origin, cyl), 
      summarize, 
        mean=mean(hp)) 

# ddply also has an advantage because it can do more at once: 

# Mean and SD takes three steps with aggregate()...
(agg.example <- aggregate(hp ~ cyl + origin, data=mtcars2, FUN=mean) ) 
colnames(agg.example)[3] <- "hp.mean"
agg.example[,"hp.sd"] <- aggregate(hp ~ cyl + origin, data=mtcars2, FUN=sd)$hp 
agg.example

# ... but ddply can combine the two: 
ddply(mtcars2, .(cyl, origin), 
      summarize, 
        hp.mean=mean(hp), 
        hp.sd=sd(hp)) 

# After all that work - make sure to save!

getwd()
save(mtcars2, file="./data/mtcars2.Rdata") 
# or
save(mtcars2, file=file.choose()) 