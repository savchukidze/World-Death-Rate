library(ggplot2) #vis
library(ggalt) #coord
library(dplyr) #manipulations
library(viridis) #colours
library(season) #easy palette
library(sf)

#world map
world <- map_data("world")

#del Antarctica
world <- world[world$region != "Antarctica", ]

#get data
death_rate <- readxl::read_excel("death.xlsx")
death_map <- full_join(world, death_rate, by = "region")

#scale
brks_scale <- seq(0, 14, 2)

#vis
png('world_death.png', height = 1455*1.5, width = 2570*1.5)

ggplot(death_map) +
   geom_polygon(aes(x = long, y = lat, group = group, fill = death_map$death_rate),
                alpha = 0.9, size = 0.5)+
   geom_path(aes(x = long, y = lat, group = group), 
             color = "black", size = 0.2) +
   
   coord_proj("+proj=robin +lon_0=0 +x_0=0 +y_0=20 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")+
   
   scale_fill_viridis(option = "C",
                      direction = -1, 
                      breaks = brks_scale,
                      name = "на 1,000 осіб",
   guide = guide_legend(
      direction = "vertical",
      keyheight = unit(7, units = "mm"), 
      keywidth = unit(75, units = "mm"),
      title.position = 'top',
      title.hjust = 0.5,
      label.hjust = 0.5,
      nrow = 1,
      byrow = T,
      reverse = F,
      label.position = "bottom"))+
   
   labs(x = NULL, y = NULL,
        title = "Рівень смертності" )+ 
   
   theme_minimal(base_family = "Alegreya SC Regular")+
   theme(
      text = element_text(color = '#3A3F4A'), 
      axis.text = element_blank(),
      axis.ticks.length = unit(1, 'lines'),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = 'top',
      legend.text = element_text(size = 26*1.5, color = 'black'),
      legend.title = element_text(size = 30*1.5, color = 'black'),
      plot.title = element_text(face = "bold", size = 60*1.5, hjust = 0.5, margin = margin(t = 90, b = 75), color = 'black', family = "Alegreya SC Bold"),
      plot.background = element_rect(fill = "#f5f5f2", color = "#f5f5f2"),
      panel.background = element_rect(fill = "#f5f5f2", color = NA),
      legend.background = element_rect(fill = "#f5f5f2", color = NA),
      plot.margin = unit(c(1.5, 1.5, 1.5, 1.5), "cm")
   )

dev.off()