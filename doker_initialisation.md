# PC4U – Guide d'installation complet

Ce document explique comment installer Docker, configurer la base de données SQL Server, lancer l’application complète PC4U et tester les fonctionnalités Register et Login. 


## 1. Installation de Docker

### 1.1 Windows ou macOS
1. Télécharger Docker Desktop depuis :  
   https://www.docker.com/products/docker-desktop/
2. Installer Docker Desktop avec les paramètres par défaut.
3. Lancer Docker Desktop.
4. Attendre que Docker indique qu'il est prêt.




## 3. Démarrer l'application avec Docker
Dans le dossier PC4U, exécuter :

docker compose up --build
Cette commande :

démarre le conteneur SQL Server (pc4u-db),

démarre le backend Node.js (pc4u-api),

démarre le frontend Nginx (pc4u-web).

Laisser cette fenêtre ouverte, ce sont les logs des conteneurs.

Pour arrêter Docker :

Appuyer sur CTRL + C

Exécuter :

docker compose down
## 4. Accéder au site PC4U
Ouvrir un navigateur et aller à :

http://localhost:3000/

Le frontend doit s’afficher.

## 5. Configuration de la base de données avec SSMS
L’application nécessite une base SQL Server nommée PC4U.
Chaque membre doit créer sa propre base dans son conteneur Docker.
Les données ne sont pas synchronisées entre les machines.

5.1 Connexion à SQL Server via SSMS
Ouvrir SQL Server Management Studio (SSMS)

Se connecter avec :

Server name : localhost,1500

Authentication : SQL Server Authentication

Login : sa

Password : Pc4uStrongPass#2025

Si la connexion échoue, vérifier que Docker Desktop est ouvert et que le conteneur pc4u-db est en état "Up".

5.2 Création de la base PC4U
Dans SSMS → New Query :

executer les scripts da base de donne 


## SELECT * FROM Users;
6. Tester Register et Login
Aller sur la page Register du site.

Créer un compte utilisateur.

Vérifier que l’utilisateur apparaît dans la base :

sql
Copy code
SELECT * FROM Users;
