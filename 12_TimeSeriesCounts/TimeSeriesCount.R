pacman::p_load(plyr, dplyr,  ggplot2)

clev.d <- read.csv("./course materials/class session materials/data/AllClevelandCrimeData.csv")

str(clev.d)

# How many types of crimes occur in Cleveland? 
  nlevels(clev.d$ReportedCharge)
  
# Wow, that's a lot, what are they? 
  levels(clev.d$ReportedCharge)

# Lots of similarity, we can group similar ones
  levels(clev.d$GeneralCharge)
  
# See how many of each occur
  ggplot(clev.d)  + 
    geom_bar(aes(x=GeneralCharge), stat="count")
  
  # Potentially useful, but messy plot

  charges.gg <- ggplot(clev.d)  + theme_bw(14) +
                  geom_bar(aes(x=reorder(GeneralCharge, 
                                         GeneralCharge,
                                         function(x)-length(x))), 
                           stat="count")
  charges.gg
  charges.gg <- charges.gg +
    labs(x="Charge type", y="Frequency of incidents") 

  charges.gg
  
  charges.gg <- charges.gg +
    theme(axis.text.x=element_text(angle=45, hjust=1),
          legend.position=c(0.75,0.8), 
          legend.key.width=unit(0.25, "in"))
  charges.gg
  
# Clearly a lot of charges aren't very frequent. 
  # Can probably get away with putting them in "other"

  ggplot(clev.d)  + theme_bw(14) +
    geom_bar(aes(x=reorder(ChargeType, 
                           ChargeType,
                           function(x)-length(x))), 
             stat="count") +
    labs(x="Charge type", 
         y="Frequency of incidents") + 
    theme(axis.text.x=element_text(angle=45, hjust=1),
          legend.position=c(0.75,0.8), 
          legend.key.width=unit(0.25, "in"))
  
# To the research question: Which vary by game day? 
  
  ddply(clev.d, .(ChargeType, GameDay), 
        summarize, 
        charges=length(GameDay))
  
  ggplot(clev.d) + theme_bw(14) +
    geom_bar(aes(x=reorder(ChargeType, 
                           ChargeType,
                           function(x)-length(x)), 
                 fill=factor(GameDay)), 
             stat="count") +
    labs(x="Charge type", 
         y="Frequency of incidents") + 
    theme(axis.text.x=element_text(angle=45, hjust=1),
          legend.position=c(0.75,0.8), 
          legend.key.width=unit(0.25, "in")) +
    scale_fill_brewer(palette="Set1", 
                      name="Game day?", 
                      labels=c("No","Yes"))   
  
# subset by multiple levels
  gd.charges <- subset(clev.d, ChargeType %in% c("VIOLENT", 
                                                 "RESISTING ARREST",
                                                 "PROPERTY"))
  
  head(gd.charges$ChargeType)
  
  # Stop the shouting!
  gd.charges$ChargeType <- tolower(gd.charges$ChargeType)
  head(gd.charges$ChargeType)
  
  ggplot(gd.charges) + theme_bw(14) +
    geom_bar(aes(x=reorder(ChargeType, 
                           ChargeType,
                           function(x)-length(x)), 
                 fill=factor(GameDay)), 
             stat="count", 
             position = "dodge") +
    labs(x="Charge type", 
         y="Frequency of incidents") + 
    theme(axis.text.x=element_text(angle=45, hjust=1),
          legend.position=c(0.75,0.8), 
          legend.key.width=unit(0.25, "in")) +
    scale_fill_brewer(palette="Set1", 
                      name="Game day?", 
                      labels=c("No","Yes")) 
  
# Create a timestamp 
  head(gd.charges$Date) 
  head(gd.charges$Time)
  
  gd.charges$time.stamp <- with(gd.charges, paste(Date, Time) ) 
  head(gd.charges$time.stamp)
  gd.charges$time.stamp <- strptime(gd.charges$time.stamp, 
                                    "%m/%d/%Y %H:%M")
  head(gd.charges$time.stamp)
  class(gd.charges$time.stamp)
  
  # There are several date/time classes. 
  # ggplot requires POSIXct
  gd.charges$time.stamp <- as.POSIXct(gd.charges$time.stamp)
  
  # Now we can make a column just of hours
  # regardless of date
  gd.charges$hour <- format(gd.charges$time.stamp, "%H")
  head(gd.charges$hour)
  gd.charges$hour <- as.numeric(gd.charges$hour)
  
  # Start time at 8am
  gd.charges$hr2 <- ifelse(gd.charges$hour<8,
                           gd.charges$hour+24,
                           gd.charges$hour)
  # Sum charges per hour
  charges.hours <- ddply(gd.charges, 
                         .(GameDay, 
                          ChargeType, hr2),
                     summarize, 
                     charges=length(hr2))
  
  charges.hours$GameDay <- ifelse(charges.hours$GameDay==0,
                                  "No","Yes")
  
  charges.hours <- subset(charges.hours, hr2 != "NA")
  
 (hr.gg <- ggplot(data=charges.hours, 
         aes(x=hr2, y=charges)) + theme_bw(14) + 
    geom_bar(aes(fill=ChargeType), stat="identity",
             colour="black") +
    labs(x="Time of day", y="Number of reports") )
 
 hr.gg +
    scale_x_continuous(breaks=seq(8,28,2),
                       labels = c(seq(8,22,2),0,2,4 )) +
    scale_y_continuous(breaks=c(seq(1,20,3))) +
    facet_grid(GameDay ~ ChargeType, 
               labeller = labeller(.rows = label_both)) + 
    scale_fill_brewer(palette="Set1", 
                      guide = FALSE) 
  