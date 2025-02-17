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

outdir <- 'png/Distribution/'
dir.create( outdir , showWarnings = FALSE, recursive = TRUE, mode = "0777")

w1 <- read.csv('../data/data1.csv', dec = '.', )

weight <-as.data.table(table(w1$weight))

colnames(weight) <- c('Gewicht', 'Anzahl')

# setorder(weight,Gewicht)

gseq <- seq(1,max(weight[,2])+1)
gcount <- rep(0,length(gseq))

w <- data.frame(

  Gewicht = gseq
  , Anzahl = gcount
)

for (i in 1:nrow(weight)) {

  w[as.numeric(weight[i,1]),2] <- weight[i,2]

}
  
blp <- ggplot( w, aes( x = Gewicht, y = Anzahl ) ) + 
  geom_histogram(stat = "identity")

ggsave( plot = blp
      , file = paste( outdir, MyScriptName,".png", sep="")
      , device = "png"
      , bg = "white"
      , width = 1020
      , height = 1080
      , units = "px"
      , dpi = 144
)

print ( c(mean(w1[,2]), sd(w1[,2])))
