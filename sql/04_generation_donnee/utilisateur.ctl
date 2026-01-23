OPTIONS (SKIP=1)
LOAD DATA
INFILE 'utilisateur.csv'
APPEND
INTO TABLE Utilisateur
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(id_utilisateur, nom, prenom, pays, email, mot_de_passe, date_naissance
DATE "YYYY-MM-DD", date_inscription DATE "YYYY-MM-DD")
