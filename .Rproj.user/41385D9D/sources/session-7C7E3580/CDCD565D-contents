#' Get five summary numbers for different ramen styles
#'
#' This function gets the five number summary for selected ramen styles.
#'
#' @return A data table contains 5 summary statistics.
#'
#'@param brand The ramen brand
#'
#' @importFrom stats fivenum na.omit setNames
#'
#'
#' @export

five_sum <- function(brand = NULL){

  `%>%` <- magrittr::`%>%`

  brands <- ramen_rating %>%
    dplyr::group_by(brand) %>%
    dplyr::count(brand)

  name <- unique(brands$brand)

  choice <- sample(name, 1)

  freq <- brands %>%
    dplyr::filter(brand == choice)

ifelse(is.null(freq$brand),
   paste0("Could not find brand name"),
   paste0("This brand has", " ", freq$n, " ", "number of varieties!"))
}
