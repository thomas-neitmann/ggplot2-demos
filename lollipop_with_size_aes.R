library(dplyr)
library(ggplot2)

revenue2018 <- read.csv("revenue.csv", stringsAsFactors = FALSE) %>%
  filter(year %in% 2017:2018) %>%
  tidyr::pivot_wider(
    names_from = year, names_prefix = "revenue_",
    values_from = revenue
  ) %>%
  mutate(pct_diff = (revenue_2018 - revenue_2017) / revenue_2017) %>%
  arrange(revenue_2018) %>%
  tail(10) %>%
  mutate(company = forcats::fct_inorder(company))

ggplot(revenue2018, aes(company, revenue_2018)) +
  geom_segment(
    aes(y = 0, xend = company, yend = revenue_2018),
    color = "steelblue", size = 0.75
  ) +
  geom_point(aes(size = pct_diff), color = "steelblue") +
  coord_flip() +
  scale_size(
    name = "Difference from\nPrevious Year",
    labels = scales::percent_format(trim = FALSE),
    breaks = c(-.1, 0, .1), limits = c(-.1, NA), range = c(1, 8)
  ) +
  scale_y_continuous(label = scales::dollar_format(suffix = "B")) +
  labs(
    x = element_blank(), y = element_blank(),
    title = "Top 10 Biomedical Companies by Revenue 2018"
  ) +
  theme_minimal() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank()
  )
