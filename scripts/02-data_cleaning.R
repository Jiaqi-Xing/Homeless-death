#### Preamble ####
# Purpose: Cleans the raw homeless death data into an analysis dataset
# Author: Ariel Xing
# Date: 24 September 2024 
# Contact: ariel.xingr@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)
library(readr)
library(dplyr)
library(lubridate)
library(janitor)
library(ggplot2)

#### Clean and Prepare Data ####

# For Figure 1: Cleaning death by month data

# Load raw death data by month
raw_death_by_month_data <- read_csv("~/sta304/starter_folder-main/data/raw_data/raw_data(death by month).csv")

# Clean column names to follow snake_case convention for easier manipulation
death_by_month_data <- raw_death_by_month_data |> 
  janitor::clean_names()

# Convert 'year_of_death' and 'month_of_death' columns into a proper date format using the first day of each month
cleaned_death_by_month_data <- death_by_month_data |> 
  mutate(date = ymd(paste(year_of_death, month_of_death, "01", sep = "-"))) |> 
  arrange(date)  # Arrange the data in chronological order by date

# Remove unnecessary columns 'x_id', 'year_of_death', and 'month_of_death' as they are now redundant after creating the 'date' column
cleaned_death_by_month_data <- cleaned_death_by_month_data %>%
  select(date, everything(), -x_id, -year_of_death, -month_of_death)

# Add a 'season' column based on the month of the date, dividing the year into four seasons: Winter, Spring, Summer, Fall
cleaned_death_by_month_data <- cleaned_death_by_month_data |> 
  mutate(season = case_when(
    month(date) %in% c(12, 1, 2) ~ "Winter",
    month(date) %in% c(3, 4, 5) ~ "Spring",
    month(date) %in% c(6, 7, 8) ~ "Summer",
    month(date) %in% c(9, 10, 11) ~ "Fall"
  ))

# For Figure 2: Cleaning death by cause data

# Load raw death data by cause
raw_death_by_cause_data <- read_csv("~/sta304/starter_folder-main/data/raw_data/raw_data(death by cause).csv")

# Clean column names and correct the inconsistency in the 'cause_of_death' column ('Drug toxicity' to 'Drug Toxicity')
death_by_cause_data <- raw_death_by_cause_data |> 
  janitor::clean_names() %>%
  mutate(cause_of_death = gsub("Drug toxicity", "Drug Toxicity", cause_of_death))

# Group the data by cause of death and calculate the total number of deaths for each cause
deaths_grouped_by_cause <- death_by_cause_data %>%
  group_by(cause_of_death) %>%
  summarise(count = sum(count, na.rm = TRUE))

# Calculate the total number of deaths (across all causes)
total_deaths <- death_by_cause_data %>%
  summarise(count = sum(count, na.rm = TRUE)) %>%
  mutate(cause_of_death = "Total")

# Combine the grouped cause-specific deaths with the total death count for analysis
cleaned_death_by_cause_data <- bind_rows(deaths_grouped_by_cause, total_deaths)

# For Figure 3: Yearly death trends

# Filter out deaths caused by unknown factors and calculate yearly totals from 2017 to 2023
unknown_deaths <- death_by_cause_data |>
  filter(cause_of_death == "Unknown") |> 
  group_by(year_of_death) %>%
  summarise(yearly_unknown_deaths = sum(count, na.rm = TRUE))

# Filter out deaths caused by drug toxicity and calculate yearly totals from 2017 to 2023
drug_deaths <- death_by_cause_data |>
  filter(cause_of_death == "Drug Toxicity") |> 
  group_by(year_of_death) %>%
  summarise(yearly_drug_toxicity_deaths = sum(count, na.rm = TRUE))

# Calculate the total number of deaths per year from 2017 to 2023, across all causes
total_deaths_by_year <- death_by_month_data|> 
  group_by(year_of_death)%>%
  summarise(yearly_total_deaths = sum(count, na.rm = TRUE))

# Combine yearly total deaths, drug toxicity deaths, and unknown deaths into one table for further analysis
combined_deaths <- total_deaths_by_year %>%
  left_join(drug_deaths, by = "year_of_death") %>%
  left_join(unknown_deaths, by = "year_of_death")
combined_deaths


#### Save Cleaned Data ####

# Save the cleaned death by month data to the analysis folder
write_csv(cleaned_death_by_month_data, "~/sta304/starter_folder-main/data/analysis_data/analysis_death_by_month_data.csv")

# Save the cleaned death by cause data, including the total number of deaths for each cause
write_csv(cleaned_death_by_cause_data, "~/sta304/starter_folder-main/data/analysis_data/analysis_death_by_cause_data.csv")

# Save the combined yearly death trends (for use in Figure 3 analysis)
write_csv(combined_deaths,"~/sta304/starter_folder-main/data/analysis_data/deaths_over_time.csv")

