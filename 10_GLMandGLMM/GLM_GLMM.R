# An Introduction to R (www.introranger.org)
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 10: Fitting GLM and GLMM regression models
#
# Packages
  # Need to have these installed, but recommend *not* loading them. 
  # Remember: Only run this line once per computer. Don't re-install.
    install.packages(c("car", "lme4"))

  # Always need pacman and tidyverse!
    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(tidyverse) 
  
# Load data 
  clev_d <- read_csv("./data/AllClevelandCrimeData.csv")
  clev_d 
  
  clev_d <- clev_d %>% mutate(GameDay = recode(GameDay, "0" = "No", 
                                                        "1" = "Yes") ) 
  
# Count data 

# Are there more charges on game days? 
  ggplot(clev_d) + theme_bw(16) +
    geom_bar(aes(x=GameDay), 
             stat="count")
  
  # Summarize
  GD <- clev_d %>%
          group_by(GameDay) %>%
            summarize(charges=n())
  GD

  # Test 
    # fit the GLM model 
      glm_gd <- glm(charges ~ GameDay, GD, 
                    family=poisson(link = "identity"))
    
    # Evaluate
     summary(glm_gd)  # Pretty familiar    
     anova(glm_gd)    # Hey, what gives?  
     anova(glm_gd, test = "Chisq") # That's more like it 
     car::Anova(glm_gd)   # Different but same 
    

# Non-independence 
    
 ggplot(clev_d) + theme_bw(16) +
   geom_bar(aes(x=GameDay, 
                fill=Venue), 
            stat="count",
            position = position_dodge2())
 
  GD_v <- clev_d %>%
            group_by(Venue, GameDay) %>%
              summarize(charges=n()) %>% 
            ungroup
  GD_v

  glmer_gd <- lme4::glmer(charges ~ GameDay + (1|Venue), GD_v, 
                          family=poisson(link = "identity"))
  summary(glmer_gd)    
  anova(glmer_gd, test = "Chisq") # Trick doesn't work on glmer
  car::Anova(glmer_gd)  # This still works  

  # To use anova(), create a null model and compare
  glmer_0 <- lme4::glmer(charges ~ 1 + (1|Venue), GD_v, 
                          family=poisson(link = "log"))
  anova(glmer_0, glmer_gd) 
