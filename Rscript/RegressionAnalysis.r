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


# Einlesen der Daten aus den aufbereiteten kummulierten Fällen des RKI

df <- MT_Select ( SQL = paste('select * from Tomatoes where boxId =', box,';' ))
df$vol <- df$len * (df$dia ^ 2) * pi / 3
df$len3 <- sqrt(df$len*df$dia) ^ 3

ra <- lm(df$weight ~ df$vol)
ci <- confint(ra, level = CI)
  
a <- c(ci[1, 1], ra$coefficients[1] , ci[1, 2])
b <- c(ci[2, 1], ra$coefficients[2] , ci[2, 2])

xlim <- limbounds(df$vol,TRUE)
ylim <- limbounds(df$weight,TRUE)

plot( df$vol
    , df$weight 
    , xlim = xlim
    , ylim = ylim
    , xlab = 'Volume ~ l*d*&pi;/3'
    , ylab = 'weight [mm³]'
     
)

print(ra)
print(ci)

abline(ci[,1], col= "red")
abline(ci[,2], col= "red")
abline(ra$coefficients, col= "blue")

copyright()
  
dev.off()

}

for ( b in 2:3 ) {
  
  plot_box(b)
  
}

