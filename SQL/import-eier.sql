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

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/Eier.csv' 
    INTO TABLE Eier 
    FIELDS TERMINATED BY ';' 
    IGNORE 1 ROWS;
