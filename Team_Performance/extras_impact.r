library(ggplot2)
# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")
particular_country <- readline("Target Country : ")

# Count how many times the particular country won for each match
opposing_country_wins <- cricket_data %>%
  filter(
    (Bat.First == particular_country & Winner != particular_country) |
      (Bat.Second == particular_country & Winner != particular_country)
  ) %>%
  group_by(Match.ID, Winner) %>%
  summarise(Count_Opposing_Country_Wins = sum(!is.na(Winner)))

opposing_country_wins_summary <- opposing_country_wins %>%
  group_by(Winner) %>%
  summarise(Total_Wins = n())
# View the results
print(opposing_country_wins)

# Plotting the total wins for each country
a <- ggplot(opposing_country_wins, aes(x = Winner, y = Count_Opposing_Country_Wins)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(
    title = "Total Wins for Each Country",
    x = "Country",
    y = "Total Wins"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(a)
