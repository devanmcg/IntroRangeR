# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 10: Fitting GLM and GLMM regression models
#
# Packages
  # Need to have these installed, but recommend *not* loading them
    install.packages(c("car", "lme4"))

  # Always need pacman and tidyverse!
    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(tidyverse) 
  
# Load data 
  clev.d <- read_csv("./data/AllClevelandCrimeData.csv")
  clev.d 
  
  clev.d <- clev.d %>% mutate(GameDay = recode(GameDay, "0" = "No", 
                                                        "1" = "Yes") ) 
  
# Count data 

# Are there more charges on game days? 
  ggplot(clev.d) + theme_bw(16) +
    geom_bar(aes(x=GameDay), stat="count")
  
  # Summarize
  GD <- clev.d %>%
          group_by(GameDay) %>%
            summarize(charges=n())
  GD

  # Test 
    # fit the GLM model 
      glm_gd <- glm(charges ~ GameDay, GD, family=poisson(link = "log"))
    
    # Evaluate
     summary(glm_gd)  # Pretty familiar    
     anova(glm_gd)    # Hey, what gives?  
     anova(glm_gd, test = "Chisq") # That's more like it 
     car::Anova(glm_gd)   # Different but same 
    

# Non-independence 
    
 ggplot(clev.d) + theme_bw(16) +
   geom_bar(aes(x=GameDay, fill=Venue), 
            stat="count",
            position = position_dodge2())
 
  GD.v <- clev.d %>%
            group_by(Venue, GameDay) %>%
              summarize(charges=n()) %>% ungroup
  GD.v

  glmer_gd <- lme4::glmer(charges ~ GameDay + (1|Venue), GD.v, 
                          family=poisson(link = "log"))
  summary(glmer_gd)    
  anova(glmer_gd, test = "Chisq") # Trick doesn't work on glmer
  car::Anova(glmer_gd)  # This still works  

  # TO use anova(), create a null model and compare
  glmer_0 <- lme4::glmer(charges ~ 1 + (1|Venue), GD.v, 
                          family=poisson(link = "log"))
  anova(glmer_0, glmer_gd) 
