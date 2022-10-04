#' @title
#' Get good and bad ramen from each country
#'
#' @description
#' This function generates plots illustrating the proportion of good and bad ramen for each nation.
#'
#' @return
#' A pie chart shows the corresponding percentage of ramen rated as either good or bad.
#'
#' @param names The country name in which ramen comes from.
#'
#' @importFrom graphics pie
#'
#' @export

get_pct <- function(names) {
  `%>%` <- magrittr::`%>%`

  plot <- ramen_rating %>%
    tidyr::drop_na(stars) %>%
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

#' @title Get the average ratings
#'
#' @description
#' This function produces graphs showing averating ratings on each country, across continents
#'
#' @return
#' A interactive boxplot shows the five summary values for each country.
#'
#' @param continents The continent in which the country is located.
#'
#' @export


get_average <- function(continents) {
  `%>%` <- magrittr::`%>%`

  average <- ramen_rating %>%
    dplyr::group_by(country) %>%
    dplyr::filter(continent == continents) %>%
    ggplot2::ggplot(ggplot2::aes(x = country, y = stars, fill = country)) +
    ggplot2::geom_boxplot(color = "black",
                          size = 1,
                          width = 0.3) +
    ggplot2::theme(
      legend.title = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank()) +
    ggplot2::ylab("Rating") +
    ggplot2::coord_flip()

    plotly::ggplotly(average)
}



