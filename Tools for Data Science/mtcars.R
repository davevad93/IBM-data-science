# Load necessary libraries
library(dplyr)
library(ggplot2)
library(caret)
library(corrplot)

# Load the dataset
data("mtcars")
df <- mtcars

# Step 1: Check for missing values
if (sum(is.na(df)) > 0) {
  df <- na.omit(df)
}

# Step 2: Exploratory Data Analysis (EDA)
summary(df)
pairs(df)

cor_matrix <- cor(df)
print(cor_matrix)
corrplot::corrplot(cor_matrix, method = "circle")

# Step 3: Split the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(df$mpg, p = 0.8, list = FALSE)
train <- df[trainIndex, ]
test <- df[-trainIndex, ]

# Step 4: Build a linear regression model
model <- lm(mpg ~ ., data = train)
summary(model)

# Step 5: Predict on the test set and evaluate the model
predictions <- predict(model, test)
mse <- mean((predictions - test$mpg)^2)
rmse <- sqrt(mse)
rsq <- 1 - sum((predictions - test$mpg)^2) / sum((mean(train$mpg) - test$mpg)^2)

cat("MSE:", mse, "\nRMSE:", rmse, "\nR-squared:", rsq, "\n")

# Step 6: Visualize the results
ggplot(test, aes(x = mpg, y = predictions)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = 'red') +
  labs(title = "Actual vs Predicted MPG", x = "Actual MPG", y = "Predicted MPG")
