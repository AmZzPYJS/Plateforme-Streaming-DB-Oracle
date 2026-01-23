CREATE TABLE Utilisateur (
    id_utilisateur      NUMBER CONSTRAINT pk_utilisateur PRIMARY KEY,
    nom                 VARCHAR2(50)  NOT NULL,
    prenom              VARCHAR2(50)  NOT NULL,
    pays                VARCHAR2(50)  NOT NULL,
    email               VARCHAR2(100) NOT NULL CONSTRAINT unique_email UNIQUE,
    mot_de_passe        VARCHAR2(100) NOT NULL,
    date_naissance      DATE          NOT NULL,
    date_inscription    DATE          NOT NULL)
);

CREATE TABLE Abonnement (
    id_abonnement       NUMBER CONSTRAINT pk_abonnement PRIMARY KEY,
    type_abonnement     VARCHAR2(50) NOT NULL,
    prix                NUMBER(5,2)  NOT NULL,
    duree               NUMBER       NOT NULL
);












CREATE TABLE Film (
    id_film             NUMBER CONSTRAINT pk_film PRIMARY KEY,
    titre               VARCHAR2(100) NOT NULL,
    annee_apparition    NUMBER(4)     NOT NULL,
    pays_production     VARCHAR2(50)  NOT NULL,
    duree               NUMBER        NOT NULL,
    limite_age          NUMBER        NOT NULL
);

CREATE TABLE Serie (
    id_serie            NUMBER CONSTRAINT pk_serie PRIMARY KEY,
    titre               VARCHAR2(100) NOT NULL,
    annee_apparition    NUMBER(4)     NOT NULL,
    pays_production     VARCHAR2(50)  NOT NULL,
    limite_age          NUMBER        NOT NULL
);

CREATE TABLE Personnage (
    id_personnage       NUMBER CONSTRAINT pk_personnage PRIMARY KEY,
    prenom              VARCHAR2(50) NOT NULL,
    nom                 VARCHAR2(50) NOT NULL,
    type_role           VARCHAR2(50) NOT NULL,
    description         VARCHAR2(255)
);

CREATE TABLE Realisateur (
    id_realisateur      NUMBER CONSTRAINT pk_realisateur PRIMARY KEY,
    nom                 VARCHAR2(50) NOT NULL,
    prenom              VARCHAR2(50) NOT NULL,
    date_naissance      DATE         NOT NULL,
    nationalite         VARCHAR2(50) NOT NULL
);

CREATE TABLE Prends (
    id_utilisateur      NUMBER NOT NULL,
    id_abonnement       NUMBER NOT NULL,
    debut_abonnement    DATE   NOT NULL,
    CONSTRAINT pk_prends PRIMARY KEY (id_utilisateur, id_abonnement),
    CONSTRAINT fk_prends_utilisateur FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_prends_abonnement FOREIGN KEY (id_abonnement) REFERENCES Abonnement(id_abonnement) ON DELETE CASCADE
);















CREATE TABLE Incarne (
    id_acteur           NUMBER NOT NULL,
    id_personnage       NUMBER NOT NULL,
    version             VARCHAR2(50),
    CONSTRAINT pk_incarne PRIMARY KEY (id_acteur, id_personnage),
    CONSTRAINT fk_incarne_acteur FOREIGN KEY (id_acteur)
REFERENCES Acteur(id_acteur) ON DELETE CASCADE,
    CONSTRAINT fk_incarne_personnage FOREIGN KEY (id_personnage) 	
REFERENCES Personnage(id_personnage) ON DELETE CASCADE
);

CREATE TABLE Realise_Film (
    id_realisateur      NUMBER NOT NULL,
    id_film             NUMBER NOT NULL,
    CONSTRAINT pk_realisefilm PRIMARY KEY (id_realisateur, id_film),
    CONSTRAINT fk_realisefilm_realisateur FOREIGN KEY (id_realisateur)
        REFERENCES Realisateur(id_realisateur) ON DELETE CASCADE,
    CONSTRAINT fk_realisefilm_film FOREIGN KEY (id_film)
        REFERENCES Film(id_film) ON DELETE CASCADE
);

CREATE TABLE Realise_Serie (
    id_realisateur      NUMBER NOT NULL,
    id_serie            NUMBER NOT NULL,
    CONSTRAINT pk_realiseserie PRIMARY KEY (id_realisateur, id_serie),
    CONSTRAINT fk_realiseserie_realisateur FOREIGN KEY (id_realisateur)
        REFERENCES Realisateur(id_realisateur) ON DELETE CASCADE,
    CONSTRAINT fk_realiseserie_serie FOREIGN KEY (id_serie)
        REFERENCES Serie(id_serie) ON DELETE CASCADE
);

CREATE TABLE Appartient (
    id_personnage       NUMBER NOT NULL,
    id_serie            NUMBER NOT NULL,
    CONSTRAINT pk_appartient PRIMARY KEY (id_personnage, id_serie),
    CONSTRAINT fk_appartient_personnage FOREIGN KEY (id_personnage)
        REFERENCES Personnage(id_personnage) ON DELETE CASCADE,
    CONSTRAINT fk_appartient_serie FOREIGN KEY (id_serie)
        REFERENCES Serie(id_serie) ON DELETE CASCADE
);

CREATE TABLE Inclus (
    id_personnage       NUMBER NOT NULL,
    id_film             NUMBER NOT NULL,
    CONSTRAINT pk_inclus PRIMARY KEY (id_personnage, id_film),
    CONSTRAINT fk_inclus_personnage FOREIGN KEY (id_personnage)
        REFERENCES Personnage(id_personnage) ON DELETE CASCADE,
    CONSTRAINT fk_inclus_film FOREIGN KEY (id_film)
        REFERENCES Film(id_film) ON DELETE CASCADE
);









CREATE TABLE Visionne (
    id_visionnage       NUMBER CONSTRAINT pk_visionne PRIMARY KEY,
    date_visionnage     DATE   NOT NULL,
    duree_visionnage    NUMBER NOT NULL,
    likes               NUMBER(1) NOT NULL,
    id_utilisateur      NUMBER NOT NULL,
    id_film             NUMBER,
    id_episode          NUMBER,
    CONSTRAINT fk_visionne_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES Utilisateur(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_visionne_film FOREIGN KEY (id_film)
        REFERENCES Film(id_film) ON DELETE CASCADE,
    CONSTRAINT fk_visionne_episode FOREIGN KEY (id_episode)
        REFERENCES Episode(id_episode) ON DELETE CASCADE
);

CREATE TABLE Telecharge (
    id_telechargement   NUMBER CONSTRAINT pk_telecharge PRIMARY KEY,
    date_telechargement DATE NOT NULL,
    id_utilisateur      NUMBER NOT NULL,
    id_film             NUMBER,
    id_episode          NUMBER,
    CONSTRAINT fk_telecharge_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES Utilisateur(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_telecharge_film FOREIGN KEY (id_film)
        REFERENCES Film(id_film) ON DELETE CASCADE,
    CONSTRAINT fk_telecharge_episode FOREIGN KEY (id_episode)
        REFERENCES Episode(id_episode) ON DELETE CASCADE
);
