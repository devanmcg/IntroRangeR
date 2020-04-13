# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.2.2 - (A) Script for viewing ordinations in 3D. 
#                     Assumes ordinations fit as in Lesson 11.2.2 script,
#                     IntroMultivariateOrdGroupsGradients.R 
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(rgl, vegan3d) 

# View multidimensional space in "3D"
  rgl.bg(color = "white")
  ordirgl(chem_pca, display="sites", 
          type="text", ax.col = "black") 
  orglellipse(chem_pca, groups = man$BurnSeason, 
              display = "sites", 
              kind = "se", conf=0.95, choices = 1:3, alpha = 0.2,
              col=c("blue","orange", "black"))
  orglspider(chem_pca, groups = man$BurnSeason, 
             display = "sites", col=c("blue","orange", "black")) 
  orgltext(chem_pca, display = "species", col = "darkred")


  
  
