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

#### Clean data ####
raw_death_by_month_data <- read_csv("~/sta304/starter_folder-main/data/raw_data/raw_data(death by month).csv")

# Clean column names
cleaned_death_by_month_data <- raw_death_by_month_data |> 
  janitor::clean_names()

# Convert the month and year into a proper date format
cleaned_death_by_month_data <- cleaned_death_by_month_data |> 
  mutate(date = ymd(paste(year_of_death, month_of_death, "01", sep = "-"))) |> 
  arrange(date)

# Remove 'x_id'，'year_of_death' and 'month_of_death' columns
cleaned_death_by_month_data <- cleaned_death_by_month_data %>%
  select(date, everything(), -x_id, -year_of_death, -month_of_death)

# Plot monthly death data
ggplot(cleaned_death_by_month_data, aes(x = date, y = count)) +
  geom_smooth(method = "loess",            # Add a smooth line
              se = FALSE,                  # Do not show confidence interval
              color = "blue", size = 1) + 
  geom_point(color = "red", size = 1) +  
  labs(title = "Trends in Homeless Deaths Over Time", 
       x = "Date", 
       y = "Number of Deaths") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Add season information
cleaned_death_by_month_data <- cleaned_death_by_month_data |> 
  mutate(season = case_when(
    month(date) %in% c(12, 1, 2) ~ "Winter",
    month(date) %in% c(3, 4, 5) ~ "Spring",
    month(date) %in% c(6, 7, 8) ~ "Summer",
    month(date) %in% c(9, 10, 11) ~ "Fall"
  ))

# Aggregate deaths by season
seasonal_deaths <- cleaned_death_by_month_data %>%
  group_by(season) %>%
  summarise(total_deaths = sum(count, na.rm = TRUE))

# Plot seasonal deaths
ggplot(seasonal_deaths, aes(x = season, y = total_deaths, fill = season)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = total_deaths), vjust = -0.3, size = 2) + 
  labs(title = "Total Homeless Deaths by Season", x = "Season", y = "Number of Deaths") +
  theme_minimal()

#### Save data ####
write_csv(cleaned_death_by_month_data, "~/sta304/starter_folder-main/data/analysis_data/analysis_death_by_month_data.csv")

