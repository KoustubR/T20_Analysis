# Install and load required packages
library(tidyverse)
library(plotly)

# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")

bowler_data <- cricket_data %>%
  group_by(Bowler) %>%
  summarise(Total_Runs_Conceded = sum(Bowler.Runs.Conceded))

# Create an interactive bar chart
a <- plot_ly(
  data = bowler_data,
  x = ~Bowler,
  y = ~Total_Runs_Conceded,
  type = "bar",
  text = ~ paste("Bowler: ", Bowler, "<br>Total Runs Conceded: ", Total_Runs_Conceded),
  hoverinfo = "text"
) %>%
  layout(
    title = "Total Runs Conceded by Bowler",
    xaxis = list(title = "Bowler"),
    yaxis = list(title = "Total Runs Conceded")
  )
print(a)
