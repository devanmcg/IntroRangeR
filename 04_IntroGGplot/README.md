# Introduction to *ggplot*

The script and exercises for this week introduce new users to the **ggplot2** package. 
Here are some helpful resources for learning how to use *ggplot* and just thinking about graphing, in general. 

## **ggplot2** how-to pages 
* [The ggplot2 main reference page](https://ggplot2.tidyverse.org/reference/)
* [Rstudio's official Data Visualisation cheatsheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf)
* [Beautiful plotting in R: A ggplot2 cheatsheet](http://http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3)
* [Using and modifying ggplot themes](http://www.sthda.com/english/wiki/ggplot2-themes-and-background-colors-the-3-elements)

## General graphing resources 
* [A chapter by Edward Tufte about data-ink maximization](https://github.com/devanmcg/rangeR/blob/master/Analysis%20of%20Ecosystems/readings/Tufte%20chap%206%20Data-Ink%20Maximization.pdf)
* [Choosing color palettes](https://www.r-bloggers.com/choosing-colour-palettes-part-ii-educated-choices/)
* [Ugly Charts](https://flowingdata.com/category/visualization/ugly-visualization/) 
* [5 tips on designing colorblind-friendly visualizations](https://www.tableau.com/about/blog/2016/4/examining-data-viz-rules-dont-use-red-green-together-53463) 

# Homework assignment 

*There is an [R markdown template](https://github.com/devanmcg/IntroRangeR/blob/master/04_IntroGGplot/ggplotHomeworkTemplate.Rmd) (`.Rmd`) specifically for this assignment that you can download locally and open in R studio.
Just add your name in the header and add your script to the code chunks (no need to create additional code chunks).

Apply script from class  to a novel dataset (`iris`, which comes with R) to create scatterplots with `ggplot` from **ggplot2**. 
Load the required package.

## Data structure 

Show the structure of the `iris` data. 
Which variables are continuous? Which are categorical? 

## Scatterplot

### Simple defaults

Using the `iris` data, create a simple scatterplot with `Sepal.Length` against `Sepal.Width`. 
Default plot options are fine, but if you're feeling saucy, you can change the theme, or point shape, or anything else. 

### Add a categorical variable

Now add information to the scatterplot with `Sepal.Length` against `Sepal.Width`. 
Plot the points by the categorical variable, `Species`. 

### Plotting linear relationships

Add `smooth`ed trendlines to show the linear relationship between sepal width and sepal length for each species. 
Ensure lines and points have the same color within each species. 

### Facet by categorical variable

Display the relationship between sepal width and sepal length within the categorical variable `Species` in three side-by-side panes, instead of within a single graph pane. 
Tweak `aes()` to ensure that the categorical variable is not accounted for twice in the final graph. 

