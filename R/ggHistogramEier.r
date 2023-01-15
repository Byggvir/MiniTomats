#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"ggHistogramEier"

library(tidyverse)
library(grid)
library(gridExtra)
library(gtable)
library(lubridate)
library(ggplot2)
library(viridis)
library(hrbrthemes)
library(scales)
library(ragg)

# Set Working directory to git root

if (rstudioapi::isAvailable()){
  
  # When executed in RStudio
  SD <- unlist(str_split(dirname(rstudioapi::getSourceEditorContext()$path),'/'))
  
} else {
  
  #  When executi on command line 
  SD = (function() return( if(length(sys.parents())==1) getwd() else dirname(sys.frame(1)$ofile) ))()
  SD <- unlist(str_split(SD,'/'))
  
}

WD <- paste(SD[1:(length(SD)-1)],collapse='/')

setwd(WD)

source("R/lib/myfunctions.r")
source("R/lib/sql.r")

outdir <- 'png/Eier/'
dir.create( outdir , showWarnings = FALSE, recursive = TRUE, mode = "0777")

df <- RunSQL ( SQL = paste('select * from Eier;' ))

blp <- df %>% ggplot( aes( x = weight, group = sizeclass ) ) + 
  geom_histogram( aes( fill = sizeclass), binwidth = 1 ) +
  labs(  title = paste('Eier', sep='')
         , subtitle = paste ( 'Gewichte nach Größenklassen')
         , x = "Gewicht [g]"
         , y = "Anzahl" 
         , colour = "Größenklasse"
         , caption = citation ) +
  theme_ipsum()
  

ggsave( plot = blp
      , file = paste( outdir, MyScriptName,".png", sep="")
      , device = 'png'
      , bg = "white"
      , width = 1920
      , height = 1080
      , units = "px"
      , dpi = 144 
)
