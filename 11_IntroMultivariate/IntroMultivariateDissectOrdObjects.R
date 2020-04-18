# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 11.3 - (A) Script for dissecting ordination objects. 
#                   Assumes ordinations etc fit as in Lesson 11.3 script,
#                   IntroMultivariateGGplotting.R 

# Dissecting the vegan ordination object
  class(chem_pca)
  ?cca
  str(chem_pca)
  
    chem_pca$CA$eig 
    chem_pca$CA$u %>% head   # CA$u = sites
    chem_pca$CA$v %>% head   # CA$v = species
  
    # Scores function applies internal scaling to u and v
    # This is part of the math within the metric ordination
      scores(chem_pca, display = "sites") %>% head 
      scores(chem_pca, display = "species") 
      
      scores(chem_pca, display = "species") %>%
        as.data.frame %>%
          as_tibble(rownames="nutrient")
      
# Dissecting the vegan groups/gradient object
  class(pca_hd)
  ?envfit 
  str(pca_hd) 
  str(pca_hd$vectors)
    
    pca_hd$vectors$arrows
    scores(pca_hd, "vectors")
    
    scores(pca_hd, "vectors") %>%
      as.data.frame %>% 
        round(3) %>%
          as_tibble(rownames="gradient")

# Dissecting the gg_ordiplot object
  class(pca_gg) 
  str(pca_gg)

  pca_gg$df_ord %>% head
  pca_gg$df_spiders %>% head 
    
    pca_gg$df_spiders %>% 
      rename(MDS1 = x, MDS2 = y) %>%
        as_tibble
  

