# Loading necessary packages for this project
pacman::p_load(dplyr, tidyr, stringr, janitor, purrr,
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

home_team_logo <- "https://i.imgur.com/RlXYW46.png"
away_team_logo <- "https://i.imgur.com/r6Y9lT8.png"

match_date <- "Nov 28, 2021"
league_year <- "Premier League 2021-2022"
matchday <- 1
source_text <- "**Table**: Dr Johan Ibrahim (**Twitter**: @DrJohan81) | **Data**: understat"
match_id <- 16500

# Fetching the data using understatr packages
raw_match_df <- understatr::get_match_stats(match_id)
