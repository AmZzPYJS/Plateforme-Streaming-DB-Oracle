-- Contraintes Complexes (Triggers) --

CREATE OR REPLACE TRIGGER visionne_abonnement_actif
BEFORE INSERT ON Visionne
FOR EACH ROW
DECLARE
    nombre_visionnage NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nombre_visionnage
    FROM Prends p
        JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
    WHERE p.id_utilisateur = :NEW.id_utilisateur
    AND :NEW.date_visionnage >= p.debut_abonnement
    -- ADD_MONTHS permet d'ajouter un nombre de mois (a specifié) à un attribut de type DATE
    AND :NEW.date_visionnage < ADD_MONTHS(p.debut_abonnement, a.duree);

    IF nombre_visionnage = 0 THEN
RAISE_APPLICATION_ERROR(-20000,'Aucun abonnement actif à la date de visionnage.');
    END IF;
END;
/








CREATE OR REPLACE TRIGGER visionne_limite_basique
BEFORE INSERT ON Visionne
FOR EACH ROW
DECLARE
    nb_basique NUMBER;
    nb_mois NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nb_basique
    FROM Prends p
           JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
    WHERE p.id_utilisateur = :NEW.id_utilisateur
    AND a.type_abonnement = 'Basique'
    AND :NEW.date_visionnage >= p.debut_abonnement
    AND :NEW.date_visionnage < ADD_MONTHS(p.debut_abonnement, a.duree);
    IF nb_basique > 0 THEN
        SELECT COUNT(*) INTO nb_mois
        FROM Visionne v
        WHERE v.id_utilisateur = :NEW.id_utilisateur
        AND EXTRACT(YEAR  FROM v.date_visionnage) = EXTRACT(YEAR  FROM :NEW.date_visionnage)
        AND EXTRACT(MONTH FROM v.date_visionnage) = EXTRACT(MONTH FROM :NEW.date_visionnage);
        IF nb_mois >= 50 THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Limite de 50 visionnages par mois atteinte (abonnement basique).');
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER visionne_limite_age
BEFORE INSERT ON Visionne
FOR EACH ROW
DECLARE
    t_naiss DATE;
    t_age NUMBER;
    t_limite NUMBER;
BEGIN
    SELECT date_naissance INTO t_naiss
    FROM Utilisateur
    WHERE id_utilisateur = :NEW.id_utilisateur;

    t_age := FLOOR(MONTHS_BETWEEN(:NEW.date_visionnage, t_naiss) / 12);

    IF :NEW.id_film IS NOT NULL THEN
        SELECT limite_age INTO t_limite FROM Film WHERE id_film = :NEW.id_film;
    ELSE
        SELECT s.limite_age
        INTO t_limite
        FROM Episode e JOIN Serie s ON s.id_serie = e.id_serie
        WHERE e.id_episode = :NEW.id_episode;
    END IF;

    IF t_age < t_limite THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Accès refusé : limite d''âge non respectée.');
    END IF;
END;
/



CREATE OR REPLACE TRIGGER telecharge_abonnement_actif
BEFORE INSERT ON Telecharge
FOR EACH ROW
DECLARE
    t_nb NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO t_nb
    FROM Prends p
           JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
    WHERE p.id_utilisateur = :NEW.id_utilisateur
    AND :NEW.date_telechargement >= p.debut_abonnement
    AND :NEW.date_telechargement < ADD_MONTHS(p.debut_abonnement, a.duree);

    IF t_nb = 0 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Aucun abonnement actif à la date de téléchargement.');
    END IF;
END;
/













CREATE OR REPLACE TRIGGER telechargement_premium
BEFORE INSERT ON Telecharge
FOR EACH ROW
DECLARE
    v_nb_premium NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_nb_premium
    FROM   Prends p
           JOIN Abonnement a ON a.id_abonnement = p.id_abonnement
    WHERE  p.id_utilisateur = :NEW.id_utilisateur
    AND    a.type_abonnement = 'Premium'
    AND    :NEW.date_telechargement >= p.debut_abonnement
    AND    :NEW.date_telechargement < ADD_MONTHS(p.debut_abonnement, a.duree);

    IF v_nb_premium = 0 THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Téléchargement interdit : abonnement Premium requis.');
    END IF;
END;
/










CREATE OR REPLACE TRIGGER telechargement_max20
BEFORE INSERT ON Telecharge
FOR EACH ROW
DECLARE
    v_nb     NUMBER;
    v_min_dt DATE;
    v_min_id NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_nb
    FROM   Telecharge
    WHERE  id_utilisateur = :NEW.id_utilisateur;
    IF v_nb >= 20 THEN
        SELECT MIN(date_telechargement)
        INTO   v_min_dt
        FROM   Telecharge
        WHERE  id_utilisateur = :NEW.id_utilisateur;
        SELECT MIN(id_telechargement)
        INTO   v_min_id
        FROM   Telecharge
        WHERE  id_utilisateur = :NEW.id_utilisateur
        AND    date_telechargement = v_min_dt;

        DELETE FROM Telecharge
        WHERE id_telechargement = v_min_id;
    END IF;
END;
/
