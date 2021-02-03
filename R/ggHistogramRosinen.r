#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"ggHistogramRosinen"

require(data.table)

setwd("~/git/R/MiniTomatoes/R")

source("lib/copyright.r")
source("lib/myfunctions.r")
source("lib/sql.r")
library(REST)
library(ggplot2)
library(viridis)
library(hrbrthemes)


df <- MT_Select ( SQL = paste('select * from Rosinen;' ))

blp <- ggplot(df, aes(x=weight)) + 
  geom_histogram(binwidth=0.05, color="black", fill="lightblue")

ggsave(plot = blp, file = paste('../png/', MyScriptName,"-", box,  ".png", sep="")
       , type = "cairo-png",  bg = "white"
       , width = 29.7, height = 21, units = "cm", dpi = 150)
