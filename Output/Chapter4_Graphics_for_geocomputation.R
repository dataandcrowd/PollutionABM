library(tidyverse)
library(directlabels)
library(data.table)
library(gghighlight)


df <- fread("df.csv")
df$Type[df$Type=="danger"] <- "%Total"
df$Type <- factor(df$Type, levels=c("%Total", "age15", "age1564", "age65", "edulow", "eduhigh"))

##########
#--BAU--##
##########
#1. Total
df %>% 
  filter(`[step]` >= 2000, Scenario =="BAU", Type == "%Total", AC != "AC150") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_wrap(~ AC, ncol = 1, scales = "free_y") +
  scale_x_continuous(breaks = c(3000, 4000, 5000, 6000, 7000, 8000, 8763), limits = c(2000,10500)) +
  xlab("ticks") +
  ylab("Risk population(%)")  +
  theme_bw() +
  theme(legend.position = "none",
        legend.title=element_text(size=15),
        legend.text=element_text(size=15),
        axis.text.y=element_text(size=15),
        axis.text.x=element_text(size=11),
        axis.title=element_text(size=15),
        strip.text = element_text(size = 20)
  ) -> bau_total

plot_bau_total <- direct.label(bau_total,list(dl.trans(x=x+0.1), "last.qp",cex=1))
#ggsave("plot_bau_total.png", plot_bau_total, height = 11, width = 6.5, dpi = 200)



#2. Age
df %>% 
  filter(`[step]` >= 2000, Scenario =="BAU", Type %in% c("age15","age1564","age65"), AC != "AC150") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC, scales = "free_y") +
  #gghighlight(max(Value) > 15,  use_group_by = T, calculate_per_facet = TRUE, use_direct_label = F) +
  #gghighlight(District %in% c("Yeongdeungpo", "Guro", "Mapo", "Seocho", "Gangnam", "Jungnang", "Yongsan"),
  #            use_group_by = F, calculate_per_facet = TRUE, use_direct_label = F) +
  scale_x_continuous(breaks = c(3000, 4000, 5000, 6000, 7000, 8000, 8763), limits = c(3000,10500)) +
  xlab("ticks") +
  ylab("Risk population(%)")  +
  theme_bw() +
  theme(legend.position = "none",
        #legend.position = "bottom",
        legend.title=element_text(size=15),
        legend.text=element_text(size=15),
        axis.text.y=element_text(size=20),
        axis.text.x=element_text(size=14),
        axis.title=element_text(size=20),
        strip.text = element_text(size = 23)
  ) -> bau_age

plot_bau_age <- direct.label(bau_age, list(dl.trans(x=x+0.1), "last.qp",cex=1.1))
#ggsave("plot_bau_age.png", plot_bau_age, height = 12, width = 17, dpi = 200)




##########
#--INC--##
##########
#1. Total
df %>% 
  filter(`[step]` >= 2000, Scenario =="INC", Type == "%Total", AC != "AC150") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  #acet_grid( Type ~ AC ) + #, scales = "free_y") +
  facet_wrap(~ AC, ncol = 1, scales = "free_y") +
  scale_x_continuous(breaks = c(3000, 4000, 5000, 6000, 7000, 8000, 8763), limits = c(2000,10500)) +
  xlab("ticks") +
  ylab("Risk population(%)")  +
  theme_bw() +
  theme(legend.position = "none",
        legend.title=element_text(size=15),
        legend.text=element_text(size=15),
        axis.text.y=element_text(size=15),
        axis.text.x=element_text(size=11),
        axis.title=element_text(size=15),
        strip.text = element_text(size = 20)
  ) -> inc_total

plot_inc_total <- direct.label(inc_total,list(dl.trans(x=x+0.1), "last.qp",cex=1))
#ggsave("plot_inc_total.png", plot_inc_total, height = 11, width = 6.5, dpi = 200)



#2. Age
df %>% 
  filter(`[step]` >= 2000, Scenario =="INC", Type %in% c("age15","age1564","age65"), AC != "AC150") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC, scales = "free_y") +
  scale_x_continuous(breaks = c(3000, 4000, 5000, 6000, 7000, 8000, 8763), limits = c(3000,10500)) +
  xlab("ticks") +
  ylab("Risk population(%)")  +
  theme_bw() +
  theme(legend.position = "none",
        #legend.position = "bottom",
        legend.title=element_text(size=15),
        legend.text=element_text(size=15),
        axis.text.y=element_text(size=20),
        axis.text.x=element_text(size=14),
        axis.title=element_text(size=20),
        strip.text = element_text(size = 23)
  ) -> inc_age

plot_inc_age <- direct.label(inc_age, list(dl.trans(x=x+0.1), "last.qp",cex=1))
#ggsave("plot_inc_age.png", plot_inc_age, height = 12, width = 17, dpi = 200)



##########
#--DEC--##
##########
#1. Total
df %>% 
  filter(`[step]` >= 2000, Scenario =="DEC", Type == "%Total", AC != "AC150") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC ) + #, scales = "free_y") +
  facet_wrap(~ AC, ncol = 1) +
  scale_x_continuous(breaks = c(3000, 4000, 5000, 6000, 7000, 8000, 8763), limits = c(2500,10500)) +
  xlab("ticks") +
  ylab("Risk population(%)")  +
  theme_bw() +
  theme(legend.position = "none",
        legend.title=element_text(size=15),
        legend.text=element_text(size=15),
        axis.text.y=element_text(size=15),
        axis.text.x=element_text(size=11),
        axis.title=element_text(size=15),
        strip.text = element_text(size = 20)
  ) -> dec_total

plot_dec_total <- direct.label(dec_total,list(dl.trans(x=x+0.1), "last.qp",cex=1))
#ggsave("plot_dec_total.png", plot_dec_total, height = 11, width = 6.5, dpi = 200)



#2. Age
df %>% 
  filter(`[step]` >= 2000, Scenario =="DEC", Type %in% c("age15","age1564","age65"), AC != "AC150") %>% 
  ggplot(aes(`[step]`, Value)) + 
  geom_line(aes(colour = District, group = District), size = 1) +
  facet_grid( Type ~ AC, scales = "free_y") +
  scale_x_continuous(breaks = c(3000, 4000, 5000, 6000, 7000, 8000, 8763), limits = c(3000,10500)) +
  xlab("ticks") +
  ylab("Risk population(%)")  +
  theme_bw() +
  theme(legend.position = "none",
        #legend.position = "bottom",
        legend.title=element_text(size=15),
        legend.text=element_text(size=15),
        axis.text.y=element_text(size=20),
        axis.text.x=element_text(size=14),
        axis.title=element_text(size=20),
        strip.text = element_text(size = 23)
  ) -> dec_age

plot_dec_age <- direct.label(dec_age, list(dl.trans(x=x+0.1), "last.qp",cex=1))
#ggsave("plot_dec_age.png", plot_dec_age, height = 12, width = 17, dpi = 200)



