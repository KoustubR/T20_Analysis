# Install and load required packages
library(dplyr)
library(ggplot2)

# Loading Data
cricket_data <- read.csv("ball_by_ball_it20.csv")

# Create a new column 'Result' to identify the result of each match
cricket_data <- cricket_data %>%
  mutate(Result = ifelse(Winner == Bat.First, "Win", "Loss"))

# Calculate win/loss records for each team
team_records <- cricket_data %>%
  group_by(Team = ifelse(Result == "Win", Bat.First, Bat.Second)) %>%
  summarise(
    Wins = sum(Result == "Win"),
    Losses = sum(Result == "Loss")
  )

# Calculate total matches played by each team
team_records <- team_records %>%
  mutate(
    TotalMatches = Wins + Losses,
    WinPercentage = (Wins / TotalMatches) * 100
  )

# Select only the top 20 winning countries
top_20_winning_countries <- team_records %>%
  top_n(20, TotalMatches)

# Print or visualize the results for the top 20 winning countries
print(top_20_winning_countries, n = 20)

# Create a bar plot to visualize win/loss records for the top 20 winning countries
a <- ggplot(top_20_winning_countries, aes(x = reorder(Team, -WinPercentage), y = WinPercentage)) +
  geom_bar(stat = "identity", fill = "green", color = "black") +
  labs(
    title = "Top 20 Winning Countries - Win/Loss Records",
    x = "Team",
    y = "Win Percentage"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(a)
