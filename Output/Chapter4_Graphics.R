library(tidyverse)
library(directlabels)
library(data.table)

df <- fread("df.csv")
df$Type[df$Type=="danger"] <- "%Total"
df$Type <- factor(df$Type, levels=c("%Total", "age15", "age1564", "age65", "edulow", "eduhigh"))
############################

df %>% 
  filter(`[step]` >= 2000, Scenario =="BAU") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC, scales = "free_y") +
  geom_dl(aes(label = District), method =  "last.points", cex = 0.8) +
  xlim(2500,11000) +
  xlab("ticks") +
  ylab("Percent of risk population(%)")  +
  theme_bw() +
  theme(legend.position = "bottom",
        legend.title=element_text(size=13),
        legend.text=element_text(size=13),
        axis.text=element_text(size=13),
        axis.title=element_text(size=13),
        strip.text = element_text(size = 16)
        ) -> bau

ggsave("bau.png", bau, height = 12, width = 10, dpi = 300)



df %>% 
  filter(`[step]` >= 2000, Scenario =="INC") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC, scales = "free" ) +
  geom_dl(aes(label = District), method =  "last.points", cex = 0.8) +
  xlim(2500,11000) +
  xlab("ticks") +
  ylab("Percent of risk population(%)")  +
  theme_bw() +
  theme(legend.position = "bottom",
        legend.title=element_text(size=13),
        legend.text=element_text(size=13),
        axis.text=element_text(size=13),
        axis.title=element_text(size=13),
        strip.text = element_text(size = 16)
  ) -> inc

ggsave("inc.png", inc, height = 12, width = 10, dpi = 300)



df %>% 
  filter(`[step]` >= 2000, Scenario =="DEC") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC, scales = "free" ) +
  geom_dl(aes(label = District), method =  "last.points", cex = 0.8) +
  xlim(2500,11000) +
  xlab("ticks") +
  ylab("Percent of risk population(%)")  +
  theme_bw() +
  theme(legend.position = "bottom",
        legend.title=element_text(size=13),
        legend.text=element_text(size=13),
        axis.text=element_text(size=13),
        axis.title=element_text(size=13),
        strip.text = element_text(size = 16)
  ) -> dec

ggsave("dec.png", dec, height = 12, width = 10, dpi = 300)




