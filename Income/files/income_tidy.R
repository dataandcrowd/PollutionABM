library(tidyverse)

admin <- read_csv("admin.csv")
heng <- readxl::read_excel("hengjeong.xlsx")
income <- read_csv("income_age.csv")

# get rid of duplicated values
heng1 <- heng[!duplicated(heng$행정구역분류), ]


admin %>% 
  left_join(heng1, by = c("code" = "행정구역분류")) %>% 
  left_join(income, by = c("행정기관코드" = "admin")) %>% 
  select(gu, code, admin_cd, subdis,`20s`, `30s`, `40s`, `50s`, `60over`) -> final

write.csv(final, "income.csv", row.names = F)
