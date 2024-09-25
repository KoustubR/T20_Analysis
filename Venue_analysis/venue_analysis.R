library(plotly)
library(tidyverse)

player_name <- readline("Target Player : ")
# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")
# print(summary(cricket_data))

# Filter data for the specific player (replace "Player_X" with the actual player name)
player_data <- cricket_data %>% filter(Batter == player_name)

# Group data by venue and calculate the total runs scored in each venue
venue_performance <- player_data %>%
  group_by(Venue) %>%
  summarise(Total_Runs = sum(Runs.From.Ball))

# Create a numeric index for each unique venue
venue_index <- as.numeric(factor(venue_performance$Venue))

# Create a 2D scatter plot
a <- plot_ly(
  x = ~venue_index,
  y = ~ venue_performance$Total_Runs,
  type = "scatter",
  mode = "markers",
  marker = list(color = "blue", size = 5),
  text = venue_performance$Venue,
) %>%
  layout(
    title = sprintf("%s Performance in Different Venues", player_name),
    xaxis = list(title = "Venue"),
    yaxis = list(title = "Total Runs")
  )
print(a)

b <- plot_ly(
  x = ~venue_index,
  y = ~ venue_performance$Total_Runs,
  type = "bar",
  marker = list(color = "blue"),
  text = venue_performance$Venue,
) %>%
  layout(
    title = sprintf("%s Performance in Different Venues", player_name),
    xaxis = list(title = "Venue"),
    yaxis = list(title = "Total Runs")
  )


print(b)
