# An introduction to data wrangling with *tidyverse*

-   [Materials](#materials)
-   [Homework assignment](#homework-assignment)
 
## Materials 

**Script**

[`DataWrangling.R`](https://raw.githubusercontent.com/devanmcg/IntroRangeR/master/03.1_IntroTidyverse/DataWrangling.R)

[Walk through the script](https://www.introranger.org/post/lesson-3-intro-to-tidyverse/#walking-through-the-script) on the [IntroRangeR](http://www.introranger.org) course website. 

**Video lecture on YouTube**

[![Lesson 3 Data wrangling](http://img.youtube.com/vi/TPifWRJ-5dw/0.jpg)](https://youtu.be/TPifWRJ-5dw "Lesson 3 Data wrangling")



## Homework assignment 

For this assignment, use script from class to produce summary statistics and a boxplot with means using a different dataset, `mpg`, which comes with tidyverse. Upload your table and graph in a .pdf or .docx file created via R markdown. 

* Create a new R markdown file. 
Three ways:
  - You can open a new template but remove all of the default text and R script.
  - Open a new file, change it to R markdown in the bottom right corner, and copy-paste code chunks from somewhere else.
  - Use [homework_template.Rmd](https://github.com/devanmcg/IntroRangeR/blob/master/homework_template.Rmd), which I made for this purpose.
* Set up the following code chunks with default settings (`echo=TRUE`), and answer the various questions in the text below each chunk:
  - Identify the structure of the dataset. 
  What are the types of each variable?
  Are all of the variables stored as the correct type?
  - Based on your response to the second question above, make the appropriate corrections.
  - Provide *tidy* script and output for mean highway fuel economy by drivetrain type (`drv`). 
  Change the variable name and levels to something useful, not the default.
  - Present a boxplot of highway fuel economy by drivetrain type that includes means for each group. 
  You can use base graphics functions. 
  Pay attention to the issues around factors vs. characters when making boxplots with base functions. 

