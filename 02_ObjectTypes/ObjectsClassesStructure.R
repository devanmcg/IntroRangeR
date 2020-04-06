# An Introduction to R
#
# Devan Allen McGranahan (devan.mcgranahan@gmail.com)
#
# YouTube lectures: https://www.youtube.com/playlist?list=PLKXOvaXmjIGcSHFMe2Wpsaw4yzvWR0AgQ
# github repo: https://github.com/devanmcg/IntroRangeR
# 
# Lesson 2: R objects, classes, and structure

# Setting working directories
	# Working directories help pull data from, and save to, specific files. 
	# You can always see what your current working directory is:
		getwd() # print the current working directory (cwd)
		ls()    # list the objects in the current workspace
		
	# You can change the working directory: 
		setwd("E:/R/")  # ~!~ note: use / or \\ instead of \ in windows ~!~
	
	# Saving things 
		# Save specific objects. 
		# Always a good idea: after importing and manipulating data, 
		# save specific objects
		save(file_name, file="./file_name.Rdata") # saves to cwd
		load("./file_name.Rdata") # Bring R objects into the workspace from cwd. 
			
		# Save workspace: at the end of your session, you can save everything 
		# on the current workspace. 
		# Two schools of thought on this one, though!
		save.image()
	
	# Types of R objects
	 	# Libraries/packages are how the R community shares extended functionality 
		# Hundreds are available "officially" through r-cran 
		# (the preferred way to access and reference)
		# Many more functions are available on github and personal and academic websites
		install.packages("pacman") # prompts a download procedure. Must select a source.
		# Once installed, a package is called a library. 
		# Libraries must be loaded each time R is restarted
		#	Two ways to use a library in a session:
		library(pacman) # Loads the library/package into the session. 
		                 # All included functions are available.
		p_load(dplyr)    # p_load is a pacman function that will run now. 
		pacman::p_load(dplyr) # Alternative way to make a one-time call 
		                        # to a specific function in a library: 
		                        #   PackageName::FunctionInPackage( )
		                        # Useful if you know two packages have 
		                        # same function and will compete. 
		
# Some diagnostic functions
		
		# Evaluate an entire R object 
		
		dim(cars)  	      # Dimensions of the object
		names(cars)	      # Displays column headings
		head(cars)	      # Displays top six lines of the data
		tail(cars)        # Displays bottom six lines
		class(cars)	      # Data frame, matrix, etc.
		class(cars$speed) # Returns class of specific column
		str(cars)         # Provides all evaluation info
		                  # of object and components
		summary(cars)     # Basic stats on data. Key function for stats.

	 # Evaluate specific columns
		
		head(cars)        # Top six rows of both columns
		head(cars$speed)  # Top six rows of column "speed"
		head(cars[1])     # Top six rows of first column

		column = "speed"
		head(cars[[column]]) # Useful in programming 
		                     # eg, if name or position can change
		
		# Silly example script:
		
  		columns <- names(cars)
  		columns
  		length(columns)
  		
  		for( i in 1:length(columns)) {
  		  column = columns[i]
  		  print(head(cars[[column]]))  
  		}
	  
		# Evaluate specific rows and cells 
		
		cars[1,]   # Display row 1
		cars[1:3,] # Display rows 1 through 3
		cars[3:5,] # Display rows 3 through 5
		cars[5,2]  # Display component located in row 5, column 2
		
# A more complex dataset?
		
		str(mtcars)  
		summary(mtcars)
		
		# Changing component classes with as. functions
		
		mtcars$cyl <- as.factor(mtcars$cyl)
		mtcars$vs <- as.factor(mtcars$vs)
		str(mtcars)
		
		# This is laborious if many conversions are required. 
		# dplyr package from the tidyverse has a 'tidy' solution:

		mtcars <- mutate_at(mtcars, vars(gear, carb), as.factor)
		str(mtcars)
		
		# make some basic plots. 
		# Note intuitive Y by X notation
		
		plot(mpg ~ disp, mtcars)
		plot(mpg ~ am, mtcars)
		
		# Wait, what the heck is "am" anyway? Go to help:
		?mtcars
		
		# Change column data to something more useful
		# Example of a dplyr pipe. 
		# Use mutate verb to make changes to the table in a tidy way
		
		mtcars <- mtcars %>% # The super-handy pipe operator 'pours' data down
		            mutate(am = as.factor(am), # First operation: as.factor; pour down
		                   am = recode(am, "0"="Automatic",   # Second operation:
		                                   "1"="Manual")) %>% # change level names; pour down
		              rename(transmission = am) # Third operation: rename am; return 
		str(mtcars)
		
		# Plot again: 
		
  		plot(mpg ~ transmission, mtcars)  # R is pretty smart, hey?

		# After all that work - make sure to save!
		
		getwd()
		save(mtcars, file="./data/mtcars.Rdata") 
		# or
		save(mtcars, file=file.choose()) 
