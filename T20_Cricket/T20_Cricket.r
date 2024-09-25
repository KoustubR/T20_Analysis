# Install and load necessary libraries
if (!require("data.table")) install.packages("data.table")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("plotly")) install.packages("plotly")

library(data.table)
library(tidyverse)
library(ggplot2)
library(plotly)

# Print current working directory
getwd()

ball_by_ball_data <- fread("ball_by_ball_it20.csv")

# Group data by player and calculate metrics
player_metrics <- ball_by_ball_data %>%
  group_by(Batter) %>%
  summarize(
    Total_Runs = sum(`Batter Runs`),
    Strike_Rate = sum(`Batter Runs`) / sum(!is.na(`Batter Runs`)),
    Length_of_Rows = sum(!is.na(`Batter Runs`))
  )

# Display the result
head(player_metrics)

# Create a scatter plot using plotly
scatter_plot <- plot_ly(player_metrics,
  x = ~Total_Runs, y = ~ Strike_Rate * 100,
  text = ~Batter, mode = "markers", marker = list(size = 10),
  color = ~Length_of_Rows, colors = "blue",
  type = "scatter", source = "scatter"
)

# Add labels and titles
scatter_plot <- scatter_plot %>% layout(
  title = "Scatter Plot of Total Runs vs Strike Rate",
  xaxis = list(title = "Total Runs"),
  yaxis = list(title = "Strike Rate"),
  showlegend = TRUE
)

# Show the plot
print(scatter_plot)
