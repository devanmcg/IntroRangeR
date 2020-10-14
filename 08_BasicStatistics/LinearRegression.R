# An Introduction to R (www.introranger.org)
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 8.2: Linear regression
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, GGally)
  
# Prepare data (steps taken in Lesson 8.1)
  mtcars <- mutate_at(mtcars, vars(cyl, am), 
                      as.character ) %>%
    mutate(am = recode(am, "0"="Automatic",   
                           "1"="Manual"), 
           lmpg = log(mpg)) %>% 
    rename(transmission = am) 
  
# Linear regression 
  # Scatterplot
    sp_gg <- ggplot(mtcars, aes(x=hp, y=mpg)) + theme_bw(14) 
    sp_gg + geom_point()
  
  # Fit trendline
    sp_gg + geom_point() +
      geom_smooth(method="lm", se=FALSE) 
  
  # Fit linear regression model
    hp_lm <- lm(lmpg ~ hp, mtcars)
  
  # Evaluate
    summary(hp_lm)
    anova(hp_lm)

# Two continuous variables 
  # Fit
    mr_lm <- lm(lmpg ~ hp + wt + drat, mtcars)
  
  # Assess
    summary(mr_lm)
    summary(mr_lm)$coefficients
    coef(mr_lm)
    
  # Scaling 
    # Option 1
      sc1_lm <- 
        mtcars %>%
          select(lmpg, hp, wt, drat) %>%
            mutate_all(~scale(.)) %>%
        lm(lmpg ~ hp + wt + drat, .)
      coef(sc1_lm) 
    # Option 2
      sc2_lm <- lm(scale(lmpg) ~ scale(hp) + scale(wt) + scale(drat), mtcars)
      coef(sc2_lm)
      
  # Confidence intervals 
    confint(mr_lm)
    
  # scatterplot matrix
    ggpairs(mtcars, columns = c("lmpg","hp", "wt", "drat"))
    
  # Custom function to combine regression coefficients 
    # and confidence intervals into tidy object
    coefR <- function(x) {
              require(tidyverse)
              confint(x) %>%
                as.data.frame() %>%
                rownames_to_column("name") %>% 
                full_join(enframe(coef(x)), by = 'name') %>%
                setNames(c("term", "lwr", "upr", "est")) %>%
                select(term, lwr, est, upr)    }
    
   # Obtain regression coefficient results from model
     terms <- coefR(mr_lm)
     terms
     
  # Plot CIs (w/out Intercept term)
    terms %>%
      slice(-1) %>%
     ggplot(aes(x = term)) + theme_bw(14) +
       geom_hline(yintercept = 0, 
                  lty = 2, 
                  color="grey70") + 
       geom_errorbar(aes(ymin = lwr, ymax = upr), 
                     width = 0.1, 
                     size = 1, 
                     col="blue") + 
       geom_point(aes(y = est), 
                  shape = 21, 
                  col = "blue", 
                  fill = "lightblue", 
                  size = 4, 
                  stroke = 1.25) +
       coord_flip() 
      
# Continuous + categorical variables

  # Conditioned scatterplot
    ggplot(mtcars, 
           aes(x = wt, 
               y = mpg)) + theme_bw(16) +
      geom_smooth(aes(color = transmission), 
                  method="lm", se = F) +
      geom_point(aes(fill=transmission), 
                 pch = 21, size = 2, stroke = 1.1) +
      labs(y = "Fuel economy (mpg)", 
           x = "Vehicle weight (x 1000 lbs)")
    
  # Fit a multiple regression model 
    cat_lm <- lm(lmpg ~ wt + transmission, mtcars)
    summary(cat_lm)$coefficients
    
  # Fit a single regression model... 
    wt_lm <- lm(lmpg ~ wt, mtcars) 
  
  # ... and compare:
    anova(wt_lm, cat_lm)
    
  # Fit an interaction model... 
    int_lm <- lm(lmpg ~ wt + transmission + wt:transmission, mtcars)
  
  # ... and compare again: 
    anova(wt_lm, cat_lm, int_lm)
