# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 8: Basic statistical analysis
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, GGally) 

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
  
# Multiple regression 
  # Two continuous variables 
  GGally::ggpairs(mtcars, columns = c("hp","mpg", "wt"))
    
    mrc.lm <- lm(mpg ~ hp + wt, mtcars)
    summary(mrc.lm)
    anova(mrc.lm)
  
  # Simple model comparison 
    m0 <- lm(mpg ~ 1, mtcars)
    m1 <- lm(mpg ~ hp, mtcars)
    m2 <- lm(mpg ~ hp + wt, mtcars)
    anova(m0, m1, m2)
    coef(m2) # View regression coefficients (similar to effect size)
    confint(m2)

  # Continuous + categorical variables
    mrd.gg <- ggplot(mtcars, aes(x=hp, y=mpg, 
                                 color=transmission)) + theme_bw(14) 
    mrd.gg + geom_point() 
    mrd.gg + geom_point() +
            geom_smooth(method="lm", se=FALSE)
    
    mrd.lm <- lm(mpg ~ hp + transmission, mtcars)
    summary(mrd.lm)
    anova(mrd.lm)
  
    m0 <- lm(mpg ~ 1, mtcars)
    m1 <- lm(mpg ~ hp, mtcars)
    m2 <- lm(mpg ~ hp + transmission, mtcars)
    anova(m0, m1, m2)
    coef(m2) 
    confint(m2)
    
  # Testing for statistical interactions 
     int.lm1 <- lm(mpg ~ hp:wt, mtcars)
     int.lm2 <- lm(mpg ~ hp + wt + hp:wt, mtcars)
     int.lm3 <- lm(mpg ~ hp * wt, mtcars) 
     
     anova(int.lm1)
     anova(int.lm2)
     anova(int.lm3)