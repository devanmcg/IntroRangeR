# Homework assignment

[Template](https://github.com/devanmcg/IntroRangeR/blob/master/08_BasicStatistics/BasicStatsHomeworkTemplate.Rmd) (`.Rmd`)

## Data structure 

This assignment uses the `starwars` data from the **tidyverse** package. 
Load it now and review the data. 
*Note that as an object from **tidyverse** the data are stored differently than other* R *objects. 
Do not use the `str()` command. 
Simply call the `starwars` object by its name.*

## A basic pairwise comparison

While it is good that the `starwars` data are inclusive of non-binary gender classifications, it complicates a basic pairwise comparison of males and females. 
Let's use the argument that non-binary genders in the dataset have too low of a sample size, and exclude them from this analysis. 

* Subset the data to include just males and females
* Present an appropriate `ggplot` to show how mass varies among males and females. 
Give a descriptive caption. 
* Present an appropriate `ggplot` on the actual (not theoretical) distribution of variable `mass`. 
Is it sufficiently normally distributed to proceed with statistical tests that include normality as an assumption? 
Give a descriptive caption. 
* Conduct and interpret an appropriate statistical test for the pairwise comparison that determines not only whether males and females have different mass, but which is greater. 

## Multiple-factor comparison

*To get this example to work, we need to combine some factors and remove some outliers. 
Some `tidyverse` code to do so has been added in a code chunk in the homework template. 
Do not modify the chunk.
For this section of the assigment, use `StaWa` as your data.*


```
StaWa <- starwars %>% 
              filter(mass < 1000) %>%
              mutate(taxa = case_when(
                       species == "Droid" ~ "Droid", 
                      species == "Human" ~ "Human",
                       TRUE ~ "Biological")) %>%
              filter( ! ((taxa == "Biological" & mass > 120) | (taxa=="Human" & mass < 50)) )
```


Star Wars characters can be divided into taxa as Humans, Droids, and non-human, non-droids we'll call Biologicals. 

* Use `ggplot` to show `mass` by `taxa` in the `StaWa` data. 
Give the graph a descriptive caption. 
* Perform a statistical test and report just the signficance of the `taxa` term in the relationship between `mass` and `taxa` (assume statistical significance at *P*<0.05). 
Interpret these results in terms of the relationships among the three taxa. 
* If necessary, perform a single additional statistical test to inform your answer to the question above.

## Linear regression 

### Simple 

* Plot the relationship between `height` and `mass` from the `StaWa` subset. 
* Is the linear relationship significant? 
If so, how much of the variation is explained by your model? 
Provide statistical evidence to support your answer.
Incorporate this information into your figure caption. 


### Multiple 

Using the same data as above, determine whether adding taxa as a term to the linear model improves explanatory power. 

* Update and re-plot your original graph. 
* Perform a simple comparison of your original linear model versus the multiple model. 
Provide statistical evidence as to whether they are different or not.
