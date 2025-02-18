#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

setwd('~/git/R/MiniTomatoes/R')

options( scipen = 999 )  # turn-off scientific notation like 1e+48

MyScriptName <- "TTest.r"

require(data.table)

source("lib/sql.r")

library(ggplot2)
library(gridExtra)


theme_set(theme_bw())  # pre-set the bw theme.

for (b in 3:6) {
  
  df <- RunSQL ( SQL = paste('select * from Tomatoes2 where boxId = ', b, ' or boxId = 7;')  )
  print(t.test( formula = weight ~ boxId , data = df))

}

df <- RunSQL ( SQL = paste('select * from Eier where sizeclass = "L";')  )

T = t.test( df$weight, mu = (73+63)/2, alternative = 'two.sided' ) 

print(T)

