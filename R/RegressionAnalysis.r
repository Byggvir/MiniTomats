#!usr/bin/env Rscript
#
#
# Script: RKI_RegressionAnalysisKw.r
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


setwd('/home/thomas/git/R/MiniTomatoes/R')

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



plot_box  <- function ( df , box) {
  
png(  paste('../png/', MyScriptName, '-', box, '.png',sep='' )
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

for ( box in 3:5 ) {
  
  # Einlesen der Messwerte aus der MariaDB
  
  df <- MT_Select ( SQL = paste('select * from Tomatoes2 where boxId =', box,';' ))  
  plot_box(df, box)
  
}

df <- MT_Select ( SQL = paste('select * from Tomatoes2;' ))  
plot_box(df,0)


