-- Exemple d'insertion manuelle avec les Sequences --

INSERT INTO Abonnement VALUES (seq_abonnement.NEXTVAL, 'Basique', 5.99, 1);
INSERT INTO Abonnement VALUES (seq_abonnement.NEXTVAL, 'Premium', 12.99, 1);

INSERT INTO Utilisateur VALUES (seq_utilisateur.NEXTVAL, 'MEZOUER', 'Amîn', 'France', 'amin.mezouer@ens.uvsq.fr', '*******', TO_DATE('2004-05-12','YYYY-MM-DD'), SYSDATE);

INSERT INTO Film VALUES (seq_film.NEXTVAL,'Arsène Lupin',2020,'France',120,12);

INSERT INTO Serie VALUES (seq_serie.NEXTVAL,'Validé 2',2022,'France',16);
COMMIT; --Pour enregistrement des changements—
