library(randomForest)
generate_test_data <- function() {
  # Create a data frame with the specified structure
  test_data <- data.frame(
    test_labels = c(259, 259, 259, 259, 259, 259),
    Bat.First.Afghanistan = rep(0, 6),
    Bat.First.Australia = rep(0, 6),
    Bat.First.Bangladesh = rep(0, 6),
    Bat.First.England = rep(0, 6),
    Bat.First.India = rep(0, 6),
    Bat.First.Ireland = rep(0, 6),
    Bat.First.New_Zealand = rep(0, 6),
    Bat.First.Pakistan = rep(0, 6),
    Bat.First.South_Africa = rep(0, 6),
    Bat.First.Sri_Lanka = rep(0, 6),
    Bat.First.West_Indies = c(1, 1, 1, 1, 1, 1),
    Bat.First.Zimbabwe = rep(0, 6),
    Bat.Second.Afghanistan = rep(0, 6),
    Bat.Second.Australia = rep(0, 6),
    Bat.Second.Bangladesh = rep(0, 6),
    Bat.Second.England = rep(0, 6),
    Bat.Second.India = rep(0, 6),
    Bat.Second.Ireland = rep(0, 6),
    Bat.Second.New_Zealand = rep(0, 6),
    Bat.Second.Pakistan = rep(0, 6),
    Bat.Second.South_Africa = c(1, 1, 1, 1, 1, 1),
    Bat.Second.Sri_Lanka = rep(0, 6),
    Bat.Second.West_Indies = rep(0, 6),
    Bat.Second.Zimbabwe = rep(0, 6),
    Innings.Runs = c(57, 99, 105, 116, 140, 141),
    Innings.Wickets = rep(1, 6),
    overs = c(5.1, 8.1, 8.2, 8.4, 10.5, 11.1),
    runs_last_5_overs = c(57, 67, 73, 83, 78, 67),
    wickets_last_5_overs = c(1, 0, 0, 0, 2, 2)
  )

  return(test_data)
}

# Example usage
test_data <- generate_test_data()
print(test_data)

loaded_model <- readRDS("random_forest_model.rds")

predictions <- predict(loaded_model, newdata = test_data)
print(predictions)
