pacman::p_load(ggplot2, vegan, vegan3d)

setwd("C:/Users/Devan.McGranahan/GoogleDrive/Teaching/Classes/Intro to R/course materials/class session materials")

# Load data 

spp.d <- read.csv(file="./data/VareExample/SpeciesData.csv") 
chem.d <- read.csv(file="./data/VareExample/SoilChemistryResults.csv")
man.d <- read.csv(file="./data/VareExample/Management.csv")

# Check out univariate comparisons
pairs(chem.d[2:13], upper.panel = NULL)

# Create Euclidean distance matrix 
(chem.m <- round(vegdist(chem.d[2:13], 
                            method="euclidean"),1))

# Cluster analysis

# Calculate cluster diagram
chem.clust <- hclust(chem.m, method="average") 	
plot(chem.clust, labels=chem.d$name, 
     main="Cluster diagram of soil chemistry", 
     xlab="Sample", ylab="Euclidean distance", las=1)

# Visualize potential groups
rect.hclust(chem.clust, 2, border="red") 
rect.hclust(chem.clust, 4, border="blue")

plot(chem.clust, labels=chem.d$name, 
     main="Cluster diagram of soil chemistry", 
     xlab="Sample", ylab="Euclidean distance", las=1)
rect.hclust(chem.clust, 5, border="darkgreen")


# Principal Components Analysis 
  # Base R
    chem.pca <- prcomp(chem.m, scale.=TRUE)
    summary(chem.pca)
    plot(chem.pca, type="l") # Scree plot
    biplot(chem.pca)

# Package vegan
    chem.pca2 <- rda(chem.d[2:13], scale=TRUE)
    summary(chem.pca2)$cont
    screeplot(chem.pca2, type="lines")
    plot(chem.pca2)
  
  # Compare to cluster diagram
    chem.clust <- hclust(vegdist(chem.d[2:13], 
                              method="euclidean"), 
                      method="average")
  
    x11(12,5.5) ; par(mgp=c(4, 1, 0), mar=c(6, 6, 1, 1), 
                      las=1, cex.lab=1.4, cex.axis=1.4, mfrow=c(1,2)) 
    plot(chem.clust, 
          labels=chem.d$name, 
          xlab="Sample", ylab="Euclidean distance", las=1)
    plot(chem.pca2, display = "sites", las=1)
    ordicluster(chem.pca2, chem.clust)
    dev.off()
    
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
