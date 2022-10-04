#' @title
#' Get good and bad ramen from each country
#'
#' @description
#' This function generates plots illustrating the proportion of good and bad ramen for each nation.
#'
#' @return
#' A pie chart showing the corresponding percentage of ramen rated as either good or bad.
#'
#' @param names The country name in which ramen comes from.
#'
#' @importFrom graphics pie
#'
#' @export

get_pct <- function(names) {
  `%>%` <- magrittr::`%>%`

  type <- country <- n <- total <- percentage <- NULL



  plot <- ramen_rating %>%
    dplyr::filter(stars != "NA") %>%
    dplyr::mutate(type = dplyr::case_when(
      stars < 3 ~ "Bad",
      stars >= 3 ~ "Good")) %>%
    dplyr::group_by(country, type) %>%
    dplyr::count(country, type) %>%
    dplyr::group_by(country) %>%
    dplyr::mutate(total = sum(n)) %>%
    dplyr::mutate(percentage = n/total * 100) %>%
    dplyr::filter(country == names)

  choices <- sample(unique(plot$country), 1)

  slices <- plot$percentage
  lbls <- plot$type
  pct <- round(slices)
  lbls <- paste(lbls, pct)
  lbls <- paste(lbls,"%",sep="")

  out <- pie(slices,labels = lbls, col= c("#eec6a7", "#9f1618"),
             main="Percentage of good and bad ramen")

if(names == choices) {
  print(out)
} else {
  print("There is no record on this country")
}

}
#' @examples
#' get_pct(names = "Australia")
#' get_pct(names = "Japan")


