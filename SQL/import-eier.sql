USE MiniTomatoes;

-- Boxes

DROP TABLE IF EXISTS Eier;
CREATE TABLE IF NOT EXISTS Eier (
    ObjectId        INT(11) PRIMARY KEY
  , boxId           INT(11)
  , sizeclass       CHAR(2)
  , weight   DOUBLE
  , INDEX ( boxId)
  , INDEX ( sizeclass )
  );

LOAD DATA LOCAL INFILE '/data/git/R/MiniTomatoes/data/Eier-Liste.csv' 
    INTO TABLE Eier 
    FIELDS TERMINATED BY ';' 
    IGNORE 1 ROWS;

    
DROP TABLE IF EXISTS EierKlassen;
CREATE TABLE IF NOT EXISTS Eierklassen (
    sizeclass   CHAR(2)
  , classname   VARCHAR(32)
  , weightFrom  DOUBLE
  , weightTo    DOUBLE
  , PRIMARY Key ( sizeclass )
  );

LOAD DATA LOCAL INFILE '/data/git/R/MiniTomatoes/data/Eier-Klassen.csv' 
    INTO TABLE Eierklassen
    FIELDS TERMINATED BY ';' 
    IGNORE 1 ROWS;

