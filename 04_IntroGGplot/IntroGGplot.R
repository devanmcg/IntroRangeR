# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# Course website: https://www.introranger.org 
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 4: Introducing ggplot 
#
  if (!require("pacman")) install.packages("pacman")
    pacman::p_load(ggplot2)
# 
# Load data 
#
# ...either from a locally-saved .Rdata file:
  setwd(".../R") 
  mtcars2 <- load("./data/mtcars2.Rdata")

# ...or read from a .Rdata file published online  
  objURL <- url("https://github.com/devanmcg/IntroRangeR/raw/master/data/mtcars2.Rdata")
  load(objURL)

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
    
  # Add trendline
    ggp + geom_smooth() 
    ggp + geom_smooth(method="lm", se=FALSE) 
    
  # Add variables 
    # Change point types with aes(shape= )
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 shape=cyl)) +
        geom_point()
    
    # And control point color with aes(color=)
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 color=cyl,
                 shape=cyl)) +
        geom_point()
    
    # Two aesthetics, two variables: 
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 color=cyl,
                 shape=transmission)) +
        geom_point()
      
    # Can also facet by variable
      # facet_wrap on one variable
        ggplot(mtcars2, 
               aes(x=hp, y=mpg, 
                   color=cyl)) +
          geom_point() +
          facet_wrap(~transmission)
      
      # facet_grid on two variables
        ggplot(mtcars2, 
               aes(x=hp, y=mpg, 
                   color=cyl)) +
          geom_point() +
          facet_grid(origin~transmission)
        
    # Six variables in one graph: 
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 color=cyl,
                 size=wt)) +
        geom_point() +
        facet_grid(origin~transmission)

#
# Customizing ggplot
#
# As powerful as it is, default ggplots rarely look 
# the way you need them to for papers, presentations, etc.
# Fortunately ggplots are almost infinitely customizable.
# Some parameters are set in the geom, 
# Others in a theme command (but not the themes from above)
  
  # More specific control over appearance of aesthetics
    # Default plot
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 color=cyl, 
                 shape=cyl,
                 size=wt)) +
        geom_point() 
    
    # scale_ settings: 
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 fill=cyl, 
                 shape=cyl,
                 size=wt)) +
        geom_point() +
        scale_shape_manual(values=c(21,22,24)) + 
        scale_size_continuous(guide=FALSE)
      
    # Caption vs. legend 
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 fill=cyl, 
                 shape=cyl,
                 size=wt)) +
        geom_point() + 
        scale_shape_manual(values=c(21,22,24)) + 
        scale_size_continuous(guide=FALSE) +
        labs(caption = 'Point sizes scaled to show relative car weights')
   
    # Explanatory axis labels 
      ggplot(mtcars2, 
             aes(x=hp, y=mpg, 
                 fill=cyl, 
                 shape=cyl,
                 size=wt)) +
        geom_point() +
        scale_shape_manual(values=c(21,22,24)) + 
        scale_size_continuous(guide=FALSE) +
        labs(x="Engine power (horsepower)",
             y="Fuel economy (miles/gallon)", 
             caption = 'Point sizes scaled to show relative car weights')
      
  # Themes
    # Using theme() 
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
 
    # Using default theme_
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
        