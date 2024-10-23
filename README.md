# Projet Capteurs Capacitifs

Ce dépôt GitHub contient trois dossiers principaux, chacun dédié à une partie du projet utilisant des capteurs capacitifs : 

1. **Code Arduino** : Ce dossier contient les codes nécessaires pour interagir avec les capteurs capacitifs via une carte Arduino. Il inclut deux scripts distincts :
   - **Matrice de Capteurs** : Un code pour lire les valeurs de plusieurs capteurs capacitifs à l'aide d'un multiplexeur, capable de gérer jusqu'à 16 capteurs (Y0 à Y15).
   - **Jeu Interactif** : Un code qui utilise plusieurs capteurs pour créer une expérience interactive, où les données des capteurs influencent le comportement d'une simulation.

2. **Matrice sous Processing** : Ce dossier contient un projet développé avec Processing pour visualiser en temps réel les données reçues de 16 capteurs via une connexion série. Il permet de voir les intersections actives sur une grille 8x8 en fonction des valeurs des capteurs.

3. **Jeu Interactif sous Processing** : Ce dossier contient un programme de simulation de particules en utilisant Processing. Le programme reçoit des données de capteurs et modifie dynamiquement les particules affichées en fonction de ces données, permettant une interaction riche avec les utilisateurs.

## Fonctionnalités

- **Code de la Matrice de Capteurs** : 
  - Lecture des valeurs des capteurs via un multiplexeur.
  - Envoi des données au port série au format CSV.
  
- **Code du Jeu Interactif** : 
  - Interaction des utilisateurs avec des capteurs capacitifs.
  - Envoi des valeurs des capteurs au port série au format CSV.

- **Visualisation de la Matrice** : 
  - Affichage en temps réel des données des capteurs sur une grille.
  - Algorithme de lissage pour stabiliser les valeurs.

- **Jeu Interactif sous Processing** : 
  - Connexion au port série pour recevoir des données des capteurs.
  - Visualisation de particules dynamiques avec des paramètres ajustables (couleur, taille, gravité, forme).

## Instructions d'utilisation

1. **Configuration** : Assurez-vous que l'environnement de développement approprié est installé (Arduino IDE et Processing).
2. **Exécution** :
   - Chargez les codes Arduino sur votre carte.
   - Connectez les capteurs et exécutez le code correspondant.
   - Ouvrez le projet Processing pour visualiser les données et interagir avec le jeu ou la matrice.

## Conclusion

Ce projet démontre l'utilisation des capteurs capacitifs dans diverses applications, allant de la détection de points à la création d'expériences interactives. Il peut être étendu et adapté pour développer des projets plus complexes et immersifs.
