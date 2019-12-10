library(tidyverse)
library(directlabels)
library(data.table)
#######################################

box <- fread("dfbox.csv")

box$Scenario <- factor(box$Scenario, levels=c("BAU", "INC", "DEC"))


box %>% 
  filter(Type == "danger") %>% 
  ggplot(aes(reorder(District, Value), Value)) + 
  geom_boxplot() +
  facet_grid(AC ~ Scenario, scales = "free") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw() +
  theme(
    legend.text=element_text(size=13),
    axis.text=element_text(size=13),
    axis.title=element_text(size=13),
    strip.text = element_text(size = 13)
  ) -> boxresult

ggsave("box.png", boxresult, height = 12, width = 10, dpi = 200)
