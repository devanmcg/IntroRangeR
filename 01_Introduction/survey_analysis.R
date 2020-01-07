# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 1.2: Getting to know each other through data
#
# This script demonstrates several R capacities
# by chugging through the Get To Know You survey
#
#
# START Code Chunk 1

# Install, load packages
  # This script uses several external packages. 
  # To install them semi-automatically, 
  # first install the pacman PACkage MANagement package:
    install.packages("pacman")
  # Once installed, pacman will take care of the rest for you:
    pacman::p_load(maps, rgdal, ggmap,  
                   maptools, tidyverse, grid, broom, 
                   tm, SnowballC, wordcloud, gridExtra, chron)
#
# END Code Chunk 1

# START Code Chunk 2
#
  # Fetch survey data
  # To complete the survey: https://goo.gl/forms/EceTzhp1QML0BFVg2
  responses <- url("https://docs.google.com/spreadsheets/d/e/2PACX-1vToeOasZ6tIwTVI0CuZN2fB9ZKztXeIyWdeQDnDx0f0o9XDYgurE1DlzNQvUqRfMNKLGr-j8bQ0qCF6/pub?output=csv")
  # Set up the survey data
  survey.d <- 
    read.csv(responses)  %>%
      mutate(Timestamp = as.POSIXct(Timestamp, format="%m/%d/%Y %H:%M:%S"), 
             Year = lubridate::year(Timestamp), 
             Month = lubridate::month(Timestamp)) %>%
        filter(Year == format(Sys.Date(), "%Y") ) %>% # Limit responses to those from this year
          select(-Timestamp, -Year, -Month) 
  
   #names(survey.d) 
  colnames(survey.d) <- c("degree", "program", "USundergrad", "water", 
                          "relationship", "gender", "UndergradWhere", 
                          "INTundergrad", "moist", "previous")
  survey.d <- select(survey.d, -gender, -UndergradWhere, -previous) 
  
#
# END Code Chunk 2
  

# START Code Chunk 3
  # Bar graphs
    degree.gg <- ggplot(survey.d, aes(x=reorder(degree,degree, function(x)-length(x)), 
                                      fill=factor(degree))) + 
      geom_bar() +
        labs(x = "Degree type", y = "Number of students") + 
        scale_fill_brewer(palette = "Set1") + 
        theme_bw() + 
        theme(axis.text.x = element_text(angle = 33, hjust = 1),
              axis.text=element_text(size=12, color="black"), 
              axis.title=element_text(size=12,face="bold"),
              legend.key.width= unit(2, "cm"), 
              legend.text=element_text(size=12), 
              legend.title=element_text(size=12, face="bold"), 
              legend.position = "none") 
    
  program.gg <- ggplot(survey.d, aes(x=reorder(program,program, function(x)-length(x)), 
                                     fill=factor(program))) + 
    geom_bar() +
      labs(x = "Program", y = "Number of students") + 
       scale_fill_brewer(palette = "Set1") + 
      theme_bw() +  
      theme(axis.text.x = element_text(angle = 33, hjust = 1),
            axis.text=element_text(size=12, color="black"), 
            axis.title=element_text(size=12,face="bold"),
            legend.key.width= unit(2, "cm"), 
            legend.text=element_text(size=12), 
            legend.title=element_text(size=12, face="bold"), 
            legend.position = "none")
  grid.arrange(degree.gg, program.gg, ncol=2)
# 
# END Code Chunk 3
  
#
# START Code Chunk 4
# 
  both.gg <- ggplot(survey.d, aes(x=reorder(program,program, function(x)-length(x)), 
                                  fill=factor(degree))) + 
    geom_bar() +
    labs(x = "Program", y = "Number of students") + 
    scale_fill_brewer(palette = "Set1", name="Degree") + 
    theme_bw() +  
    theme(axis.text.x = element_text(angle = 33, hjust = 1),
          axis.text=element_text(size=12, color="black"), 
          axis.title=element_text(size=12,face="bold"),
          legend.key.width= unit(1, "cm"), 
          legend.text=element_text(size=12), 
          legend.title=element_text(size=12, face="bold"), 
          legend.position = "top")
  
  wet.gg <- ggplot(survey.d, aes(x=reorder(water,water, function(x)-length(x)), 
                                 fill=factor(program))) + 
    geom_bar() +
    labs(x = "Which implies greater water content?", 
         y = "Number of students") + 
    scale_fill_brewer(palette = "Set1", name="Program") + 
    theme_bw() +  
    theme(axis.text.x = element_text(angle = 33, hjust = 1),
          axis.text=element_text(size=12, color="black"), 
          axis.title=element_text(size=12,face="bold"),
          legend.key.width= unit(1, "cm"), 
          legend.text=element_text(size=12), 
          legend.title=element_text(size=12, face="bold"), 
          legend.position = "top")

  grid.arrange(both.gg, wet.gg, ncol=2)
#
# END Code Chunk 3 
  
#
# START Code Chunk 4
  states.md <- map_data("state")
  l48 <- subset(states.md, region !="alaska")
  survey.d$USundergrad <- as.character(survey.d$USundergrad)
  
  ug.us <- survey.d %>% drop_na(USundergrad, degree) 
  ug.us <- data.frame(degree=ug.us$degree, 
                             geocode(c(ug.us$USundergrad), source="dsk") )  
  
 US.gg <- ggplot() +coord_map() + theme_minimal() + 
   geom_polygon(data=l48, aes(x=long, y=lat, group=group), 
                color="white", fill="grey90", size=0.25) + 
   stat_sum(data=ug.us, aes(x=lon, y=lat, 
                                   size=factor(..n..), 
                                   fill=degree), 
            geom = "point", pch=24, 
            col="black")  +
   scale_size_discrete(range = c(2, 6), guide=FALSE) + 
   theme(legend.position = "bottom") +
   labs(x="longitude", y="latitude", title="Where we did our undergrad")
 
 world.md <- map_data("world")
 world.md <- subset(world.md, region !="Antarctica")
 survey.d$INTundergrad <- as.character(survey.d$INTundergrad)
 
 ug.int <- survey.d %>%  drop_na(INTundergrad, degree) 
 ug.int <- data.frame(degree=ug.int$degree, 
                             geocode(c(ug.int$INTundergrad), source="dsk") )  
  ug.int <- drop_na( ug.int ) 
 #' Where you all are from. The bigger the symbol, the more of you are from there:
 int.gg <- ggplot() +coord_quickmap() + theme_minimal() + 
   geom_polygon(data=world.md, aes(x=long, y=lat, group=group), 
                color="white", fill="grey90", size=0.25) + 
   stat_sum(data=ug.int, aes(x=lon, y=lat, 
                                    size=factor(..n..), 
                                    fill=degree), 
            geom = "point", pch=24, 
            col="black")  +
   scale_size_discrete(range = c(2, 6), guide=FALSE) + 
   theme(legend.position = "bottom") +
   labs(x="longitude", y="latitude")
 
 grid.arrange(US.gg, int.gg, ncol=1)
 #
 # END Code Chunk 4
 
 
 # START Code Chunk 5
 #
 # Make a word cloud of relationships with data
 #
  datCorpus <- Corpus(VectorSource(survey.d$relationship))
  datCorpus <- tm_map(datCorpus, removeWords, stopwords('english'))
  wordcloud(datCorpus$content, scale=c(4,0.5),min.freq=1,max.words=Inf,
            random.order=FALSE, random.color=TRUE)
  
#
# END Code Chunk 5
  