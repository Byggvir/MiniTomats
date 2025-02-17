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
MyScriptName <- "ScatterPlot"

require(data.table)
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

# Output folder for PNG

OUTDIR <-'png/Minitomatoes/'
dir.create( OUTDIR, showWarnings = FALSE, recursive = FALSE, mode = "0777" )

source("R/lib/copyright.r")
source("R/lib/myfunctions.r")
source("R/lib/sql.r")

theme_set(theme_bw())  # pre-set the bw theme.

CI <- 0.95

plot_box  <- function ( df, box ) {

df$vol <- df$len * df$dia ^ 2 * pi
df$l3 <- df$len ^ 3
df$d2 <- df$dia ^ 2

# Scatterplot


p1 <- ggplot(df, aes( x = vol, y = weight)) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ len * dia²", 
       x="Volume [mm³]",
       y="Weigth [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

ra <- lm(formula = weight ~ vol , data = df)
ci <- confint(ra, level = CI)

print(ra$coefficients)
print(ci)

p2 <- ggplot(df, aes(x=as.numeric(len), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Length", 
       x="Length [mm]",
       y="Weigth [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p3 <- ggplot(df, aes(x=as.numeric(dia), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Diameter", 
       x="Diameter [mm]",
       y="Weigth [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p4 <- ggplot(df, aes(x=as.numeric(l3), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Weight ~ Length³", 
       x="Length³ [mm³]",
       y="Weight [g]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p5 <- ggplot(df, aes(x=as.numeric(len), y=as.numeric(dia))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Diameter ~ Length", 
       x="Length [mm]",
       y="Diameter [mm]", 
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

p6 <- ggplot(df, aes(x=as.numeric(d2), y=as.numeric(weight))) + 
  geom_point( ) + 
  geom_smooth(method="lm", se=TRUE) + 
  labs(subtitle="Diameter ~ Length", 
       x="Diameter² [mm²]", 
       y="Weight [g]",
       title="Cherry Tomaten", 
       caption = "Source: Thomas Arend")

gg <- grid.arrange(p1,p2,p3,p4,p5,p6, ncol=2)

plot(gg)

ggsave( plot = gg
        , file = paste( OUTDIR, MyScriptName, '-',box, '.png', sep='' )
       , device = 'png'
       , bg = 'white'
       , width = 1920
       , height = 1080
       , units = "px"
       , dpi = 144)

}


# for ( box in 2:7 ) {
#   
#   df <- RunSQL ( SQL = paste( 'select * from Tomatoes2 where boxId >=', box,';' ))
#   plot_box(df, box)
#   
# }

df <- RunSQL( SQL = paste('select * from Tomatoes2;' ) )

plot_box(df, 0)
