library(magick)

create_map <- function(data, fill_var, title) {
  mainland <- data[data$NAME != "Alaska", ]
  
  ggplot() +
    geom_sf(data = mainland, aes(fill = .data[[fill_var]])) +
    coord_sf(xlim = c(-130, -65),
             ylim = c(25, 50),
             expand = FALSE,
             datum = NA) +
    scale_fill_viridis_c(option = "viridis") +
    theme_void() +
    theme(
      plot.title = element_text(size = 10, hjust = 0.5),
      legend.title = element_text(size = 10),
      legend.text = element_text(size = 8),
      plot.margin = margin(0, 0, 0, 0),
      legend.position = "right",
      legend.box.margin = margin(0, 0, 0, 0),
    ) +
    labs(
      title = title,
      fill = "Proportion"
    )
}

#(0 = No Symptoms and 16 = All Symptoms Nearly Everyday)
# Create individual plots with viridis scales
p1 <- create_map(map_data, "prop_high_income", "High Income Distribution")
p2 <- create_map(map_data, "prop_high_edu", "Higher Education Distribution")
p3 <- create_map(map_data, "mean_total_mh", "Avg. Symptom Frequency \n (Past 2 Weeks)")
p4 <- create_map(map_data, "psychol", "Mental Healthcare Providers per 100K")

# Combine plots with annotations
socioeconomic_plot <- p1 + p2 +
  plot_annotation(
    title = "US Geographic Distribution of Socioeconomic Metrics and Mental Health"
  )

health_plot <- p3 + p4

# save plots as img and crop so they are the right dimension
ggsave("images/socioeconomic_map.png", plot = socioeconomic_plot)
ggsave("images/health_metrics_map.png", plot = health_plot)

socioeconomic_map <- image_read("images/socioeconomic_map.png") |>
  image_trim() |>
  image_write("images/socioeconomic_map.png")

health_metrics_map <- image_read("images/health_metrics_map.png") |>
  image_trim() |>
  image_write("images/health_metrics_map.png")