# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 4: Basic plotting
#
# Data loading 
#
# Two types of options: 
#
# 1.  Convert from a .csv file that is either 
#       saved locally or available online
#
# Read from a locally-saved .csv file:
  setwd(".../R") 
  mtcars2 <- read.csv("./data/mtcars2.csv")

# Read from a Google Sheets file published  
# online in .csv format:
  csvURL <- url("https://docs.google.com/spreadsheets/d/e/2PACX-1vRba0jYQ4pAd8pX0ikaDGamvm_k6zstaAoCOKIz_zi-pnR8qDL6V-NxGc6cp189hmkrG-BoA2Jm32qN/pub?output=csv")
  mtcars2 <- read.csv(csvURL)

# Must still deal with structure
  str(mtcars2)
    mtcars2$cyl <- as.factor(mtcars2$cyl)
    mtcars2$vs <- as.factor(mtcars2$vs)
    mtcars2$gear <- as.factor(mtcars2$gear)
    mtcars2$carb <- as.factor(mtcars2$carb)
  str(mtcars2)

# 2. Load an .Rdata object

  # Locally-saved
  setwd(".../R") 
  load("./data/mtcars2.Rdata")
  
  str(mtcars2)
  
##
## B A S I C  P L O T T I N G  W/ plot()  F U N C T I O N S 
##
  
# Summary tables can be convenient and are occassionally necessary
#   but can also be boring and obscure information 
  
  pacman::p_load(plyr)
  
  hp.means <- ddply(mtcars2, .(cyl, origin), 
                summarise, 
                mean = round(mean(hp), 1), 
                sem = round(sd(hp)/sqrt(length(hp)), 2)) 
  hp.means

# DO your data have categorical predictors, continuous response?
# Box plots are a great option. 

  class(mtcars2$hp)
  class(mtcars2$cyl) 

# boxplot() takes arguments in the formula format (y ~ x, data)

# Default settings don't look bad for simple plots:
  boxplot(hp ~ origin, mtcars2)
  boxplot(hp ~ cyl, mtcars2)

# But even just adding one variable gets messy: 

  boxplot(hp ~ origin + cyl, mtcars2)

# Several graphics parameters help clean it up  
  boxplot(hp ~ origin + cyl, mtcars2, las=1, 
          xaxt="n", lwd=2,
          xlab="Number of cylinders", 
          ylab="Horsespower", 
          cex.lab=1.3, 
          cex.axis=1.3,  
          col=c("blue","orange"))
  axis(side=1, cex.lab=1.3, 
       at=c(1.5,3.5, 5.5), 
       labels=c("4", "6", "8"))
  legend("topleft", cex=1.2, bty="n", 
         title="Origin", c("Foreign","Domestic"), 
         fill=c("blue", "orange"))

  # xlab and ylab assign axis labels
  # cex.axis and cex.lab change font size of axis and axis labels
  # lwd changes the width (weight) of lines
  # las=1 makes Y axis labels read parallel 
  # ?par gives you *tons* more

# Add means to the boxplot: 
  hp.box <- boxplot(hp ~ origin + cyl, mtcars2)
  points(seq(hp.box$n), hp.means$mean,
         pch=24, col="white", bg="blue", cex=3)
  hp.means
  
  hp.means2 <- rbind(data.frame(cyl=4,
                               origin="domestic", 
                               mean=0, 
                               sem=0), 
                    hp.means) 
  points(seq(hp.box$n), hp.means2$mean,
         pch=24, col="white", bg="grey30", cex=2)

# Scatterplots are often used when both variables are continuous: 

  class(mtcars2$hp)
  class(mtcars2$mpg)

# plot() function takes formula format: 

  plot(mpg ~ hp, mtcars2)

# Think carefully when setting up your formula: 
# Which variable is independent? (it goes in for X)
# Which variable depends on the other? (it goes in for Y)

  x11(width=8, height=4) ; split.screen(c(1,2))
  screen(1) ; plot(mpg ~ hp, mtcars2, las=1)
  screen(2) ; plot(hp ~ mpg, mtcars2, las=1)
  close.screen(all=TRUE) 
  
  dev.off() # Kill pop-up graphics device, return to Rstudio

# Fitting trend lines 

# Linear relationships beg to have a line drawn through them. 
# R includes functions to automatically fit and plot lines. 
# e.g., abline() and lm() are seperate functions, but abline()
# "knows" how to read lm() (linear model) results for line info:

  abline(lm(mpg ~ hp, mtcars2))

# Different pars can be added - to abline - to customize:

  abline(lm(mpg ~ hp, mtcars2), lwd=2)
  abline(lm(mpg ~ hp, mtcars2), lwd=5, lty=2)

# Note the overplotting. 
# To get a new line, must start from scratch:

  plot(mpg ~ hp, mtcars2, las=1)
  abline(lm(mpg ~ hp, mtcars2), lwd=2, lty=2)

# Combining continuous and categorical variables

# Perhaps cars with different origins have unique 
# mpg ~ hp relationships?
# Adventures with subset(): 

  plot(mpg ~ hp, mtcars2, las=1, type="n") # Make a blank plot
  points(mpg ~ hp, subset(mtcars2,origin=="foreign"),pch=1)
  points(mpg ~ hp, subset(mtcars2,origin=="domestic"),pch=19)

# Can also make new data.frames

  for.mtcars <- subset(mtcars2,origin=="foreign")
  dom.mtcars <- subset(mtcars2,origin=="domestic")
  
  abline(lm(mpg~hp, for.mtcars),lty=1)
  abline(lm(mpg~hp, dom.mtcars),lty=2)

# Customize the graph: 
# Improve aesthetics, provide more info about the data: 

  plot(mpg ~ hp, mtcars2, las=1, type="n", 
       cex.axis=1.4, cex.lab=1.4,
       xlab="Engine power (hp)", xlim=c(50,350), 
       ylab="Fuel economy (mpg)", ylim=c(10,35))
  
  points(mpg ~ hp, subset(mtcars2, origin=="foreign"), 
         pch=19, cex=1.4, col="orange")
  points(mpg ~ hp, subset(mtcars2, origin=="domestic"), 
         pch=17, cex=1.4, col="blue")
  
  abline(lm(mpg~hp, subset(mtcars2, origin=="foreign")), 
         lwd=2, col="orange", lty=1)
  abline(lm(mpg~hp, subset(mtcars2, origin=="domestic")), 
         lwd=2, col="blue", lty=2)
  
  legend("topright", title="Car origin", c("Foreign","USA"), 
         lty = c(1,2), col=c("orange","blue"), 
         pch=c(19, 17), cex=1.4, lwd=2, bty="n" )
  
# What happens when plot is categorical vs. categorical?

  plot(am ~ origin, mtcars2, col=c("orange","blue"))
  
  plot(cyl ~ continent, mtcars2, col=c("orange", "black","blue"))  
  
# Scope out relationships among multiple variables
  
  pairs(~mpg+hp+drat+wt,data=mtcars2) 
  
  pairs(~mpg+hp+drat+cyl,data=mtcars2, 
        upper.panel = NULL) 
