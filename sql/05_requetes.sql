-- Table : Utilisateur/trice --
-- 1.	Lister tous les utilisateurs qui ont l’âge requis pour visionner un contenu déconseillé au moins de 16 ans (avec date de naissance d’un utilisateur et limite d’âge d’un contenu). --

SELECT DISTINCT u.id_utilisateur, u.nom, u.prenom
FROM Utilisateur u
JOIN Visionne v ON v.id_utilisateur = u.id_utilisateur
LEFT JOIN Film f ON f.id_film = v.id_film
LEFT JOIN Episode e ON e.id_episode = v.id_episode
LEFT JOIN Serie s ON s.id_serie = e.id_serie
WHERE NVL(f.limite_age, s.limite_age) >= 16
  AND MONTHS_BETWEEN(v.date_visionnage, u.date_naissance)/12 >= 16;

-- 2.	Lister les utilisateurs inactifs n’ayant regardé aucun film ni épisode de série au cours des 90 derniers jours. --

SELECT u.id_utilisateur, u.nom, u.prenom
FROM Utilisateur u
LEFT JOIN Visionne v
  ON v.id_utilisateur = u.id_utilisateur
 AND v.date_visionnage >= SYSDATE - 90
WHERE v.id_visionnage IS NULL;





-- Table : Visionne --
-- 3.	Calculer l’âge moyen des utilisateurs ayant regardé au moins un épisode de série. --

SELECT AVG(MONTHS_BETWEEN(SYSDATE, u.date_naissance)/12) AS age_moyen
FROM Utilisateur u
JOIN Visionne v ON v.id_utilisateur = u.id_utilisateur
WHERE v.id_episode IS NOT NULL;

-- 4.	Pour l’année 2025, quelle série a été le plus visionnée (pour faire un classement annuel de chaque série). --

SELECT titre, nb_visionnages
FROM (
  SELECT s.titre, COUNT(*) AS nb_visionnages
  FROM Visionne v
  JOIN Episode e ON e.id_episode = v.id_episode
  JOIN Serie s   ON s.id_serie = e.id_serie
  WHERE EXTRACT(YEAR FROM v.date_visionnage) = 2025
  GROUP BY s.titre
  ORDER BY nb_visionnages DESC
)
WHERE ROWNUM = 1;	

-- 5.	Afficher les 5 films ayant obtenu le plus grand nombre de « like ». --

SELECT * FROM ( SELECT f.titre, SUM(v.likes) AS total_likes
  			FROM Visionne v JOIN Film f ON f.id_film = v.id_film
  			GROUP BY f.titre
  			ORDER BY total_likes DESC)
WHERE ROWNUM <= 5;  		


-- 6.	Lister les utilisateurs qui ont à la fois visionné un film et visionné un épisode d’une série d’une saison. --

SELECT u.id_utilisateur, u.nom, u.prenom
FROM Utilisateur u
WHERE EXISTS (SELECT 1 FROM Visionne v WHERE v.id_utilisateur=u.id_utilisateur AND v.id_film IS NOT NULL)
  AND EXISTS (SELECT 1 FROM Visionne v WHERE v.id_utilisateur=u.id_utilisateur AND v.id_episode IS NOT NULL);

-- 7.	Quels sont les utilisateurs qui ont visionné tous les épisodes d’une série. --

SELECT v.id_utilisateur, e.id_serie
FROM Visionne v
JOIN Episode e ON e.id_episode = v.id_episode
GROUP BY v.id_utilisateur, e.id_serie
HAVING COUNT(DISTINCT v.id_episode) =
       (SELECT COUNT(*) FROM Episode ep WHERE ep.id_serie = e.id_serie);

-- 8.	Calculer le taux d’achèvement par utilisateur et par série (nombre d’épisodes vus / nombre total d’épisodes de la série). --

SELECT v.id_utilisateur,
       e.id_serie,
       COUNT(DISTINCT v.id_episode)
       / (SELECT COUNT(*) FROM Episode ep WHERE ep.id_serie = e.id_serie) AS taux
FROM Visionne v
JOIN Episode e ON e.id_episode = v.id_episode
GROUP BY v.id_utilisateur, e.id_serie;



-- 9.	Calculer le nombre moyen d’épisode visionné par mois selon le type d’abonnement (basique vs premium). --

SELECT type_abonnement, AVG(nb_episodes) AS moyenne_par_mois
FROM ( SELECT a.type_abonnement,
         EXTRACT(YEAR FROM v.date_visionnage) AS annee,
         EXTRACT(MONTH FROM v.date_visionnage) AS mois,
         COUNT(*) AS nb_episodes
  FROM Visionne v
  JOIN Prends p ON p.id_utilisateur = v.id_utilisateur
  JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
  WHERE v.id_episode IS NOT NULL
  GROUP BY a.type_abonnement,
           EXTRACT(YEAR FROM v.date_visionnage),
           EXTRACT(MONTH FROM v.date_visionnage)
)
GROUP BY type_abonnement;



-- Table : Episode --
-- 10.	Calculer la moyenne ainsi que le maximum et le minimum de durée des épisodes de chaque série. --

SELECT id_serie, AVG(duree) AS duree_moyenne,
       MAX(duree) AS duree_max,
       MIN(duree) AS duree_min
FROM Episode
GROUP BY id_serie;



-- 11.	Afficher les séries dont la durée moyenne des épisodes est supérieure à 45 minutes. --

SELECT id_serie
FROM Episode
GROUP BY id_serie
HAVING AVG(duree) > 45;


-- Table : Télécharge --
-- 12.	Faire un classement des séries les plus téléchargées. --

SELECT e.id_serie, COUNT(*) AS nb_telechargements
FROM Telecharge t
JOIN Episode e ON e.id_episode = t.id_episode
GROUP BY e.id_serie
ORDER BY nb_telechargements DESC;


-- 13.	Lister les films ayant été téléchargés plus de 100 fois. --

SELECT id_film, COUNT(*) AS nb_telechargements
FROM Telecharge
WHERE id_film IS NOT NULL
GROUP BY id_film
HAVING COUNT(*) > 100;




-- Table : Acteur/trice --
-- 14.	Lister tous les personnages d’un acteur avec sa série. --

SELECT
	a.id_acteur, a.nom, a.prenom,
	p.id_personnage, p.prenom AS prenom_personnage, p.nom AS nom_personnage,
	s.id_serie, s.titre AS titre_serie
FROM Acteur a
JOIN Incarne i     
	ON i.id_acteur = a.id_acteur
JOIN Personnage p  
	ON p.id_personnage = i.id_personnage
LEFT JOIN Appartient ap 
	ON ap.id_personnage = p.id_personnage
LEFT JOIN Serie s       
	ON s.id_serie = ap.id_serie
WHERE a.id_acteur = 1
ORDER BY s.titre, p.nom, p.prenom;


-- 15.	Lister les acteurs ayant joué dans au moins trois séries. --

SELECT a.id_acteur, a.nom, a.prenom, COUNT(DISTINCT ap.id_serie) AS nb_series
FROM Acteur a
JOIN Incarne i ON i.id_acteur = a.id_acteur
JOIN Appartient ap ON ap.id_personnage = i.id_personnage
GROUP BY a.id_acteur, a.nom, a.prenom
HAVING COUNT(DISTINCT ap.id_serie) >= 3;



-- Table : Abonnement --
-- 16.	Quel abonnement est le plus vendu pour les jeunes (entre 18 et 25 ans). --

SELECT type_abonnement, nb
FROM (SELECT a.type_abonnement, COUNT(*) AS nb
  FROM Prends p
  JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
  JOIN Utilisateur u ON u.id_utilisateur = p.id_utilisateur
  WHERE MONTHS_BETWEEN(SYSDATE, u.date_naissance)/12 BETWEEN 18 AND 25
  GROUP BY a.type_abonnement
  ORDER BY nb DESC
)
WHERE ROWNUM = 1;

-- 17.	Afficher le revenu total mensuel par type d’abonnement (nombre d’abonnements actifs × prix mensuel). --

SELECT a.type_abonnement, COUNT(*) * a.prix AS revenu
FROM Prends p
JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
WHERE SYSDATE >= p.debut_abonnement
  AND SYSDATE < ADD_MONTHS(p.debut_abonnement, a.duree)
GROUP BY a.type_abonnement, a.prix;








-- Table : Réalisateur/trice --
-- 18.	Quels réalisateurs ont produit au minimum deux séries. --

SELECT r.id_realisateur, r.nom, r.prenom, COUNT(*) AS nb_series
FROM Realisateur r
JOIN Realise_Serie rs ON rs.id_realisateur = r.id_realisateur
GROUP BY r.id_realisateur, r.nom, r.prenom
HAVING COUNT(*) >= 2;


-- Table : Série --
-- 19.	Lister toutes les séries, même celles qui n’ont jamais reçu de « like », ainsi que le nombre total de likes associés. --

SELECT s.id_serie, s.titre, SUM(v.likes) AS total_likes
FROM Serie s
LEFT JOIN Episode e ON e.id_serie = s.id_serie
LEFT JOIN Visionne v ON v.id_episode = e.id_episode
GROUP BY s.id_serie, s.titre;
