# install.packages("dplyr", "ggplot2", "plotly", "grideextra", "tidyverse","tidyr","heatmaply","randomForest","caret")
library(dplyr)
# Function to perform analysis based on user input
perform_analysis <- function(choice) {
  if (choice == "1") {
    cat("1. Average Score \n")
    cat("2. Batting Order \n")
    cat("3. Extras Impact \n")
    cat("4. Win Loss \n")

    ch <- readline("Enter Choice : ")

    result <- case_when(
      ch == "1" ~ "Team_Performance\\average_score.r",
      ch == "2" ~ "Team_Performance\\batting_order.r",
      ch == "3" ~ "Team_Performance\\extras_impact.r",
      ch == "4" ~ "Team_Performance\\win_loss.r",
      TRUE ~ "Venue_analysis\\win_loss.r"
    )
    source(result)
  } else if (choice == "2") {
    cat("1. Batsman Analysis \n")
    cat("2. Bowler Analysis \n")
    cat("3. Correlation Between Runs Scored v Conceded \n")
    cat("4. Player Performance \n")
    cat("5. Venue Analysis \n")
    ch <- readline("Enter Choice : ")

    result <- case_when(
      ch == "1" ~ "Venue_analysis\\batsman_analysis.r",
      ch == "2" ~ "Venue_analysis\\bowler_analysis.r",
      ch == "3" ~ "Venue_analysis\\correlation.r",
      ch == "4" ~ "Venue_analysis\\player_performance.r",
      ch == "5" ~ "Venue_analysis\\venue_analysis.r",
      TRUE ~ "Venue_analysis\\venue_analysis.r"
    )
    source(result)
  } else if (choice == "3") {

       cat("1. Predictions Testing \n")
    cat("2. T20 Cricket \n")
    cat("3. Total Runs Predictor \n")
    ch <- readline("Enter Choice : ")

    result <- case_when(
    ch == "1" ~ "T20_Cricket\\predictions_testing.r",
    ch == "2" ~ "T20_Cricket\\T20_Cricket.r",
    ch == "3" ~ "T20_Cricket\\total_runs_predictor.r",
    TRUE ~ "T20_Cricket\\total_runs_predictor.r3"
  )
  source(result)

  } else {
    source("eda.r")
  }
}
# Main script
cat("\n\nWelcome to the Analysis Menu\n")
cat("1. Team Performance\n")
cat("2. Venue Analysis\n")
cat("3. T20 Cricket\n")
cat("4. EDA\n\n")

# Get user input
user_choice <- readline("Enter the number corresponding to the analysis you want to perform: ")

# Perform analysis based on user input
perform_analysis(user_choice)
