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

OUTDIR <-'png/Minitomatoes/'
dir.create( OUTDIR, showWarnings = FALSE, recursive = FALSE, mode = "0777" )

citation = paste( '© Thomas Arend 2022\nhttps://github.com/Byggvir/MiniTomatoes' )

CI <- 0.95

options(
  digits = 7
  ,   scipen = 999
  ,   Outdec = "."
  ,   max.print = 3000
)



plot_box  <- function ( df) {

  df$x <- df$len*df$dia^2
  df$y <- df$weight
  
  ra <- lm(df$y ~ df$x)
  ci <- confint(ra, level = CI)
    
  a <- c(ci[1, 1], ra$coefficients[1] , ci[1, 2])
  b <- c(ci[2, 1], ra$coefficients[2] , ci[2, 2])
  
  print(ra)
  print(ci)

  df %>% 
    ggplot( aes(x = len * dia ^2, y = weight ) ) +
     geom_point() +
     geom_smooth() +
     scale_x_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
     scale_y_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
       theme_ipsum () +
       theme(  legend.position="right"
               #            , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
       ) +
       labs(  title = paste( 'Minitomaten' )
              , subtitle = paste( 'Gewicht in Abhänigkeit von Länge * Durchmesser zum Quadrat' )
              , x = "Volumen Quader l * d² [mm³]"
              , y = "Gewicht [g]"
              , colour = 'Legende'
              , caption = citation
       )  -> scp
 
  ggsave( plot = scp
          , file = paste( OUTDIR, MyScriptName,"-G-V.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )
  
  scp <- scp + facet_wrap(vars(Box))
  
  ggsave( plot = scp
          , file = paste( OUTDIR, MyScriptName,"-G-V-Eimer.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )

  df %>% 
    ggplot( aes(x = len, y = weight ) ) +
    geom_point() +
    geom_smooth() +
    scale_x_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    scale_y_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    theme_ipsum () +
    theme(  legend.position="right"
            #            , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
    ) +
    labs(  title = paste( 'Minitomaten' )
           , subtitle = paste( 'Gewicht in Abhänigkeit der Länge' )
           , x = "Länge [mm]"
           , y = "Gewicht [g]"
           , colour = 'Legende'
           , caption = citation
    )  -> scp
  
  ggsave( plot = scp
          , file = paste( OUTDIR, MyScriptName,"-G-L.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 
    )
  
  scp <- scp + facet_wrap(vars(Box))
  
  ggsave( plot = scp
          , file = paste( OUTDIR, MyScriptName,"-G-L-Eimer.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144  
  )

}


SQL <- 'select * from Tomatoes2;'

df <- RunSQL ( SQL =  SQL)
df$Box <- factor(df$boxId, levels = unique(df$boxId),  labels = paste( 'Eimer', unique(df$boxId) - 2) )

plot_box(df)
