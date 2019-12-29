library(dplyr)
library(ggplot2)
library(patchwork)
revenue <- read.csv("revenue.csv", stringsAsFactors = FALSE)

revenue2018 <- revenue %>%
  filter(year == 2018) %>%
  arrange(revenue) %>%
  tail(10) %>%
  mutate(company = forcats::fct_inorder(company))

theme_set(theme_minimal())
bar_chart <- ggplot(revenue2018, aes(company, revenue)) +
  geom_col(fill = "steelblue", width = 0.75) +
  coord_flip()

dot_plot <- ggplot(revenue2018, aes(company, revenue)) +
  geom_point(color = "steelblue", size = 3) +
  coord_flip() +
  ylim(0, NA)

lollipop_chart <- dot_plot +
  geom_segment(
    aes(y = 0, xend = company, yend = revenue),
    color = "steelblue", size = 0.75
  )

bar_chart / dot_plot / lollipop_chart
