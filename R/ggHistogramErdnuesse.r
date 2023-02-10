#!/usr/bin/env Rscript
#
#
# Script: ggHistogramEier.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"ggHistogramErdnuesse"

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

outdir <- 'png/Erdnuesse/'
dir.create( outdir , showWarnings = FALSE, recursive = TRUE, mode = "0777")

citation = paste( '© Thomas Arend 2023\nhttps://github.com/Byggvir/MiniTomatoes' )

df <- RunSQL( SQL = paste('select * from Erdnuesse where Makel = FALSE;' ))

mg <- mean(df$weight)
ng <- median(df$weight)
sg <- sd(df$weight)

bin_width <- ceiling(sg) / 5

  df %>% ggplot( aes( x = weight ) ) + 
    geom_histogram( color = 'black'
                    , fill = 'cyan'
                    , binwidth = bin_width ) +
    labs(  title = paste('Erdnüsse', sep='')
           , subtitle = paste ( 'Gewichtsverteilung der Erdnüsse in einer Tüte')
           , x = "Gewicht [g]"
           , y = "Anzahl" 

           , caption = citation ) +
    theme_ipsum() -> PHist

  ggsave( plot = PHist
        , file = paste( outdir, MyScriptName, '.png', sep="")
        , device = 'png'
        , bg = "white"
        , width = 1920
        , height = 1080
        , units = "px"
        , dpi = 144 
  )
  
  print(round(c(mg,ng,sg),2))
  
  print( shapiro.test( df$weight ) )
  print( t.test( df$weight, mu=400/170 ) )
