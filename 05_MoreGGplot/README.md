# Homework assignment 

[R markdown template](https://github.com/devanmcg/IntroRangeR/blob/master/05_MoreGGplot/MoreGGplotHomeworkTemplate.Rmd) (`.Rmd`) Custom template for this week. 
Remember, for best results, right-click on *Raw* and *Save as...*

This assignment requires the `mtcars` dataset, a default dataset available in **R**.
It also requires use of several functions that are not available in base **R**. 
Load the required package(s). 

## Data structure 

Do what needs to be done to ensure various variables in `mtcars` are stored as the correct class. 
After you've fixed the classes, show the structure of the modified dataset.

## Boxplot 

Using `ggplot`, create a boxplot that shows how fuel economy varies with number of cylinders. 

Some of these groups have wide distributions. 
Others have outliers. 
Re-plot the boxplot with data overlayed by group. 
What additional information do the data points give us about outliers that the original boxplot doesn't?

## Means and error bars

Ultimately we want to show the relationship between fuel economy, number of cylinders, and transmission type. 
But the stylesheet for the *Journal of Default Datasets* says they aren't keen on boxplots, so we need to devise a graph of means and error bars. 
This requires us to calculate summary statistics before we can make the plot. 
Show the summary statistics you calculate.

Now use `ggplot` to make a nice-looking graph of these data. 
*By "nice-looking" we mean tend to size and spacing of the data points, error bars, and text, and meaningful axis labels.* 
