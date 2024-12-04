suppressWarnings(suppressMessages(library(tidyverse)))

suppressWarnings(suppressMessages({
  care_data <- read_csv("dataset/care_data.csv")
}))

care_data_sum <- care_data |>
  reframe(st_abbrev, psychol_21, socwk_21, conslrs_21, popn_pums_21)

state_names <- c(
  AL = "alabama",
  AK = "alaska",
  AZ = "arizona",
  AR = "arkansas",
  CA = "california",
  CO = "colorado",
  CT = "connecticut",
  DE = "delaware",
  FL = "florida",
  GA = "georgia",
  HI = "hawaii",
  ID = "idaho", 
  IL = "illinois",
  IN = "indiana",
  IA = "iowa",
  KS = "kansas",
  KY = "kentucky",
  LA = "louisiana",
  ME = "maine",
  MD = "maryland",
  MA = "massachusetts",
  MI = "michigan",
  MN = "minnesota",
  MS = "mississippi",
  MO = "missouri",
  MT = "montana",
  NE = "nebraska",
  NV = "nevada",
  NH = "new hampshire",
  NJ = "new jersey",
  NM = "new mexico",
  NY = "new york",
  NC = "north carolina",
  ND = "north dakota",
  OH = "ohio",
  OK = "oklahoma",
  OR = "oregon",
  PA = "pennsylvania",
  RI = "rhode island",
  SC = "south carolina",
  SD = "south dakota",
  TN = "tennessee",
  TX = "texas",
  UT = "utah",
  VT = "vermont",
  VA = "virginia",
  WA = "washington",
  WV = "west virginia",
  WI = "wisconsin",
  WY = "wyoming"
)

care_data_sum <- care_data_sum |>
  mutate(region = recode(st_abbrev, !!!state_names))

write_rds(care_data_sum, "dataset/care_data_sum.rds")