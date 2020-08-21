# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 8.1: Basic statistical analysis
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse) 

  mtcars <- mutate_at(mtcars, vars(cyl, vs, am,
                                   gear, carb), 
                      as.character ) %>%
              mutate(am = recode(am, "0"="Automatic",   
                                     "1"="Manual")) %>% 
                rename(transmission = am) 

# Basic pairwise comparisons

# Do manual transmissions really get better fuel economy?
  ggplot(mtcars, aes(x=transmission, y=mpg)) + theme_bw(14) +
    geom_boxplot(aes(fill=transmission), 
                 size = 1.5, show.legend =F) 

# Check distribution
  ggplot(mtcars, aes(x=mpg)) + theme_bw(14)  +
    geom_density(alpha=.5, fill="lightgreen") + 
    geom_histogram(aes(y=..density..),      
                   binwidth=1, fill="purple", 
                   alpha=0.8, colour="black")
  
  ggplot(mtcars, aes(x=log(mpg))) + theme_bw(14) +
    geom_density(alpha=.5, fill="lightgreen") + 
    geom_histogram(aes(y=..density..),      
                   binwidth=0.1, fill="purple", 
                   alpha=0.8, colour="black") 
  
  ggplot(mtcars, aes(x=log(mpg), fill=transmission)) + theme_bw(14) + 
    geom_histogram(aes(y=..density..),      
                   binwidth=0.1,  alpha=0.8, colour="black")  +
    geom_density(alpha=.5) 

# T test 

  t.test(mpg ~ transmission, mtcars)
  
# ANOVA 
  tr.lm <- lm(mpg ~ transmission, mtcars)
  tr.lm
  summary(tr.lm)
  anova(tr.lm)
 
# Linear regression 

  sp.gg <- ggplot(mtcars, aes(x=hp, y=mpg)) + theme_bw(14) 
  sp.gg + geom_point()
  
  sp.gg + geom_point() +
       geom_smooth(method="lm", se=FALSE) 
  
  hp.lm <- lm(mpg ~ hp, mtcars)
  summary(hp.lm)
  anova(hp.lm)
  
# Multiple comparisons 
  # Factors with >2 levels 
  
  ggplot(mtcars, aes(x=cyl, y=mpg)) + theme_bw(14) +
    geom_boxplot(aes(fill=cyl), show.legend = F) 
  
  cyl.lm <- lm(mpg ~ cyl, mtcars)
  summary(cyl.lm)
  anova(cyl.lm)
  TukeyHSD(aov(cyl.lm)) # wrap lm() object in aov() 