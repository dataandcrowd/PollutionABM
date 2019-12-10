library(tidyverse)
census <- read_csv("census2010_age_.csv")

census %>%
  select(-c(code, subdis)) %>% 
  group_by(gu) %>% 
  summarise_all(list(sum = sum)) -> census_df


census %>%
  select(-c(code, subdis)) %>% 
  group_by(gu) %>% 
  mutate_all(funs(./sum(.)*100))
