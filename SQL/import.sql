USE MiniTomatoes;

-- Boxes

DROP TABLE IF EXISTS Boxes;
CREATE TABLE IF NOT EXISTS Boxes (
    ObjectId        INT PRIMARY KEY
  , variant         VARCHAR(32)
  , producer        VARCHAR(32)
  , count           INT
  , target_weight   DOUBLE
  , real_weight     DOUBLE
  , precision_weight    DOUBLE  -- precision of the weightbridge 
  , precision_meter   DOUBLE  -- precision of the weightbridge 
  , unhampered      BOOLEAN     -- box was unhampered, all tomotos countede
  , remarks         VARCHAR (255) -- Remarks
  , INDEX (variant, producer, target_weight)
  );

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/MiniTomatoes-0.csv' 
    INTO TABLE Boxes 
    FIELDS TERMINATED BY ',' 
    IGNORE 1 ROWS;

-- Dattel, first Box weight only

DROP TABLE IF EXISTS Dattel;

CREATE TABLE IF NOT EXISTS Dattel (
    ObjectId    INT PRIMARY KEY
  , boxId       INT
  , weight      DOUBLE
  , INDEX (boxId)
  );

 
LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/MiniTomatoes-1.csv' 
    INTO TABLE Dattel 
    FIELDS TERMINATED BY ',' 
    IGNORE 1 ROWS;

-- Tomatoes, second box and following weight,length and diameter 

DROP TABLE IF EXISTS Tomatoes;
CREATE TABLE IF NOT EXISTS Tomatoes (
    ObjectId    INT PRIMARY KEY -- Object Id
  , boxId       INT         -- box where the tomato was in
  , weight      DOUBLE      -- weight of tomato
  , len         DOUBLE      -- longest length of tomato
  , dia         DOUBLE      -- diameter of tomato
  , INDEX (boxid)
  );

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/MiniTomatoes-2.csv' 
    INTO TABLE Tomatoes 
    FIELDS TERMINATED BY ',' 
    IGNORE 1 ROWS;
    
-- Tomatoes, second box and following weight,length and diameter 

DROP TABLE IF EXISTS Tomatoes2;
CREATE TABLE IF NOT EXISTS Tomatoes2 (
    ObjectId    INT PRIMARY KEY -- Object Id
  , boxId       INT         -- box where the tomato was in
  , weight      DOUBLE      -- weight of tomato
  , len         DOUBLE      -- longest length of tomato
  , dia         DOUBLE      -- diameter of tomato
  , INDEX (boxid)
  );

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/MiniTomatoes-3.csv' 
    INTO TABLE Tomatoes2 
    FIELDS TERMINATED BY ',' 
    IGNORE 1 ROWS;


    
DROP TABLE IF EXISTS Rosinen;
CREATE TABLE IF NOT EXISTS Rosinen (
    ObjectId    INT PRIMARY KEY -- Object Id
  , weight      DOUBLE      -- weight of tomato
  );

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/Rosinen-1.csv' 
    INTO TABLE Rosinen
    FIELDS TERMINATED BY ',' 
    IGNORE 1 ROWS;
