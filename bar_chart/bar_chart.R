#' Easy Bar Charts
#' 
#' Easily create a bar chart
#' 
#' @author Thomas Neitmann
#' 
#' @param data Dataset to use for the bar chart
#' @param x The x variable
#' @param y numeric. If y is missing then it will be assigned the number of records in each group of y
#' @param ... Additional arguments passed to aes()
#' @param sort logical. Should the data be sorted before plotting?
#' @param horizontal logical. Should coord_flip() be added to the plot
#' @param limit integer. If a value for limit is provided only the first limit records will be displayed
#' 
#' @example
#' 
#' # Plots the number of records per cut
#' data(diamonds)
#' bar_chart(diamonds, cut)
#' 
bar_chart <- function(data, x, y, ..., sort = TRUE, horizontal = TRUE,
                      limit) {
  x <- rlang::enquo(x)
  
  if (missing(y)) {
    data <- dplyr::count(data, !!x)
    y <- rlang::sym("n")
  } else {
    y <- rlang::enquo(y)
  }

  if (sort) {
    data <- data %>%
      dplyr::arrange(!!y) %>%
      dplyr::mutate(!!x := forcats::fct_inorder(!!x))
  }
  
  if (!missing(limit)) {
    data <- tail(data, limit)
  }
  
  p <- data %>%
    filter(!is.na(!!x), !is.na(!!y)) %>%
    ggplot(aes(!!x, !!y, ...)) +
    geom_col(fill = "steelblue", width = .75) +
    theme_minimal() +
    theme(panel.grid.major.y = element_blank())
  
  if (horizontal) {
    p <- p + coord_flip()
  }
  p
}
