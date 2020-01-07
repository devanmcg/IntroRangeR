pacman::p_load(plyr, tidyverse)

str(iris)

# Introduction to piping

iris.st <- data.frame(iris[5], stack(iris[1:4]) )
colnames(iris.st) <- c("species", "value", "trait")
iris.sep1 <- separate(iris.st, trait, 
                     into=c("organ", "dimension"), 
                     remove=TRUE)
head(iris.sep1)

# Why call thrice what one can call once??

iris.sep2 <- data.frame(iris[5], stack(iris[1:4]) ) %>%
                plyr::rename(c("values" = "value",
                               "ind" = "trait")) %>%
                        separate(trait, 
                            into=c("organ", "dimension"), 
                            remove=TRUE)

head(iris.sep2)

iris.sep2 %>% select(Species, organ, dimension, value) -> iris.sep3

head(iris.sep3)

# Alternatives to getting summary statistics 

ddply(iris.st, .(species, trait), 
      summarise, 
      mean=mean(value))

iris %>%
  group_by(Species) %>%
  summarise(
    Sepal.Length = mean(Sepal.Length),
    Sepal.Width = mean(Sepal.Width)
  )

     