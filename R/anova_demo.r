#!usr/bin/env Rscript
#
#
# Script: RegressionAnalysis.r
#
# Stand: 2022-12-21
# (c) 2020 by Thomas Arend, Rheinbach
# E-Mail: thomas@arend-rhb.de
#

MyScriptName <-"ggRegressionAnalysis"

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

if (rstudioapi::isAvailable()){
  
  # When called in RStudio
  SD <- unlist(str_split(dirname(rstudioapi::getSourceEditorContext()$path),'/'))
  
} else {
  
  #  When called from command line 
  SD = (function() return( if(length(sys.parents())==1) getwd() else dirname(sys.frame(1)$ofile) ))()
  SD <- unlist(str_split(SD,'/'))
  
}

WD <- paste(SD[1:(length(SD)-1)],collapse='/')
setwd(WD)

source("R/lib/sql.r")

# Output folder for PNG

OUTDIR <-'png/'
dir.create( OUTDIR, showWarnings = FALSE, recursive = FALSE, mode = "0777" )

citation = paste( '© Thomas Arend 2022\nhttps://github.com/Byggvir/MiniTomatoes' )

CI <- 0.95

options(
  digits = 7
  ,   scipen = 999
  ,   Outdec = "."
  ,   max.print = 3000
)

SQL <- 'select * from Tomatoes2;'

df <- RunSQL ( SQL =  SQL)
df$Box <- factor(df$boxId, levels = unique(df$boxId),  labels = paste( 'Eimer', unique(df$boxId) - 2) )

ra1 <- lm(data = df, formula = weight ~ len  )
ci1 <- confint(ra1, level = CI)

# print(ra1)
# print(ci1)

ra2 <- lm(data = df, formula = weight ~ (len * dia ^ 2))
ci2<- confint(ra2, level = CI)

# print(ra2)
# print(ci2)

print(anova(ra1,ra2))

