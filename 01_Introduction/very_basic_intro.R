# An Introduction to R
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
# 
# Lesson 1.1: General introduction

## R as a calculator: 
2+2 # R should return 4 
2*2 # R will return 4
2*2+6 # R will return 10
6+2*2 # R will return 10, it knows the order of operations
6+(2*2) # R also recognizes parentheses 

# R is "object-oriented" - define an object and R will remember it:
answer <- 6+(2*2)
answer
answer*2
new.answer <- answer*2
new.answer

# Introducing functions 
# Researchers often want to find the mean of data: 

(24 + 13 + 12 + 22 + 15) / 5 

data <- c(24, 13, 12, 22, 15)
data

data / 5 
sum(data) / 5 

length(data)
sum(data) / length(data)
mean(data)

# Write your own function
Meaner <- function(x) { sum(x) / length(x) }

Meaner(data)

# Make your function do more
Meaner <- function(x) { 
  m <- sum(x) / length(x)
  m1 <- paste(m, "!", sep="") 
  return(m1)
}
Meaner(data)