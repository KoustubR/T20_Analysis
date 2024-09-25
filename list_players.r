# Read your CSV file
library(dplyr)
cricket_data <- read.csv("ball_by_ball_it20.csv")

target_country <- readline("Target_Country : ")
# Assuming your data frame is named 'cricket_data'
unique_batters <- cricket_data %>%
  select(Batter, Bat.First, Innings) %>%
  filter(Bat.First == target_country & Innings == 1) %>%
  distinct()

# View the unique batters and their respective countries
print(unique_batters %>% select(Batter))
