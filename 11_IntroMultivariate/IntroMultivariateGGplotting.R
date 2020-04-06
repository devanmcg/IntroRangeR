# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.3: Introducing multivariate analysis - Pretty plots
#
# Packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, vegan, ggdendro, dendextend) # For dendrogram plotting

# GGplotting cluster analysis

# ggplot2-style with ggdendro::ggdendrogram
  ggdendrogram(chem_clust) + theme_minimal(16) +
    labs(x = "Site", y = "Euclidean distance") +
    coord_flip(y=c(10,600)) + 
    theme(panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank())

# requires dendextend
  chem_clust %>% 
    as.dendrogram %>%
    set("branches_k_color", k=5) %>% 
    set("branches_lwd", 1.2) %>%
    as.ggdend( ) %>%
    ggplot(horiz=TRUE, 
           offset_labels = -25 ) + 
    theme_minimal(16) +
    labs(x = "Site", y = "Euclidean distance") +
    scale_y_continuous(position = "left") + 
    theme(axis.text.y = element_blank(), 
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank())