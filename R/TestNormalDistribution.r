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

plot_box  <- function ( box ) {

df <- MT_Select ( SQL = paste('select * from Tomatoes2 where boxId =', box,';' ))

df$vol <- df$len * df$dia ^ 2 * pi
df$l3 <- df$len ^ 3

# Test norm

print(shapiro.test(df$len))
print(shapiro.test(df$dia))
print(shapiro.test(df$weight))


}


for ( b in 3:5 ) {
  
  plot_box(b)
  
}
