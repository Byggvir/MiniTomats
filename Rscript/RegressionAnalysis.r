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


setwd('/home/thomas/git/R/MiniTomatoes/Rscript')

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



plot_box  <- function ( box ) {
  
png(  paste('../png/', MyScriptName, '-', box, '.png',sep='' )
      , width = 1920
      , height = 1080
)


# Einlesen der Messwerte eus der MariaDB

df <- MT_Select ( SQL = paste('select * from Tomatoes where boxId =', box,';' ))
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

for ( b in 2:4 ) {
  
  plot_box(b)
  
}

