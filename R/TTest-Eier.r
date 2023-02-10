#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <- "TTest-Eier.r"

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

tt <- ( 68 - mean(df$weight) ) / sd(df$weight)*sqrt( nrow(df) ) 

print(pt(tt,nrow(df)))

df <- RunSQL ( SQL = paste('select * from Eier where sizeclass = "L";')  )
T = t.test( df$weight, mu = ( 73 + 63 )/2, alternative = 'two.sided' ) 

print(T)

