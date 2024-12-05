prepare_data <- function(data) {
  data_with_age <- data |>
    mutate(age = 2024 - Birth_Year)
  
  bind_rows(
    data_with_age |>
      group_by(age) |>
      summarize(
        Anxious_Frequency = mean(Anxious_Frequency),
        Worry_Frequency = mean(Worry_Frequency),
        Little_Interest_Frequency = mean(Little_Interest_Frequency),
        Depressed_Frequency = mean(Depressed_Frequency),
        Average_Mental_Health = (mean(Anxious_Frequency) + mean(Worry_Frequency) + 
                                   mean(Little_Interest_Frequency) + mean(Depressed_Frequency)) / 4
      ) |>
      mutate(variable = "Age", x_value = age),
    
    # Income data
    data |>
      group_by(Household_Income) |>
      summarize(
        Anxious_Frequency = mean(Anxious_Frequency),
        Worry_Frequency = mean(Worry_Frequency),
        Little_Interest_Frequency = mean(Little_Interest_Frequency),
        Depressed_Frequency = mean(Depressed_Frequency),
        Average_Mental_Health = (mean(Anxious_Frequency) + mean(Worry_Frequency) + 
                                   mean(Little_Interest_Frequency) + mean(Depressed_Frequency)) / 4
      ) |>
      mutate(variable = "Income", x_value = as.numeric(Household_Income)),
    
    # Education data
    data |>
      group_by(Educational_Attainment) |>
      summarize(
        Anxious_Frequency = mean(Anxious_Frequency),
        Worry_Frequency = mean(Worry_Frequency),
        Little_Interest_Frequency = mean(Little_Interest_Frequency),
        Depressed_Frequency = mean(Depressed_Frequency),
        Average_Mental_Health = (mean(Anxious_Frequency) + mean(Worry_Frequency) + 
                                   mean(Little_Interest_Frequency) + mean(Depressed_Frequency)) / 4
      ) |>
      mutate(variable = "Education", x_value = as.numeric(Educational_Attainment))
  ) |>
    filter(!is.na(x_value))|>
    pivot_longer(
      cols = c(Anxious_Frequency, Worry_Frequency, 
               Little_Interest_Frequency, Depressed_Frequency,
               Average_Mental_Health),
      names_to = "metric",
      values_to = "value"
    ) |>
    mutate(metric = case_when(
      metric == "Anxious_Frequency" ~ "Anxiety",
      metric == "Worry_Frequency" ~ "Worry",
      metric == "Little_Interest_Frequency" ~ "Interest",
      metric == "Depressed_Frequency" ~ "Depression",
      metric == "Average_Mental_Health" ~ "Average Mental Health"
    ))
}