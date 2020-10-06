# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# Course website: https://www.introranger.org 
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 7.2: The Gamma distribution
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse) 

# Load some data from github
  load(url("https://github.com/devanmcg/IntroRangeR/raw/master/data/swha.dat.Rdata") )
  
  swha <- as_tibble(swha.dat) # Swainson's Hawk counts before and during Rx fires 
  swha

# Are these data normal?
  swha_gg <- ggplot(swha, aes(x=diff)) + theme_bw(16) + 
              geom_histogram(aes(y=..density..),      
                             binwidth=1,
                             colour="black",
                             fill="lightgreen") +
              geom_density(alpha=.2, fill="#FF6666")  

  swha_gg + 
    stat_function(data=swha, 
                  fun = dnorm, 
                  args=list(mean=mean(swha$diff),
                            sd=sd(swha$diff)),
                  colour="blue", 
                  size=1.1)  + 
    xlim(c(-30, 60))  + 
    stat_function(data=swha, 
                  fun = dlnorm, 
                  args=list(meanlog=mean(log(swha$diff+1)),
                            sdlog=sd(log(swha$diff+1))),
                  colour="blue", 
                  lty=5,
                  size=1.1)  + 
    labs(title = "Normal (Gaussian) & log-normal")

# Check a Gamma distribution
  MASS::fitdistr(swha$diff+0.001, "Gamma")
  
  swha_gg + stat_function(data=swha, 
                          fun = dgamma, 
                          args=list(shape=1.86, 
                                    rate=0.101),
                          colour="darkred", 
                          size=1.1) + 
    stat_function(data=swha, 
                  fun = dlnorm, 
                  args=list(meanlog=mean(log(swha$diff+1)),
                            sdlog=sd(log(swha$diff+1))),
                  colour="blue", 
                  lty=5,
                  size=1.1)  +  
    xlim(c(-1, 60)) +
    labs(title = "Gamma + log-normal distribution")

# These data are differences:
# if there is an effect, the difference is 
# significantly different from zero. 
# Thus at P = 0.05, 95% of the time, 
# the data should not include zero 
# (This is called the 95% confidence interval)

  mean(swha$diff)

# Test difference from zero with two distributions 
# using simulated data 
# Create simulated data using r*dist functions
  swha_dist <- 
    tibble( Normal = 
              rnorm(
                n=1000, 
                mean=mean(swha$diff),
                sd=sd(swha$diff)), 
            LogNormal = 
              rlnorm(
                n = 1000,
                meanlog=mean(log(swha$diff+1)), 
                sdlog=sd(log(swha$diff+1))), 
            Gamma = 
              rgamma(
                n=1000, 
                shape=1.86, 
                rate=0.101 ) ) %>%
    pivot_longer(everything()) %>%
    rename(dist = name)
  swha_dist

# Calculate quantiles that define 95% confidence interval 
  swha_dist %>%
    group_by(dist) %>%
    summarize(`2.5%` = round(quantile(value, 
                                      prob=0.025,
                                      na.rm=TRUE), 
                             0), 
              `97.5%` = round(quantile(value, 
                                       prob=0.975,
                                       na.rm=TRUE), 
                              0))

# Visualize distributions of simulated data with respect to zero (no effect)
  swha_dist %>%
    ggplot() + theme_bw(16) + 
    geom_hline(yintercept = 0, 
               size=1.5, 
               lty=2) + 
    geom_violin(aes(x=dist, 
                    y=value, 
                    fill=dist), 
                alpha=0.75, 
                show.legend = F) +
    coord_flip() + 
    geom_violin(data=swha, 
                aes(x=1.5, y=diff), 
                fill=NA, size=1.5) + 
    geom_jitter(data=swha, 
                aes(x=1.5, y=diff), 
                width = 0.1, 
                size=4, 
                pch=21, stroke=1.5, 
                col="grey80", bg="grey20") +
    annotate("text", x=1.5, y=100, 
             label="Actual data", 
             size=6, 
             fontface="bold")