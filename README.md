# Estimating ATE Using Regression Adjustment in R Studio
#### By: Charlize Samuels and Jamila Spears

This repository focuses around how to reproduce the results of the our research paper which focuses on answering the following question: 

*What is the average treatment effect of having health insurance on general health?*

Here, it will be shown how the data was extracted, imported, and used in R Studio to estimate the ATE by means of regression adjustment through the use of the `library(targeted)` package.

## Data
This specific research uses data from IPUMS Health Survey. It uses provide harmonized data from multiple national and international health surveys, making it easier for researchers to analyze health trends across different populations and regions. In addition to health-related variables, IPUMS Health Surveys often include demographic information such as age, gender, race/ethnicity, education, income, and household composition. This allows researchers to analyze health disparities and the social determinants of health.
### - Step 1: Data Extraction
IPUMS allows you to build data sets through selecting the only variables relevant to your research. The data extraction page for IPUMS Health Surveys can be found [here.](https://nhis.ipums.org/nhis-action/variables/group)

To achieve reproducibility, select the following variables as part of your extract:

- RACENEW (covariate)
- SEX (covariate)
- POORYN (covariate)
- MARST (covariate)
- HEALTH (outcome variable)
- HINOTCOVE (treatment variable)

⭐ Importing these same variables for your extract will ensure that all the provided code will run on your machine.

After the data extract is created, download both the data file itself (it will be a .dat file) and also the corresponding DDI file (it will be an .xml file) on the downloads page.

<img width="776" alt="Screenshot 2024-05-02 at 8 04 59 PM" src="https://github.com/charlize1174/Econ-520-Final/assets/123476373/a27aa7a3-fa39-48f1-9187-ac1aef33c2b4">

The DDI (Data Documentation Initiative) file for IPUMS data serves as a metadata file that provides detailed information about the structure, content, and documentation of the dataset. It allows coding programs such as R to properly import the data; the .dat file and the .xml file work together to provide the correct structure and variable names for the data.

❗You must save both the .dat files and the .xml files to the same folder in your machine. Ensure that you are able to find the correct directory for this folder.

### - Step 2: Data Import
To import data from IPUMS into R Studio, you will need to download the `library(ipumsr)` package. Below is the code for the installing and calling of this package:

```language
install.packages("ipumsr")
library(ipumsr)
```
Next, set your working directory to the folder that contains the .dat file and the .xml file for the data.

```language
setwd("your_directory")
```
Finally, you can import and view the data using the `read_ipums_micro()` function:

```language
data <- read_ipums_micro("your ddi file.xml")
View(data)
```
❗It is important to note that you only actually need the .xml file (DDI) for importing the data through the R code. This is why keeping both files within the same folder (and without changing the names of these files) helps to ensure easy data importing.

*We did not include the exact data file that we used for our research due to certain restrictions regarding the redistribution of IPUMS data extracts*

## Data Cleaning 

Please refer to the .rmd file available in this repository for the following:
1) To see (again) the exact variables we used from the IPUMS Health Surveys to create our data extract.
2) The code used to clean all thse variables, which should run as long as you choose those same variables for the extract.
3) The codes used to provide summary statistics as well as tables in graphs as part of the preliminary data analysis process which should also run as long as you choose the same variables



## ATE Estimation

As mentioned before, the aim of this repository is show how to estimate the ATE using linear regression adjustment. 

Estimating the ATE by subtracting the linear regression results from just the treated group and the untreated group (which is essentially the processs of linear regression adjustment) has several advantages over simply using the coefficient on the treatment variable from a single regression. For one, by fitting separate regressions for the treated and untreated groups, and then subtracting the results, you effectively control for potential confounding variables that may affect the outcome. This helps to isolate the true effect of the treatment by accounting for differences in baseline characteristics between the treated and untreated groups. Also, estimating the ATE through linear regression adjustment provides a robust approach that is less sensitive to model specification and potential sources of bias. It offers a more flexible and nuanced analysis compared to simply using the coefficient on the treatment variable from a single regression.


### - Step 1: Package Installation

The `library(targeted)` package will be used to to run the regression adjustment:

```language
install.packages("targeted")
library(targeted)
```

### - Step 2: Running the Regressions

The `ate()` function within the `library(targeted)` package will directly calculate the ATE. If all the code for the data cleaning of the variables was run, then the following code should run without issues to estimate the ATE:

```language
atehat <- targeted::ate(health_dummy ~ health_insurance_dummy |  health_insurance_dummy*(Black+Other+female_dummy+Unmarried+pov_dummy)|1, 
                        data=data, binary=FALSE)
```

### - Step 3: View the Results

You can see the results of this regression adjustment process using the `summary()` function:

```language
summary(atehat)
```

The results of our output looked like the following:

<img width="728" alt="Screenshot 2024-04-29 at 1 53 12 AM" src="https://github.com/charlize1174/Econ-520-Final/assets/123476373/8e520e9f-ad87-4e58-8e91-38fc509458f6">

Here, we can see that we have two estimates, one for when D=1 (treated group) and one for when D=0 (untreated group) from the two separate regressions ran for the treated and untreated groups. The difference between these values is the ATE, derived from regression adjustment.

Refer to the source code provided to view our report in which the interpretation of these results as well as the comparison groups dropped from each strata of covariates are clearly explained.

