library(tidyverse)
library(directlabels)

health <- read_csv("health_loss.csv")
road <- read_csv("road_sensitivity.csv")

## Health
health %>% 
  select(health_loss, `[step]`, danger) %>% 
  filter(`[step]` >= 2000) -> hcal
  
hcal %>% 
  mutate(health_loss = as.factor(health_loss)) %>% 
  ggplot(aes(x=`[step]`, y=danger, group = health_loss, colour = health_loss)) +
  geom_line() +
  xlim(2500,9500) +
  ylab("Population at risk(%)") +
  geom_dl(aes(label = health_loss), method = "last.points", cex = 0.8)  +
  theme_minimal() +
  theme(axis.text.x=element_text(size = 12),
        axis.text.y=element_text(size = 12),
        strip.text.x = element_text(size = 12),
        legend.title=element_text(size=12), 
        legend.text=element_text(size=12)
        ) -> healthplot

ggsave("health_sensitivity.png", healthplot, width = 12, height = 8, dpi = 300)


#### Curve

hcal %>% 
  filter(danger >= .001) %>% 
  group_by(health_loss) %>% 
  filter(danger == min(danger), `[step]` == min(`[step]`)) %>% 
  arrange(health_loss) %>% 
  ungroup() -> curve


curve %>% 
  ggplot(aes(x = health_loss, y = `[step]`)) +
  geom_smooth(method = 'loess') +
  geom_point() +
  theme_minimal() +
  ylim(2000, 8500) +
  xlab("Health Loss") +
  ylab("Time of illness onset") +
  theme(axis.text.x=element_text(size = 12),
        axis.text.y=element_text(size = 12),
        strip.text.x = element_text(size = 12),
        legend.title=element_text(size=12), 
        legend.text=element_text(size=12)
  ) -> smoothplot

ggsave("smooth_sensitivity.png", smoothplot, width = 6, height = 6, dpi = 200)





## Road
road %>% 
  select(road_proximity, `[step]`, danger) %>% 
  filter(`[step]` >= 6000) -> rcal

rcal %>% 
  mutate(road_proximity = as.factor(road_proximity)) %>% 
  ggplot(aes(x=`[step]`, y=danger, group = road_proximity, colour = road_proximity)) +
  geom_line() +
  ylab("Population at risk(%)") +
  #geom_dl(aes(label = road_proximity), method = "last.points", cex = 0.8)  +
  theme_minimal() +
  theme(axis.text.x=element_text(size = 12),
        axis.text.y=element_text(size = 12),
        strip.text.x = element_text(size = 12),
        legend.title=element_text(size=12), 
        legend.text=element_text(size=12)
  ) -> roadplot

ggsave("road_sensitivity.png", roadplot, width = 6, height = 5, dpi = 300)
