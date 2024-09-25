library(dplyr)
library(heatmaply)
library(randomForest)
library(caret)

# Importing dataset
t20i_df <- read.csv('ball_by_ball_it20.csv')

cat(sprintf("Dataset successfully Imported of Shape : %s\n", toString(dim(t20i_df))))

# Compute Overs for each Match innings
t20i_df$overs <- as.numeric(paste(t20i_df$Over, '.', t20i_df$Ball, sep = '')) - 1

# Compute Runs in last 5 overs & Wickets in last 5 overs
t20i_df <- t20i_df %>%
  mutate(
    runs_last_5_overs = ifelse(Balls.Remaining < 89, Innings.Runs - lag(Innings.Runs, 30), Innings.Runs),
    wickets_last_5_overs = ifelse(Balls.Remaining < 89, Innings.Wickets - lag(Innings.Wickets, 30), Innings.Wickets)
  )

# Print the dataframe
# print(t20i_df %>% select(runs_last_5_overs,wickets_last_5_overs))

# Assuming 'irrelevant' is a vector of column names to be removed
irrelevant <- c('X', 'Match.ID', 'Date', 'Venue', 'Innings', 'Batter', 'Non.Striker', 'Bowler', 'Over', 'Ball',
                'Batter.Runs', 'Extra.Runs', 'Runs.From.Ball', 'Ball.Rebowled', 'Extra.Type', 'Wicket', 'Method', 
                'Player.Out', 'Runs.to.Get', 'Balls.Remaining', 'Winner', 'Chased.Successfully', 'Total.Batter.Runs',
                'Total.Non.Striker.Runs', 'Batter.Balls.Faced', 'Non.Striker.Balls.Faced', 'Player.Out.Runs', 
                'Player.Out.Balls.Faced', 'Bowler.Runs.Conceded', 'Valid.Ball')

# Before removing irrelevant columns
# print(paste("Before Removing Irrelevant Columns:", ncol(t20i_df)))

# Remove Irrelevant Columns
t20i_df <- t20i_df[, !(names(t20i_df) %in% irrelevant)]

# After removing irrelevant columns
# print(paste("After Removing Irrelevant Columns:", ncol(t20i_df)))

# Display the first 124 rows
# print(head(t20i_df, 124))

# Define Consistent Teams
const_teams <- c('Afghanistan', 'Australia', 'Bangladesh', 'England', 'India', 'Ireland', 
                 'New Zealand', 'Pakistan', 'South Africa', 'Sri Lanka', 'West Indies', 'Zimbabwe')

# Before removing inconsistent teams
# print(paste("Before Removing Inconsistent Teams:", dim(t20i_df)))

# Remove the Non-Consistent Teams
t20i_df <- t20i_df[t20i_df$Bat.First %in% const_teams & t20i_df$Bat.Second %in% const_teams, ]

# After removing inconsistent teams
# print(paste("After Removing Inconsistent Teams:", dim(t20i_df)))

# Display consistent teams
# cat("Consistent Teams: \n", unique(t20i_df$Bat.First), "\n")

# Display the head of the dataframe
# print(head(t20i_df))

# Before removing overs
cat("Before Removing Overs:", dim(t20i_df), "\n")

# Remove rows where 'overs' is less than 5.0
t20i_df <- t20i_df[t20i_df$overs >= 5.0, ]

# After removing overs
cat("After Removing Overs:", dim(t20i_df), "\n")

# Display the head of the dataframe
# print(head(t20i_df))

# Select numerical columns
numerical_t20i_df <- subset(t20i_df, select = c(overs, Innings.Runs, Target.Score, runs_last_5_overs, wickets_last_5_overs))

# Compute correlation matrix
cor_matrix <- cor(numerical_t20i_df)

# Display interactive heatmap using heatmaply
print(heatmaply(cor_matrix, annot = TRUE))

# Convert 'Bat_First' and 'Bat_Second' columns to factors
for (col in c('Bat.First', 'Bat.Second')) {
  t20i_df[[col]] <- factor(t20i_df[[col]])
}

# Apply one-hot encoding using dummyVars
dummy_vars <- dummyVars(" ~ .", data = t20i_df)
t20i_df_encoded <- predict(dummy_vars, newdata = t20i_df)

# Combine the encoded data with the original data
t20i_df <- cbind(t20i_df, t20i_df_encoded)

# Drop the original 'Bat_First' and 'Bat_Second' columns
t20i_df <- t20i_df[, !(names(t20i_df) %in% c('Bat.First', 'Bat.Second'))]

# Display the first few rows of the encoded data
# print(head(t20i_df))

df <- t20i_df
num_cols <- ncol(df)

# Drop the last 6 columns
df <- df[, 1:(num_cols - 6)]
df <- df[, c((7:ncol(df)), (1:6))]
colnames(df) <- gsub(" ", "_", colnames(df))
df <- head(df,10000)
# Separate features and labels
features <- df[, !(names(df) %in% c('Target.Score'))]
labels <- df$Target.Score

# Split the data into training and testing sets
set.seed(123)
splitIndex <- createDataPartition(labels, p = 0.8, list = FALSE)
train_features <- features[splitIndex, ]
test_features <- features[-splitIndex, ]
train_labels <- labels[splitIndex]
test_labels <- labels[-splitIndex]

# Print the dimensions of the training and testing sets
cat("Training Set:", dim(train_features), "\n")
cat("Testing Set:", dim(test_features), "\n")

# Train a decision tree model
tree_model <- randomForest(train_labels ~ ., data = train_features)

# Evaluate the model on the training set
train_score_tree <- cor(tree_model$predicted, train_labels)^2 * 100

# Make predictions on the testing set
predictions <- predict(tree_model, newdata = cbind(test_labels, test_features))

# Evaluate the model on the testing set
test_score_tree <- cor(predictions, test_labels)^2 * 100

print(test_score_tree)

# Print the scores
cat("Train Score:", round(train_score_tree, 2), "%\n")
cat("Test Score:", round(test_score_tree, 2), "%\n")

# Calculate Mean Absolute Error (MAE)
mae_value <- mean(abs(predictions - test_labels))
cat("Mean Absolute Error (MAE):", mae_value, "\n")

# Calculate Mean Squared Error (MSE)
mse_value <- mean((predictions - test_labels)^2)
cat("Mean Squared Error (MSE):", mse_value, "\n")

# Calculate Root Mean Squared Error (RMSE)
rmse_value <- sqrt(mse_value)
cat("Root Mean Squared Error (RMSE):", rmse_value, "\n")

# Save the model to a file
filename <- "random_forest_model.rds"
saveRDS(tree_model, file = filename)

