# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.2: Introducing multivariate analysis - Ordination
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, vegan, vegan3d) 

# Load data 
  data("varechem")  # comes with vegan
  chem_d <- select(varechem, N:Mo) # grab a subset

# Clustering refresher
  chem_ <- vegdist(chem_d, method="euclidean")
  chem_clust <- hclust(chem_m2, method="average")

##
##  O r d i n a t i o n 
##
# Ordination with Euclidean distance matrix (method = "euc")
# aka Principal Components Analysis (PCA)
  
  chem_pca <- capscale(chem_d ~ 1, method = "euc") 
  summary(chem_pca)$cont  
  screeplot(chem_pca, type="lines")
  plot(chem_pca)
  
  # Old-school way to make plots side-by-side
  x11(12,5.5) ; par(mgp=c(4, 1, 0), mar=c(6, 6, 1, 1), 
                    las=1, cex.lab=1.4, cex.axis=1.4, mfrow=c(1,2)) 
  plot(chem.clust, 
        labels=chem.d$name, 
        xlab="Sample", ylab="Euclidean distance", las=1)
  plot(chem_pca, display = "sites", las=1) 
  ordicluster(chem_pca, chem_clust)
  dev.off()
  
  plot(chem_pca, display = "sites", las=1, 
       main = "K means groups, unscaled data") 
  ordispider(chem_pca, groups = as.data.frame(fit$partition)$`2 groups`) 
  plot(chem_pca, display = "sites", las=1, 
       main = "K means groups, scaled data") 
  ordispider(chem_pca, groups = as.data.frame(fit_s$partition)$`2 groups`) 
    
  # View multidimensional space
    ordirgl(chem.pca2, display="sites", type="text") 
    orgltext(chem.pca2, row.names(chem.d), display="sites") # focus on 20, 22, 23
  
  # Plotting by known groups
    plot(chem.pca2, type="n", las=1)
        text(chem.pca2, display = "sites", labels=row.names(chem.d))
        ordispider(chem.pca2, man.d$BurnSeason, display="sites", 
                   label=T, lwd=2, col=c("blue","orange", "black"))
        
  # Testing groups
    envfit(chem.pca2 ~ man.d$BurnSeason)
    envfit(chem.pca2 ~ man.d$BurnSeason, choices=c(1:3))

# D I S C L A I M E R:
# We use PCA here for illustration 
# (Euclidean distance is conceptually easy)
# PCA is not the only choice for ordination... 
# ...and for ecologists, it is rarely the best choice. 
# The vegan package provides many alternatives to the 
# Euclidean distance measure;  see ?vegdist.
# See ?metaMDS and ?capscale for non-metric and metric
# multidimensional scaling functions for analysis.
