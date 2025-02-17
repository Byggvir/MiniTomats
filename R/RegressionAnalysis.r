#!usr/bin/env Rscript
#
#
# Script: RegressionAnalysis.r
#
# Stand: 2022-12-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"RegressionAnalysis"

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

source("R/lib/sql.r")

# Output folder for PNG

OUTDIR <-'png/RA/'
dir.create( OUTDIR, showWarnings = FALSE, recursive = FALSE, mode = "0777" )

citation = paste( '© Thomas Arend 2022' )

source("R/lib/copyright.r")
source("R/lib/myfunctions.r")
source("R/lib/sql.r")

CI <- 0.95

options(
  digits = 7
  ,   scipen = 999111
  ,   Outdec = "."
  ,   max.print = 3000
)



plot_box  <- function ( df , box) {
  
png(  paste( OUTDIR, MyScriptName, '-', box, '.png',sep='' )
      , width = 1920
      , height = 1080
)

df$x <- df$len*df$dia^2
df$y <- df$weight

ra <- lm(df$y ~ df$x)
ci <- confint(ra, level = CI)
  
a <- c(ci[1, 1], ra$coefficients[1] , ci[1, 2])
b <- c(ci[2, 1], ra$coefficients[2] , ci[2, 2])

xlim <- limbounds(df$x,TRUE)
ylim <- limbounds(df$y,TRUE)

plot( df$x
    , df$y 
    , xlim = xlim
    , ylim = ylim
    , xlab = 'Volume ~ l*d^2'
    , ylab = 'weight [g]'
     
)

print(ra)
print(ci)

abline(ci[,1], col= "red")
abline(ci[,2], col= "red")
abline(ra$coefficients, col= "blue")

abline(v=min(df$x), col= "orange")
abline(v=max(df$x), col= "orange")
abline(h=min(df$y), col= "orange")
abline(h=max(df$y), col= "orange")

copyright()
  
dev.off()

}

for ( box in 3:7 ) {
  
  # Einlesen der Messwerte aus der MariaDB
  
  df <- RunSQL ( SQL = paste('select * from Tomatoes2 where boxId =', box,';' ))  
  plot_box(df, box)
  
}

df <- RunSQL ( SQL = paste('select * from Tomatoes2;' ))  
plot_box(df,0)


