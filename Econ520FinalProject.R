# Importing necessary libraries
install.packages("ipumsr")
install.packages("dplyr")
install.packages("car")
install.packages("targeted")
library(dplyr)
library(ipumsr)
library(targeted)

# Importing the data
setwd("/Users/charlizesamuels/Downloads")
dataraw <- read_ipums_micro("nhis_00008.xml")
View(dataraw)

# Check for N/A values in the entire data frame
na_values <- is.na(dataraw)
# Count the number of missing values in each column
missing_counts <- colSums(na_values)
# Print the counts
print(missing_counts)

# Print the total number of observations in the dataset
total_observations <- nrow(dataraw)

# Remove duplicated observations
dataraw = distinct(dataraw)

# Print the total number of observations in the dataset after remove duplicates
total_observations2 <- nrow(dataraw)
print(paste("Total observations:", total_observations))

# Clean "SEX" variable
# Get all unique values for the poverty variable
unique_sex <- unique(dataraw$SEX)
# Print the unique values
print(unique_sex)
# Get counts for each unique value in the "sex" variable
sex_counts <- table(dataraw$SEX)
# Print the counts
print(sex_counts)
# Create female dummy variable
dataraw$female_dummy <- as.integer(dataraw$SEX == 2)

# Clean "RACE" variable
# Get all unique values for the "race" variable
unique_race <- unique(dataraw$RACENEW)
# Print the unique values
print(unique_race)
# Get counts for each unique value in the "race" variable
race_counts <- table(dataraw$RACENEW)
# Print the counts
print(race_counts)
# Subset the dataset to remove observations with values 997, 998, and 999 in RACENEW
dataraw <- dataraw[!(dataraw$RACENEW %in% c(997, 998, 999)), ]
# Check to see if removed successfully
race_counts2 <- table(dataraw$RACENEW)
race_counts2
# Create dummy variables for White and Black
dataraw$White <- as.integer(dataraw$RACENEW == 100)  # "White only" corresponds to value 100
dataraw$Black <- as.integer(dataraw$RACENEW == 200)  # "Black/African American only" corresponds to value 200
# Create a dummy variable for the "Other" category
dataraw$Other <- as.integer(dataraw$RACENEW %in% c(500, 510, 520, 530, 540, 541, 542, 997, 998, 999))
# List all the variables in the dataset to see if new race dummy variables were created
variable_names <- names(dataraw)
print(variable_names)

# Clean "MARST" variable
unique_marst <- unique(dataraw$MARST)
# Print the unique values
print(unique_marst)
# Get counts for each unique value in the "MARST" variable
marst_counts <- table(dataraw$MARST)
# Print the counts
print(marst_counts)
# Remove NIU and "Unknown"
dataraw <- dataraw[!(dataraw$MARST %in% c(0, 99)), ]
# Check to see if removed successfully
marst_counts2 <- table(dataraw$MARST)
marst_counts2
# Create dummy variables for Married and Unmarried
dataraw$Married <- as.integer(dataraw$MARST %in% c(10, 11, 12, 13, 40))
dataraw$Unmarried <- as.integer(dataraw$MARST %in% c(20, 30, 50))
# Check if marriage status variables 
variable_names2 <- names(dataraw)
print(variable_names2)

# Clean "POORYN" variable
# Get all unique values for the poverty variable
unique_pov <- unique(dataraw$POORYN)
# Print the unique values
print(unique_pov)
# Get counts for each unique value in the poverty variable
pov_counts <- table(dataraw$POORYN)
pov_counts
# Subset the dataset to remove observations with value 9 in POORYN
dataraw <- dataraw[dataraw$POORYN != 9, ]
# Check to see if removed successfully
pov_counts2 <- table(dataraw$POORYN)
pov_counts2
# Make it into a binary variable
dataraw$pov_dummy <- as.integer(dataraw$POORYN == 2)
dataraw$nonpov_dummy <- as.integer(dataraw$POORYN == 1)
pov_counts3 <- table(dataraw$pov_dummy)
pov_counts3
# Make binary variable for non-poverty status observations
pov_counts4 <- table(dataraw$nonpov_dummy)
pov_counts4

# Clean "HEALTH" variable
# Get all unique values for the health variable
unique_health <- unique(dataraw$HEALTH)
print(unique_health)
# Get counts for each unique value in the health variable
health_counts <- table(dataraw$HEALTH)
health_counts
# Remove unknowns
dataraw <- dataraw[!(dataraw$HEALTH %in% c(7, 8, 9)), ]
# Check to see if removed successfully
health_counts2 <- table(dataraw$HEALTH)
health_counts2
# Create a dummy variable based on the HEALTH variable
dataraw$health_dummy <- as.integer(dataraw$HEALTH %in% c(1, 2, 3))
# Check
health_counts3 <- table(dataraw$health_dummy)
health_counts3

# Clean "HINOTCOVE" variable
# Get all unique values for the insurance variable
unique_insurance <- unique(dataraw$HINOTCOVE)
print(unique_insurance)
# Get counts for each unique value in the insurance variable
insurance_counts <- table(dataraw$HINOTCOVE)
insurance_counts
# Remove unknowns
dataraw <- dataraw[dataraw$HINOTCOVE != 9, ]
# Check if removed
insurance_counts2 <- table(dataraw$HINOTCOVE)
insurance_counts2
# Make it into a binary variable
dataraw$health_insurance_dummy <- as.integer(dataraw$HINOTCOVE == 1)
# Check
insurance_counts3 <- table(dataraw$health_insurance_dummy)
insurance_counts3

# Check NOBS after cleaning
total_observations3 <- nrow(dataraw)
print(paste("Total observations:", total_observations3))

View(dataraw)



# Summary Stats for Race
# Calculate the proportion of White, Black, and Other variables
mean_race <- c(mean(dataraw$White), mean(dataraw$Black), mean(dataraw$Other))
# Plot the mean values on a bar graph
barplot_race <- barplot(mean_race, names.arg = c("White", "Black", "Other"), xlab = "Race", ylab = "Proportion", main = "Proportion of Each Racial Group in Entire Dataset", col = "lightblue", border = "skyblue")
# Subset the data to include only observations with "1" for health_insurance_dummy
insured_data <- dataraw[dataraw$health_insurance_dummy == 1, ]
# Calculate the mean of White, Black, and Other variables among insured individuals
mean_race_insured <- c(mean(insured_data$White), mean(insured_data$Black), mean(insured_data$Other))
# Plot the mean values among insured individuals on a bar graph
barplot_race2 <- barplot(mean_race_insured, names.arg = c("White", "Black", "Other"), xlab = "Race", ylab = "Proportion", main = "Proportion of Each Racial Group (Insured Only)", col = "lightblue", border = "skyblue")
# Calculate correlation coefficients
correlation_white <- cor(dataraw$White, dataraw$health_insurance_dummy)
correlation_black <- cor(dataraw$Black, dataraw$health_insurance_dummy)
correlation_other <- cor(dataraw$Other, dataraw$health_insurance_dummy)
# Create a data frame for the correlation coefficients
correlation_table <- data.frame(
  Variable = c("White", "Black", "Other"),
  Correlation = c(correlation_white, correlation_black, correlation_other)
)
# Print the correlation table
print(correlation_table)


# Summary Stats for Sex
mean_female <- mean(dataraw$female_dummy)
mean_male <- 1 - mean_female
mean_sex <- c(mean_female, mean_male)
# Plot the mean values on a bar graph
barplot_sex <- barplot(mean_sex, names.arg = c("Female", "Male"), xlab = "Sex", ylab = "Proportion", main = "Proportion of Each Sex in Entire Dataset", col = c("pink", "lightblue"), border = c("salmon","skyblue"))
mean_sex_insured <- c(mean(insured_data$female_dummy), 1-mean(insured_data$female_dummy))
barplot_sex2 <- barplot(mean_sex_insured, names.arg = c("Female", "Male"), xlab = "Sex", ylab = "Proportion", main = "Proportion of Each Sex (Insured Only)", col = c("pink", "lightblue"), border = c("salmon","skyblue"))
# Calculate correlation coefficients
# Calculate correlation coefficients
correlation_female <- cor(dataraw$female_dummy, dataraw$health_insurance_dummy)
dataraw$male_dummy <- as.integer(dataraw$SEX == 1) #create dummy variable for male observations to calculate correlation coefficient
correlation_male <- cor(dataraw$male_dummy, dataraw$health_insurance_dummy)
# Create a data frame for the correlation coefficients
correlation_table2 <- data.frame(
  Variable = c("Female", "Male"),
  Correlation = c(correlation_female, correlation_male)
)
# Print the correlation table
print(correlation_table2)


# Summary Stats for Marital Status
mean_married <- mean(dataraw$Married)
mean_unmarried <- mean(dataraw$Unmarried)
mean_marital_status <- c(mean_married, mean_unmarried)
# Bar Plot
barplot_marital <- barplot(mean_marital_status, names.arg = c("Married", "Unmarried"), xlab = "Marital Status", ylab = "Proportion", main = "Proportion of Each Marital Status in Entire Dataset", col = c("lightgreen", "orange"), border = c("darkgreen","darkorange"))
mean_marital_insured <- c(mean(insured_data$Married), mean(insured_data$Unmarried))
barplot_marital2 <- barplot(mean_marital_insured, names.arg = c("Married", "Unmarried"), xlab = "Marital Staus", ylab = "Proportion", main = "Proportion of Each Marital Status (Insured Only)", col = c("lightgreen", "orange"), border = c("darkgreen","darkorange"))
# Correlation Table
correlation_married <- cor(dataraw$Married, dataraw$health_insurance_dummy)
correlation_unmarried <- cor(dataraw$Unmarried, dataraw$health_insurance_dummy)
correlation_table3 <- data.frame(
  Variable = c("Married", "Unmarried"),
  Correlation = c(correlation_married, correlation_unmarried)
)
print(correlation_table3)



# Summary Stats for Poverty Status
dataraw$nonpov_dummy <- as.integer(dataraw$POORYN == 1) # make dummy for non-poverty status observations
mean_pov <- mean(dataraw$pov_dummy)
mean_nonpov <- mean(dataraw$nonpov_dummy)
mean_poverty_status <- c(mean_pov, mean_nonpov)
barplot_poverty <- barplot(mean_poverty_status, names.arg = c("Yes", "No"), xlab = "Poverty Status", ylab = "Proportion", main = "Proportion of Each Poverty Status in Entire Dataset", col = c("red", "magenta"), border = c("darkred","maroon"))
insured_data <- dataraw[dataraw$health_insurance_dummy == 1, ]
mean_poverty_insured <- c(mean(insured_data$pov_dummy), mean(insured_data$nonpov_dummy))
barplot_poverty2 <- barplot(mean_poverty_insured, names.arg = c("Yes", "No"), xlab = "Poverty Staus", ylab = "Proportion", main = "Proportion of Each Poverty Status (Insured Only)", col = c("red", "magenta"), border = c("darkred","maroon"))
# Correlation Table
correlation_pov <- cor(dataraw$pov_dummy, dataraw$health_insurance_dummy)
correlation_nonpov <- cor(dataraw$nonpov_dummy, dataraw$health_insurance_dummy)
correlation_table4 <- data.frame(
  Variable = c("Yes", "No"),
  Correlation = c(correlation_pov, correlation_nonpov)
)
print(correlation_table4)


# Summary Stats for treatment variable (health insurance status)
# Calculate mean health insurance status
mean_insurance <- mean(dataraw$health_insurance_dummy)
# Calculate mean no insurance status
mean_noinsurance <- 1 - mean_insurance
# Combine means into a vector
mean_treatment <- c(mean_insurance, mean_noinsurance)
# Print mean treatment
mean_treatment

# Summary Stats for Outcome Variable (Health Status)
# Calculate mean healthy status
mean_healthy <- mean(dataraw$health_dummy)
# Calculate mean no healthy status
mean_nohealthy <- 1 - mean_healthy
# Combine means into a vector
mean_outcome <- c(mean_healthy, mean_nohealthy)
# Print mean outcome
mean_outcome

# Make final correlation table
correlation_table_final <- data.frame(
  Variable = c("White", "Black", "Other", "Female", "Male", "Married", "Unmarried", "Poverty", "Not in Poverty" ),
  Correlation = c(correlation_white, correlation_black, correlation_other, correlation_female, correlation_male, correlation_married, correlation_unmarried, correlation_pov, correlation_nonpov)
)
# Print the correlation table
print(correlation_table_final)


#Let's estimate the ate
atehat <- targeted::ate(health_dummy ~ health_insurance_dummy |  health_insurance_dummy*(Black+Other+female_dummy+Unmarried+pov_dummy)|1, 
                        data=dataraw, binary=FALSE)
summary(atehat)

