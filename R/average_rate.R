#' Get five summary numbers for ramen in different countries
#'
#' This function gets the average ratings for ramen based on countries.
#'
#' @return A boxplot contains 5 summary statistics of different ramen.
#'
#'@param continent The continent in which a country is located in.
#'
#' @examples
#'boxplot("Asia")
#'
#'
#' @export

boxplot <- function(continent = NULL) {

   `%>%` <- magrittr::`%>%`
continent <- unique(ramen_rating$continent)

average <- ramen_rating %>%
  dplyr::group_by(country)

out <- ggplot2::ggplot(average, ggplot2::aes(x = country, y = stars, fill = country)) +
          ggplot2::geom_boxplot(color = "black",
                       size = 1,
                       width = 0.3) +
          ggplot2::theme(
            legend.title = ggplot2::element_blank(),
            axis.title.x = ggplot2::element_blank(),
            axis.title.y = ggplot2::element_blank()) +
          ggplot2::ylab("Rating") +
          ggplot2::coord_flip()
}


