#### Preamble ####
# Purpose: Tests three cleaned data
# Author: Ariel Xing
# Date: 26 September 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
install.packages("testthat")
library(testthat)
library(tidyverse)

#### Test simulate data ####
data <- read_csv("~/sta304/starter_folder-main/data/raw_data/simulated_data.csv")

## Test for negative numbers(simulate_data)
expect_true(all(data$total_deaths >= 0), info = "There are negative death counts in the dataset.")

## Test for NAs(simulate_data)
test_that("Simulated data has no missing values (NAs)", {
  
  # Check that no missing values exist in the 'year_of_death' column
  expect_false(any(is.na(simulated_tibble$year_of_death)), info = "There are NAs in the year_of_death column.")
  
  # Check that no missing values exist in the 'cause_of_death' column
  expect_false(any(is.na(simulated_tibble$cause_of_death)), info = "There are NAs in the cause_of_death column.")
  
  # Check that no missing values exist in the 'season' column
  expect_false(any(is.na(simulated_tibble$season)), info = "There are NAs in the season column.")
  
  # Check that no missing values exist in the 'total_deaths' column
  expect_false(any(is.na(simulated_tibble$total_deaths)), info = "There are NAs in the total_deaths column.")
  
})


#### Test for cleaned_death_by_month_data ####
cleaned_death_by_month_data <- read_csv("~/sta304/starter_folder-main/data/analysis_data/analysis_death_by_month_data.csv")

## Test for negative numbers(cleaned_death_by_month_data)
test_that("cleaned_death_by_month_data has no negative death counts", {
  
  # Ensure that no negative death counts exist in any relevant columns
  expect_true(all(cleaned_death_by_month_data$count >= 0), info = "There are negative death counts in the dataset.")
  
})

## Test for NAs(cleaned_death_by_month_data)
test_that("cleaned_death_by_month_data has no missing values (NAs)", {
  
  # Check that there are no NAs in the 'date' column
  expect_false(any(is.na(cleaned_death_by_month_data$date)), info = "There are NAs in the date column.")
  
  # Check that there are no NAs in the 'season' column
  expect_false(any(is.na(cleaned_death_by_month_data$season)), info = "There are NAs in the season column.")
  
  # Check that there are no NAs in the 'count' column (if count column exists)
  expect_false(any(is.na(cleaned_death_by_month_data$count)), info = "There are NAs in the count column.")
  
})

#### Test for cleaned_death_by_cause_data ####
cleaned_death_by_cause_data <- read_csv("~/sta304/starter_folder-main/data/analysis_data/analysis_death_by_cause_data.csv")

## Test for negative numbers(cleaned_death_by_cause_data)
test_that("cleaned_death_by_cause_data has no negative death counts", {
  
  # Ensure that no negative values exist in the 'count' column
  expect_true(all(cleaned_death_by_cause_data$count >= 0), info = "There are negative death counts in the dataset.")
  
})

## Test for NAs(cleaned_death_by_cause_data)
test_that("cleaned_death_by_cause_data has no missing values (NAs)", {
  
  # Check that there are no NAs in the 'cause_of_death' column
  expect_false(any(is.na(cleaned_death_by_cause_data$cause_of_death)), info = "There are NAs in the cause_of_death column.")
  
  # Check that there are no NAs in the 'count' column
  expect_false(any(is.na(cleaned_death_by_cause_data$count)), info = "There are NAs in the count column.")
  
})
