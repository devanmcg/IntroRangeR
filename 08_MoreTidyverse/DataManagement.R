pacman::p_load(plyr, dplyr, tidyr)

setwd("C:/Users/Devan.McGranahan/GoogleDrive/Teaching/Classes/Intro to R/course materials/class session materials")

# Load data 

spp.d <- read.csv(file="./data/VareExample/SpeciesData.csv") 
chem.d <- read.csv(file="./data/VareExample/SoilChemistryResults.csv")
man.d <- read.csv(file="./data/VareExample/Management.csv")

# Make a unique sample ID 

names(spp.d)
sampID <- spp.d %>% 
            select( c("Pasture", "Treatment", "Point")) %>%
              unite("sampleID", 1:3, sep=".")

  # check out the opposite:
   head( sampID %>%  separate(sampleID, c("Pasture","Treatment","Point")) ) 

# Associate management with lab results 

head(chem.d)
head(man.d)

ManChem <- merge(man.d, chem.d, by="SampleID")


# Break out multiple entries

BareSoil.d <- ManChem %>%
              select( c("SampleID","BareSoil")) %>%
                mutate(BareSoil = strsplit(as.character(BareSoil), ",")) %>% 
                     unnest(BareSoil) 
str(BareSoil.d)

BareSoil.m <- ddply(BareSoil.d, .(SampleID), 
                    summarize, 
                    MeanBareSoil=mean(as.numeric(BareSoil)))
str(BareSoil.m)

merge(man.d, BareSoil.m, by="SampleID")


