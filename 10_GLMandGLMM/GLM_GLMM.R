pacman::p_load(plyr, dplyr,  ggplot2, lme4, car)

clev.d <- read.csv("./course materials/class session materials/data/AllClevelandCrimeData.csv")

str(clev.d)

# Count data 

# Are there more charges on game days?
  # Plot
  ggplot(clev.d) + 
    geom_bar(aes(x=factor(GameDay)), stat="count")
  
  # Test
  GD <- ddply(clev.d, .(GameDay),
                      summarize, 
              charges=length(ChargeType))
  GD

  null.t <- glm(charges ~ 1, GD, family=poisson(link = "log"))
  gd <- glm(charges ~ GameDay, GD, family=poisson(link = "log"))
  anova(null.t, gd)
  car::Anova(gd)
  confint(gd, level = 0.95)

# Non-independence 
  GD.v <- ddply(clev.d, .(Venue, GameDay),
              summarize, 
              charges=length(ChargeType))
  GD.v

  null.t <- glmer(charges ~ 1 + (1|Venue), GD.v, 
                  family=poisson(link = "log"))
  gd <- glmer(charges ~ GameDay + (1|Venue), GD.v, 
              family=poisson(link = "log"))
  anova(null.t, gd)
  Anova(gd)
  confint(gd, level = 0.95)  

