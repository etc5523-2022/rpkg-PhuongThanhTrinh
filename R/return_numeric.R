#' Get highest varieties
#'
#' @description
#' This function gets the highest varietie.
#'
#' @return A sentence describes the number of variations.
#'
#'@param styles The style of ramen containers
#'
#'
#' @export

get_best_style <- function(styles){

  `%>%` <- magrittr::`%>%`

  ramen <- ramen_rating %>%
    tidyr::drop_na(stars) %>%
    dplyr::group_by(style) %>%
    dplyr::count(style) %>%
    dplyr::filter(style == styles)

  choice <- sample(unique(ramen$style), 1)

if(styles == choice){
  paste0("There are", " ", ramen$n, " ", "variations available in this style!")
}
}

#' Rank highest average rate
#'
#' @description
#' This function gets the ranking of average rate for each ramen style.
#'
#' @return A sentence ranks the average rate .
#'
#'@param styles The style of ramen containers
#'
#' @export

get_rank <- function(styles){

  `%>%` <- magrittr::`%>%`

  ranking <- ramen_rating %>%
    tidyr::drop_na(stars) %>%
    dplyr::group_by(style) %>%
    dplyr::summarise(average = mean(stars)) %>%
    dplyr::mutate(rank = as.factor(rank(-average))) %>%
    dplyr::filter(style == styles)

  choice <- sample(unique(ranking$style), 1)

  if(styles == choice){
    paste0("This style ranks", " ", ranking$rank, "th", " ", "among all styles!")
  }
}
