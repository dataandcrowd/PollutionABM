library(tidyverse)
library(directlabels)
library(data.table)

# Import Files
csv_files <- fs::dir_ls(regexp = "dobong")
dobong <- csv_files %>% 
  map_dfr(fread) %>% 
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Dobong") 

csv_files <- fs::dir_ls(regexp = "dongdaemoon")
dongdaemoon <- csv_files %>% 
  map_dfr(fread) %>% 
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Dongdaemoon") 


csv_files <- fs::dir_ls(regexp = "jungnang")
jungnang <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Jungnang")


csv_files <- fs::dir_ls(regexp = "seongdong")
seongdong <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Seongdong")


csv_files <- fs::dir_ls(regexp = "yongsan")
yongsan <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Yongsan")


csv_files <- fs::dir_ls(regexp = "gangnam")
gangnam <- csv_files %>% 
  map_dfr(fread) %>% 
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Gangnam") 


csv_files <- fs::dir_ls(regexp = "jongno")
jongno <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Jongno")


csv_files <- fs::dir_ls(regexp = "jung")
jung <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Jung")


csv_files <- fs::dir_ls(regexp = "gwangjin")
gwangjin <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Gwangjin")


csv_files <- fs::dir_ls(regexp = "seongbuk")
seongbuk <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Seongbuk")


csv_files <- fs::dir_ls(regexp = "eunpyeong")
eunpyeong <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Eunpyeong")


csv_files <- fs::dir_ls(regexp = "seodaemoon")
seodaemoon <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Seodaemoon")


csv_files <- fs::dir_ls(regexp = "mapo")
mapo <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Mapo")


csv_files <- fs::dir_ls(regexp = "gangseo")
gangseo <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Gangseo")


csv_files <- fs::dir_ls(regexp = "guro")
guro <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Guro")


csv_files <- fs::dir_ls(regexp = "yeongdeungpo")
yeongdeungpo <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Yeongdeungpo")


csv_files <- fs::dir_ls(regexp = "dongjak")
dongjak <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Dongjak")


csv_files <- fs::dir_ls(regexp = "gwanak")
gwanak <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Gwanak")


csv_files <- fs::dir_ls(regexp = "seocho")
seocho <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Seocho")


csv_files <- fs::dir_ls(regexp = "songpa")
songpa <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Songpa")


csv_files <- fs::dir_ls(regexp = "gangdong")
gangdong <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Gangdong")


csv_files <- fs::dir_ls(regexp = "geumcheon")
geumcheon <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Geumcheon")


csv_files <- fs::dir_ls(regexp = "nowon")
nowon <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Nowon")


csv_files <- fs::dir_ls(regexp = "gangbuk")
gangbuk <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Gangbuk")


csv_files <- fs::dir_ls(regexp = "yangcheon")
yangcheon <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  filter(`[step]` == 8763) %>%
  add_column(District = "Yangcheon")



################################
dobong <- dobong %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

dongdaemoon <- dongdaemoon %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

jungnang <- jungnang %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

seongdong <- seongdong %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

yongsan <- yongsan %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value")

jung <- jung %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

jongno <- jongno %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

gangnam <- gangnam %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

gwangjin <- gwangjin %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

seongbuk <- seongbuk %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value")

eunpyeong <- eunpyeong %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

seodaemoon <- seodaemoon %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

mapo <- mapo %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

gangseo <- gangseo %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

guro <- guro %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value")

yeongdeungpo <- yeongdeungpo %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

seocho <- seocho %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

gwanak <- gwanak %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

dongjak <- dongjak %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

songpa <- songpa %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

gangdong <- gangdong %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

geumcheon <- geumcheon %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value")

nowon <- nowon %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

gangbuk <- gangbuk %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 

yangcheon <- yangcheon %>% select(`[step]`, Scenario, AC, District, danger, age15, age1564, age65, edulow, eduhigh) %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"), variable.name = "Type", value.name = "Value") 


df <- bind_rows(dobong, dongdaemoon, dongjak, eunpyeong, gangbuk, gangdong, gangnam, gangseo, 
                geumcheon, guro, gwanak, gwangjin, jongno, jung, jungnang, mapo, nowon, seocho, 
                seodaemoon, seongbuk, seongdong, songpa, yangcheon, yeongdeungpo, yongsan)

df$AC[df$AC == 100] <- "AC100"
df$AC[df$AC == 150] <- "AC150"
df$AC[df$AC == 200] <- "AC200"


rm(list=setdiff(ls(), "df"))

write_csv(df, "dfbox.csv")
