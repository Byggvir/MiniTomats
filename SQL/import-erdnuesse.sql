USE MiniTomatoes;

-- Boxes
DROP TABLE IF EXISTS ErdnussTueten;
CREATE TABLE IF NOT EXISTS ErdnussTueten (
    ObjectId        INT(11) PRIMARY KEY
  , Beschreibung VARCHAR(254)
  );

insert into ErdnussTueten values ( 1, "Farmers naturals, geröstete Erdnüsse in Schale");


DROP TABLE IF EXISTS Erdnuesse;
CREATE TABLE IF NOT EXISTS Erdnuesse (
    ObjectId        INT(11) PRIMARY KEY
  , boxId           INT(11)
  , weight   DOUBLE
  , Makel BOOLEAN
  , INDEX ( boxId)
  );

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/Erdnuesse.csv' 
    INTO TABLE Erdnuesse
    FIELDS TERMINATED BY ',' 
    IGNORE 1 ROWS;
