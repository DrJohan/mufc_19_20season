if (!require("pacman")) {
  install.packages("pacman")  
}

pacman::p_load(tidyverse, polite, scales, ggimage, ggforce,
               understatr, cowplot, kableExtra, ggbeeswarm,
               jsonlite, xml2, qdapRegex, stringi, stringr,
               rvest, glue, extrafont, ggrepel, magick, ggtext, StatsBombR, worldfootballR,
               SBpitch, soccermatics, patchwork, gtable, grid)
loadfonts(quiet = TRUE)

england <- worldfootballR::fb_league_urls(country = "ENG", gender = "M", season_end_year = 2022, tier = "1st")
team_urls <- worldfootballR::fb_teams_urls(england)
mufc22021_urls <- "https://fbref.com/en/squads/19538871/Manchester-United-Stat
mufc_results <- worldfootballR::get_team_match_results(mufc22021_urls)