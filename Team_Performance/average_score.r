# Install and load required packages
library(dplyr)
library(ggplot2)

# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")

# Calculate average total runs scored by teams
average_total_runs <- cricket_data %>%
  group_by(Bat.First) %>%
  summarise(Avg_Total_Runs = mean(Total.Batter.Runs)) %>%
  top_n(15, Avg_Total_Runs)

# Print or visualize the results
print(average_total_runs)

# Create a bar plot to visualize average total runs scored by teams
a <- ggplot(average_total_runs, aes(x = reorder(Bat.First, -Avg_Total_Runs), y = Avg_Total_Runs)) +
  geom_bar(stat = "identity", fill = "lightblue", color = "blue") +
  labs(
    title = "Average Total Runs Scored by Teams",
    x = "Team",
    y = "Average Total Runs"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(a)
