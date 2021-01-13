#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"ggHistogram"

require(data.table)

setwd("~/git/R/MiniTomatoes/Rscript")

source("lib/copyright.r")
source("lib/myfunctions.r")
source("lib/sql.r")
library(REST)
library(ggplot2)
library(viridis)
library(hrbrthemes)


plot_box  <- function ( box ) {
  
df <- MT_Select ( SQL = paste('select * from Tomatoes where boxId =', box,';' ))

blp <- ggplot(df, aes(x=weight)) + 
  geom_histogram(binwidth=1, color="black", fill="lightblue")

ggsave(plot = blp, file = paste('../png/', MyScriptName,"-", box,  ".png", sep="")
       , type = "cairo-png",  bg = "white"
       , width = 29.7, height = 21, units = "cm", dpi = 150)
}

for ( b in 2:3 ) {
  
  plot_box(b)
  
}
