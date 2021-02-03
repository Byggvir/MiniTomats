#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

setwd('~/git/R/MiniTomatoes/Rscript')

options(scipen=999)  # turn-off scientific notation like 1e+48
MyScriptName <- "ScatterPlot"

require(data.table)

source("lib/copyright.r")
source("lib/myfunctions.r")
source("lib/sql.r")

library(REST)
library(ggplot2)
library(gridExtra)


theme_set(theme_bw())  # pre-set the bw theme.

plot_box  <- function ( df, box ) {

df$vol <- df$len * df$dia ^ 2 * pi
df$l3 <- df$len ^ 3

# Scatterplot


p1 <- ggplot(df, aes(x=as.numeric(vol), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Volume", 
       x="Volume [mm³]",
       y="Weigth [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p2 <- ggplot(df, aes(x=as.numeric(len), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Length", 
       x="Length [mm]",
       y="Weigth [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p3 <- ggplot(df, aes(x=as.numeric(dia), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Diameter", 
       x="Diameter [mm]",
       y="Weigth [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p4 <- ggplot(df, aes(x=as.numeric(l3), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Length³", 
       x="Length³ [mm³]",
       y="Weight [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p5 <- ggplot(df, aes(x=as.numeric(len), y=as.numeric(dia))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Diameter ~ Length³", 
       x="Length [m]",
       y="Diameter [m]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")


gg <- grid.arrange(p1,p2,p3,p4,p5, ncol=2)

plot(gg)

ggsave(plot = gg, file = paste('../png/', MyScriptName, '-',box, '.png', sep='')
       , type = "cairo-png",  bg = "white"
       , width = 29.7, height = 21, units = "cm", dpi = 150)

}


for ( box in 2:5 ) {
  
  df <- MT_Select ( SQL = paste('select * from Tomatoes2 where boxId >=', box,';' ))
  plot_box(df, box)
  
}
df <- MT_Select ( SQL = paste('select * from Tomatoes2;' ))
plot_box(df, 0)
