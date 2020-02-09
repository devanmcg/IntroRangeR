pacman::p_load(plyr, ggplot2, GGally) 

str(mtcars)       # A more complex dataset

# Changing component classes with as. functions

mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$vs <- as.factor(mtcars$vs)
mtcars$gear <- as.factor(mtcars$gear)
mtcars$carb <- as.factor(mtcars$carb)
mtcars$am <- revalue(as.factor(mtcars$am), c("0"="Automatic", 
                                             "1"="Manual"))

# Basic pairwise comparisons

# Do manual transmissions really get better fuel economy?
  ggplot(mtcars, aes(x=am, y=mpg)) + theme_bw() +
    geom_boxplot(aes(fill=am)) 

# Check distribution
  ggplot(data=mtcars, aes(x=mpg)) + theme_bw() + 
    geom_histogram(aes(y=..density..),      
                   binwidth=0.1, fill="purple", alpha=0.8, colour="black") +
    geom_density(aes(fill=mpg), alpha=.5, fill="lightgreen")
  
  ggplot(data=mtcars, aes(x=log(mpg))) + theme_bw() + 
    geom_histogram(aes(y=..density..),      
                   binwidth=0.1, fill="purple", alpha=0.8, colour="black") +
    geom_density(aes(fill=mpg), alpha=.5)
  
  ggplot(data=mtcars, aes(x=log(mpg))) + theme_bw() + 
    geom_histogram(aes(y=..density.., fill=am),      
                   binwidth=0.1,  alpha=0.8, colour="black") +
    geom_density(aes(fill=am), alpha=.5)

# T test 

  t.test(mpg ~ am, mtcars)
  
# ANOVA 
  am.lm <- lm(mpg ~ am, mtcars)
  am.lm
  summary(am.lm)
  anova(am.lm)
 
# Linear regression 

  sp.gg <- ggplot(mtcars, aes(x=hp, y=mpg)) + theme_bw() 
  sp.gg + geom_point()
  
  sp.gg + geom_point() +
       geom_smooth(method="lm", se=FALSE) 
  
  hp.lm <- lm(mpg ~ hp, mtcars)
  summary(hp.lm)
  anova(hp.lm)
  
# Multiple comparisons 
  # Factors with >2 levels 
  
  ggplot(mtcars, aes(x=cyl, y=mpg)) + theme_bw() +
    geom_boxplot(aes(fill=cyl)) 
  
  cyl.lm <- lm(mpg ~ cyl, mtcars)
  summary(cyl.lm)
  anova(cyl.lm)
  TukeyHSD(aov(cyl.lm)) # wrap lm() object in aov() 
  
# Multiple regression 
  # Two continuous variables 
    ggpairs(mtcars, columns = c("hp","mpg", "wt"))
    
    mrc.lm <- lm(mpg ~ hp + wt, mtcars)
    summary(mrc.lm)
    anova(mrc.lm)
  
  # Simple model comparison 
    m1 <- lm(mpg ~ 1, mtcars)
    m2 <- lm(mpg ~ hp, mtcars)
    m3 <- lm(mpg ~ hp + wt, mtcars)
    anova(m1, m2, m3)
    coef(m3) # View regression coefficients (similar to effect size)
    confint(m3)

  # Continuous + categorical variables
    mrd.gg <- ggplot(mtcars, aes(x=hp, y=mpg, color=am)) + theme_bw() 
    mrd.gg + geom_point() 
    mrd.gg + geom_point() +
            geom_smooth(method="lm", se=FALSE)
    
    mrd.lm <- lm(mpg ~ hp + am, mtcars)
    summary(mrd.lm)
    anova(mrd.lm)
  
    m1 <- lm(mpg ~ 1, mtcars)
    m2 <- lm(mpg ~ hp, mtcars)
    m3 <- lm(mpg ~ hp + am, mtcars)
    anova(m1, m2, m3)
    coef(m3) 
    confint(m3)
    
  # Testing for statistical interactions 
     int.lm1 <- lm(mpg ~ hp:wt, mtcars)
     int.lm2 <- lm(mpg ~ hp + wt + hp:wt, mtcars)
     int.lm3 <- lm(mpg ~ hp * wt, mtcars) 
     
     anova(int.lm1)
     anova(int.lm2)
     anova(int.lm3)
  



  