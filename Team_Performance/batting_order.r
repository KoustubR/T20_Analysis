# Install and load required packages
library(dplyr)
library(ggplot2)

# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")

# Filter out incomplete innings data
complete_innings <- cricket_data %>%
  filter(!is.na(Innings.Runs))

# Summary statistics for innings runs based on batting first or second
summary_stats <- complete_innings %>%
  group_by(Bat.First) %>%
  summarise(
    Avg_Innings_Runs = mean(Innings.Runs),
    Median_Innings_Runs = median(Innings.Runs),
    Max_Innings_Runs = max(Innings.Runs),
    Min_Innings_Runs = min(Innings.Runs)
  )

print("Summary Statistics for Innings Runs:")
print(summary_stats)

# Select the top 20 batting performances based on average innings runs
top_20_batting_performances <- complete_innings %>%
  group_by(Bat.First) %>%
  summarise(Avg_Innings_Runs = mean(Innings.Runs)) %>%
  top_n(20, Avg_Innings_Runs)

# Print or visualize the top 20 batting performances
print(top_20_batting_performances)

# Box plot to compare innings runs when batting first or second for the top 20 batting performances
a <- ggplot(
  complete_innings %>% filter(Bat.First %in% top_20_batting_performances$Bat.First),
  aes(x = as.factor(Bat.First), y = Innings.Runs)
) +
  geom_boxplot(fill = "lightblue", color = "blue") +
  labs(
    title = "Comparison of Innings Runs for Top 20 Batting Performances",
    x = "Batting First (0) / Batting Second (1)", y = "Innings Runs"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
print(a)
