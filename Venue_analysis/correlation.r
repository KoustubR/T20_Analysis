# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")

# Filter out incomplete player data
complete_player_data <- cricket_data %>%
  filter(!is.na(Batter.Runs) | !is.na(Bowler.Runs.Conceded))

# Calculate the total runs scored by each batter
total_batting_runs <- complete_player_data %>%
  group_by(Batter) %>%
  summarise(Total_Batting_Runs = sum(Batter.Runs)) %>%
  filter(!is.na(Total_Batting_Runs))

# Calculate the total runs conceded by each bowler
total_bowling_runs_conceded <- complete_player_data %>%
  group_by(Bowler) %>%
  summarise(Total_Bowling_Runs_Conceded = sum(Bowler.Runs.Conceded)) %>%
  filter(!is.na(Total_Bowling_Runs_Conceded))

# Print or visualize the total runs scored by each batter+
print(total_batting_runs)

# Print or visualize the total runs conceded by each bowler
print(total_bowling_runs_conceded)

# Merge the batting and bowling data based on the common player names
merged_data <- merge(total_batting_runs, total_bowling_runs_conceded, by.x = "Batter", by.y = "Bowler", all = TRUE)
merged_data <- na.omit(merged_data)
print(head(merged_data))

# Create a scatter plot using plotly
plotly_scatter <- plot_ly(
  data = merged_data,
  x = ~Total_Batting_Runs,
  y = ~Total_Bowling_Runs_Conceded,
  text = ~Batter,
  mode = "markers",
  type = "scatter",
  marker = list(size = 10, color = "blue")
)

# Add axis labels and title
plotly_scatter <- plotly_scatter %>% layout(
  xaxis = list(title = "Total Batting Runs"),
  yaxis = list(title = "Total Bowling Runs Conceded"),
  title = "Batting Runs vs. Bowling Runs for Players"
)

# Show the plot
print(plotly_scatter)
