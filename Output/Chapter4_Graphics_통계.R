library(tidyverse)
library(directlabels)
library(data.table)
library(gghighlight)


df <- fread("df.csv")
df$Type[df$Type=="danger"] <- "%Total"
df$Type <- factor(df$Type, levels=c("%Total", "age15", "age1564", "age65", "edulow", "eduhigh"))



##########################################

df %>% 
  filter(`[step]`==8763, Scenario == "DEC", AC == "AC100", Type == "%Total") %>% 
  mutate(Value = round(Value,1)) %>% 
  View()


df %>% 
  filter(`[step]`==8763, Scenario == "DEC", AC == "AC150", Type == "age65") %>% 
  mutate(Value = round(Value,1)) %>% 
  View()



df %>% 
  filter(`[step]`==8763, Scenario == "BAU", AC == "AC100", Type %in% c("age15", "age1564", "age65")) %>% 
  mutate(Value = round(Value,1)) %>% 
  View()


df %>% 
  filter(`[step]`==8763, Scenario == "DEC", AC == "AC100", Type %in% c("eduhigh", "edulow"), Value > 5 ) %>% 
  mutate(Value = round(Value,1)) %>% 
  View()
