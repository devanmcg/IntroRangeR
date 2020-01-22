# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 6: More ggplot - continuing the introduction to ggplot 
# 
  pacman::p_load(ggplot2)
    
  str(ChickWeight)
  
  # Boxplot for factors 
  
  EndWeight <- subset(ChickWeight, Time==max(ChickWeight$Time))
   
  ggplot(EndWeight) + 
    geom_boxplot(aes(x=Diet, y=weight))
  
  
  # Tweaking appearance
  
  pacman::p_load(plyr) 
  
  ChickWeight$ActualDiet <- revalue(as.factor(ChickWeight$Diet), 
                                       c("1"="corn", 
                                         "2"="oats", 
                                         "3"="burgers", 
                                         "4"="tacos"))
  EndWeight <- subset(ChickWeight, Time==max(ChickWeight$Time))
  
  ggplot(EndWeight) + 
    geom_boxplot(aes(x=ActualDiet, y=weight))
  
  ggplot(EndWeight, aes(x=reorder(ActualDiet, weight, median), y=weight)) + 
    geom_boxplot()
  
  EW.gg <-  ggplot(EndWeight, aes(x=reorder(ActualDiet, -weight, median), y=weight)) 
  EW.gg + geom_boxplot()
  
  EW.gg <- EW.gg + labs(x="Chick diet", y="End weight (g)") 
  EW.gg + geom_boxplot()

# jitter adds points to show distribution  
  EW.gg + geom_boxplot() +
          geom_jitter()
  
  EW.gg + geom_boxplot() +
    geom_jitter(width=0.15)
  
  EW.gg + geom_boxplot() +
    geom_jitter(width=0.15, pch=21, stroke=1.5,
                color="black", fill="red")
  
# Violin plot gives shape to the distribution  
  EW.gg + geom_violin() 
  
  EW.gg + geom_violin(draw_quantiles= c(0.25, 0.5, 0.75)) # quartiles
  EW.gg + geom_violin(draw_quantiles= c(0.5))             # median
 
# Plotting error bars
  # Summarize mean and appropriate variance estimate
  EW.summ <- ddply(EndWeight, .(ActualDiet), 
                   summarise, 
                   mean=round(mean(weight), 1), 
                   sem=round(sd(weight)/sqrt(length(weight)), 1) )
  
  # Create plot
  EW.gg <- ggplot(EW.summ, aes(x=reorder(ActualDiet, -mean, max), y=mean))
  EW.gg + geom_point()  
  
  EW.gg + geom_point() +
          geom_errorbar(aes(ymin=mean-sem, 
                            ymax=mean+sem))
  
  EW.gg + geom_point() +
    geom_errorbar(aes(ymin=mean-sem, 
                      ymax=mean+sem), 
                  width=0.25)
  
  EW.gg + geom_errorbar(aes(ymin=mean-sem, 
                      ymax=mean+sem), 
                  width=0.25) +
          geom_point(shape=21, color="black", fill="white",
                     size=3, stroke=1.5) 

# Adding another variable 
  ChickWeight$Grain <- revalue(as.factor(ChickWeight$Diet), 
                               c("1"="corn", 
                                 "2"="corn", 
                                 "3"="oats", 
                                 "4"="oats"))
  ChickWeight$Source <- revalue(as.factor(ChickWeight$Diet), 
                                c("1"="conventional", 
                                  "2"="organic", 
                                  "3"="conventional", 
                                  "4"="organic"))
  
  EndWeight <- subset(ChickWeight, Time==max(ChickWeight$Time))
  
  EW.summ <- ddply(EndWeight, .(Grain, Source), 
                   summarise, 
                   mean=round(mean(weight), 1), 
                   sem=round(sd(weight)/sqrt(length(weight)), 1) )
  
  # Easy to add to a boxplot...
  ggplot(EndWeight, aes(x=reorder(Grain, -weight, median), y=weight)) + 
    geom_boxplot(aes(fill=Source))
  
  # ... but less easy for mean w/ errorbars?
  ggplot(EW.summ, aes(x=reorder(Grain, -mean, max),
                      y=mean,
                      color=Source)) +   
    geom_errorbar(aes(ymin=mean-sem, 
                      ymax=mean+sem)) +
    geom_point()  
  
  # use position_dodge
    ggplot(EW.summ, aes(x=reorder(Grain, -mean, max),
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

# Data are grouped by chick, though, we might want 
# to follow individuals through time. 
  
  # use group aesthetic
  ggplot(ChickWeight, aes(x=Time, y=weight)) + 
    geom_point() +
    geom_line(aes(group=Chick))

# Kind of messy, and doesn't address the question: 
# How do chicks respond by diet group?
  
  # summarize
  TS.summ <- ddply(ChickWeight, .(Grain, Time), 
                   summarise, 
                   mean=round(mean(weight), 1), 
                   sem=round(sd(weight)/sqrt(length(weight)), 1) )
  
  # plot
 TS.gg <- ggplot(TS.summ, aes(x=Time,
                              y=mean,
                              color=Grain)) +   
            geom_errorbar(aes(ymin=mean-sem, 
                              ymax=mean+sem), 
                          width=1, 
                          position=position_dodge(width = 0.25)) +
            geom_point(position=position_dodge(width = 0.25), 
                       shape=21, fill="white", stroke=1.5) 
TS.gg  

TS.gg + geom_line(aes(group=Grain),
                  position=position_dodge(width = 0.25))  

ggplot() +   theme_bw(14) + 
  geom_line(data=ChickWeight, aes(x=Time, 
                                   y=weight,
                                   color=Grain, 
                                   group=Chick), 
             alpha=0.25) +
  geom_point(data=ChickWeight, aes(x=Time, 
                                   y=weight,
                                   color=Grain), 
             alpha=0.25) +
  geom_errorbar(data=TS.summ, aes(x=Time,
                                  color=Grain, 
                                  ymin=mean-sem, 
                                  ymax=mean+sem), 
                width=1, lwd=1.5,
                position=position_dodge(width = 0.25)) +
  geom_line(data=TS.summ, aes(x=Time,
                              y=mean,
                              color=Grain, 
                              group=Grain), 
            position=position_dodge(width = 0.25), lwd=1.5) +
  geom_point(data=TS.summ, aes(x=Time,
                               y=mean,
                               color=Grain),
             position=position_dodge(width = 0.25), 
             shape=21, fill="white", stroke=1.5, size=4) 
