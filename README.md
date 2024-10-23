# Jeu interactif sous processing

## Description

Ce projet est un programme de simulation de particules en utilisant **Processing**. Le programme se connecte à un port série pour recevoir des données capteurs, qui influencent les particules affichées sur l'interface graphique. Le programme permet de modifier dynamiquement la couleur, la taille, la gravité et la forme des particules en fonction des seuils définis pour chaque capteur.

## Fonctionnalités principales

1. **Connexion série** : 
   Le programme se connecte à un port série, attend des données CSV, et les traite pour déclencher des effets sur les particules.

2. **Boîte de simulation** : 
   Une boîte au centre de l'écran représente l'espace dans lequel les particules évoluent. Cette boîte peut s'ouvrir et se fermer en fonction de l'état des capteurs.

3. **Particules dynamiques** :
   - **Couleurs** : Chaque particule peut changer de couleur parmi une palette prédéfinie, ou utiliser une couleur dynamique qui change en fonction du temps.
   - **Taille** : Les particules peuvent changer de taille, avec des tailles dynamiques qui oscillent entre deux valeurs.
   - **Gravité** : La gravité qui influence les particules peut également être modifiée dynamiquement.
   - **Forme** : Les particules peuvent avoir différentes formes comme des cercles, carrés, triangles ou hexagones.

4. **Interface utilisateur** : 
   Plusieurs informations sont affichées à l'écran, telles que :
   - La couleur, taille, gravité et forme actuelles des particules.
   - Le nombre total de particules affichées.
   - Le nombre de collisions entre les particules.
   - Le nombre de succès cachés à débloquer dans la simulation.

## Paramètres des capteurs

Chaque capteur a un seuil défini et déclenche un effet particulier lorsque le seuil est dépassé. Voici les seuils par défaut pour les capteurs :
- **Capteur 1** : Seuil à 40
- **Capteur 2** : Seuil à 40
- **Capteur 3** : Seuil à 40 (changement de couleur)
- **Capteur 4** : Seuil à 40 (changement de taille)
- **Capteur 5** : Seuil à 40 (changement de gravité)
- **Capteur 6** : Seuil à 40
- **Capteur 7** : Seuil à 40 (changement de forme)

## Résolution de l'interface graphique

La fenêtre d'affichage a une taille de **800 x 800 pixels**. Tous les éléments de l'interface (boîte, textes, légendes, etc.) sont centrés ou ajustés pour s'afficher correctement dans cette résolution.

## Schéma des composants principaux

### Setup
- Initialisation de la fenêtre graphique.
- Connexion au port série défini (`COM11` par défaut).
- Initialisation des paramètres de la boîte et des particules.

### Draw
- Mise à jour continue de l'interface à un taux de rafraîchissement de 60 FPS.
- Gestion des particules, de leurs propriétés et de leurs interactions.
- Affichage des informations textuelles (couleur, taille, gravité, nombre de particules, etc.).
- Gestion des succès et des événements déclenchés par les capteurs.

### Fonctions principales

- `updateDynamicColor()`: Change la couleur des particules dynamiques au fil du temps.
- `updateDynamicSize()`: Modifie la taille des particules de manière dynamique avec des oscillations.
- `updateDynamicGravity()`: Modifie la gravité appliquée aux particules de manière dynamique.
- `drawBox()`: Affiche la boîte de simulation au centre de l'écran.
- `drawLegend()`: Affiche la légende des couleurs, tailles, gravités, et formes disponibles sur le côté gauche de l'écran.

## Réglages et ajustements

- Vous pouvez modifier les seuils des capteurs dans les variables `thresholdSensorX` pour changer le comportement des capteurs.
- La boîte peut être redimensionnée en modifiant les variables `boxWidth` et `boxHeight`.
- Les couleurs, tailles, formes et gravités disponibles pour les particules sont définies dans des tableaux et peuvent être ajustées directement dans le code.

## Instructions pour l'exécution

1. Assurez-vous que **Processing** est installé sur votre ordinateur.
2. Connectez le capteur au port série spécifié (`COM11` par défaut).
3. Ouvrez le fichier `.pde` dans l'IDE Processing.
4. Cliquez sur le bouton "Play" pour exécuter la simulation.
5. Observez les changements dans l'interface en fonction des données des capteurs.
