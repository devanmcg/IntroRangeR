# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 5: Introducing ggplot 
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

# Must still deal with structure
  str(mtcars2)
    
    mtcars2$vs <- as.factor(mtcars2$vs)
    mtcars2$gear <- as.factor(mtcars2$gear)
    mtcars2$carb <- as.factor(mtcars2$carb)
  str(mtcars2)
#
# Getting into ggplot
#
  pacman::p_load(ggplot2)
    
    # Two main functions: 
      # qplot() or "quick plot" - takes aesthetics and geometry in-line
      # ggplot() builds plot as aesthetics and geometries are added
        # Some aesthetics (aes) include: x, y, color, shape, line type...
        # Some geometries (geoms) include: point, boxplot, line, text...
 
    # Recall the base way: 
      plot(mpg ~ cyl, data = mtcars2)   # Formula format
      with(mtcars2, plot(x=cyl, y=mpg)) # Weird way w/out formula
    
    # Neither qplot nor ggplot read formula format. 
    # Arguments must be specified. 
    # qplot assumes order is x, y:
       
      qplot(cyl, mpg, data = mtcars2)  # Incorrect. Note X axis.
      class(mtcars2$cyl) # Right, cyl is stored as numeric
      mtcars2$cyl <- as.factor(mtcars2$cyl) # Store as factor
      class(mtcars2$cyl)
      qplot(cyl, mpg, data = mtcars2)  # Still incorrect! 
                                       # But again, note X axis.
                                       # qplot treats cyl as factor, 
                                       # But assumes wrong geometry. 
      qplot(cyl, mpg, data = mtcars2, geom="boxplot")
      qplot(hp, mpg, data = mtcars2)  # Correct geometry assumption
     
    # The power of ggplot lies in *aesthetics mapping*
    # Instead of subsetting and specifying colors, sizes, etc, 
    # You tell ggplot which variables you want to plot by, and ggplot
    # finds them in your data and applies default (but customizeable)
    # parameters like color (often "colour" since the author is Kiwi):
    
      qplot(cyl, mpg, data = mtcars2, colour=origin, geom="boxplot")
      qplot(hp, mpg, data = mtcars2, colour=origin)
      qplot(hp, mpg, data = mtcars2, colour=origin, shape=am)
      mtcars2$am <- as.factor(mtcars2$am)
      qplot(hp, mpg, data = mtcars2, colour=origin, shape=am)
      qplot(hp, mpg, data = mtcars2, facets=~origin, colour=am)
      qplot(hp, mpg, data = mtcars2, facets=am~origin, colour=cyl)
    
    # Adding regression lines are beyond qplot. Need to jump to ggplot:
    
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
            aes(x=hp, y=mpg, 
                fill=cyl, 
                shape=cyl,
                size=wt)) +
       geom_point() +
       theme_bw() +
       scale_shape_manual(values=c(21,22,24)) + 
       scale_size_continuous(guide=FALSE) +
       theme(axis.title = element_text(size=14), 
             axis.text = element_text(size=12)) +
       labs(x="Horsepower", y="Miles per gallon", 
            title="Fuel efficiency declines as engine power increases",
            caption="Point sizes scaled to car weight") 
   

  