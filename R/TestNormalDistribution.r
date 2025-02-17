#!/usr/bin/env Rscript
#
#
# Script: CherryTomatos.r
#
# Stand: 2020-10-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

options(scipen=999)  # turn-off scientific notation like 1e+48

require(data.table)

source("lib/copyright.r")
source("lib/myfunctions.r")
source("lib/sql.r")

library(ggplot2)
library(gridExtra)

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


theme_set(theme_bw())  # pre-set the bw theme.

plot_box  <- function ( box , df ) {

df$vol <- df$len * df$dia ^ 2 * pi
df$l3 <- df$len ^ 3

# Test norm

print(shapiro.test(df$len))
print(shapiro.test(df$dia))
print(shapiro.test(df$weight))


}


for ( b in 3:6 ) {
  
  df <- RunSQL ( SQL = paste('select * from Tomatoes2 where boxId =', b,';')  )
  plot_box(b, df)
  
}

  df <- RunSQL ( SQL = paste('select * from Tomatoes2;' ))
  plot_box(0, df)
  
