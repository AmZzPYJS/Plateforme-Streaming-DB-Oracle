-- Contraintes CHECK --

ALTER TABLE Utilisateur 
ADD CONSTRAINT ck_utilisateur_date_naissance         
CHECK (date_naissance < date_inscription);

ALTER TABLE Abonnement 
ADD CONSTRAINT ck_abonnement_prix
CHECK (prix > 0);

ALTER TABLE Film
ADD CONSTRAINT ck_film_limite_age
CHECK (limite_age IN (0, 7, 12, 16, 18));

ALTER TABLE Serie
ADD CONSTRAINT ck_serie_limite_age
CHECK (limite_age IN (0, 7, 12, 16, 18));



ALTER TABLE Visionne
ADD CONSTRAINT ck_visionne_film_ou_episode
CHECK ((id_film IS NOT NULL AND id_episode IS NULL)
  OR (id_film IS NULL AND id_episode IS NOT NULL));

ALTER TABLE Telecharge
ADD CONSTRAINT ck_telecharge_film_ou_episode
CHECK ((id_film IS NOT NULL AND id_episode IS NULL)
  OR (id_film IS NULL AND id_episode IS NOT NULL));

ALTER TABLE Visionne
ADD CONSTRAINT ck_visionne_likes
CHECK (likes IN (0,1));

ALTER TABLE Episode
ADD CONSTRAINT ck_episode_num_saison
CHECK (numero_saison >= 1);

ALTER TABLE Episode
ADD CONSTRAINT ck_episode_num_episode
CHECK (numero_episode >= 1);
