# Clean Household Pulse Survey Data
# OUTPUT: data, data_by_state

# Load required libraries
suppressWarnings(suppressMessages(library(readr)))   # read csv
suppressWarnings(suppressMessages(library(ggplot2)))  # data visualization
suppressWarnings(suppressMessages(library(dplyr)))    # data manipulation

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
  pulse_data <- read.csv("dataset/data_unclean.csv", na = c(NA_VALUE))
}))

# Keep only selected columns and convert -99 to 0
pulse_data <- pulse_data[columns]
pulse_data[pulse_data == ZERO_VALUE] <- 0

# Rename columns to be more intuitive
pulse_data <- pulse_data |>
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

state_lookup <- c(
  '1'='alabama',
  '2'='alaska',
  '4'='arizona',
  '5'='arkansas',
  '6'='california',
  '8'='colorado',
  '9'='connecticut',
  '10'='delaware',
  '11'='district of columbia',
  '12'='florida',
  '13'='georgia',
  '15'='hawaii',
  '16'='idaho',
  '17'='illinois',
  '18'='indiana',
  '19'='iowa',
  '20'='kansas',
  '21'='kentucky',
  '22'='louisiana',
  '23'='maine',
  '24'='maryland',
  '25'='massachusetts',
  '26'='michigan',
  '27'='minnesota',
  '28'='mississippi',
  '29'='missouri',
  '30'='montana',
  '31'='nebraska',
  '32'='nevada',
  '33'='new hampshire',
  '34'='new jersey',
  '35'='new mexico',
  '36'='new york',
  '37'='north carolina',
  '38'='north dakota',
  '39'='ohio',
  '40'='oklahoma',
  '41'='oregon',
  '42'='pennsylvania',
  '44'='rhode island',
  '45'='south carolina',
  '46'='south dakota',
  '47'='tennessee',
  '48'='texas',
  '49'='utah',
  '50'='vermont',
  '51'='virginia',
  '53'='washington',
  '54'='west virginia',
  '55'='wisconsin',
  '56'='wyoming')

pulse_data <- pulse_data |>
  mutate(region = recode(as.character(State_Living_in), !!!state_lookup))

# Save the cleaned dataset to rds file
write_rds(pulse_data, "dataset/pulse_data.rds")