OPTIONS (SKIP=1) 
LOAD DATA
INFILE 'film.csv'
APPEND
INTO TABLE Film
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  id_film          INTEGER EXTERNAL,
  titre            CHAR(100),
  annee_apparition INTEGER EXTERNAL,
  pays_production  CHAR(50),
  duree            INTEGER EXTERNAL,
  limite_age       INTEGER EXTERNAL
)
