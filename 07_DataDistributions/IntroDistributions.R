if (!require("pacman")) install.packages("pacman")
pacman::p_load(permute, MASS, plyr, ggplot2)

data(jackal)

str(jackal)

# Does the length of jackal teeth vary by sex?
j.sum <- ddply(jackal, .(Sex), 
               summarise, 
               mean=mean(Length), 
               se=round(sqrt(var(Length)/length(Length)),2))
j.sum

# Plot the tooth length data
jn.gg <- ggplot(jackal, aes(x=Length)) + theme_bw() + 
              geom_histogram(aes(y=..density..),      
                 binwidth=1,
                 colour="black", fill="lightgreen") 
jn.gg

(jn.gg <- jn.gg + geom_density(alpha=.2, fill="#FF6666") )

fitdistr(jackal$Length, "normal")

jn.gg <- jn.gg + stat_function(data=jackal, fun = dnorm, 
                               args=list(mean=111,
                                         sd=3.78),
                               colour="blue", size=1.1) 
jn.gg

jn.gg + xlim(c(mean(jackal$Length)-15, 
               mean(jackal$Length)+15))


# What the t-test actually compares

# Actual data:
  ggplot(data=jackal, aes(x=Length)) + theme_bw() + 
    xlim(c(mean(jackal$Length)-15, 
           mean(jackal$Length)+15)) +
    geom_histogram(aes(y=..density.., fill=Sex),      
                   binwidth=1, colour="black") +
    geom_density(aes(fill=Sex), alpha=.3)

# Theoretical distributions
  ggplot(data=jackal, aes(x=Length)) + theme_bw() + 
    xlim(c(mean(jackal$Length)-15, 
           mean(jackal$Length)+15)) +
    stat_function(data=jackal, fun = dnorm, 
                  args=list(mean=mean(subset(jackal, 
                                             Sex=="Male")$Length),
                            sd=sd(jackal$Length)),
                  colour="blue", size=1.1) +
    stat_function(data=jackal, fun = dnorm, 
                  args=list(mean=mean(subset(jackal, 
                                             Sex=="Female")$Length),
                            sd=sd(jackal$Length)),
                  colour="orange", size=1.1) 
  
# Calculate a t statistic 
  
  j.sum
  
  X1 <- j.sum[1,2]
  X2 <- j.sum[2,2]
  se1 <- j.sum[1,3]
  se2 <- j.sum[2,3]
  
  (X1-X2)/sqrt(se1^2 + se2^2)
  
# run a t test
  # Welch's t test with function t.test(): 
  
  t.test(Length ~ Sex, jackal, var.equal=FALSE)
  
  
# Alternate distributions 
  
  str(swha.dat) # Swainson's Hawks 

# Are these data normal?
  swha.gg <- ggplot(swha.dat, aes(x=diff)) + theme_bw() + 
    geom_histogram(aes(y=..density..),      
                   binwidth=1,
                   colour="black", fill="white") +
    geom_density(alpha=.2, fill="#FF6666") 
  swha.gg
  
  swha.gg + stat_function(data=swha.dat, fun = dnorm, 
                          args=list(mean=mean(swha.dat$diff),
                                    sd=sd(swha.dat$diff)),
                          colour="blue", size=1.1) 
 
  # Check for a Gamma distribution
  fitdistr(swha.dat$diff+0.001, "Gamma")
  
  swha.gg + stat_function(data=swha.dat, fun = dgamma, 
                          args=list(shape=1.86, 
                                    rate=0.101),
                          colour="blue", size=1.1) 
  
# These data are differences:
  # if there is an effect, the difference is 
  # significantly different from zero. 
  # Thus at P = 0.05, 95% of the time, 
  # the data should not include zero 
  # (This is called the 95% confidence interval)
  
   mean(swha.dat$diff)
  
  # Test difference from zero with normal distribution
    swha.norm <- rnorm(1000, mean=mean(swha.dat$diff),
                             sd=sd(swha.dat$diff))
    round(quantile(swha.norm, prob=c(0.025,0.975),na.rm=TRUE),0)
    
  # Test difference from zero with Gamma distribution
    swha.gam <- rgamma(1000,shape=1.86, rate=0.101 )
    
    round(quantile(swha.gam, prob=c(0.025,0.975),na.rm=TRUE),0)
  