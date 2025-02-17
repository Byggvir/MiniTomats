#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2023-02-08
# (c) 2023 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <- "ggHistogramRosinen"

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

if ( rstudioapi::isAvailable() ){
  
  # When executed in RStudio
  SD <- unlist( str_split( dirname( rstudioapi::getSourceEditorContext()$path), '/') )
  
} else {
  
  #  When executed on command line 
  SD = (function() return( if( length( sys.parents() ) == 1 ) getwd() else dirname( sys.frame(1)$ofile ) ) )()
  SD <- unlist( str_split( SD, '/' ) )
  
}

WD <- paste( SD[ 1:(length(SD)-1) ], collapse='/' )

setwd( WD )

source("R/lib/myfunctions.r")
source("R/lib/sql.r")

outdir <- 'png/Rosinen/'
dir.create( outdir , showWarnings = FALSE, recursive = TRUE, mode = "0777")

citation = paste( '© Thomas Arend 2022\nhttps://github.com/Byggvir/MiniTomatoes' )

df <- RunSQL ( SQL = paste('select * from Rosinen;' ))

blp <- ggplot(df, aes(x=weight)) + 
  geom_histogram(binwidth=0.05, color="black", fill="lightblue")

ggsave( plot = blp
      , file = paste( outdir, MyScriptName, ".png", sep="")
      , device = 'png'
      , bg = "white"
      , width = 1920
      , height = 1080
      , units = "px"
      , dpi = 144)
