-- Création des droits attribuable aux vues --

CREATE ROLE role_resp_contenu;
CREATE ROLE role_service_abos;
CREATE ROLE role_utilisateur_basique;
CREATE ROLE role_utilisateur_premium;
CREATE ROLE role_analyste;

-- Création des vues --

-- Catalogue Public (Vue sur Film et Série)
-- Cette vue présente le catalogue public des contenus disponibles sur la plateforme.
-- Elle liste l’ensemble des films et des séries avec leur titre, leur année de sortie et leur limite d’âge, sans information personnelle sur les utilisateurs.


CREATE OR REPLACE VIEW v_catalogue_public AS
SELECT f.id_film AS id_contenu, f.titre, f.limite_age, f.annee_apparition, 'FILM' AS type_contenu
FROM Film f
UNION ALL
SELECT s.id_serie AS id_contenu, s.titre, s.limite_age, s.annee_apparition, 'SERIE' AS type_contenu
FROM Serie s;

-- Vue Historique (Visionne + Télécharge + Titre du contenu)
-- Cette vue fournit l’historique des activités d’un utilisateur sur la plateforme.
-- Elle regroupe les visionnages et les téléchargements effectués par chaque utilisateur, en précisant le contenu concerné (film ou épisode de série), la date et le nombre de likes associés.

CREATE OR REPLACE VIEW v_historique AS

-- Historique des visionnages --
SELECT v.id_utilisateur, v.date_visionnage AS date_action, 'VISIONNAGE' AS type_action, v.likes, f.titre AS titre_film, s.titre AS titre_serie, e.numero_saison, e.numero_episode
FROM Visionne v
LEFT JOIN Film f ON f.id_film = v.id_film
LEFT JOIN Episode e ON e.id_episode = v.id_episode
LEFT JOIN Serie s ON s.id_serie = e.id_serie

UNION ALL

-- Historique des téléchargements
SELECT t.id_utilisateur, t.date_telechargement AS date_action, 'TELECHARGEMENT' AS type_action, NULL AS likes, f.titre AS titre_film, s.titre AS titre_serie, e.numero_saison, e.numero_episode
FROM Telecharge t
LEFT JOIN Film f     ON f.id_film = t.id_film
LEFT JOIN Episode e  ON e.id_episode = t.id_episode
LEFT JOIN Serie s    ON s.id_serie = e.id_serie;


-- Vue Compte (Utilisateur + Abonnement)
-- Cette vue permet à un utilisateur de consulter les informations de son compte personnel, incluant ses données d’identité ainsi que les informations liées à son abonnement actuel (type, prix, durée, date de début).

CREATE OR REPLACE VIEW v_compte AS
SELECT u.id_utilisateur, u.nom, u.prenom, u.email, u.pays, u.date_naissance, u.date_inscription, a.type_abonnement, a.prix, a.duree, p.debut_abonnement
FROM Utilisateur u
LEFT JOIN Prends p ON p.id_utilisateur = u.id_utilisateur
LEFT JOIN Abonnement a ON a.id_abonnement = p.id_abonnement;


-- Vue Responsable Contenu (Film + Série + nombre d’épisode)
-- Cette vue est destinée aux responsables du contenu.
-- Elle permet de visualiser l’ensemble des films et séries disponibles sur la plateforme, avec leurs caractéristiques principales ainsi que, pour les séries, le nombre total d’épisodes.

CREATE OR REPLACE VIEW v_resp_contenu AS
SELECT 'FILM' AS type_contenu, f.id_film AS id_contenu, f.titre, f.annee_apparition, f.pays_production, f.limite_age, NULL AS nb_episodes
FROM Film f
UNION ALL
SELECT 'SERIE', s.id_serie,s.titre,s.annee_apparition,s.pays_production, s.limite_age, COUNT(e.id_episode) AS nb_episodes
FROM Serie s
LEFT JOIN Episode e ON e.id_serie = s.id_serie
GROUP BY s.id_serie, s.titre, s.annee_apparition, s.pays_production, s.limite_age;



-- Vue service abonnement (Vue sur les abonnements actifs)
-- Cette vue est destinée au service des abonnements. Elle permet de consulter les informations des utilisateurs abonnés ainsi que les détails de leur abonnement (type, prix, durée et période de validité).

CREATE OR REPLACE VIEW v_service_abos AS
SELECT
  u.id_utilisateur, u.nom, u.prenom, u.email,
  a.type_abonnement, a.prix, a.duree,
  p.debut_abonnement
FROM Utilisateur u
JOIN Prends p     ON p.id_utilisateur = u.id_utilisateur
JOIN Abonnement a ON a.id_abonnement  = p.id_abonnement
WHERE SYSDATE >= p.debut_abonnement
  AND SYSDATE < ADD_MONTHS(p.debut_abonnement, a.duree);


-- Vue Stats Analyste (Vue sur les données avec utilisation d’agregat)
-- Cette vue fournit des statistiques globales par type d’abonnement. Elle permet d’analyser le nombre d’abonnés, le volume de visionnages, de téléchargements et le nombre total de likes, afin d’évaluer l’activité et la rentabilité de chaque abonnement.

CREATE OR REPLACE VIEW v_stats AS
SELECT
  a.type_abonnement,
  COUNT(DISTINCT p.id_utilisateur) AS nb_abonnes,
  COUNT(v.id_visionnage) AS nb_visionnages,
  COUNT(t.id_telechargement) AS nb_telechargements,
  NVL(SUM(v.likes), 0) AS total_likes
FROM Abonnement a
LEFT JOIN Prends p ON p.id_abonnement = a.id_abonnement
LEFT JOIN Visionne v ON v.id_utilisateur = p.id_utilisateur
LEFT JOIN Telecharge t ON t.id_utilisateur = p.id_utilisateur
GROUP BY a.type_abonnement;

-- Attribution des vues pour les rôles : --


GRANT SELECT ON v_catalogue_public TO role_utilisateur_basique;
GRANT SELECT ON v_compte           TO role_utilisateur_basique;
GRANT SELECT ON v_catalogue_public TO role_utilisateur_premium;
GRANT SELECT ON v_compte           TO role_utilisateur_premium;
GRANT SELECT ON v_historique       TO role_utilisateur_premium;
GRANT SELECT ON v_resp_contenu     TO role_resp_contenu;
GRANT SELECT ON v_service_abos     TO role_service_abos;
GRANT SELECT ON v_stats            TO role_analyste;
