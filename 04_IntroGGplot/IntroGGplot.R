# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 4: Introducing ggplot 
#
  if (!require("pacman")) install.packages("pacman")
    pacman::p_load(tidyverse)
# 
# Load data
#
# ...either from a locally-saved .csv file:
  setwd(".../R") 
  mtcars2 <- read.csv("./data/mtcars2.csv")

# ...or read from a Google Sheets file  
# published online in .csv format:
  csvURL <- url("https://docs.google.com/spreadsheets/d/e/2PACX-1vRba0jYQ4pAd8pX0ikaDGamvm_k6zstaAoCOKIz_zi-pnR8qDL6V-NxGc6cp189hmkrG-BoA2Jm32qN/pub?output=csv")
  mtcars2 <- read.csv(csvURL)
#
  str(mtcars2)
#
# Getting into ggplot
#
  # Three main components: 
    # call to the ggplot function -- ggplot() 
    # specify data.frame
    # identify aesthetics -- variables to be plotted -- aes() 
    # define a geometry -- how the plot should look
  
      ggplot(data=mtcars2, aes(x=hp, y=mpg)) # Empty! No geometry
      ggplot(data=mtcars2, aes(x=hp, y=mpg)) +
        geom_point() 

    # ggplot can be object-oriented, helps build plots:
      ggp <- ggplot(data=mtcars2, aes(x=hp, y=mpg)) +
                geom_point() 
      ggp
      (ggp <- ggp + geom_smooth(method="lm", se=FALSE) ) 
    
      ggp + facet_wrap(~am)
      ggp + facet_grid(origin~am)
    
    # Themes
    
      # Several defaults:
        ggp + theme_bw() # No background, major + minor gridlines
        ggp + theme_linedraw() # No background, no minor gridlines
        ggp + theme_minimal() # No axis lines 
        
      # Many options developed:
        pacman::p_load(ggthemes)
        ggp + theme_wsj()   # Print like a Wall Street Journal graph
        ggp + theme_economist()  # Or one from the Economist
        ggp + theme_tufte() 
        # Themes based on retro stat software:
          ggp + theme_stata() 
          ggp + theme_excel() # Ugh.
          ggp + theme_base() # Recognize this one??
  
#
# Customizing ggplot
#
  # As powerful as it is, default ggplots rarely look 
  # the way you need them to for papers, presentations, etc.
  # Fortunately ggplots are almost infinitely customizable.
  # Some parameters are set in the geom, 
  # Others in a theme command (but not the themes from above):
          
    ggp + theme_bw() 
    ggp + theme_bw(18)
    
    # Note critical difference between these sets of plots:
     ggplot(data=mtcars2, aes(x=hp, y=mpg)) +
        geom_point(aes(shape=cyl))
     ggplot(data=mtcars2, aes(x=hp, y=mpg)) +
       geom_point(shape=17) 
     
     ggplot(data=mtcars2, aes(x=hp, y=mpg)) +
       geom_point(aes(shape=cyl), color="blue")
     ggplot(data=mtcars2, aes(x=hp, y=mpg)) +
       geom_point(aes(color=cyl), shape=17) 
   
   # Building up our ggplot: 
   # More information, more clarity
     
     ggplot(data=mtcars2, 
            aes(x=hp, y=mpg, 
                color=cyl, 
                shape=cyl,
                size=wt)) +
       geom_point() 
     
     ggplot(data=mtcars2, 
            aes(x=hp, y=mpg, 
                fill=cyl, 
                shape=cyl,
                size=wt)) +
       geom_point() +
       scale_shape_manual(values=c(21,22,24)) + 
       scale_size_continuous(guide=FALSE)
     
     ggplot(data=mtcars2, 
            aes(x=hp, y=mpg, 
                fill=cyl, 
                shape=cyl,
                size=wt)) +
       geom_point() +
       scale_shape_manual(values=c(21,22,24)) + 
       scale_size_continuous(guide=FALSE) +
       theme(axis.title = element_text(size=14), 
             axis.text = element_text(size=12))
   
     ggplot(data=mtcars2, 
            aes(x=hp, y=mpg)) +
       geom_smooth(method="lm", color="black", se=FALSE) +
       geom_point(aes(fill=cyl, 
                      shape=cyl,
                      size=wt)) +
       theme_bw(16) +
       scale_shape_manual(name="Engine\ncylinders", 
                          values=c(21,22,24)) + 
       scale_fill_viridis_d(name="Engine\ncylinders") + 
       scale_size_continuous(guide=FALSE) +
       labs(x="Engine power (horsepower)",
            y="Fuel economy (miles/gallon)", 
            title="Fuel efficiency declines as engine power increases",
            caption="Point sizes scaled to car weight")
   

  
