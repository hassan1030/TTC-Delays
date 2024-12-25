cat("\014") #Clears the console
rm(list = ls()) #Clears the global environment 
try(dev.off(dev.list()["R Studio"]), silent = TRUE) #Clears the plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) #Clears package
options(scipen = 100) #disables scientific notation for entire R session

ttc <- read.csv("/Users/muhammadhassanzahoor/Desktop/NEU/ALY 6010/Final Project/Final_Project/ttc-bus-delay-data-2021.csv")

library(tidyverse)
library("psych")
library(ggplot2)
library(knitr)
library(lubridate)
library(kableExtra)
library(readr)
library(dplyr)
library(stats)
library(broom)

#describing the data
str(ttc)
summary(ttc)
describe_ttc <- describe(ttc)
describe_ttc

#Cleaning data by removing any rows with missing values to better understand
data_clean <- na.omit(ttc)
data_clean

#Regression Hypothesis 1 (Impact of Incident Type on Delay Duration):
# Null Hypothesis (H0): The type of incident (Mechanical, Emergency Services, Vision, etc.) has no significant impact on the duration of delay (Min Delay) for TTC buses.
#Alternative Hypothesis (H1): The type of incident significantly impacts the duration of delay for TTC buses.

# Convert 'Incident' to a factor
ttc_incident <- ttc$Incident <- as.factor(ttc$Incident)
ttc_incident

#Since we have a lot of incidents, we will be focusing on just the 5 common incidents

# Identify the 5 most common incidents
top_incidents <- names(sort(table(ttc$Incident), decreasing = TRUE)[1:5])

# Filter the data to include only the top 5 incidents and convert 'Incident' to a factor
ttc_top <- ttc %>%
  filter(Incident %in% top_incidents) %>%
  mutate(Incident = factor(Incident, levels = top_incidents))

# Create the linear regression model
model1_top <- lm(Min.Delay ~ Incident, data = ttc_top)
model1_top

# Output the summary of the model
summary_model1_top <- summary(model1_top)
summary_model1_top

# Create a regression table
regression_table_top <- tidy(model1_top)

# Print the regression table
print(regression_table_top)

# Basic plot of residuals
plot(model1_top$residuals, main = "Residuals of the Model")

# Diagnostic plots for the model
par(mfrow = c(2, 2))
plot(model1_top)

# Run an ANOVA to check overall model significance
anova_model1_top <- anova(model1_top)
anova_model1_top

# Scatterplot with linear regression line using ggplot2
ggplot(ttc_top, aes(x = Route, y = Min.Delay)) +
  geom_point(alpha = 0.5) +  # Add transparency to points
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Scatterplot with Linear Regression Line", x = "Route", y = "Min Delay")

# Boxplot to visualize delays by top incident types
ggplot(ttc_top, aes(x = Incident, y = Min.Delay)) +
  geom_boxplot() +
  labs(title = "Boxplot of Min Delay by Top Incident Types", x = "Incident Type", y = "Min Delay")

#  Jitterplot with linear regression line for each incident type
jitterplot_top <- ggplot(ttc_top, aes(x = Incident, y = Min.Delay, color = Incident)) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Jitterplot for Top Incidents",
       x = "Incident Type", y = "Min Delay") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Adjusting the angle of x-axis labels



# Print the model summary and plots
print(summary_model1_top)
print(jitterplot_top)





#Hypothesis 2
#Regression Hypothesis 2 (Effect of Time of Day on Delay Duration):
#Null Hypothesis (H0): The time of day does not significantly affect the duration of delay (Min Delay) for TTC buses.
#Alternative Hypothesis (H1): The time of day has a significant effect on the duration of delay for TTC buses.

# Convert 'Date' to Date type and 'Day' to a factor
ttc$Date <- as.Date(ttc$Date, format="%m/%d/%Y")
ttc$Day <- as.factor(ttc$Day)

# Define public holidays in Canada for the year 2021
public_holidays <- as.Date(c("2021-01-01", "2021-02-15", "2021-04-02", 
                             "2021-05-24", "2021-07-01", "2021-09-06", 
                             "2021-10-11", "2021-12-25", "2021-12-26"))

# Classify each day as a holiday or a regular day
ttc$IsHoliday <- ttc$Date %in% public_holidays

# Perform a two-sample T-test
weekday_delays <- ttc[!ttc$IsHoliday & !ttc$Day %in% c('Saturday', 'Sunday'), 'Min.Delay']
holiday_delays <- ttc[ttc$IsHoliday, 'Min.Delay']

t_test_results <- t.test(weekday_delays, holiday_delays, var.equal = FALSE)
t_test_results

#Performing a variance test between weekday delays and holidat delays
variance_test_results <- var.test(weekday_delays, holiday_delays)
variance_test_results

# Calculate 95% Confidence Interval
alpha <- 0.05
ci <- t_test_results$conf.int

# Output the results
print(paste("95% CI: [", ci[1], ", ", ci[2], "]", sep = ""))

# Create boxplots
ggplot(ttc, aes(x = as.factor(IsHoliday), y = Min.Delay)) +
  geom_boxplot() +
  labs(title = "Boxplot of Delays: Weekday vs. Holiday", x = "Is Holiday", y = "Min Delay")

# Create histograms
ggplot(ttc, aes(x = Min.Delay, fill = as.factor(IsHoliday))) +
  geom_histogram(position = "dodge", binwidth = 1) +
  labs(title = "Histogram of Delays", x = "Min Delay", y = "Frequency") +
  scale_fill_discrete(name = "Is Holiday")


# Prepare a summary table
summary_table <- data.frame(
  Test = c("Two-sample t-test: Weekday vs Holiday"),
  Statistic = c(t_test_results$statistic),
  P_Value = c(t_test_results$p.value)
)
summary_table

# Create a nicely formatted table using knitr's kable function
kable(summary_table, format = "html", 
      col.names = c("Test", "Statistic", "P-Value"),
      caption = "Summary of Hypothesis Tests") %>%
  kable_styling(bootstrap_options = c("striped", "hover"))



#Hypothesis 3
#Regression Hypothesis 2 (Effect of Time of Day on Delay Duration):
#Null Hypothesis (H0): The time of day does not significantly affect the duration of delay (Min Delay) for TTC buses.
#Alternative Hypothesis (H1): The time of day has a significant effect on the duration of delay for TTC buses.

# Convert 'Time' to a numerical value representing the hour of the day
ttc <- ttc %>%
  mutate(Time = as.numeric(substring(Time, 1, 2))) %>% 
  na.omit() # Remove NA values if any conversion failed

# Create the linear model
lm_model <- lm(Min.Delay ~ Time, data = ttc)
lm_model
# Output the summary of the model
summary_lm_model <- summary(lm_model)
summary_lm_model

plot(lm_model$residual, main = "Residuals of the Model")

#Diagnostic plots for the model
par(mfrow = c(2, 2))
plot(lm_model)

# Scatterplot with regression line and confidence interval
scatterplot <- ggplot(ttc, aes(x = Time, y = Min.Delay)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", level = 0.95) +
  labs(title = "Time of Day vs. Min Delay", x = "Time of Day", y = "Min Delay")
scatterplot

# Plot the residuals to check for homoscedasticity
residuals_time_of_day <- ggplot(ttc, aes(x = lm_model$fitted.values, y = lm_model$residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted Values", x = "Fitted Values", y = "Residuals")
residuals_time_of_day

# Create regression table
regression_table <- tidy(lm_model)

# Display the regression table
print(regression_table)

# Save the model summary to a dataframe for reporting
summary_df_time_of_day <- broom::tidy(lm_model)

# Create a regression table
regression_table_time_of_day <- kable(summary_df_time_of_day, format = "html", 
                                      col.names = c("Term", "Estimate", "Std. Error", "Statistic", "P-Value"),
                                      caption = "Regression Analysis: Effect of Time of Day on Min Delay") %>%
  kable_styling(bootstrap_options = c("striped", "hover"))
regression_table_time_of_day


