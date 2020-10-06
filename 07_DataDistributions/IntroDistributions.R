# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# Course website: https://www.introranger.org 
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 7.1: Introduction to data distributions
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(permute, tidyverse)
  
  data(jackal)
  as_tibble(jackal)

# Does the length of jackal teeth vary by sex?
  # View average length of jackal teeth by sex:
    jackal %>% 
      group_by(Sex) %>%
      summarise( 
        Mean = mean(Length) )
    
  # Also consider error around mean:
    jackal %>% 
      group_by(Sex) %>%
        summarise( 
          Mean = mean(Length), 
          SD = sd(Length), 
          SE = sd(Length)/sqrt(length(Length)))

# View data 
  jackal %>% 
    group_by(Sex) %>%
      summarise( 
        Mean = mean(Length), 
        SE = sd(Length)/sqrt(length(Length))) %>%
    ggplot(aes(x=Sex)) + theme_bw(16) +
      geom_jitter(data=jackal, 
                  aes(y = Length), 
                  width = 0.15, 
                  alpha = 0.5) + 
      geom_errorbar(aes(ymin = Mean - SE, 
                        ymax = Mean + SE), 
                    width = 0.1, 
                    size = 1) +
      geom_point(aes(y = Mean), 
                 pch = 17, 
                 size = 5)

# Plot the tooth length data 
  # Histogram: Where the actual data actually are 
    jn_gg <- ggplot(jackal, aes(x=Length)) + theme_bw(16) + 
      geom_histogram(aes(y=..density..),      
                     binwidth=1,
                     colour="black",
                     fill="lightgreen") 
    jn_gg
  
  # Kernel density estimate: smoothed interpolation of actual data
    jn_gg <- jn_gg + geom_density(alpha=.5, fill="lightblue")
    jn_gg 

# MASS::fitdistr is a workhorse function for providing parameter estimates
  MASS::fitdistr(jackal$Length, "normal")

  # Feed the parameter estimates into stat_function to see 
  # the theoretical distribution of the data 
  # i.e. how a statistical model assumes the data look 
  
    jn_gg <- jn_gg + 
      stat_function(data=jackal, 
                    fun = dnorm, 
                    args=list(mean = 111,
                              sd = 3.78),
                    colour="blue", 
                    size=1.1) 
    jn_gg
  
  # Modify range to get better picture of what model assumes 
    jn_gg <- jn_gg + xlim(c(mean(jackal$Length)-15, 
                            mean(jackal$Length)+15))
    jn_gg
    
  # Can also view data as if log-transformed (log-normal distribution)
    
    MASS::fitdistr(jackal$Length, "lognormal")
    
    jn_gg + 
      stat_function(data=jackal, 
                    fun = dlnorm, 
                    args=list(meanlog=4.71,
                              sdlog=0.03),
                    lty=5,
                    colour="blue", 
                    size=1.1)  


    

  