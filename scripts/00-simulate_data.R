#### Preamble ####
# Purpose: Simulates
# Author: Ariel Xing
# Date: 19 September 2024
# Contact: ariel.xing@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)


# Set seed for reproducibility
set.seed(123)

# Define the years and causes of death
years <- 2017:2023
causes <- c("Drug Toxicity", "Accident", "Cancer", "Cardiovascular Disease", "COVID-19", "Homicide", "Infection", "Pneumonia", "Suicide", "Unknown", "Other")
seasons <- c("Winter", "Spring", "Summer", "Fall")

# Simulate total number of deaths for each cause in each year
simulated_data <- expand.grid(year_of_death = years, cause_of_death = causes, season = seasons) %>%
  mutate(total_deaths = case_when(
    cause_of_death == "Drug Toxicity" ~ rpois(n(), lambda = 80),  # higher number for drug toxicity
    cause_of_death == "Accident" ~ rpois(n(), lambda = 15),
    cause_of_death == "Cancer" ~ rpois(n(), lambda = 10),
    cause_of_death == "Cardiovascular Disease" ~ rpois(n(), lambda = 20),
    cause_of_death == "COVID-19" ~ rpois(n(), lambda = 5),  # lower COVID-19 cases
    cause_of_death == "Homicide" ~ rpois(n(), lambda = 7),
    cause_of_death == "Infection" ~ rpois(n(), lambda = 3),
    cause_of_death == "Pneumonia" ~ rpois(n(), lambda = 12),
    cause_of_death == "Suicide" ~ rpois(n(), lambda = 10),
    cause_of_death == "Other" ~ rpois(n(), lambda = 10),
    cause_of_death == "Unknown" ~ rpois(n(), lambda = 50)  # higher number for unknown causes
  ))

# Store the simulated data in a tibble
simulated_tibble <- as_tibble(simulated_data)

# View the tibble
print(simulated_tibble)

write_csv(simulated_tibble, file = "~/sta304/starter_folder-main/data/raw_data/simulated_data.csv")


