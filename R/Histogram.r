#!/usr/bin/env Rscript
#
#
# Script: Histogram.r
#
# Stand: 2022-12-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"Histogram"

require(data.table)
library(tidyverse)
library(grid)
library(gridExtra)
library(gtable)
library(lubridate)
library(ggplot2)
library(ggrepel)
library(viridis)
library(hrbrthemes)
library(scales)
library(ragg)

if (rstudioapi::isAvailable()){
  
  # When called in RStudio
  SD <- unlist(str_split(dirname(rstudioapi::getSourceEditorContext()$path),'/'))
  
} else {
  
  #  When called from command line 
  SD = (function() return( if(length(sys.parents())==1) getwd() else dirname(sys.frame(1)$ofile) ))()
  SD <- unlist(str_split(SD,'/'))
  
}

WD <- paste(SD[1:(length(SD)-1)],collapse='/')
setwd(WD)

source("R/lib/copyright.r")
source("R/lib/myfunctions.r")
source("R/lib/sql.r")


# Output folder for PNG

OUTDIR <-'png/'
dir.create( OUTDIR, showWarnings = FALSE, recursive = FALSE, mode = "0777" )

citation = paste( '© Thomas Arend 2022' )

CI <- 0.95

options(
  digits = 7
  ,   scipen = 999111
  ,   Outdec = "."
  ,   max.print = 3000
)
png(  paste(OUTDIR, MyScriptName, '.png',sep='' )
      , width = 1920
      , height = 1080
)

par ( mfcol=c(2,2) )

# Get Data from database

data <- RunSQL()

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
