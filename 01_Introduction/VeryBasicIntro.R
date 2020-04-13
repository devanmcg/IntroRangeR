# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 1: General introduction

## R as a calculator: 
  2+2 # R returns 4 
  2*2 # R returns 4
  2*2+6 # R returns 10
  6+2*2 # R returns 10; it follows order of operations
  6+(2*2) # R also recognizes parentheses 

# R is "object-oriented" - define an object and R will remember it:
  answer <- 2+(2*20)
  answer
  answer*2
  new.answer <- answer*2
  new.answer

# Introducing functions 
  # Researchers often want to find the mean of data. 
  # Say we have the following five observations:

  (24 + 13 + 12 + 22 + 15) / 5 
  
  # Create and view an object
  data <- c(24, 13, 12, 22, 15) # c = concatenate function
                                # it joins everything between ( ),
                                #  separated by commas, 
                                # into a ~vector~ 
  data 
  
  data / 5 # R applies operations to each observation in the vector

  # Mean is the sum of observations divided by the count 
  # R includes a ~function~ that does the summation for us:
    sum(data) / 5 
    
  # But what if your technician inadvertently lost or 
  # failed to enter some data? 
  # Hard-coding your count creates problems: 
    data2 <- c(24, 13, 12, 22)
    sum(data2) / 5  # Too low
    
  # Better to have R determine the count for each operation
  # So if counts differ, R can automatically account for it
    length(data)
    sum(data) / length(data)
    
    length(data2)
    sum(data2) / length(data2)
  
  # Of course, R has a built-in function for calculating means
    mean(data)

# Write your own function
  Meaner <- function(x) { sum(x) / length(x) }
  Meaner 
  
  Meaner(data)

# Personalize your function. Make it do more!
  Meaner <- function(x) { 
    m = sum(x) / length(x)
    m1 = paste(m, "!", sep="") 
    return(m1)
  }
  Meaner(data)
  