USE MiniTomatoes;

LOAD DATA LOCAL INFILE '/home/thomas/git/R/MiniTomatoes/data/MiniTomatoes-3.csv' 
    INTO TABLE Tomatoes2 
    FIELDS TERMINATED BY ';' 
    IGNORE 1 ROWS;
