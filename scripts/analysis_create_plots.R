# Function to create plots and print key model metrics
create_plots <- function(data, prepared_data) {
  # Add age to the original data first
  data <- data %>% 
    mutate(age = 2024 - Birth_Year,
           # Create average mental health score
           avg_mental_health = (Anxious_Frequency + Worry_Frequency + 
                                  Little_Interest_Frequency + Depressed_Frequency) / 4)
  
  # Reorder the levels of metric to ensure Average Mental Health appears last (on top)
  prepared_data <- prepared_data %>%
    mutate(metric = factor(metric, 
                           levels = c("Anxiety", "Depression", "Interest", "Worry", "Average Mental Health")))
  
  # Line plot with modified appearance
  line_plot <- ggplot(prepared_data, aes(x = x_value, y = value, color = metric, linetype = metric)) +
    geom_smooth(method = "lm", se = FALSE, size = 0.7, alpha = 0.1) +
    facet_wrap(~variable, scales = "free_x") +
    scale_y_continuous(limits = c(1, 2)) +
    scale_linetype_manual(values = c(
      "Anxiety" = "solid",
      "Depression" = "solid",
      "Interest" = "solid",
      "Worry" = "solid",
      "Average Mental Health" = "dotted"
    )) +
    scale_color_manual(values = c(
      "Anxiety" = "#F8766D",
      "Depression" = "#00BA38",
      "Interest" = "#619CFF",
      "Worry" = "#F564E3",
      "Average Mental Health" = "black"
    )) +
    labs(x = "Value", y = "Average Score", 
         title = "Mental Health Components by Demographics") +
    theme_minimal() +
    theme(
      legend.position = "top",
      legend.title = element_blank()
    )
  
  # QQ plots data
  qq_data <- bind_rows(
    data.frame(
      theoretical = qqnorm(resid(lm(avg_mental_health ~ age, data)), plot.it = FALSE)$x,
      sample = qqnorm(resid(lm(avg_mental_health ~ age, data)), plot.it = FALSE)$y,
      variable = "Age"),
    data.frame(
      theoretical = qqnorm(resid(lm(avg_mental_health ~ Household_Income, data)), plot.it = FALSE)$x,
      sample = qqnorm(resid(lm(avg_mental_health ~ Household_Income, data)), plot.it = FALSE)$y,
      variable = "Income"),
    data.frame(
      theoretical = qqnorm(resid(lm(avg_mental_health ~ Educational_Attainment, data)), plot.it = FALSE)$x,
      sample = qqnorm(resid(lm(avg_mental_health ~ Educational_Attainment, data)), plot.it = FALSE)$y,
      variable = "Education")
  )
  
  # QQ plot
  qq_plot <- ggplot(qq_data, aes(x = theoretical, y = sample)) +
    geom_point(alpha = 0.1) +
    geom_abline(color = "red", linetype = "dashed") +
    facet_wrap(~variable) +
    labs(title = "Q-Q Plots by Demographic Variable") +
    theme_minimal()
  
  # Create and extract key metrics from models
  print_key_metrics <- function(model, variable_name) {
    summary_stats <- summary(model)
    coef_table <- summary_stats$coefficients
    
    cat(sprintf("\n%s Analysis:", variable_name))
    cat(sprintf("\nEffect: %.4f (p < %.3e)", 
                coef_table[2, 1],  # coefficient
                coef_table[2, 4])) # p-value
    cat(sprintf("\nR-squared: %.3f%%\n", 
                summary_stats$r.squared * 100))
  }
  
  # Print key metrics for each model
  # print_key_metrics(lm(avg_mental_health ~ age, data), "Age")
  # print_key_metrics(lm(avg_mental_health ~ Household_Income, data), "Income")
  # print_key_metrics(lm(avg_mental_health ~ Educational_Attainment, data), "Education")
  
  # Return both plots
  list(line_plot = line_plot, qq_plot = qq_plot)
}