#!/usr/bin/env Rscript
#
#
# Script: TTest-Eier.r
#
# Stand: 2024-02-17
# (c) 2020 - 2025 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

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
library(nortest)

# Set Working directory to git root

if (rstudioapi::isAvailable()){
  
  # When executed in RStudio
  SD <- unlist(str_split(dirname(rstudioapi::getSourceEditorContext()$path),'/'))
  
} else {
  
  #  When executi on command line 
  SD = ( function() return( if( length( sys.parents()) == 1 ) getwd() else dirname( sys.frame( 1 )$ofile) ) )()
  SD <- unlist(str_split(SD,'/'))
  
}

WD <- paste(SD[1:(length(SD))],collapse='/')

setwd(WD)

require(data.table)
source("lib/myfunctions.r")
source("lib/sql.r")

w = RunSQL( SQL = paste('select * from Eierklassen where weightFrom > 0 and weightTo <= 73;', sep = '' ) )

for ( i in 1:nrow(w)) {
  
  print(w$classname[i])
  
  MEAN <- ( w$weightFrom[i] + w$weightTo[i] ) / 2
  
  eggs <- RunSQL ( SQL = paste('select * from Eier where sizeclass = "', w$sizeclass[i], '";' , sep = '')  )
  
  TT = t.test( eggs$weight, mu = MEAN, alternative = 'two.sided' ) 
  
  tt <- ( MEAN - mean(eggs$weight) ) / sd(eggs$weight)*sqrt( nrow(eggs) ) 
  
  print(pt(tt,nrow(eggs)-1))
  
  print(TT)

}

i = 1
for ( B in unique(eggs$boxId)) { 
  TT = t.test ( (eggs %>% filter (boxId == B) )$weight, mu = 58 ) 
  cat(i, B, TT$p.value, '\n')
  i = i+1
    
}
