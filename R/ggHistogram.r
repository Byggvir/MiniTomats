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

# Output folder for SVG

OUTDIR <-'png/Minitomatoes/'
dir.create( OUTDIR, showWarnings = FALSE, recursive = FALSE, mode = "0777" )

citation = paste( '© Thomas Arend 2022\nhttps://github.com/Byggvir/MiniTomatoes' )


plot_box  <- function ( df ) {

  
  df %>% ggplot( aes( x = weight ) ) + 
    geom_histogram( binwidth = 1 , color = "black", fill = "lightblue") +
    geom_text( stat = 'bin', binwidth = 1, aes ( label = after_stat(count) ), vjust = 0 ) +
    scale_x_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    scale_y_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    theme_ipsum () +
    theme(  legend.position="right"
#            , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
            ) +
    labs(  title = paste( 'Minitomaten' )
           , subtitle = paste( 'Gewichtsverteilung' )
           , x = "Gewicht [g]"
           , y = "Anzahl"
           , colour = 'Legende'
           , caption = citation
    )  -> blp 
  

  ggsave( plot = blp
          , file = paste( OUTDIR, MyScriptName,"-Gewicht.png", sep="")
          ,  bg = "white"
          , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )

  blp <- blp + facet_wrap(vars(Box))

  ggsave( plot = blp
          , file = paste( OUTDIR, MyScriptName,"-Gewicht-Eimer.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )
  
  breaks_len <- round(min(df$len)):round(max(df$len))
  
  df %>% ggplot( aes( x = len ) ) + 
    geom_histogram( binwidth = 1 , color = "black", fill = "lightblue") +
    geom_text( stat = 'bin', binwidth = 1, aes ( label = after_stat(count) ), vjust = 0 ) +
    scale_x_continuous( breaks = breaks_len, labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    scale_y_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    theme_ipsum () +
    theme(  legend.position="right"
            #            , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
    ) +
    labs(  title = paste( 'Minitomaten' )
           , subtitle = paste( 'Längenverteilung' )
           , x = "Länge [mm]"
           , y = "Anzahl"
           , colour = 'Legende'
           , caption = citation
    )  -> blp 
  
  
  ggsave( plot = blp
          , file = paste( OUTDIR, MyScriptName,"-Laenge.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )
  
  blp <- blp + facet_wrap(vars(Box))
  
  ggsave( plot = blp
          , file = paste( OUTDIR, MyScriptName,"-Laenge-Eimer.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )

  breaks_dia <- round(min(df$dia)):round(max(df$dia))
  
  df %>% ggplot( aes( x = dia ) ) + 
    geom_histogram( binwidth = 1 , color = "black", fill = "lightblue") +
    geom_text( stat = 'bin', binwidth = 1, aes ( label = after_stat(count) ), vjust = 0 ) +
    scale_x_continuous( breaks = breaks_dia, labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    scale_y_continuous( labels = function (x) format(x, big.mark = ".", decimal.mark= ',', scientific = FALSE ) ) +
    theme_ipsum () +
    theme(  legend.position="right"
            #            , axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
    ) +
    labs(  title = paste( 'Minitomaten' )
           , subtitle = paste( 'Verteilung des Durchmessers' )
           , x = "Durchmesser [mm]"
           , y = "Anzahl"
           , colour = 'Legende'
           , caption = citation
    )  -> blp 
  
  
  ggsave( plot = blp
          , file = paste( OUTDIR, MyScriptName,"-Durchmesser.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )
  
  blp <- blp + facet_wrap(vars(Box))
  
  ggsave( plot = blp
          , file = paste( OUTDIR, MyScriptName,"-Durchmesser-Eimer.png", sep="")
          ,  bg = "white"
            , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 )
  
}

SQL <- 'select * from Tomatoes2;'

df <- RunSQL ( SQL =  SQL)
df$Box <- factor(df$boxId, levels = unique(df$boxId),  labels = paste( 'Eimer', unique(df$boxId) - 2) )

plot_box(df)

print(
  round(
    c( mean(df$weight)
     , mean(df$len)
     , mean(df$dia)
     )
    , 4
    )
  )
