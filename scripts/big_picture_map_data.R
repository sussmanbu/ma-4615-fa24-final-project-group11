joint_data <- read.csv("dataset/joint_data.csv") |>
  mutate(total_mentalhealth = Anxious_Frequency + Worry_Frequency + 
           Little_Interest_Frequency + Depressed_Frequency)

joint_data <- joint_data |>
  group_by(region) |>
  reframe(mean_edu = mean(Educational_Attainment),
          children_need = sum(Children_Need_for_Mental_Health_Treatment, na.rm = TRUE),
          children_receive = sum(Children_Receive_Mental_Health_Treatment, na.rm = TRUE),
          mean_income = mean(Household_Income, na.rm = TRUE),
          mean_total_mh = mean(total_mentalhealth, na.rm = TRUE),
          psychol = mean(psychol_21 / (popn_pums_21/100000)),
          high_income = sum(Household_Income >= 8, na.rm = TRUE),
          total_inc = sum(Household_Income == Household_Income, na.rm = TRUE), 
          prop_high_income = high_income/total_inc, 
          high_edu = sum(Educational_Attainment >= 6, na.rm = TRUE),
          total_edu = sum(Educational_Attainment == Educational_Attainment, na.rm = TRUE),
          prop_high_edu = high_edu/total_edu
  )

v2020 <- load_variables(2020, "pl", cache = TRUE)

census_data <- get_decennial(
  geography = "state",
  variables = c(
    "pop_total" = "P1_001N"
  ) ,
  year = 2020,
  geometry = TRUE
) 

census_data <- census_data |>
  mutate(region = tolower(NAME))

map_data <- left_join(census_data, joint_data, by = "region")

saveRDS(map_data, "dataset/map_data.rds")