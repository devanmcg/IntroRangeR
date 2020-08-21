# An Introduction to R (www.introranger.org)
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 9: Working with count data & time series
#
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse) 
  
  clev.d <- read.csv("./data/AllClevelandCrimeData.csv")
  
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
  
  # Axis formatting tricks in theme() 
  charges.gg <- charges.gg +
                  theme(axis.text.x=element_text(angle=45, hjust=1, color = "black"), 
                        panel.grid.major.x = element_blank())
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
    theme(axis.text.x=element_text(angle=45, hjust=1, color = "black"), 
          panel.grid.major.x = element_blank() )
  
# To the research question: Which vary by game day? 
  
  clev.d %>%
    group_by(ChargeType, GameDay) %>% 
        summarize(charges=length(GameDay))
  
  ggplot(clev.d) + theme_bw(14) +
    geom_bar(aes(x=reorder(ChargeType, 
                           ChargeType,
                           function(x)-length(x)), 
                 fill=factor(GameDay)), 
             stat="count") +
    labs(x="Charge type", 
         y="Frequency of incidents") + 
    theme(axis.text.x=element_text(angle=45, hjust=1, color = "black"), 
          panel.grid.major.x = element_blank(),
          legend.position=c(0.75,0.8), 
          legend.key.width=unit(0.25, "in")) +
    scale_fill_brewer(palette="Set1", 
                      name="Game day?", 
                      labels=c("No","Yes"))   
  
# subset by multiple levels
  gd.charges <- filter(clev.d, ChargeType %in% c("VIOLENT", 
                                                 "RESISTING ARREST",
                                                 "PROPERTY"))
  
  head(gd.charges$ChargeType)
  
  # Stop the shouting!
  gd.charges <- gd.charges %>% mutate(ChargeType = tolower(ChargeType) )
  head(gd.charges$ChargeType)
  
  ggplot(gd.charges) + theme_bw(16) +
    geom_bar(aes(x=reorder(ChargeType, 
                           ChargeType,
                           function(x)-length(x)), 
                 fill=factor(GameDay)), 
             stat="count", 
             position = "dodge") +
    labs(x="Charge type", 
         y="Frequency of incidents") + 
    theme(axis.text.x=element_text(angle=45, hjust=1, color = "black"), 
          panel.grid.major.x = element_blank(),
          legend.position=c(0.75,0.8), 
          legend.key.width=unit(0.25, "in")) +
    scale_fill_brewer(palette="Set1", 
                      name="Game day?", 
                      labels=c("No","Yes")) 
#
# T i m e  s e r i e s 
#
# Create a timestamp 
  # R has several date/time object classes. 
  # tidyverse is compatible with POSIXct
  
  head(gd.charges$Date) 
  head(gd.charges$Time)
  
  gd.charges <- gd.charges %>% unite('timestamp', c(Date, Time), sep =" " ) 
  head(gd.charges$timestamp)
  gd.charges <- gd.charges %>% mutate( timestamp = as.POSIXct(timestamp, 
                                                              format = "%m/%d/%Y %H:%M") ) 

  head(gd.charges$timestamp)
  class(gd.charges$timestamp)
  
  # Now we can make a column just of hours
  # regardless of date
  gd.charges <- gd.charges %>% mutate(hour = format(timestamp, "%H") )
  head(gd.charges$hour)
  gd.charges <- gd.charges %>% mutate(hour = as.numeric(hour) )
  
  # Start time at 8am
  # Note use of lubridate::hours from tidyverse
  gd.charges <- gd.charges %>% mutate(hr2 = ifelse( hour < 8,
                                                      hour + 24,
                                                      hour) )
  # Sum charges per hour
  charges.hours <- gd.charges %>%
                       group_by(GameDay, ChargeType, hr2) %>%
                        summarize(charges=length(hr2)) %>%
                    ungroup 
  
  charges.hours <- charges.hours %>% mutate(GameDay = ifelse(GameDay==0,
                                                             "No","Yes") )
  
  charges.hours <- charges.hours %>% filter(hr2 != "NA")
  
 hr.gg <- ggplot(charges.hours, 
                  aes(x=hr2, y=charges)) + theme_bw(14) + 
            geom_bar(aes(fill=ChargeType), stat="identity",
                     colour="black") +
            labs(x="Time of day", y="Number of reports") 
 hr.gg 
 
 hr.gg +
    scale_x_continuous(breaks=seq(8,28,2),
                       labels = c(seq(8,22,2),0,2,4 )) +
    scale_y_continuous(breaks=c(seq(1,20,3))) +
    facet_grid(GameDay ~ ChargeType, 
               labeller = labeller(.rows = label_both)) + 
    scale_fill_brewer(palette="Set1", 
                      guide = FALSE) 
  