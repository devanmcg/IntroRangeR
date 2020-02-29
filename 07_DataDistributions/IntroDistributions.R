# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 7: Introduction to data distributions
#

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(permute, tidyverse)
  
  data(jackal)
  as_tibble(jackal)

# Does the length of jackal teeth vary by sex?
j.sum <- jackal %>% 
          group_by(Sex) %>%
            summarise( 
               mean=mean(Length), 
               se=sd(Length)/sqrt(length(Length)) )
j.sum

# Plot the tooth length data 
  # Histogram: Where the actual data actually are 
  jn.gg <- ggplot(jackal, aes(x=Length)) + theme_bw(16) + 
                geom_histogram(aes(y=..density..),      
                   binwidth=1,
                   colour="black", fill="lightgreen") 
  jn.gg
  
  # Kernel density estimate: smoothed interpolation of actual data
  (jn.gg <- jn.gg + geom_density(alpha=.5, fill="lightblue") )

# MASS::fitdistr is a workhorse function for providing parameter estimates
  MASS::fitdistr(jackal$Length, "normal")

  # Feed the parameter estimates into stat_function to see 
  # the theoretical distribution of the data 
  # i.e. how a statistical model assumes the data look 
  
    jn.gg <- jn.gg + 
              stat_function(data=jackal, 
                           fun = dnorm, # distribution, normal function
                           args=list(mean=111,
                                     sd=3.78),
                           colour="blue", 
                           size=1.1) 
    jn.gg
  
  # Modify range to get better picture of what model assumes 
    (jn.gg <- jn.gg + xlim(c(mean(jackal$Length)-15, 
                      mean(jackal$Length)+15)) ) 
    
  # Can also view data as if log-transformed (log-normal distribution)
    
    MASS::fitdistr(jackal$Length, "lognormal")
    
    jn.gg + 
      stat_function(data=jackal, 
                    fun = dlnorm, # distribution, log-normal  function
                    args=list(meanlog=4.71,
                              sd=0.03),
                    lty=5,
                    colour="blue", 
                    size=1.1) 

#
# t  - t e s t s 
#
# What does a t-test actually compare? 

# Actual data:
(ggt <-  ggplot(data=jackal, aes(x=Length)) + theme_bw(16) + 
    xlim(c(mean(jackal$Length)-15, 
           mean(jackal$Length)+15)) +
    geom_histogram(aes(y=..density.., fill=Sex),      
                   binwidth=1, colour="black") +
    geom_density(aes(fill=Sex), alpha=.3) ) 
    
# Theoretical distributions
  # Note that stat_function doesn't use aes() so can't map by a variable. 
  # Splitting a stat_function by a variable in one plot requires 
  # filtering and calling stat_function for each subset of the data. 
  ggt +
    stat_function(data=jackal, fun = dnorm, 
                  args=list(mean=mean(filter(jackal, 
                                             Sex=="Male")$Length),
                            sd=sd(jackal$Length)),
                  colour="blue", size=2)  + 
    stat_function(data=jackal, fun = dnorm, 
                  args=list(mean=mean(filter(jackal, 
                                             Sex=="Female")$Length),
                            sd=sd(jackal$Length)),
                  colour="orange", size=2) +
    annotate("text", x=c(100, 120), y=0.12, 
             label = c("Female", "Male"), 
             color=c("orange", "blue"), 
             size=10)
  
# Calculate a t statistic 
  
  j.sum <- as.data.frame(j.sum) # just removes the extra info of a tibble
  
  X1 = j.sum[1,2]
  X2 = j.sum[2,2]
  se1 = j.sum[1,3]
  se2 = j.sum[2,3]
  
  (X1-X2)/sqrt(se1^2 + se2^2) 
  
# run a t test
  # Welch's t test with function t.test(): 
  
  t.test(Length ~ Sex, jackal, var.equal=FALSE)
  
  
# Alternate distributions 
  # Load some data from github
  load(url("https://github.com/devanmcg/IntroRangeR/raw/master/data/swha.dat.Rdata") )
  
  as_tibble(swha.dat) # Swainson's Hawk counts before and during Rx fires 

# Are these data normal?
  swha_gg <- ggplot(swha.dat, aes(x=diff)) + theme_bw(16) + 
              geom_histogram(aes(y=..density..),      
                             binwidth=1,
                             colour="black", fill="lightgreen") +
              geom_density(alpha=.2, fill="#FF6666")  
  
  swha_gg + 
    stat_function(data=swha.dat, 
                  fun = dnorm, 
                  args=list(mean=mean(swha.dat$diff),
                            sd=sd(swha.dat$diff)),
                  colour="blue", 
                  size=1.1)  + 
    xlim(c(-30, 60))  + 
    stat_function(data=swha.dat, 
                  fun = dlnorm, 
                  args=list(meanlog=mean(log(swha.dat$diff+1)),
                            sdlog=sd(log(swha.dat$diff+1))),
                  colour="blue", 
                  lty=5,
                  size=1.1)  + 
    labs(title = "Normal (Gaussian) & log-normal")
 
  # Check a Gamma distribution
    fitdistr(swha.dat$diff+0.001, "Gamma")
    
    swha_gg + stat_function(data=swha.dat, 
                            fun = dgamma, 
                            args=list(shape=1.86, 
                                      rate=0.101),
                            colour="darkred", 
                            size=1.1) + 
      stat_function(data=swha.dat, 
                    fun = dlnorm, 
                    args=list(meanlog=mean(log(swha.dat$diff+1)),
                              sdlog=sd(log(swha.dat$diff+1))),
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
  
   mean(swha.dat$diff)
  
  # Test difference from zero with two distributions 
  # using simulated data 
    # Create simulated data using r*dist functions
     swha_dist <- tibble(normal = rnorm(1000, # randomly generate 1000 on a normal dist
                                       mean=mean(swha.dat$diff),
                                       sd=sd(swha.dat$diff)), 
                         LogNormal = rlnorm(1000, # randomly generate 1000 on a log-normal dist
                                                    meanlog=mean(log(swha.dat$diff+1)),
                                                    sdlog=sd(log(swha.dat$diff+1))), 
                        gamma = rgamma(1000, # randomly generate 1000 on a Gamma dist
                                       shape=1.86, 
                                       rate=0.101 ) ) %>%
                    gather(dist, value) 
    
  # Calculate quantiles that define 95% confidence interval 
     swha_dist %>%
      group_by(dist) %>%
        summarize(`2.5%` = round(quantile(value, prob=0.025,na.rm=TRUE), 0), 
                  `97.5%` = round(quantile(value, prob=0.975,na.rm=TRUE), 0))
    
  # Visualize distributions of simulated data with respect to zero (no effect)
    swha_dist %>%
      ggplot() + theme_bw(16) + 
        geom_hline(yintercept = 0, size=1.5, lty=2) + 
        geom_violin(aes(x=dist, y=value, 
                         fill=dist), 
                    alpha=0.75, show.legend = F) +
        coord_flip() + # rotate to horizontal graph 
      geom_violin(data=swha.dat, aes(x=1.5, y=diff), fill=NA, size=1.5) + 
       geom_jitter(data=swha.dat, 
                   aes(x=1.5, y=diff), width = 0.1, 
                   size=4, pch=21, stroke=1.5, 
                   col="grey80", bg="grey20") +
       annotate("text", x=1.5, y=100, label="Actual data", 
                size=6, fontface="bold")
    

  