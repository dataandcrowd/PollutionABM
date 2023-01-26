options(scipen = 100)

library(tidyverse)
library(directlabels)
library(data.table)

################################

csv_files <- fs::dir_ls(path = "subdistrict", regexp = "gwanak")
gwanak <- csv_files %>% 
  map_dfr(fread) %>%
  select(-c(starts_with('dead'), starts_with('health'), `road-poll`, `scenario-percent`, 
            `PM10-parameters`, siminputrow, `[run number]`, `random-seed`, `mean-pm10`)) %>% 
  mutate(AC = case_when(AC == 100 ~ "AC100",
                        AC == 150 ~ "AC150",
                        AC == 200 ~ "AC200"))

csv_files <- fs::dir_ls(path = "subdistrict", regexp = "gangnam")
gangnam <- csv_files %>% 
  map_dfr(fread) %>% 
  select(-c(starts_with('dead'), starts_with('health'), `road-poll`, `scenario-percent`, 
            `PM10-parameters`, siminputrow, `[run number]`, `random-seed`, `mean-pm10`)) %>% 
  mutate(AC = case_when(AC == 100 ~ "AC100",
                        AC == 150 ~ "AC150",
                        AC == 200 ~ "AC200"))

################################

gwanak1 <- gwanak %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  summarise_all(funs(mean)) %>%
  select(-c(danger, age15, age1564, age65, edulow, eduhigh)) %>% 
  #add_column(District = "Gwanak") %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"),variable.name = "Subdistrict", value.name = "Value") %>% 
  mutate(Subdistrict = str_remove(Subdistrict, "_risk"),
         Abb = str_replace_all(Subdistrict, c("Boramae" = "BRM", "Cheongnim" ="CHN", "Cheongryong"="CHR", "Daehak" = "DHK",
                                              "Euncheon" = "EUC", "Haengun"="HUN", "Inheon" = "INH", "Jowon" = "JOW",
                                              "Jungang" = "JNG", "Miseong" = "MIS", "Nakseongdae" = "NSD", "Namheon" = "NAM", 
                                              "Nangok" = "NAN", "Nanhyang" = "NAH", "Samseong" = "SAS", "Seowon" = "SEW", 
                                              "Shillim"="SHL", "Shinsa" = "SHS", "Shinwon" = "SHW", "Sunghyeon" = "SGH")))


gangnam1 <- gangnam %>% 
  group_by(`[step]`, Scenario, AC) %>% 
  summarise_all(funs(mean)) %>%
  select(-c(danger, age15, age1564, age65, edulow, eduhigh)) %>% 
  add_column(District = "Gangnam")  %>% 
  reshape2::melt(id = c("[step]", "Scenario", "AC", "District"),variable.name = "Subdistrict", value.name = "Value") %>% 
  mutate(Subdistrict = str_remove(Subdistrict, "_risk"),
         Abb = str_replace_all(Subdistrict, c("Shinsa" = "SI", "Nonhyeon1" ="NH1", "Nonhyeon2"="NH2", "Samseong1" = "SA1",
                                        "Samseong2" = "SA2", "Daechi1"="DC1", "Daechi4" = "DC4", "Yeoksam1" = "YS1",
                                        "Yeoksam2" = "YS2", "Dogok1" = "DG1", "Dogok2" = "DG2", "Gaepo1" = "GP1", "Gaepo4" = "GP4",
                                        "Ilwonbon" = "IL", "Ilwon1" = "IL1", "Ilwon2" = "IL2", 
                                        "Suseo" = "SS", "Apgujeong1" = "AP", "Cheongdam" = "CD", "Daechi2" = "DC2", "Gaepo2" = "GP2",
                                        "Segok" = "SG")))


#########################
##--Load subdistricts--##
#########################
library(gridExtra)
library(tidyverse)
library(ggpubr)
library(directlabels)
library(tidyquant)
library(cowplot)



gw_dot_BAU100 <- gwanak1 %>% 
  filter(Scenario == "BAU" & AC == "AC100", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_BAU150 <- gwanak1 %>% 
  filter(Scenario == "BAU" & AC == "AC150", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_BAU200 <- gwanak1 %>% 
  filter(Scenario == "BAU" & AC == "AC200", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_INC100 <- gwanak1 %>% 
  filter(Scenario == "INC" & AC == "AC100", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_INC150 <- gwanak1 %>% 
  filter(Scenario == "INC" & AC == "AC150", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_INC200 <- gwanak1 %>% 
  filter(Scenario == "INC" & AC == "AC200", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_DEC100 <- gwanak1 %>% 
  filter(Scenario == "DEC" & AC == "AC100", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_DEC150 <- gwanak1 %>% 
  filter(Scenario == "DEC" & AC == "AC150", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_DEC200 <- gwanak1 %>% 
  filter(Scenario == "DEC" & AC == "AC200", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))



#################
#--Line Graph--##
#################

gw_line_BAU100 <- gwanak1 %>% 
  filter(Scenario == "BAU" & AC == "AC100") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_BAU150 <- gwanak1 %>% 
  filter(Scenario == "BAU" & AC == "AC150") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_BAU200 <- gwanak1 %>% 
  filter(Scenario == "BAU" & AC == "AC200") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 



gw_line_INC100 <- gwanak1 %>% 
  filter(Scenario == "INC" & AC == "AC100") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_INC150 <- gwanak1 %>% 
  filter(Scenario == "INC" & AC == "AC150") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_INC200 <- gwanak1 %>% 
  filter(Scenario == "INC" & AC == "AC200") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 



gw_line_DEC100 <- gwanak1 %>% 
  filter(Scenario == "DEC" & AC == "AC100") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_DEC150 <- gwanak1 %>% 
  filter(Scenario == "DEC" & AC == "AC150") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_DEC200 <- gwanak1 %>% 
  filter(Scenario == "DEC" & AC == "AC200") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,60)) +
  scale_x_continuous(breaks = c(5000,7500,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 




############################


b100 <- gw_line_BAU100 + annotation_custom(grob = ggplotGrob(gw_dot_BAU100), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)
b150 <- gw_line_BAU150 + annotation_custom(grob = ggplotGrob(gw_dot_BAU150), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)
b200 <- gw_line_BAU200 + annotation_custom(grob = ggplotGrob(gw_dot_BAU200), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)

i100 <- gw_line_INC100 + annotation_custom(grob = ggplotGrob(gw_dot_INC100), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)
i150 <- gw_line_INC150 + annotation_custom(grob = ggplotGrob(gw_dot_INC150), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)
i200 <- gw_line_INC200 + annotation_custom(grob = ggplotGrob(gw_dot_INC200), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)

d100 <- gw_line_DEC100 + annotation_custom(grob = ggplotGrob(gw_dot_DEC100), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)
d150 <- gw_line_DEC150 + annotation_custom(grob = ggplotGrob(gw_dot_DEC150), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)
d200 <- gw_line_DEC200 + annotation_custom(grob = ggplotGrob(gw_dot_DEC200), xmin = 3500, xmax = 7500, ymin = 20, ymax = 60)


final <- plot_grid(b100, b150, b200, i100, i150, i200, d100, d150, d200,
                   labels = c("A", "B", "C", "D", "E", "F", "G", "H", "I"), ncol = 3, align = "h")

ggsave("final_gw.png", final, width = 12, height = 14, dpi = 300)






#############
##-Gangnam-##
#############

gw_dot_BAU100 <- gangnam1 %>% 
  filter(Scenario == "BAU" & AC == "AC100", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_BAU150 <- gangnam1 %>% 
  filter(Scenario == "BAU" & AC == "AC150", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_BAU200 <- gangnam1 %>% 
  filter(Scenario == "BAU" & AC == "AC200", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_INC100 <- gangnam1 %>% 
  filter(Scenario == "INC" & AC == "AC100", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_INC150 <- gangnam1 %>% 
  filter(Scenario == "INC" & AC == "AC150", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))



gw_dot_INC200 <- gangnam1 %>% 
  filter(Scenario == "INC" & AC == "AC200", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_DEC100 <- gangnam1 %>% 
  filter(Scenario == "DEC" & AC == "AC100", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_DEC150 <- gangnam1 %>% 
  filter(Scenario == "DEC" & AC == "AC150", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))


gw_dot_DEC200 <- gangnam1 %>% 
  filter(Scenario == "DEC" & AC == "AC200", `[step]` == 8763) %>% 
  ggplot(aes(x = reorder(Abb, Value), y = Value)) + 
  geom_point(colour = "black") +
  guides(fill=FALSE) + 
  coord_flip() +
  xlab("") +
  ylab("%")  +
  theme_bw()+
  theme(legend.position = "",
        panel.background = element_rect(fill = "transparent"), # bg of the panel
        plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text.x = element_text(size=9, angle = 90),
        axis.text.y = element_text(size=9),
        axis.title=element_text(size=12),
        strip.text = element_text(size = 4))



#################
#--Line Graph--##
#################

gw_line_BAU100 <- gangnam1 %>% 
  filter(Scenario == "BAU" & AC == "AC100") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60,90), limits = c(0,45)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_BAU150 <- gangnam1 %>% 
  filter(Scenario == "BAU" & AC == "AC150") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,45)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_BAU200 <- gangnam1 %>% 
  filter(Scenario == "BAU" & AC == "AC200") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,45)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 



gw_line_INC100 <- gangnam1 %>% 
  filter(Scenario == "INC" & AC == "AC100") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,80)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_INC150 <- gangnam1 %>% 
  filter(Scenario == "INC" & AC == "AC150") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,80)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_INC200 <- gangnam1 %>% 
  filter(Scenario == "INC" & AC == "AC200") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,80)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_DEC100 <- gangnam1 %>% 
  filter(Scenario == "DEC" & AC == "AC100") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,45)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_DEC150 <- gangnam1 %>% 
  filter(Scenario == "DEC" & AC == "AC150") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,45)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 


gw_line_DEC200 <- gangnam1 %>% 
  filter(Scenario == "DEC" & AC == "AC200") %>% 
  ggplot(aes(x=`[step]`, y=Value, group = Subdistrict, color = Subdistrict)) +
  geom_line(size = 0.8) +
  xlab("ticks") +
  ylab("Risk population (%)") +
  geom_dl(aes(label = Subdistrict), method= "last.qp", cex=.8) +
  scale_y_continuous(breaks = c(0,5,10,20,40,60), limits = c(0,45)) +
  scale_x_continuous(breaks = c(4000,7000,8763), limits = c(4000,10500)) +
  theme_bw() +
  theme(legend.position = "",
        legend.title=element_text(size=12),
        legend.text=element_text(size=12),
        axis.text=element_text(size=12),
        axis.title=element_text(size=12),
        strip.text = element_text(size =12)) 




############################


b100 <- gw_line_BAU100 + annotation_custom(grob = ggplotGrob(gw_dot_BAU100), xmin = 3500, xmax = 7500, ymin = 10, ymax = 45)
b150 <- gw_line_BAU150 + annotation_custom(grob = ggplotGrob(gw_dot_BAU150), xmin = 3500, xmax = 7500, ymin = 10, ymax = 45)
b200 <- gw_line_BAU200 + annotation_custom(grob = ggplotGrob(gw_dot_BAU200), xmin = 3500, xmax = 7500, ymin = 10, ymax = 45)

i100 <- gw_line_INC100 + annotation_custom(grob = ggplotGrob(gw_dot_INC100), xmin = 3500, xmax = 7500, ymin = 20, ymax = 80)
i150 <- gw_line_INC150 + annotation_custom(grob = ggplotGrob(gw_dot_INC150), xmin = 3500, xmax = 7500, ymin = 20, ymax = 80)
i200 <- gw_line_INC200 + annotation_custom(grob = ggplotGrob(gw_dot_INC200), xmin = 3500, xmax = 7500, ymin = 20, ymax = 80)

d100 <- gw_line_DEC100 + annotation_custom(grob = ggplotGrob(gw_dot_DEC100), xmin = 3500, xmax = 7500, ymin = 10, ymax = 45)
d150 <- gw_line_DEC150 + annotation_custom(grob = ggplotGrob(gw_dot_DEC150), xmin = 3500, xmax = 7500, ymin = 10, ymax = 45)
d200 <- gw_line_DEC200 + annotation_custom(grob = ggplotGrob(gw_dot_DEC200), xmin = 3500, xmax = 7500, ymin = 10, ymax = 45)


final <- plot_grid(b100, b150, b200, i100, i150, i200, d100, d150, d200,
                   labels = c("A", "B", "C", "D", "E", "F", "G", "H", "I"), ncol = 3, align = "h")

ggsave("final_gn.png", final, width = 12, height = 14, dpi = 300)






