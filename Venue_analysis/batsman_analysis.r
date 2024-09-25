# Install and load required packages
library(dplyr)
library(tidyr)
library(plotly)

# Inputs
target_player <- readline("Target Batsman : ")
target_country <- readline("Target Country : ")

# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")

# Determine the country of the bowler based on conditions
bowler_country_data <- cricket_data %>%
  mutate(
    Bowler_Country = case_when(
      Innings == 1 ~ Bat.Second,
      Innings == 2 ~ Bat.First
    )
  ) %>%
  select(Bowler, Bowler_Country) %>%
  distinct()

# Filter bowlers from the target country
target_bowlers <- bowler_country_data %>%
  filter(Bowler_Country == target_country) %>%
  select(Bowler)

# Filter dismissals data for the target player and bowlers from the target country
dismissals_data <- cricket_data %>%
  filter(Batter == target_player, Bowler %in% target_bowlers$Bowler) %>%
  group_by(Batter, Bowler) %>%
  summarise(Dismissals = n(), .groups = "drop")

# Create an interactive bar chart
a <- plot_ly(
  data = dismissals_data,
  x = ~Bowler,
  y = ~Dismissals,
  type = "bar",
  text = ~ paste("Bowler: ", Bowler, "<br>Dismissals: ", Dismissals, "<br>Country: ", target_country),
  hoverinfo = "text"
) %>%
  layout(
    title = paste("Number of Dismissals for", target_player, "against Bowlers from", target_country),
    xaxis = list(title = "Bowler"),
    yaxis = list(title = "Number of Dismissals")
  )

print(a)
