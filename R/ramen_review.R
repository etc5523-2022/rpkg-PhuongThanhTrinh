#' Get review ratings for different ramen varieties
#'
#' This function gets the ratings for various ramen
#'
#' @return A data.frame including 3180 observations and 6 variables.
#' @examplea
#' ramen_ratings()

#' @export

ramen_ratings <- function(){

  `%>%` <- magrittr::`%>%`
url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-04/ramen_ratings.csv'

ramen_rating <- readr::read_csv(url) %>%
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
         country = ifelse(country == "Phlippines", "Philippines", country))
}
