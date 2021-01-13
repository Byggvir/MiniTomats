library(RMariaDB)
library(data.table)

MT_Select <- function (
  SQL = 'select * from Tomatoes;'
  , prepare="set @i := 1;") {
  
  rmariadb.settingsfile <- "/home/thomas/git/R/MiniTomatoes/SQL/MiniTomato.cnf"
  
  rmariadb.db <- "MiniTomatoes"
  
  MiniTomatoes <- dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db)
  dbExecute(MiniTomatoes, prepare)
  rsQuery <- dbSendQuery(MiniTomatoes, SQL)
  dbRows<-dbFetch(rsQuery)
  # Clear the result.
  
  dbClearResult(rsQuery)
  
  dbDisconnect(MiniTomatoes)
  
  return(dbRows)
}
