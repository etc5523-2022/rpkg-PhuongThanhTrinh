#' Get shiny app for ramen rating dataset
#'
#' This function gets shiny app for ramen rating dataset
#'
#' @return A Shiny app
#'
#' @export
run_app <- function() {
  app_dir <- system.file("Shiny-app", package = "ramenreview")
  shiny::runApp(app_dir, display.mode = "normal")
}



