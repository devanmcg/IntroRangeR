# Homework assignment

## Background 

Gerry Stokka, NDSU Animal Science, put these spikes in the noses of a few calves while they were still nursing on the range. 
The idea is that they poke mama's udder, she resists nursing, and the calves learn to find their own food, essentially self-weaning. 

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/09_TimeSeriesCounts/WeanySpikes.jpg" width="400">

Stokka's lab was curious how this affected their behavior once everyone was officially weaned and brought to the feedlot.
As the calves went on to the feedlot, I put a few of my [DIY GPS collars](https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.4094) on a subset of the calves and logged their movements for seven days. 

## The assignment

### Graph 
Use these data [CalfDistancesByMinute.Rdata](https://github.com/devanmcg/IntroRangeR/blob/master/data/CalfDistancesByMinute.Rdata)
to reproduce the following graph as closely as possible:

<img src="https://github.com/devanmcg/IntroRangeR/blob/master/09_TimeSeriesCounts/HourlyDistances-1.png" width="600">

### Questions

* How did not having a flap affect behavior over time?
* What might account for differences between the two groups, and changes within?

### Hints 

 * Different scales of time can be `format`ted differently. 
 * You'll need to implement `summarize` at least twice on different `group_by` constructions. 
 * You'll likely need to use `as.POSIXct` again after other manipulations. 
 * Check out various `scale_x_` options when you get to your `ggplot`
