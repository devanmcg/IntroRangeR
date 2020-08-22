# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 0: Getting to know each other through data
#
# This script demonstrates several R capacities
# by chugging through the Get To Know You survey
#
#
# START Code Chunk 1
#
# Install, load packages
  # This script uses several external packages. 
  # To install them semi-automatically, 
  # first install the pacman PACkage MANagement package:
  if (!require("pacman")) install.packages("pacman")
  # Once installed, pacman will take care of the rest for you:
    pacman::p_load(tidyverse, grid, gridExtra, 
                   maps,  ggmap, maptools,  
                   tm, SnowballC, wordcloud)
#
# END Code Chunk 1
#
# START Code Chunk 2
#
  # Fetch survey data
    #
    # Two options: 
      #
      # Current (or most recent) term only:
        survey.d <- read.csv(url("https://raw.githubusercontent.com/devanmcg/IntroRangeR/master/data/SurveyResponsesMostRecent.csv"))
      #
      # Data from all-time:
        survey.d <- read.csv(url("https://raw.githubusercontent.com/devanmcg/IntroRangeR/master/data/SurveyResponsesAll.csv"))
#
# END Code Chunk 2
#
# START Code Chunk 3
#
  # Bar graphs
    (degree.gg <- 
        ggplot(survey.d, 
               aes(x=reorder(degree,degree, 
                              function(x)-length(x)))) + 
      geom_bar() +
        labs(x = "Degree type", 
             y = "Number of students") + 
        theme_bw(16) + 
        theme(axis.text=element_text(color="black"), 
              axis.title=element_text(face="bold"),
              panel.grid.major.x  = element_blank(),
              legend.position = "none") )
    
  (program.gg <- 
      ggplot(survey.d, 
             aes(x=reorder(program,program, 
                            function(x)-length(x)))) + 
    geom_bar() +
      labs(x = "Program", 
           y = "Number of students") + 
      theme_bw(16) +  
      theme(axis.text=element_text(color="black"),
            axis.text.x = element_text(angle = 33, hjust = 1),
            axis.title=element_text(face="bold"),
            panel.grid.major.x  = element_blank(),
            legend.position = "none") ) 
  
  grid.arrange(degree.gg, program.gg, ncol=2)
# 
# END Code Chunk 3
#  
# START Code Chunk 4
# 
  ggplot(survey.d, aes(x=reorder(program,program, 
                                 function(x)-length(x)))) + 
    geom_bar(aes(fill=degree)) +
    labs(x = "Program", 
         y = "Number of students") + 
    scale_fill_brewer(palette = "Set1", name="Degree") + 
    theme_bw(16) +  
    theme(axis.text=element_text(color="black"),
          axis.text.x = element_text(angle = 33, hjust = 1),
          axis.title=element_text(face="bold"),
          legend.key.width= unit(1, "cm"), 
          legend.text=element_text(size=12), 
          legend.title=element_text(size=12, face="bold"), 
          panel.grid.major.x  = element_blank(),
          legend.position = "top")
#
# END Code Chunk 4
#
# START Code Chunk 5
#
  ggplot(survey.d, aes(x=reorder(water,water, 
                                 function(x)-length(x)), 
                      fill=factor(program))) + 
    geom_bar() +
    labs(x = "Which implies greater water content?", 
         y = "Number of students") + 
    scale_fill_brewer(palette = "Set1", name="Program") + 
    theme_bw(18) +  
    theme(axis.text=element_text(color="black"),
          axis.title=element_text(face="bold"),
          legend.title=element_text(face="bold"), 
          panel.grid.major.x  = element_blank(),
          legend.position = "top")
#
# END Code Chunk 5
#  
# START Code Chunk 6
#
  # Get some map data
  world.md <- map_data("world") %>% filter(region !="Antarctica")
  l48.md <- map_data("state") 
  
  #
  (us.gg <- 
  ggplot() +coord_map("polyconic") + theme_minimal(16) + 
    geom_polygon(data=l48.md, aes(x=long, y=lat, group=group), 
                 color="white", fill="grey90", size=0.25) + 
    stat_sum(data=survey.d %>%
               filter(country == "United States"), 
             aes(x=long, y=lat, 
                 size=factor(..n..), 
                 fill=degree), 
             geom = "point", pch=24, col="black")  +
    scale_size_discrete(range = c(2, 6), guide=FALSE) + 
    theme(legend.position = "bottom") +
    labs(x="longitude", y="latitude", 
         title = "Where we did our undergrad") )
#
# END Code Chunk 6
#  
# START Code Chunk 7
#  
  # Can't leave Alaska out
    ak.md <- world.md %>% filter(region == "USA", 
                                 subregion == "Alaska", 
                                 long <= -120, 
                                 lat >= 50) 
    us.gg +     geom_path(data=ak.md, aes(x=long, y=lat, group=group), 
                             color="black",  size=0.25) 
#
# END Code Chunk 7
#  
# START Code Chunk 8
#
  # Intro R is worldwide! Must include our international colleagues:
   ggplot() +coord_quickmap( ) + theme_minimal(16) + 
     geom_polygon(data=world.md, aes(x=long, y=lat, group=group), 
                  color="white", fill="grey90", size=0.25) + 
     stat_sum(data=survey.d,
              aes(x=long, y=lat, 
                  size=factor(..n..), 
                  fill=degree), 
              geom = "point", pch=24, col="black")  +
     scale_size_discrete(range = c(2, 6), guide=FALSE) + 
     theme(legend.position = "bottom") +
     labs(x="longitude", y="latitude", 
          title="Where we ALL did our undergrad")
#
# END Code Chunk 8
#
# START Code Chunk 9
#
  # Make a word cloud of relationships with data
  #
  datCorpus <- Corpus(VectorSource(survey.d$relationship))
  datCorpus <- tm_map(datCorpus, removeWords, stopwords('english'))
  wordcloud(datCorpus$content, 
            scale=c(4,0.5),
            min.freq=1,
            max.words=Inf,
            random.order=FALSE, 
            random.color=TRUE)
#
# END Code Chunk 9