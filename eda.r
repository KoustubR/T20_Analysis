# Install and load required packages
library(dplyr)
library(ggplot2)
library(gridExtra)


# Read your CSV file
cricket_data <- read.csv("ball_by_ball_it20.csv")

# Display the structure of the dataset
str(cricket_data)

# Summary statistics
summary_stats <- summary(cricket_data)
print("Summary Statistics:")
print(summary_stats)

# Distribution of numerical columns
numeric_columns <- c("Batter.Runs", "Innings.Runs", "Target.Score")

# Create a list to store the plots
plots_list <- list()
for (col in numeric_columns) {
  a <- ggplot(cricket_data, aes(x = !!sym(col))) +
    geom_histogram(binwidth = 1, fill = "blue", color = "white") +
    labs(title = paste("Histogram of", col), x = col, y = "Frequency") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  plots_list[[col]] <- a
}

# Box plots for key numerical columns (replace "Numeric_Column" with actual column name)
key_numeric_columns <- c("Innings.Runs", "Innings.Wickets", "Bowler.Runs.Conceded")
plots_list2 <- list()
for (col in key_numeric_columns) {
  a <- ggplot(cricket_data, aes(x = 1, y = !!sym(col))) +
    geom_boxplot(fill = "lightblue", color = "blue") +
    labs(title = paste("Box Plot of", col), x = NULL, y = col) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  plots_list2[[col]] <- a
}
grid.arrange(grobs = c(plots_list, plots_list2), ncol = 2) # Adjust ncol as needed
