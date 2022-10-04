#'  @title
#' Get ramen_rating dataset
#'
#' @description
#' This function gets the ramen_rating dataset
#'
#' @return
#' A data frame including 3180 rows and 7 columns.
#'
#' @importFrom graphics stars
#'
#' @export

get_ramen_rating <- function(){

  `%>%` <- magrittr::`%>%`
url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-04/ramen_ratings.csv'

asia <- c("Russia", "Thailand", "Japan", "Taiwan", "South Korea", "Hong Kong", "Malaysia", "China", "Philippines", "Vietnam", "Bangladesh", "Singapore", "Indonesia", "India", "Pakistan", "Nepal", "Myanmar", "Cambodia", "Dubai")
europe <- c("France", "Ukraine", "Netherlands", "Italy", "Poland", "Germany", "Hungary", "United Kingdom", "Finland", "Sweden", "Estonia")
oceania <- c("Australia", "New Zealand", "Fiji")
africa <- c("Nigeria", "Ghana")
america <- c("Canada", "United States", "Brazil", "Mexico", "Colombia")

readr::read_csv(url) %>%
  dplyr::mutate(country = ifelse(country == "Hong Kong", "China", country),
         country = ifelse(country == "Russia", "Russian Federation", country),
         country = ifelse(country == "Holland", "Netherlands", country),
         country = ifelse(country == "Dubai", "United Arab Emirates", country),
         country = ifelse(country == "South Korea", "Republic of Korea", country),
         country = ifelse(country == "Singapore", "Malaysia", country),
         country = ifelse(country == "Sarawak", "Malaysia", country),
         country = ifelse(country == "USA", "United States", country),
         country = ifelse(country == "UK", "United Kingdom", country),
         country = ifelse(country == "Phlippines", "Philippines", country)) %>%
  dplyr::mutate(continent = dplyr::case_when(
    country %in% asia ~ "Asia",
    country %in% europe ~ "Europe",
    country %in% oceania ~ "Oceania",
    country %in% america ~ "America",
    country %in% africa ~ "Africa"))
}
#'@usage
#'Run the below code:
#'get_ramen_rating()
#'

