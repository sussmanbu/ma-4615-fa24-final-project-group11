suppressWarnings(suppressMessages(library(tidyverse)))

suppressWarnings(suppressMessages({
  care_data <- read_csv("dataset/care_data.csv")
}))

care_data <- care_data |>
  reframe(st_abbrev, psychol_21, socwk_21, conslrs_21, popn_pums_21)

state_names <- setNames(tolower(state.name), state.abb)

care_data <- care_data |>
  mutate(region = recode(st_abbrev, !!!state_names))

write_rds(care_data, "dataset/care_data.rds")