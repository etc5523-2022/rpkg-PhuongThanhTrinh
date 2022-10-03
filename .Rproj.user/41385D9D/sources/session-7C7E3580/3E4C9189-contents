#' Get five summary numbers for ramen in different countries
#'
#' This function gets the average ratings for ramen based on countries.
#'
#' @return A boxplot contains 5 summary statistics of different ramen.
#'
#'@param country The country in which a ramen bran comes from.
#'
#'@importFrom graphics pie
#'
#' @examples
#' good_bad_ramen("Australia")
#'
#'
#' @export

good_bad_ramen <- function(country) {
  `%>%` <- magrittr::`%>%`

  plot <- ramen_rating %>%
    dplyr::mutate(Type = dplyr::case_when(
      stars < 3 ~ "Bad",
      stars >= 3 ~ "Good")) %>%
    dplyr::group_by(country, Type) %>%
    dplyr::count(country, Type) %>%
    dplyr::group_by(country) %>%
    dplyr::mutate(total = sum(n)) %>%
    dplyr::mutate(percentage = n/total * 100)

  countries <- unique(plot$country)

  choices <- sample(countries, 1)

  worst <- plot %>%
    dplyr::filter(country == choices)

  slices <- worst$percentage
  lbls <- worst$Type
  pct <- round(slices)
  lbls <- paste(lbls, pct)
  lbls <- paste(lbls,"%",sep="")

  out <- pie(slices,labels = lbls, col= c("#eec6a7", "#9f1618"),
             main="Percentage of good and bad ramen")

ifelse((country == worst$country),
  print(out),
  print("There is no record on this country."))
}



