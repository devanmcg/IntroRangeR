# Lectures

As the course has moved online, I've broken the Introduction to Multivariate material into several smaller chunks:

**11.1: Cluster analysis** 
* [Video available here on YouTube](https://youtu.be/3FFerYQbb-0). 
* Script: [IntroMultivariateClustering.R](https://github.com/devanmcg/IntroRangeR/blob/master/11_IntroMultivariate/IntroMultivariateClustering.R) 

**11.2: Ordination** 
* 11.2.1: Fitting ordinations 
  - [Video available here on YouTube](https://youtu.be/UsUbpj6C4QA).
  - Script *coming soon*
* 11.2.2: Plotting & testing groups 
  - Video *coming soon*
  - Script *coming soon*

**11.3: Pretty plots** 
Using `ggplot2` to present ordination graphics instead of base plotting functions.
 * Video *coming soon*
 * Script *coming soon*

# Homework assignments 

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

*coming soon*

## 11.3: Pretty plots

*coming soon*


# D I S C L A I M E R

We use PCA here for illustration because Euclidean distance is conceptually easy to grasp. 
But PCA is not the only choice for ordination, and for ecologists, it is rarely the best choice. 
The vegan package provides many alternatives to the Euclidean distance measure;  see `?vegdist`.
See`?metaMDS` and `?capscale` for non-metric and metric multidimensional scaling functions for analysis.

While I don't get into ordinations with other distance measures here in *Introduction to* ***R***, you can check out my other course, [Analysis of Ecosystems](https://github.com/devanmcg/rangeR/tree/master/Analysis%20of%20Ecosystems). 
