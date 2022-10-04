test_that("get_best_style works", {
  library(stringr)
  expect_true(str_detect(get_best_style(styles = "Bowl"), "There are \\d+ variations available in this style!"))
})

test_that("get_rank works", {
  library(stringr)
  expect_true(str_detect(get_rank(styles = "Pack"), "This style ranks \\d+th among all styles!"))
})

