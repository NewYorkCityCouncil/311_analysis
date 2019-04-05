library(ggplot2)

complaints_zscore_spread <- complaint_zscore_spread#read.csv(file="~/complaint_zscore_spread.csv", header=TRUE, sep=",")

drops <- 'X1'
complaints_zscore_spread <- complaints_zscore_spread[ , !(names(complaints_zscore_spread) %in% drops)]

#ggplot(complaints_zscore_spread,aes(x=zscore))+geom_histogram()+facet_wrap(~Type, scales = 'free')+theme_bw()

n_pages <- ceiling(
  length(unique(complaints_zscore_spread$Type))/ 9
)


library(ggforce)
# Draw each page
i <- 2


make_plot <- function(.data, title) {
  ggplot(.data, aes(x=Time))+
    geom_density() +
    labs(title = title) 
}

make_plot2 <- function(.data, title) {
  ggplot(.data, aes(x=zscore))+
    geom_histogram() +
    labs(title = title) 
}

library(dplyr)
library(tidyr)
library(purrr)
library(patchwork)


plots <- complaints_zscore_spread %>% 
  group_by(Type) %>%
  nest() %>% 
  mutate(plot = map2(data, Type, make_plot))

tmp <- plots %>% 
  ungroup() %>% 
  mutate(page = rep(1:n_pages, length.out = 50)) %>% 
  group_by(page) %>% 
  nest(plot) %>%
  mutate(new_plot = purrr::map(data, ~wrap_plots(.x$plot)))

for (i in 1:nrow(tmp)) {
  ggsave(paste('Time_dist',i,'.jpeg',sep = ''),tmp$new_plot[[i]])
}



plots2 <- complaints_zscore_spread %>% 
  group_by(Type) %>%
  nest() %>% 
  mutate(plot = map2(data, Type, make_plot2))

tmp2 <- plots %>% 
  ungroup() %>% 
  mutate(page = rep(1:n_pages, length.out = 50)) %>% 
  group_by(page) %>% 
  nest(plot) %>%
  mutate(new_plot = purrr::map(data, ~wrap_plots(.x$plot)))

for (i in 1:nrow(tmp)) {
  ggsave(paste('zscore',i,'.jpeg',sep = ''),tmp$new_plot[[i]])
}