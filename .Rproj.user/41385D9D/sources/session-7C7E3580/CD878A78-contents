#' Get review ratings for different ramen varieties
#'
#' This function gets the ratings for various ramen
#'
#' @return A data.frame including 2805 observations and 7 variables.
#'
#' @examples
#' ramen_ratings()
#'
#' @importFrom graphics stars
#'
#' @export

ramen_ratings <- function(){

  `%>%` <- magrittr::`%>%`
url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-04/ramen_ratings.csv'

asia <- c("Russia", "Thailand", "Japan", "Taiwan", "South Korea", "Hong Kong", "Malaysia", "China", "Philippines", "Vietnam", "Bangladesh", "Singapore", "Indonesia", "India", "Pakistan", "Nepal", "Myanmar", "Cambodia", "Dubai")
europe <- c("France", "Ukraine", "Netherlands", "Italy", "Poland", "Germany", "Hungary", "United Kingdom", "Finland", "Sweden", "Estonia")
oceania <- c("Australia", "New Zealand", "Fiji")
africa <- c("Nigeria", "Ghana")
america <- c("Canada", "United States", "Brazil", "Mexico", "Colombia")

readr::read_csv(url) %>%
  tidyr::drop_na(stars) %>%
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
    country %in% africa ~ "Africa")) %>%
  dplyr::filter(continent != "NA")
}
