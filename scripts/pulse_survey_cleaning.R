# Load required libraries
library(readr)      # reading CSV files
library(ggplot2)    # data visualization
library(dplyr)      # data manipulation
library(patchwork)  # combining plots

# Define data cleaning parameters
NA_VALUE <- "-88"     # value indicating "Missing / Did not report"
ZERO_VALUE <- -99     # value indicating "Question seen but not selected"

# Columns to keep (43 out of 220 original variables)
columns <- c(
  # Demographic variables
  "TBIRTH_YEAR", "RHISPANIC", "RRACE", "EEDUC", "MS", 
  "EGENID_BIRTH", "RGENID_DESCRIBE", "SEXUAL_ORIENTATION_RV",
  
  # Education enrollment variables
  "ENRPUBCHK", "ENRPRVCHK", "ENRHMSCHK",
  
  # Military service variables
  "ACTVDUTY1", "ACTVDUTY2", "ACTVDUTY3", "ACTVDUTY4", "ACTVDUTY5",
  "VETERAN1", "VETERAN2", "VETERAN3", "VETERAN4", "VETERAN5",
  
  # Employment variables
  "WRKLOSSRV", "ANYWORK", "KINDWORK", "RSNNOWRKRV",
  
  # Mental health variables
  "ANXIOUS", "WORRY", "INTEREST", "DOWN",
  "MHLTH_NEED", "MHLTH_GET", "MHLTH_SATISFD", "MHLTH_DIFFCLT",
  
  # Social support variables
  "SOCIAL1", "SOCIAL2",
  
  # Healthcare variables
  "PRIVHLTH", "PUBHLTH",
  
  # Location and income
  "EST_ST", "INCOME",
  
  # Additional support metrics
  "SUPPORT1", "SUPPORT2", "SUPPORT3", "SUPPORT4_RV"
)

# Read and clean the data
suppressWarnings(suppressMessages({
  data_unclean <- read_csv("dataset/data_unclean.csv", na = c(NA_VALUE))
}))

# Keep only selected columns and convert -99 to 0
data_unclean <- data_unclean[columns]
data_unclean[data_unclean == ZERO_VALUE] <- 0

# Display NA counts for each variable
print("Number of NA values per column:")
print(colSums(is.na(data_unclean[columns])))

# Example analysis for MHLTH_DIFFCLT
print("Number of responses for MHLTH_DIFFCLT:")
print(sum(!is.na(data_unclean$MHLTH_DIFFCLT)))

# Create visualization for MHLTH_DIFFCLT responses by birth year
plot <- ggplot(
  data = data_unclean[!is.na(data_unclean$MHLTH_DIFFCLT),],
  mapping = aes(x = TBIRTH_YEAR, fill = as.factor(MHLTH_DIFFCLT))
) + 
  geom_histogram() + 
  ggtitle(
    "MHLTH_DIFFCLT vs birth year",
    subtitle = "MHLTH_DIFFCLT: A participant's difficulty finding mental health treatment for their child(ren)"
  ) +
  labs(
    caption = paste(
      "Legend values:",
      "0: Question seen but category not selected",
      "1: Not difficult",
      "2: Somewhat difficult",
      "3: Very difficult",
      "4: Unable to get treatment due to difficulty",
      "5: Did not try to get treatment",
      sep = "\n"
    )
  )

print(plot)

# Rename columns to be more intuitive
data_unclean <- data_unclean |>
  rename(
    # Demographic renames
    Birth_Year = TBIRTH_YEAR,
    Hispanic = RHISPANIC,
    Race = RRACE,
    Educational_Attainment = EEDUC,
    Marital_Status = MS,
    Gender_at_Birth = EGENID_BIRTH,
    Gender_Identity = RGENID_DESCRIBE,
    Sexuality = SEXUAL_ORIENTATION_RV,
    
    # Education renames
    Public_School = ENRPUBCHK,
    Private_School = ENRPRVCHK,
    Home_School = ENRHMSCHK,
    
    # Military service renames
    Not_Currently_Serving_in_US_Armed_Forces = ACTVDUTY1,
    Serving_on_Active_Duty = ACTVDUTY2,
    Serving_in_Reserve_or_National_Guard = ACTVDUTY3,
    Spouse_Serving_on_Active_Duty = ACTVDUTY4,
    Spouse_Serving_in_Reserve_or_National_Guard = ACTVDUTY5,
    Not_Served_in_US_Armed_Forces = VETERAN1,
    Served_on_Active_Duty = VETERAN2,
    Served_in_Reserve_or_National_Guard = VETERAN3,
    Spouse_Served_on_Active_Duty = VETERAN4,
    Spouse_Served_in_Reserve_or_National_Guard = VETERAN5,
    
    # Employment renames
    Job_Loss = WRKLOSSRV,
    Employment_Status = ANYWORK,
    Kind_of_Work = KINDWORK,
    Reason_Not_Working = RSNNOWRKRV,
    
    # Mental health renames
    Anxious_Frequency = ANXIOUS,
    Worry_Frequency = WORRY,
    Little_Interest_Frequency = INTEREST,
    Depressed_Frequency = DOWN,
    Children_Need_for_Mental_Health_Treatment = MHLTH_NEED,
    Children_Receive_Mental_Health_Treatment = MHLTH_GET,
    Satisfaction_with_Treatment = MHLTH_SATISFD,
    Difficulty_getting_Treatment = MHLTH_DIFFCLT,
    
    # Social and support renames
    Social_and_Emotional_Support = SOCIAL1,
    Lonely_Frequency = SOCIAL2,
    Private_Health_Insurance = PRIVHLTH,
    Public_Health_Insurance = PUBHLTH,
    State_Living_in = EST_ST,
    Household_Income = INCOME,
    Family_Friends_Neighbors_Phonecall_Frequency = SUPPORT1,
    Friends_Relative_Get_Together_Frequency = SUPPORT2,
    Church_Religious_Services_Attendance_Frequency = SUPPORT3,
    Club_Organization_Meetings_Attendance_Frequency = SUPPORT4_RV
  )

# Save the cleaned dataset
write_rds(data_unclean, "dataset/data_clean.rds")
