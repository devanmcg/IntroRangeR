# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.2.2:  Ordination groups & gradients
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, vegan, RVAideMemoire) 

# Prepare data 
  data("varechem")  
  chem_s <- select(varechem, N:Mo) %>%
              scale

# Fit PCA (unconstrained ordination with Euclidean distance measure)
  chem_pca <- capscale(chem_s ~ 1, method = "euc")

##
## Viewing groups in ordination space 
##

# Plot by known groups

# Load groups 
  # (I just made some group assignments up, not from original data)
    man <- read_csv("https://github.com/devanmcg/IntroRangeR/raw/master/data/VareExample/Management.csv")
    man

# Add groups to ordination
  plot(chem_pca, type="n", las=1)
  text(chem_pca, display = "sites", 
       labels=row.names(chem_s))

# Ordihull (angular polygons around the perimeter of actual data)
  ordihull(chem_pca, man$BurnSeason, display="sites", 
             label=T, lwd=2, col=c("blue","orange", "black"))

# Ordiellipse (ellipses around actual data or estimated group space)  
  plot(chem_pca, type="n", las=1)
  text(chem_pca, display = "sites", 
       labels=row.names(chem_s))
  ordiellipse(chem_pca, man$BurnSeason, display="sites", 
            kind = "ehull", # rounded version of ordihull
            label=T, lwd=2, col=c("blue","orange", "black"))
  
  plot(chem_pca, type="n", las=1)
  text(chem_pca, display = "sites", 
       labels=row.names(chem_s))
  ordiellipse(chem_pca, man$BurnSeason, display="sites", 
              kind = "se", conf=0.95, # confidence region for group centroid
              label=T, lwd=2, col=c("blue","orange", "black"))

# Ordispider
  plot(chem_pca, type="n", las=1)
  text(chem_pca, display = "sites", 
       labels=row.names(chem_s))
  ordispider(chem_pca, man$BurnSeason, display="sites", 
             label=T, lwd=2, col=c("blue","orange", "black"))

# Combine ranges (spiders) and centroid probabilities (ellipses)
  
  plot(chem_pca, type="n", las=1)
  ordiellipse(chem_pca, man$BurnSeason, display="sites", 
              kind = "se", conf=0.95, # confidence region for group centroid
              label=F, col=c("blue","orange", "black"), 
              draw = "polygon", alpha = 50)
  ordispider(chem_pca, man$BurnSeason, display="sites", 
             label=T, lwd=2, col=c("blue","orange", "black"))

##
## Testing groups 
##

  # Global test for the significance of a factor
    envfit(chem_pca ~ man$BurnSeason) # 2 dimensions by default
    
    # Review variance explained per axis
     summary(chem_pca)$cont %>%             # PCA eigenvalues & variance
      as.data.frame %>% .[1:3] %>% round(2) # just formatting stuff
   
    # Use choices to control # axes considered in test
      envfit(chem_pca ~ man$BurnSeason, choices = c(1:3))
    
  # Post-hoc pairwise test for significant factors > 2 levels
    # RVAideMemoire::pairwise.x functions for vegan operations
  
    pairwise.factorfit(chem_pca, man$BurnSeason)
    
##
## Testing gradients 
##
  # Vectors (linear)
    hd_v <- envfit(chem_pca ~ Humdepth + pH, varechem, choices = c(1:3))
    hd_v 
    plot(hd_v, col="darkgreen", p.max = 0.1)
    
  # Smoothed surfaces (non linear)
    hd_s <- ordisurf(chem_pca, varechem$Humdepth, choices = c(1:3), plot=F)
    summary(hd_s)
    plot(chem_pca, display="sites", las=1)
    plot(hd_s, add=T)
    plot(hd_v, col="darkgreen", p.max = 0.1)
    
# All the information on one plot
  {  # R will automatically run all lines within the curly brackets
  plot(chem_pca, type="n", las=1, main = "Soil chemistry by burn season")
  ordiellipse(chem_pca, man$BurnSeason, display="sites", 
              kind = "se", conf=0.95, # confidence region for group centroid
              label=F, col=c("blue","orange", "black"), 
              draw = "polygon", alpha = 50)
  ordispider(chem_pca, man$BurnSeason, display="sites", 
             label=F, lwd=2, col=c("blue","orange", "black"))
  plot(hd_v, col="darkgreen", p.max = 0.1)
  text(chem_pca, display = "species", col="darkred")
  legend("bottomright", 
         title="Burn season", 
         legend=c("Fall", "Spring", "Summer"),
         col=c("blue","orange", "black"), 
         lty=1, bty="n")
    }

# D I S C L A I M E R:
# We use PCA here for illustration 
# (Euclidean distance is conceptually easy)
# PCA is not the only choice for ordination... 
# ...and for ecologists, it is rarely the best choice. 
# The vegan package provides many alternatives to the 
# Euclidean distance measure;  see ?vegdist.
# See ?metaMDS and ?capscale for non-metric and metric
# multidimensional scaling functions for analysis.