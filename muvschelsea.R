# Loading necessary packages for this project
pacman::p_load(dplyr, tidyr, stringr, janitor, purrr,here,
               tibble, lubridate, glue, rlang, 
               rvest, polite, StatsBombR, soccermatics, 
               ggplot2, worldfootballR, 
               gt, forcats, ggtext, extrafont, 
               understatr, ggsoccer)
## Load fonts
loadfonts(quiet = TRUE)

# Setting the meta data for the match 
home_team = "Chelsea"
away_team = "Manchester United"
home_color = "#034694" 
away_color = "#DA291C"

home_team_logo <- "https://github.com/DrJohan/mufc_19_20season/blob/main/assets/ChelseaFC.png"
away_team_logo <- "https://github.com/DrJohan/mufc_19_20season/blob/main/assets/ManUtdFC.png"

match_date <- "Nov 28, 2021"
league_year <- "Premier League 2021-2022"
matchday <- 1
source_text <- "**Table**: Dr Johan Ibrahim (**Twitter**: @DrJohan81) | **Data**: understat"
match_id <- 16500

# Fetching the data using understatr packages
raw_match_df <- understatr::get_match_stats(match_id)

# Data manipulation 
shots_df <- raw_match_df %>% 
  ## 1. Take out 2 columns we don't really need.
  select(-h_goals, -a_goals) %>% 
  ## 2. Make sure the selected columns are set to numeric type.
  mutate(across(c(minute, xG, X, Y, 
                  player_id, match_id, season), as.numeric)) %>% 
  ## 3. If xG is `NA` then set it to 0.
  ## 4. Relabel the categories in "result", "situation", "lastAction", and "shotType" columns so they're more human-friendly and presentable.
  mutate(xG = if_else(is.na(xG), 0, xG),
         result = case_when(
           result == "SavedShot" ~ "Saved Shot",
           result == "BlockedShot" ~ "Blocked Shot",
           result == "MissedShots" ~ "Missed Shot",
           result == "ShotOnPost" ~ "On Post",
           result == "OwnGoal" ~ "Own Goal",
           TRUE ~ result),
         situation = case_when(
           situation == "OpenPlay" ~ "Open Play", 
           situation == "FromCorner" ~ "From Corner",
           situation == "DirectFreekick" ~ "From Free Kick",
           situation == "SetPiece" ~ "Set Piece",
           TRUE ~ situation),
         lastAction = case_when(
           lastAction == "BallRecovery" ~ "Ball Recovery",
           lastAction == "BallTouch" ~ "Ball Touch",
           lastAction == "LayOff" ~ "Lay Off",
           lastAction == "TakeOn" ~ "Take On",
           lastAction == "Standard" ~ NA_character_,
           lastAction == "HeadPass" ~ "Headed Pass",
           lastAction == "BlockedPass" ~ "Blocked Pass",
           lastAction == "OffsidePass" ~ "Offside Pass",
           lastAction == "CornerAwarded" ~ "Corner Awarded",
           lastAction == "Throughball" ~ "Through ball",
           lastAction == "SubstitutionOn" ~ "Subbed On",
           TRUE ~ lastAction),
         shotType = case_when(
           shotType == "LeftFoot" ~ "Left Foot",
           shotType == "RightFoot" ~ "Right Foot",
           shotType == "OtherBodyPart" ~ "Other",
           TRUE ~ shotType)) %>% 
  ## 5. Consolidate team name into a single column "team_name" based on the "h_a" column.
  mutate(team_name = case_when(
    h_a == "h" ~ h_team,
    h_a == "a" ~ a_team)) %>% 
  ## 6. Add team colors to the row depending on the team.
  mutate(team_color = if_else(team_name == h_team, home_color, away_color)) %>% 
  ## 7. Own Goal is set to the team that conceded it so swap it to the team that actually scored from it.
  mutate(team_name = case_when(
    result == "Own Goal" & team_name == home_team ~ away_team,
    result == "Own Goal" & team_name == away_team ~ home_team,
    TRUE ~ team_name)) %>% 
  ## 8. Set "team_name" as a factor variable.
  mutate(team_name = forcats::as_factor(team_name)) %>% 
  ## 9. Arrange the rows by `id` so that shots are in chronological order.
  arrange(id) %>% 
  ## 10. Separate "player" into two, then re-combine.
  separate(player, into = c("firstname", "player"), 
           sep = "\\s", extra = "merge") %>% 
  ## players like Fabinho are listed without a last name "Tavares"
  ## so just add their name in again if NA
  mutate(player = if_else(is.na(player), firstname, player),
         ## 11. Set a new and cleaner ID for shots so that it starts at 1 and goes to `n`.
         id = row_number())