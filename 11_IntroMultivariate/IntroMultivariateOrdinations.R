# An Introduction to R (www.introranger.org)
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.2.1: Introducing multivariate analysis - Fitting ordinations
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, vegan) 

# Load data 
  data("varechem")  # comes with vegan
  chem_d <- select(varechem, N:Mo) # grab a subset
#
# Clustering refresher
# 
  # Fit cluster diagram (will need it later)
    chem_m <- vegdist(chem_d, method="euclidean")
    chem_clust <- hclust(chem_m, method="average")

##
##  O r d i n a t i o n 
##
 # Ordination with Euclidean distance matrix (method = "euc")
 # aka Principal Components Analysis (PCA)
    as_tibble(chem_d)
  
  # Fit and look
    # Fit with capscale ( ~ 1 leaves ordination unconstrained)
      chem_pca <- capscale(chem_d ~ 1, method = "euc")
    
    # Understanding the biplot
      biplot(chem_pca, col=c("blue", "red")) 
      plot(chem_pca, display = "sites")
      plot(chem_pca, display = "species")
      
      # More control over plot features:
        plot(chem_pca, type="n") # Empty plot
          text(chem_pca, display = "species", 
               col="red", cex=1.5)
          text(chem_pca, display = "sites", 
               col="blue", cex=1.5)

    # Scores 
      scores(chem_pca, display = "sites", choices = c(1:10)) %>%
        head %>% round(1)
      scores(chem_pca, display = "species", choices = c(1:10)) %>%
        round(2)
    
  # Assess
    summary(chem_pca)$cont %>% # Variance explained per axis
      as.data.frame %>%        # Just clean up to view
        round(2)
    # Scree plots: Visualize variance gains with additional axes
    screeplot(chem_pca, type="lines")
  
# Compare ordination to cluster diagram
  # Old-school way to make base plots side-by-side
    x11(12,5.5) ; par(mgp=c(4, 1, 0), mar=c(6, 6, 1, 1), 
                      las=1, cex.lab=1.4, cex.axis=1.4, mfrow=c(1,2)) 
    plot(chem_clust, las=1, 
          labels=chem_d$name, 
          xlab="Sample", 
         ylab="Euclidean distance")
    plot(chem_pca, display = "sites", las=1) 
    ordicluster(chem_pca, chem_clust)
    
# Ordination with scaled data 
    plot(chem_pca)
    head(chem_d)
    summary(chem_pca)$species %>%  # Check out contributions of each nutrient 
                                   # to variation in each axis
      as.data.frame %>%   
      select(MDS1) %>%             # Focus on first (primary) axis
      round(2) %>%
      t                            # transpose (long to wide format)
   
  # Fit a ~scaled~ PCA 
    chem_s <- scale(chem_d)
    chem_pca2 <- capscale(chem_s ~ 1, method = "euc")
    plot(chem_pca2)
    head(chem_s) %>% round(2)
    summary(chem_pca2)$species %>%  
      as.data.frame %>%   
      select(MDS1) %>%             
      round(2) %>%
      t 
  # Compare species scores
    summary(chem_pca)$species %>%  
      as.data.frame %>%   
      select(MDS1) %>%             
      round(2) %>%
      t       
    
    # Re-assess ~scaled~ PCA
      summary(chem_pca2)$cont %>% # Variance explained per axis
        as.data.frame %>%        # Just clean up to view
        round(2)
      screeplot(chem_pca2, type="lines") ; abline(a=1, b=0, lty=2)

# D I S C L A I M E R:
# We use PCA here for illustration 
# (Euclidean distance is conceptually easy)
# PCA is not the only choice for ordination... 
# ...and for ecologists, it is rarely the best choice. 
# The vegan package provides many alternatives to the 
# Euclidean distance measure;  see ?vegdist.
# See ?metaMDS and ?capscale for non-metric and metric
# multidimensional scaling functions for analysis.
