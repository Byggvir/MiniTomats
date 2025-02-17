library(bit64)
library(RMariaDB)
library(data.table)

RunSQL <- function (
    SQL = 'select * from Tomatoes;'
    , prepare="set @i := 1;" 
    , database = 'MiniTomatoes' ) {

  rmariadb.settingsfile <- path.expand('~/R/sql.conf.d/MiniTomatoes.conf')
  rmariadb.db <- database
  
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
  
  return(as.data.table(dbRows))

}

ExecSQL <- function (
    SQL  
    , Database = 'MiniTomatoes'
) {
  
  rmariadb.settingsfile <- path.expand('~/R/sql.conf.d/MiniTomatoes.conf')
  
  rmariadb.db <- database
  
  DB <- dbConnect(
    RMariaDB::MariaDB()
    , default.file=rmariadb.settingsfile
    , group=rmariadb.db
    , bigint="numeric"
  )
  
  count <- dbExecute(DB, SQL)
  
  dbDisconnect(DB)
  
  return (count)
  
}
