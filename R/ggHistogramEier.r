#!/usr/bin/env Rscript
#
#
# Script: ggHistogramEier.r
# Stand: 2024-02-17
# (c) 2020-2025 by Thomas Arend, Rheinbach
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

source("R/lib/myfunctions.r")
source("R/lib/sql.r")

outdir <- 'png/Eier/'
dir.create( outdir , showWarnings = FALSE, recursive = TRUE, mode = "0777")

citation = paste( '© Thomas Arend 2022-2025\nhttps://github.com/Byggvir/MiniTomatoes' )

sc <- RunSQL( SQL = paste('select E.sizeclass, count(*) as Anzahl, K.weightFrom, K.weightTo from Eier as E join Eierklassen as K on E.sizeclass = K.sizeclass group by sizeclass;' ))
eggs <- RunSQL( SQL = paste('select E.*, case when K.weightFrom > weight then -1 else ( case when K.weightTo < weight then 1 else 0 end ) end as InNorm from Eier as E join Eierklassen as K on E.sizeclass = K.sizeclass;' ))
eggs[,Norm := factor( InNorm, levels =c(-1, 0, 1), labels = c('Zu klein', 'In Norm', 'Zu groß'))]

for ( i in 1:nrow(sc)) {
  
  s = sc$sizeclass[i]
  
  print(s)
  
  SD <- sd( (eggs %>% filter ( sizeclass == s ))$weight)

  bin_width = 1 #round(SD) / 5
  min_b <- floor(min((eggs %>% filter ( sizeclass == s ))$weight))
  max_b <- ceiling(max((eggs %>% filter ( sizeclass == s ))$weight))
  
  cols = c('Zu klein' = 'red', 'In Norm' = 'green', 'Zu groß' = 'blue')
  
  eggs %>% filter ( sizeclass == s ) %>% ggplot( aes( x = weight ) ) + 
    geom_histogram( aes(fill = Norm)
                    , color = 'black'
                    , binwidth = bin_width ) +
    stat_summary( aes(xintercept = after_stat(x), y = 0, colour = 'mean' )
                  , fun = mean
                  ,  geom = "vline", linewidth = 2, alpha = 0.5,  orientation = "y") +
    stat_summary( aes(xintercept = after_stat(x), y = 0, colour = '±1.96 σ' )
                  , fun = function(x) { mean(x) - 1.96 *sd(x)} 
                  ,  geom = "vline", linewidth = 2, alpha = 0.5,  orientation = "y") +
    stat_summary( aes(xintercept = after_stat(x), y = 0, colour = '±1.96 σ' )
                  , fun = function(x) { mean(x) + 1.96 *sd(x)}
                  ,  geom = "vline", linewidth = 2, alpha = 0.5,  orientation = "y") +
    scale_x_continuous( breaks = seq( from=min_b, to=max_b, by = 1  ) ) +
    scale_fill_manual(values = cols ) +
    labs(  title = paste( 'Eggs', sep='')
           , subtitle = paste ( 'Weight of', sc$Anzahl[i], 'eggs of size class', s)
           , x = "Weight [g]"
           , y = "Number" 
           , colour = 'Legende'
           , caption = citation ) +
    theme_ipsum() -> PHist

  ggsave( plot = PHist
        , file = paste( outdir, "Histogram_", s, '.png', sep="")
        , device = 'png'
        , bg = "white"
        , width = 1920
        , height = 1080
        , units = "px"
        , dpi = 144 
  )
  
  e = eggs %>% filter ( sizeclass == s )
  
  mu = mean( e$weight )
  sigma = sd( e$weight )
  me = median(e$weight)
  
  print(c(nrow(e), mu, sigma, me))
  
  ci =list( low = mu -1.96 * sigma
            , mean = mu
            , high = mu + 1.96 * sigma
          )
  #print(ci)
  
  ribbon <-
    ggplot_build(ggplot() + geom_density( data = e, aes( x = weight ) ))$data[[1]] %>%
    select(x,y) %>% 
    filter( x >= sc$weightFrom[i] & x <= sc$weightTo[i] )

  # '±1.96 σ'
  
  eggs %>% 
    filter ( sizeclass == s ) %>% 
    ggplot( aes( x = weight ) ) + 
    geom_density( aes( fill = 'Nein' )
                  , color = 'black'
                ) +
    geom_ribbon( data = ribbon
                 , aes( x = x, ymin = 0, ymax = y , fill = 'Ja' )
    ) +
    stat_summary( aes(xintercept = after_stat(x), y = 0, colour = 'mean' )
                  , fun = mean
                  ,  geom = "vline", linewidth = 2, alpha = 0.5,  orientation = "y") +
    stat_summary( aes(xintercept = after_stat(x), y = 0, colour = '±1.96 σ' )
                  , fun = function(x) { mean(x) - 1.96 *sd(x)} 
                  ,  geom = "vline", linewidth = 2, alpha = 0.5,  orientation = "y") +
    stat_summary( aes(xintercept = after_stat(x), y = 0, colour = '±1.96 σ' )
                  , fun = function(x) { mean(x) + 1.96 *sd(x)}
                  ,  geom = "vline", linewidth = 2, alpha = 0.5,  orientation = "y") +
    
    scale_x_continuous( breaks = seq( from=min_b, to=max_b, by = 1  ) ) +
    scale_fill_manual( values = c( 'red', 'cyan' ), breaks = c( 'Nein', 'Ja') ) +
    labs(  title = paste('Eggs', sep='' )
           , subtitle = paste ( 'Density of the weight of', sc$Anzahl[i], 'eggs of size class', s)
           , x = "Weight [g]"
           , y = "Density" 
           , colour = 'Legende'
           , fill = 'In der Norm'
           , caption = citation ) +
    theme_ipsum() -> PDensity
  
  ggsave( plot = PDensity
          , file = paste( outdir, "Density_", s, '.png', sep="")
          , device = 'png'
          , bg = "white"
          , width = 1920
          , height = 1080
          , units = "px"
          , dpi = 144 
  )

  w = RunSQL( SQL = paste('select * from Eierklassen where sizeclass = "', sc$sizeclass[i] , '";', sep = '' ) )
  
  print(nrow(e %>% filter(weight <= w$weightFrom)) )
  

  if ( w$weightFrom[1] > 0 & w$weightTo[1] <= 73 ) {
    print( t.test( ( eggs %>% filter( sizeclass == s ) )$weight, mu = ( w$weightFrom[1] + w$weightTo[1] ) / 2, alternative = 'two.sided' ) )
  }
    print( shapiro.test( ( eggs %>% filter( sizeclass == s ) )$weight ) )
  if (nrow(eggs %>% filter( sizeclass == s )) > 7 ) {
    print( ad.test( ( eggs %>% filter( sizeclass == s ) )$weight ) )
  }

}
