library(bit64)
library(RMariaDB)
library(data.table)

RunSQL <- function (
    SQL = 'select * from Tomatoes;'
    , prepare="set @i := 1;") {
  
  rmariadb.settingsfile <- "/home/thomas/R/sql.conf.d/MiniTomatoes.conf"
  
  rmariadb.db <- "MiniTomatoes"
  
  DB <- dbConnect(
    RMariaDB::MariaDB()
    , default.file=rmariadb.settingsfile
    , group=rmariadb.db
    , bigint="numeric"
  )
  dbExecute(DB, prepare)
  rsQuery <- dbSendQuery(DB, SQL)
  dbRows<-dbFetch(rsQuery)
  
  # Clear the result.
  
  dbClearResult(rsQuery)
  
  dbDisconnect(DB)
  
  return(dbRows)

}
