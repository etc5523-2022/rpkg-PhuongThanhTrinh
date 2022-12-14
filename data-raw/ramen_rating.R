## code to prepare `ramen_rating` dataset goes here

library(tidyverse)

url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-04/ramen_ratings.csv'

asia <- c("Russia", "Thailand", "Japan", "Taiwan", "South Korea", "Hong Kong", "Malaysia", "China", "Philippines", "Vietnam", "Bangladesh", "Singapore", "Indonesia", "India", "Pakistan", "Nepal", "Myanmar", "Cambodia", "Dubai")
europe <- c("France", "Ukraine", "Netherlands", "Italy", "Poland", "Germany", "Hungary", "United Kingdom", "Finland", "Sweden", "Estonia")
oceania <- c("Australia", "New Zealand", "Fiji")
africa <- c("Nigeria", "Ghana")
america <- c("Canada", "United States", "Brazil", "Mexico", "Colombia")

ramen_rating <- read_csv(url) %>%
  mutate(country = ifelse(country == "Hong Kong", "China", country),
         country = ifelse(country == "Russia", "Russian Federation", country),
         country = ifelse(country == "Holland", "Netherlands", country),
         country = ifelse(country == "Dubai", "United Arab Emirates", country),
         country = ifelse(country == "South Korea", "Republic of Korea", country),
         country = ifelse(country == "Singapore", "Malaysia", country),
         country = ifelse(country == "Sarawak", "Malaysia", country),
         country = ifelse(country == "USA", "United States", country),
         country = ifelse(country == "UK", "United Kingdom", country),
         country = ifelse(country == "Phlippines", "Philippines", country)) %>%
  mutate(continent = case_when(
    country %in% asia ~ "Asia",
    country %in% europe ~ "Europe",
    country %in% oceania ~ "Oceania",
    country %in% america ~ "America",
    country %in% africa ~ "Africa"))

usethis::use_data(ramen_rating, overwrite = TRUE)
