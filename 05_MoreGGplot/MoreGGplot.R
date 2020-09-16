# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# Course website: https://www.introranger.org 
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 5: More ggplot - continuing the introduction to ggplot
#
# Load packages
  if (!require("pacman")) install.packages("pacman")
    pacman::p_load(tidyverse, knitr)
    
# Convert to tibble and view data
    ChickWeight <- as_tibble(ChickWeight)  
    ChickWeight
    
  # Boxplot for factors 
    # Trim the dataset down to last round of  (Time)
  
    EndWeight <- filter(ChickWeight, Time==max(Time)) # dplyr::filter >> base::subset
     
  # Tweaking appearance
    EndWeight <- mutate(EndWeight, 
                          ActualDiet = 
                            recode(Diet, 
                                   "1"="corn", 
                                   "2"="oats", 
                                   "3"="burgers", 
                                   "4"="tacos") )
  
    ggplot(EndWeight) + 
      geom_boxplot(aes(x=ActualDiet, y=weight))
    
    # Default order for characters = alphabetical. 
    # X axis order can be reordered by applying a function to Y values
    # In this case, function is median:
    
      ggplot(EndWeight, aes(x=reorder(ActualDiet, weight, median), y=weight)) + 
        geom_boxplot()
      
    # Alternative using mutate() in a pipe: 
      
      EndWeight %>%
        mutate(ActualDiet = reorder(ActualDiet, weight, median)) %>%
      ggplot(aes(x=ActualDiet, y=weight)) + 
        geom_boxplot()
      
    # Easily reverse direction by reordering Y variable on opposite sign:
      
      EW_gg <-  
        EndWeight %>%
        mutate(ActualDiet = reorder(ActualDiet, -weight, median)) %>%
        ggplot(aes(x=ActualDiet, y=weight))
      EW_gg + geom_boxplot()
      
      EW_gg <- EW_gg + labs(x="Chick diet", 
                            y="End weight (g)") 
      EW_gg + geom_boxplot() # This comment is only in your homework if you copy-pasted w/out thinking

# Adding individual observations to boxplots 
  EW_gg + geom_boxplot() +
    geom_point()
  # Shows fewer points than there actually are: 
    EndWeight %>%
      group_by(ActualDiet) %>%
      summarize(Count = n())
  # jitter adds points with random noise 
    # to show distributionand reduce overlap
    EW_gg + geom_boxplot() +
            geom_jitter()
  
   # Reduce the amount of noise:
    EW_gg + geom_boxplot() +
      geom_jitter(width=0.15)
   
   # Dress it up a bit:
    EW_gg + geom_boxplot() +
      geom_jitter(width=0.15, 
                  pch=21, 
                  stroke=1.5,
                  color="black", 
                  fill="red")
    
  # Violin plot gives shape to the distribution  
    EW_gg + geom_violin() 
    
    EW_gg + geom_violin(draw_quantiles= c(0.25, 0.5, 0.75)) # quartiles
    EW_gg + geom_violin(draw_quantiles= c(0.5))             # median
 
    EW_gg + geom_violin(draw_quantiles= 
                          c(0.25, 0.5, 0.75)) +
      geom_jitter(width=0.15, 
                  pch=21, 
                  stroke=1.5,
                  color="black", 
                  fill="red")
# Plotting error bars
  # Summarize mean and appropriate variance estimate
  EWsumm <- EndWeight %>%
              group_by(ActualDiet) %>%
                summarise(
                   mean=mean(weight), 
                   sem=sd(weight)/sqrt(length(weight)) )
 
   # Explore some differences between tibbles and data.frames  
      EWsumm  # tibble = neat and tidy. 
              # dbl columns appear rounded, 
              # but data aren't actually stored that way: 
      as.data.frame(EWsumm) # Note significant digits
  
      # round() function shortens digits in a data.frame
        round(1234.5678, digits = 2)
        # Apply round() to 1 or more columns with mutate_ verb forms:
          EWsumm %>%
            mutate_at( vars(mean, sem), round, digits = 2 )  %>%
              as.data.frame() 
  
      # Too many significant digits will end up a table
        knitr::kable(EWsumm) 
          
      # Rounding cuts down digits in the table
        EWsumm %>%
          mutate_at( vars(mean, sem), round, digits = 2 )  %>%
            knitr::kable()
      
  # Create plot
    EW_gg <- 
      EWsumm %>%
      mutate(ActualDiet = reorder(ActualDiet, -mean, max)) %>%
      ggplot(aes(x=ActualDiet, y=mean))
    EW_gg + geom_point()  
  
  EW_gg + geom_point() +
          geom_errorbar(aes(ymin=mean-sem, 
                            ymax=mean+sem))
  
  EW_gg + geom_point() +
    geom_errorbar(aes(ymin=mean-sem, 
                      ymax=mean+sem), 
                  width=0.25)
  
  EW_gg + geom_errorbar(aes(ymin=mean-sem, 
                      ymax=mean+sem), 
                  width=0.25) +
          geom_point(shape=21, 
                     color="black", 
                     fill="white",
                     size=3, 
                     stroke=1.5) 

# Adding another variable 
  # Mutate verb adds multiple columns in one call:
    ChickWeight <- mutate(ChickWeight, 
                          Grain = recode(Diet, 
                                    "1"="corn", 
                                    "2"="corn", 
                                    "3"="oats", 
                                    "4"="oats" ), 
                          Source = recode(Diet, 
                                    "1"="conventional", 
                                    "2"="organic", 
                                    "3"="conventional", 
                                    "4"="organic")) 
    EndWeight <- filter(ChickWeight, Time==max(Time))
  
  # Recalculate summary stats with multiple levels 
    EWsumm <- 
      EndWeight %>%
      group_by(Grain, Source) %>% 
      summarise( 
        mean=mean(weight), 
        sem=sd(weight)/sqrt(length(weight)) ) %>%
      ungroup() 
  
  # Easy to add second variable to a boxplot...
    EndWeight %>%
      mutate(Grain = reorder(Grain, -weight, median)) %>%
      ggplot(aes(x=Grain, y=weight)) + 
      geom_boxplot(aes(fill=Source))
  
  # ... but not so easy for mean w/ errorbars?
    EWsumm %>%
      mutate(Grain = reorder(Grain, -mean, max)) %>%
      ggplot(aes(x=Grain,
                 y=mean,
                 color=Source)) +   
      geom_errorbar(aes(ymin=mean-sem, 
                        ymax=mean+sem)) +
      geom_point() 
  
  # solution: use position_dodge to prevent overlap 
    EWsumm %>%
      mutate(Grain = reorder(Grain, -mean, max)) %>%
      ggplot(aes(x=Grain,
                 y=mean,
                 color=Source)) +   
      geom_errorbar(aes(ymin=mean-sem, 
                        ymax=mean+sem), 
                    width=0.15, 
                    position=position_dodge(width = 0.25)) +
      geom_point(position=position_dodge(width = 0.25))
    
# ChickWeight data are actually a time series: 
  ggplot(ChickWeight, aes(x=Time, y=weight)) + 
    geom_point() 

# Data are not totally independent, though; grouped by chick.
# (Thus these are longitudinal data comprised of repeated measures)
# We might want to follow individuals through time. 
  
  # use group aesthetic
    ggplot(ChickWeight, aes(x=Time, y=weight)) + 
      geom_point() +
      geom_line(aes(group=Chick))

  # Kind of messy, and doesn't address the question: 
  # How do chicks respond by diet group?
    
    # summarize
      TSsumm <- ChickWeight %>%
                  group_by(Grain, Time) %>% 
                    summarise(
                       mean=round(mean(weight), 1), 
                       sem=round(sd(weight)/sqrt(length(weight)), 1) )
    
    # plot group summaries over time
      TS_gg <- ggplot(TSsumm, aes(x=Time,
                                  y=mean,
                                  color=Grain)) +   
        geom_errorbar(aes(ymin=mean-sem, 
                          ymax=mean+sem), 
                      width=1, 
                      position=position_dodge(width = 0.25)) +
        geom_point(position=position_dodge(width = 0.25), 
                   shape=21, fill="white", stroke=1.5) 
      TS_gg
      # Connect the summarized observations by group along the time series
        TS_gg + geom_line(aes(group=Grain),
                        position=position_dodge(width = 0.25))  

# Show individual performances with emphasis on group means. 
  # Note empty call to ggplot() 
  # and data= arguments mapping correct data.frame to each geom
    grain_gg <- 
      ggplot() +   theme_bw(14) + 
      geom_line(data=ChickWeight, 
                aes(x=Time, 
                    y=weight,
                    color=Grain, 
                    group=Chick), 
                alpha=0.25) +
      geom_point(data=ChickWeight, 
                 aes(x=Time, 
                     y=weight,
                     color=Grain), 
                 alpha=0.25) +
      geom_errorbar(data=TSsumm, 
                    aes(x=Time,
                        color=Grain, 
                        ymin=mean-sem, 
                        ymax=mean+sem), 
                    width=1, 
                    lwd=1.5,
                    position=position_dodge(width = 0.25)) +
      geom_line(data=TSsumm, 
                aes(x=Time,
                    y=mean,
                    color=Grain, 
                    group=Grain), 
                position=position_dodge(width = 0.25),
                lwd=1.5) +
      geom_point(data=TSsumm, 
                 aes(x=Time,
                     y=mean,
                     color=Grain),
                 position=position_dodge(width = 0.25), 
                 shape=21, 
                 fill="white", 
                 stroke=1.5, 
                 size=4) 
    grain_gg
    
    # Add another level of information:
    grain_gg +  facet_wrap(~Source)

##
##  An example of a more complex workflow ending with facet_grid
##
#
# Start all over: remove ChickWeight and restore default 
#
  rm(ChickWeight)
  (ChickWeight <- as_tibble(ChickWeight))
#
# Pour data through a pipe and into ggplot. 
# Note ~~nested~~ pipe for data modification
  ChickWeight %>%
    mutate(Grain = recode(Diet, 
                          "1"="corn", 
                          "2"="corn", 
                          "3"="oats", 
                          "4"="oats" ), 
           Source = recode(Diet, 
                           "1"="conventional", 
                           "2"="organic", 
                           "3"="conventional", 
                           "4"="organic")) %>%
    ggplot() + theme_bw(14) + 
    geom_line(aes(x=Time, 
                  y=weight,
                  group=Chick), 
              alpha=0.25) +
    geom_point(aes(x=Time, 
                   y=weight), 
               alpha=0.25) +
    geom_errorbar(data=. %>%
                    group_by(Grain, Time) %>% 
                    summarise(
                      mean=mean(weight), 
                      sem= sd(weight)/sqrt(length(weight)) ), 
                  aes(x=Time,
                      ymin=mean-sem, 
                      ymax=mean+sem), 
                  width=1, 
                  lwd=1.5,
                  position=position_dodge(width = 0.25)) +
    geom_line(data=. %>%
                group_by(Grain, Time) %>% 
                summarise(
                  mean=mean(weight), 
                  sem= sd(weight)/sqrt(length(weight)) ),
              aes( x=Time,
                   y=mean,
                   group=Grain), 
              position=position_dodge(width = 0.25), 
              lwd=1.5) +
    geom_point(data=. %>%
                 group_by(Grain, Time) %>% 
                 summarise(
                   mean= mean(weight), 
                   sem=  sd(weight)/sqrt(length(weight)) ), 
               aes(x=Time,
                   y=mean),
               position=position_dodge(width = 0.25), 
               shape=21, 
               fill="white", 
               stroke=1.5, 
               size=4) + 
    facet_grid(Grain ~ Source)
  