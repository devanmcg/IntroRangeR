# Learn.

*Lectures* 

As the course has moved online, I've broken the Introduction to Multivariate material into several smaller chunks:

**11.1: Cluster analysis** 

* [Video available here on YouTube](https://youtu.be/3FFerYQbb-0) 
* Script: [IntroMultivariateClustering.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateClustering.R) 

**11.2: Ordination** 

* 11.2.1: Fitting ordinations 
  - [Video available here on YouTube](https://youtu.be/UsUbpj6C4QA)
  - Script: [IntroMultivariateOrdinations.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateOrdinations.R)
* 11.2.2: Plotting and testing groups and gradients
  - [Video on YouTube](https://youtu.be/HOQEtTofbjg)
  - Script: [IntroMultivariateOrdGroupsGradients.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateOrdGroupsGradients.R), [IntroMultivariateOrds3D.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateOrds3D.R)

**11.3: Pretty plots** 

Using `ggplot2` to present ordination graphics instead of base plotting functions.

 * [Video on YouTube](https://youtu.be/pVskBr82tEE)
 * Script: [IntroMultivariateGGplotting.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateGGplotting.R), bonus material script [IntroMultivariateDissectOrdObjects.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateDissectOrdObjects.R)

# Do. 

*Homework assignments* 

## 11.1: Cluster analysis

Since I began teaching multivariate analyses--at the University of KwaZulu-Natal, South Africa, in 2014--I've had a few students from each class submit to having several 'traits' measured and recorded. 
We use the dataset to demonstrate multivariate techniques in class. 
You will use those data, [StudentsLong.csv](https://github.com/devanmcg/IntroRangeR/raw/master/data/StudentsLong.csv) for this assignment. 

Ensure all script is included at the end of your document as an appendix. 

* Load the data and ensure they are in the proper format for multivariate analysis. 
* Present a scatterplot matrix. 
Refer to it in answering this question: *What do the axes of the variables suggest you ought to do to the data prior to conducting a multivariate analysis?*
* Present a cluster diagram based on a Euclidean distance matrix.
* Conduct a k-means clustering test and present the results graphically. 
Refer to it in answering this question: *What is the optimal number of groups for the student trait dataset?*
* Re-plot the cluster diagram with the optimal number of groups identified.

## 11.2: Ordination 

Fit, plot, and assess a PCA; test and plot by groups.

* Same data as before: [StudentsLong.csv](https://github.com/devanmcg/IntroRangeR/raw/master/data/StudentsLong.csv). 
* Your homework submission must include:
  - Biplot of PCA
  - Summary of axis importance by eigenvalues and proportion explained. 
  - Scree plot and assessment of ordination. 
  - Test grouping variables `continent` and `gender`
  - Present a table of relevant test results. 
  - Conduct any necessary tests for significant factors with > 2 levels. 
  If such a term is not significant, describe the methods you would use for a post-hoc test.
  - Plot the ordination with site scores displayed by factor levels for significant groups. 
  Describe the variables that account for differences between the groups.
* Include script as an appendix at the end of your document. 

## 11.3: Pretty plots

Use third-party packages to create clean, uncluttered ordination graphics. 

* Use the same [StudentsLong.csv](https://github.com/devanmcg/IntroRangeR/raw/master/data/StudentsLong.csv) data. 
* Present a biplot in which the site scores are identified by a grouping variable and species scores are clearly legible (and don't interfere with interpreting the site scores or groups). 
* Include your script as an appendix at the end of your homework submission. 


# D I S C L A I M E R

We use PCA here for illustration because Euclidean distance is conceptually easy to grasp. 
But PCA is not the only choice for ordination, and for ecologists, it is rarely the best choice. 
The vegan package provides many alternatives to the Euclidean distance measure;  see `?vegdist`.
See`?metaMDS` and `?capscale` for non-metric and metric multidimensional scaling functions for analysis.

While I don't get into ordinations with other distance measures here in *Introduction to* ***R***, you can check out my other course, [Analysis of Ecosystems](https://github.com/devanmcg/rangeR/tree/master/Analysis%20of%20Ecosystems). 
