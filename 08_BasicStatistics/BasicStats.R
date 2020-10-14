# An Introduction to R (www.introranger.org)
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 8.1: Basic statistical analysis
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse) 

  mtcars <- mutate_at(mtcars, vars(cyl, am), 
                      as.factor ) %>%
              mutate(am = recode(am, "0"="Automatic",   
                                     "1"="Manual"), 
                     am = factor(am, levels=c("Manual", 
                                              "Automatic"))) %>% 
              rename(transmission = am)
  
##
## Basic pairwise comparisons (among groups)
##

# Hypothesis: manual transmissions get better 
# fuel economy than automatic transmissions
  ggplot(mtcars, aes(x=transmission, y=mpg)) + theme_bw(14) +
    geom_boxplot(aes(fill=transmission), 
                 size = 1.5, show.legend =F)

# Check distribution
  ggplot(mtcars, aes(x=mpg)) + theme_bw(14)  +
    geom_density(alpha=0.5, fill="lightblue") + 
    geom_histogram(aes(y=..density..),      
                   binwidth=1, fill="lightgreen", 
                   alpha=0.8, colour="black") +
    stat_function(data=mtcars, 
                  fun = dnorm, 
                  args=list(mean=mean(mtcars$mpg),
                            sd=sd(mtcars$mpg)),
                  colour="blue", 
                  size=1.1) +
    xlim(c(0,40))
  
# Check for skewness (median:mean)
  # Data as they are:
    tibble(Mean = mean(mtcars$mpg), 
           Median = median(mtcars$mpg), 
           Ratio = Mean/Median)  %>%
      mutate_all(~round(.,2)) 
  
  # Log-transformed:
    tibble(Mean = mean(log(mtcars$mpg)), 
           Median = median(log(mtcars$mpg)), 
           Ratio = Mean/Median) %>%
      mutate_all(~round(.,2))
 
  # Proceed with log-transformed data... 
      mtcars <- mutate(mtcars, lmpg = log(mpg))
      
  # ... and re-plot distribution:
      ggplot(mtcars, aes(x=lmpg)) + theme_bw(14) +
        geom_density(alpha=.5, fill="lightblue") + 
        geom_histogram(aes(y=..density..),      
                       binwidth=0.1, 
                       fill="lightgreen", 
                       alpha=0.8,
                       colour="black")  +
        stat_function(data=mtcars, 
                      fun = dnorm, 
                      args=list(mean=mean(mtcars$lmpg),
                                sd=sd(mtcars$lmpg)),
                      colour="blue", 
                      size=1.1) +
        xlim(c(2,4)) 
#  
# t test 
#
  # Moments/distribution parameters
    mtcars %>% 
      group_by(transmission) %>%
      summarize(Mean = mean(lmpg), 
                SD = sd(lmpg), 
                n = n() ) %>%
      mutate_at(vars(Mean, SD), ~round(., 3))
    
  # View distributions by transmission types
    ggplot(mtcars, aes(x=lmpg, 
                       fill = transmission)) + theme_bw(14) +
      geom_density(alpha=.5) + 
      geom_histogram(aes(y=..density..),
                     binwidth = 0.025,
                     alpha=0.8,
                     colour="black") +
      stat_function(data=mtcars, 
                    fun = dnorm, 
                    args=list(mean=2.8,
                              sd=0.2), 
                    colour="darkred", 
                    size=2)  + 
      stat_function(data=mtcars, 
                    fun = dnorm, 
                    args=list(mean = 3.2, 
                              sd = 0.3),
                    colour="blue", 
                    size=2)  + 
      annotate("label", 
               x=c(2.75, 3.25), 
               y=c(1,2), 
               label = c("Automatic", "Manual"), 
               color=c("darkred", "blue"), 
               size=5)

  # Calculate a t statistic
    # Group means
      X_a = 2.817
      X_m = 3.163
    # Standard deviations
      s_a = 0.235
      s_m = 0.263
    # Sample sizes
      n_a = 19
      n_m = 13
    
    t_w = (X_m - X_a) / sqrt((s_m^2/n_m) + (s_a^2/n_a) )
    t_w # Welch's t statistic 
    
  # Test significance with t.test() :
    t.test(lmpg ~ transmission, mtcars)
#  
# Analysis of Variance (ANOVA)
#
  # fit model with lm() 
    tr_lm <- lm(lmpg ~ transmission, mtcars)
    tr_lm
  
  # Compare difference of group means...
    X_m
    X_m - X_a
    
  # ... to the model coefficients:
    coef(tr_lm)
    
  # Evaluate model (significance tests, etc.)
    summary(tr_lm) # t test & F test
    anova(tr_lm)   # F test only
 
# Multiple comparisons (Factors with >2 levels) 
  # View data
    ggplot(mtcars, aes(x=cyl, y=mpg, 
                       fill=cyl)) + 
      theme_bw(14) +
      geom_boxplot(show.legend = F) 
  
  # Fit model
    cyl_lm <- lm(lmpg ~ cyl, mtcars)
    
  # Evaluate
    anova(cyl_lm)
    summary(cyl_lm)

  # Tukey post-hoc comparison
    aov(cyl_lm) %>% TukeyHSD()  # wrap lm() object in aov() 
    