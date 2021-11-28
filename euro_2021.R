pacman::p_load("colorspace", "curl", "BasketballAnalyzeR", 
               "tidyverse", "htmltab", "stringr", "gridExtra", "cowplot" )

# Group A
url1 <- "https://fbref.com/en/matches/caa84313/Italy-Switzerland-June-16-2021-UEFA-Euro"
url2 <- "https://fbref.com/en/matches/95a9ebd1/Turkey-Italy-June-11-2021-UEFA-Euro"
url3 <- "https://fbref.com/en/matches/f09b64db/Turkey-Wales-June-16-2021-UEFA-Euro"
url4 <- "https://fbref.com/en/matches/d9eaa85c/Wales-Switzerland-June-12-2021-UEFA-Euro"
url5 <- "https://fbref.com/en/matches/b756c626/Italy-Wales-June-20-2021-UEFA-Euro"
url6 <- "https://fbref.com/en/matches/fa85a731/Switzerland-Turkey-June-20-2021-UEFA-Euro"
url_group_A <- rbind(url1, url2, url3, url4, url5, url6)

# Group B
url7 <- "https://fbref.com/en/matches/e594174b/Belgium-Russia-June-12-2021-UEFA-Euro"
url8 <- "https://fbref.com/en/matches/25bb1fa2/Denmark-Belgium-June-17-2021-UEFA-Euro"
url9 <- "https://fbref.com/en/matches/2c48acb2/Finland-Russia-June-16-2021-UEFA-Euro"
url10 <- "https://fbref.com/en/matches/c3c2ffa2/Denmark-Finland-June-12-2021-UEFA-Euro"
url11 <- "https://fbref.com/en/matches/bd35edec/Finland-Belgium-June-21-2021-UEFA-Euro"
url12 <- "https://fbref.com/en/matches/04188c5c/Russia-Denmark-June-21-2021-UEFA-Euro"
url_group_B <- rbind(url7, url8, url9, url10, url11, url12)

# Group C
url13 <- "https://fbref.com/en/matches/f3d39a29/Netherlands-Austria-June-17-2021-UEFA-Euro"
url14 <- "https://fbref.com/en/matches/b47a0ea6/Austria-North-Macedonia-June-13-2021-UEFA-Euro"
url15 <- "https://fbref.com/en/matches/e0eed6e8/Ukraine-North-Macedonia-June-17-2021-UEFA-Euro"
url16 <- "https://fbref.com/en/matches/0e9919a5/Netherlands-Ukraine-June-13-2021-UEFA-Euro"
url17 <- "https://fbref.com/en/matches/841065f5/North-Macedonia-Netherlands-June-21-2021-UEFA-Euro"
url18 <- "https://fbref.com/en/matches/7ed46abd/Ukraine-Austria-June-21-2021-UEFA-Euro"
url_group_C <- rbind(url13, url14, url15, url16, url17, url18)

# Group D
url19 <- "https://fbref.com/en/matches/6599f4ab/Scotland-Czech-Republic-June-14-2021-UEFA-Euro"
url20 <- "https://fbref.com/en/matches/1e930db9/Croatia-Czech-Republic-June-18-2021-UEFA-Euro"
url21 <- "https://fbref.com/en/matches/764c27dc/England-Croatia-June-13-2021-UEFA-Euro"
url22 <- "https://fbref.com/en/matches/027b11df/England-Scotland-June-18-2021-UEFA-Euro"
url23 <- "https://fbref.com/en/matches/20b1972b/Czech-Republic-England-June-22-2021-UEFA-Euro"
url24 <- "https://fbref.com/en/matches/0305e42c/Croatia-Scotland-June-22-2021-UEFA-Euro"
url_group_D <- rbind(url19, url20, url21, url22, url23, url24)

# Group E
url25 <- "https://fbref.com/en/matches/107fd412/Spain-Sweden-June-14-2021-UEFA-Euro"
url26 <- "https://fbref.com/en/matches/d35ad7a8/Poland-Slovakia-June-14-2021-UEFA-Euro"
url27 <- "https://fbref.com/en/matches/c6533f76/Sweden-Slovakia-June-18-2021-UEFA-Euro"
url28 <- "https://fbref.com/en/matches/14874531/Spain-Poland-June-19-2021-UEFA-Euro"
url29 <- "https://fbref.com/en/matches/ee6087f4/Sweden-Poland-June-23-2021-UEFA-Euro"
url30 <- "https://fbref.com/en/matches/7b46b857/Slovakia-Spain-June-23-2021-UEFA-Euro"
url_group_E <- rbind(url25, url26, url27, url28, url29, url30)

# Group F
url31 <- "https://fbref.com/en/matches/95d34c87/France-Germany-June-15-2021-UEFA-Euro"
url32 <- "https://fbref.com/en/matches/ba500d70/Hungary-Portugal-June-15-2021-UEFA-Euro"
url33 <- "https://fbref.com/en/matches/988198ba/Hungary-France-June-19-2021-UEFA-Euro"
url34 <- "https://fbref.com/en/matches/e33c4403/Portugal-Germany-June-19-2021-UEFA-Euro"
url35 <- "https://fbref.com/en/matches/5a7e53d8/Portugal-France-June-23-2021-UEFA-Euro"
url36 <- "https://fbref.com/en/matches/a4888546/Germany-Hungary-June-23-2021-UEFA-Euro"
url_group_F <- rbind(url31, url32, url33, url34, url35, url36)

#####
# Step 5: Read a single pair of tables for a single game
#####
# Choose a game from the list of URLs from the previous step
selected_game <- url35

# Some data manipulation to get the date and teams from the URLs
game_data <- substr(selected_game, 39, nchar(selected_game)-10)
date <- substr(game_data, nchar(game_data)-11, nchar(game_data))
teams <- substr(game_data, 1, nchar(game_data)-13)
teams <- str_replace(teams, "Czech-Republic", "Czech Republic")
teams <- str_replace(teams, "North-Macedonia", "North Macedonia")

teamA <- sub("-.*", "", teams)
teamB <- sub(".*-", "", teams)

#define the node
node <- "#stats_b561dd30_defense"

#add the node to the URL
url <- paste0(url35, node)

#read first table and add the date and teams
statA <- htmltab(doc = url, which = 4, rm_nodata_cols = F)
statA <- cbind(date, Team=teamA, Opponent=teamB, statA)

#read second table and add the date and teams
statB <- htmltab(doc = url, which = 11, rm_nodata_cols = F)
statB <- cbind(date, Team=teamB, Opponent=teamA, statB)

#combine the two table rows
stat_both <- rbind(statA, statB)
stat_both$Player <- str_trim(stat_both$Player, side = c("both", "left", "right"))


#####
# Step 6: Read all tables for all games
#####

#combine all game URLs for all groups
selected_urls <- rbind(url_group_A, url_group_B, url_group_C, url_group_D, url_group_E, url_group_F)

#initialize tables
all_stat <- NULL
full_stat <- NULL

for (g in 1:length(selected_urls)){
  # Get the game info from the URL
  game_data <- substr(selected_urls[g], 39, nchar(selected_urls[g])-10)
  date <- substr(game_data, nchar(game_data)-11, nchar(game_data))
  teams <- substr(game_data, 1, nchar(game_data)-13)
  teams <- str_replace(teams, "Czech-Republic", "Czech Republic")
  teams <- str_replace(teams, "North-Macedonia", "North Macedonia")
  teamA <- sub("-.*", "", teams)
  teamB <- sub(".*-", "", teams)
  
  #read the first pair of tables
  node <- "#stats_b561dd30_defense"
  url <- paste0(selected_urls[g], node)
  statA <- htmltab(doc = url, which = 4, rm_nodata_cols = F)
  statA <- cbind(date, Team=teamA, Opponent=teamB, statA)
  statB <- htmltab(doc = url, which = 11, rm_nodata_cols = F)
  statB <- cbind(date, Team=teamB, Opponent=teamA, statB)
  stat_both <- rbind(statA, statB)
  all_stat <- stat_both
  
  #define the game's data frame
  all_stat <- stat_both
  
  #loop for all tables related to the game
  for(i in 5:9){
    game_data <- substr(selected_urls[g], 39, nchar(selected_urls[g])-10)
    date <- substr(game_data, nchar(game_data)-11, nchar(game_data))
    teams <- substr(game_data, 1, nchar(game_data)-13)
    teams <- str_replace(teams, "Czech-Republic", "Czech Republic")
    teams <- str_replace(teams, "North-Macedonia", "North Macedonia")
    
    teamA <- sub("-.*", "", teams)
    teamB <- sub(".*-", "", teams)
    
    node <- "#stats_b561dd30_defense"
    url <- paste0(selected_urls[g],node)
    statA <- htmltab(doc = url, which = i, rm_nodata_cols = F)
    statA <- cbind(date, Team=teamA, Opponent=teamB, statA)
    statB <- htmltab(doc = url, which = i+7, rm_nodata_cols = F)
    statB <- cbind(date, Team=teamB, Opponent=teamA, statB)
    stat_both <- rbind(statA, statB)
    all_stat <- merge(all_stat, stat_both, by="Player") 
  }
  #add the game tables to the total data frame
  full_stat <- rbind(full_stat, all_stat)
}

#remove any duplicates
all_stat_full <- unique(full_stat)

#convert all stats into numeric variables
all_stat_full <- cbind(all_stat_full[,1:4], mutate_all(all_stat_full[,5:ncol(all_stat_full)], function(x) as.numeric(as.character(x))))

#####
# Step 7: Create summary data frame
#####
#remove some unwanted columns
all_stat_full$Pos.x <- NULL
all_stat_full$Age.x <- NULL
all_stat_full$`#.x` <- NULL
all_stat_full$Pos.x <- NULL
all_stat_full$Age.x <- NULL
all_stat_full$`#.x` <- NULL

#Sum all stats for each player
all_stat_full <- all_stat_full %>% 
  group_by(Player) %>% 
  summarise_each(list(sum))

View(all_stat_full)

#Look at the available player names.
View(unique(all_stat_full$Player))

#Select the players you want to see. Choose 8 players for better visual results.
selected_players <- subset(all_stat_full, 
                           Player=="Kylian Mbappé" |
                             Player=="Antoine Griezmann" |
                             Player=="Harry Kane" |
                             Player=="Kai Havertz" |
                             Player=="Cristiano Ronaldo" |
                             Player=="Álvaro Morata" |
                             Player=="Memphis Depay" |
                             Player=="Patrik Schick")

#####
# Step 9: Create the radar plots
#####
#attach the dataset
attach(selected_players)

#select the statistics we want to see and prepare for the plot
Sel <- data.frame("xG"=`Expected >> xG`,
                  "Dr"=`Dribbles >> Succ`,
                  "Pass"=`Passes >> Cmp`,
                  "Sh"=`Performance >> Sh`,
                  "SoT"=`Performance >> SoT`,
                  "KP"=`KP`)
Sel <- mutate_all(Sel, function(x) as.numeric(as.character(x)))

#run the radialprofile function with std=T, which standardizes the data so that the scale looks normal
p <- radialprofile(data=Sel, title=selected_players$Player, std=T)
detach(selected_players)


#####
# Step 10: Make the graph presentable
#####
g <- grid.arrange(grobs=p[1:length(p)], ncol=3)

g2 <- cowplot::ggdraw(g)+theme_grey()+
  labs(title="Selected Players Radar Plots",
       subtitle="Data from fbref.com. Aggregated data from EURO 2020 Group Stage Matches. Stat values are standardized (??=0, sd=1",
       caption = "@Sweep_SportsAnalytics")

g2

ggsave("radar-plot.png", w = 7.5, h = 7.5, dpi = 400)

#create a table with descriptions for the stats we chose
descriptions <- data.frame(
  "Category"=colnames(Sel),
  "Description"=c("Expected Goals",
                  "Successful Dribbles",
                  "Completed Passes",
                  "Shots",
                  "Shots on Target",
                  "Key Passes"))

library(kableExtra)
library(magick)

descr <- tableGrob(print(descriptions, row.names = F))



g_final <- g2 + annotation_custom(descr, xmin = 0.75, xmax = 0.85, ymin = 0.1, ymax = 0.2) +
  coord_cartesian(clip = "off")
ggsave("radar-key-final.png", w = 7.5, h = 7.5, dpi = 400)
