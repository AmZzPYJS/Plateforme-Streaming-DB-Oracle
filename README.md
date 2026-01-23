# Plateforme-Streaming-DB-Oracle

Le projet consiste à modéliser la base de données d’une plateforme de streaming, en prenant en compte l’ensemble des contraintes nécessaires à son bon fonctionnement.
L’objectif est de concevoir une structure de données, permettant de gérer efficacement les utilisateurs, abonnements, films, séries, contenus, épisodes, acteurs, personnages et réalisateurs.

Chaque utilisateur dispose d’un compte personnel lui permettant d’accéder aux contenus de la plateforme.
Lors de son inscription, il/elle doit renseigner les informations suivantes :
	• Nom,
	• Prénom, 
	• Adresse e-mail (unique) 
	• Pays de résidence
	• Date de naissance
	• Mot de passe (stocké de manière sécurisé et hachée)
Après la création du compte, l’utilisateur choisit un type d’abonnement parmi :
	• Basique : Accès limité (50 contenus différents visionnables par mois, aucun téléchargement)
	• Premium : Accès complet (Téléchargements et visionnages illimités)
Le type d’abonnement peut être changé uniquement lorsque le précédent expire et n’est pas renouvelé.
Une fois inscrit, il peut :
	• Visionner et télécharger des contenus (films ou épisodes de séries).
	• Aimer un contenu (like).
	• Consulter les informations détaillées d’un contenu (titre, durée, date de sortie, etc.).
Le cœur de la base de données sera le catalogue de contenus, qui regroupera les films et les séries.
Chaque contenu sera identifié par un titre, une durée, une date de sortie et une limite d’âge. Certains contenus pourront être restreints en fonction de l’âge : les utilisateurs ne remplissant pas les conditions ne pourront pas y accéder.
Les films comprendront des informations supplémentaires, telles que l’année de sortie, le pays de production et le (ou les) réalisateurs et personnages associés.
Les séries, quant à elles, seront composées de saisons et d’épisodes.
Chaque épisode possédera un titre, un numéro d’épisode, un numéro de série, une durée et une date de diffusion, et sera rattaché à une série.



Les réalisateurs et les acteurs auront également leur place dans la base de données.
Un(e) réalisateur(trice) pourra être associé(e) à plusieurs films ou séries selon ses œuvres, et aura la possibilité de proposer de nouveaux contenus.
Ces propositions devront être validées par la plateforme avant leur mise en ligne afin de garantir la qualité et la conformité du contenu.
Les acteurs, de leur côté, pourront participer à plusieurs films et séries et incarner différents personnages.
Chaque personnage sera défini par un nom, un prénom, un rôle et une brève description, permettant d’identifier précisément quel acteur a joué dans quelle œuvre et quel rôle il a interprété.
Les informations personnelles des acteurs (nom, prénom, date de naissance, nationalité, etc.) seront enregistrées afin de permettre des recherches et des rapports statistiques.
La base de données enregistrera également les activités des utilisateurs sur la plateforme.
Lorsqu’un(e) utilisateur/trice visionnera un film ou un épisode, la date du visionnage et la durée regardée seront conservées.
Si un contenu est téléchargé, la date du téléchargement sera enregistrée.
Les likes des utilisateurs permettront de suivre la popularité des contenus et d’améliorer les recommandations personnalisées.

Cette base de données aura donc pour rôle de relier les utilisateurs, les abonnements, les contenus audiovisuels et les personnes qui y participent, tout en garantissant la sécurité des informations et la gestion des droits et des vues associées.
