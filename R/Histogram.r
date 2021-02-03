#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"RegressionAnalysis"

library(tidyverse)
library(lubridate)
library(REST)

require(data.table)


setwd('~/git/R/MiniTomatoes/R')

source("lib/copyright.r")
source("lib/myfunctions.r")
source("lib/sql.r")

CI <- 0.95

options(
  digits = 7
  ,   scipen = 999111
  ,   Outdec = "."
  ,   max.print = 3000
)
png(  paste('../png/', MyScriptName, '.png',sep='' )
      , width = 1920
      , height = 1080
)

par ( mfcol=c(2,2) )

# Get Data from database

data <- MT_Select()

plot(  table(data$weight)
     , type = 'h'
     , main = "Minitomato Histogram"
     , sub = "Using simple plot"
     , xlab = "Weight [g]"
     )

plot(  table(round(data$len,1))
       , type = 'h'
       , main = "Minitomato Histogram"
       , sub = "Using simple plot"
       , xlab = "Length [mm]"
       )

plot(  table(round(data$dia,1))
       , type = 'h'
       , main = "Minitomato Histogram"
       , sub = "Using simple plot"
       , xlab = "Diameter [mm´]"
)
hist(    data$weight
       , main = "Minitomato Histogram"
       , sub = "Using simple hist"
       , xlab = "Weight [g]"

       )

dev.off()
