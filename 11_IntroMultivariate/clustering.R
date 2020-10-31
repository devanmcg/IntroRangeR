# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.1: Introducing multivariate analysis - Clustering
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, vegan) 

# Load data 
  data("varechem")  # comes with vegan
  chem_d <- select(varechem, N:Mo) # grab a subset

# Check out univariate comparisons
  varechem %>%
    select(N:Mo) %>%
      pairs(upper.panel = NULL)

# Create Euclidean distance matrix (vegan::vegdist)
  chem_m <- round(vegdist(chem_d, method="euclidean"), 1)
  length(chem_m)
  as.matrix(chem_m)[c(1:5), c(1:5)]

##
##  C l u s t e r i n g 
## 
  # Calculate cluster diagram
    chem_clust <- hclust(chem_m, method="ward.D2") 	
  
  # Plot cluster diagram 
    plot(chem_clust, las = 1, 
         main="Cluster diagram of soil chemistry", 
         xlab="Sample", ylab="Euclidean distance")
    
# Visualize potential groups
  plot(chem_clust, las = 1, 
       main="Cluster diagram of soil chemistry", 
       xlab="Sample", ylab="Euclidean distance")
      rect.hclust(chem_clust, 2, border="red") 
      rect.hclust(chem_clust, 4, border="blue")
      rect.hclust(chem_clust, 5, border="darkgreen")
      
# How many groups is the *right number* of groups? 
  # A general solution: k-means clustering 
  # Many options for k-means clustering, in many packages. 
  # Here we use vegan::cascadeKM, a wrapper for base::kmeans
             
  fit <- cascadeKM(chem_d, 1, 10, iter = 5000)
   # Default plot
      plot(fit, sortg = TRUE, grpmts.plot = TRUE)
    # More focused ggplot
      fit$results %>% 
        as.data.frame() %>%
        rownames_to_column("metric") %>%
          pivot_longer(names_to = "groups", 
                       values_to = "value", 
                       - metric) %>%
              mutate(groups = str_extract(groups, "\\d+"), 
                     groups = as.numeric(groups)) %>%
        filter(metric != "SSE") %>%
       ggplot(aes(x=groups, y = value)) + theme_bw(16) +
        geom_line(lwd=1.5, col="blue") +
        geom_point(pch=21, col="lightgrey", 
                   bg="blue", stroke = 1.5, size=5) +
        scale_x_continuous(breaks = c(2:10), labels = c(2:10)) +
        theme(panel.grid.minor.x = element_blank()) 
    
# View the optimal number of groups  
  # Which sites are in which groups? 
    grps <- as_tibble(fit$partition) 
    grps 

  # Label plot by group assignment 
    plot(chem_clust, las = 1,
         label = grps$`5 groups`, 
      main="Cluster diagram of soil chemistry", 
      xlab="Sample", ylab="Euclidean distance")
    rect.hclust(chem_clust, 5, border="red") 
    
  head(chem_d)

# Re-do with *scaled* data 
  
  chem_s <- scale(chem_d)
  head(chem_s) 
  
  chem_m2 <- vegdist(chem_s, method="euclidean") 
  chem_clust2 <- hclust(chem_m2, method="ward.D2")
  
  # Plot cluster diagram 
  plot(chem_clust2, las = 1, 
       main="Cluster diagram of (scaled) soil chemistry", 
       xlab="Sample", ylab="Euclidean distance")
  
  fit_s <- cascadeKM(chem_s, 1, 10, iter = 5000)
  
  fit_s$results %>% 
        as.data.frame() %>%
        rownames_to_column("metric") %>%
          pivot_longer(names_to = "groups", 
                       values_to = "value", 
                       - metric) %>%
    mutate(groups = str_extract(groups, "\\d+"), 
           groups = as.numeric(groups)) %>%
    filter(metric != "SSE") %>%
   ggplot(aes(x=groups, y = value)) + theme_bw(16) +
    geom_line(lwd=1.5, col="blue") +
    geom_point(pch=21, col="lightgrey", 
               bg="blue", stroke = 1.5, size=5) +
    scale_x_continuous(breaks = c(2:10), labels = c(2:10)) +
    theme(panel.grid.minor.x = element_blank())
  
  # Label plot by group assignment 
  plot(chem_clust2, las = 1,
       label = as_tibble(fit_s$partition)$`2 groups`, 
       main="Cluster diagram of (scaled) soil chemistry", 
       xlab="Sample", ylab="Euclidean distance")
  rect.hclust(chem_clust2, 2, border="red")
  
