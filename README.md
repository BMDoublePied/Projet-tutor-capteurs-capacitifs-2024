# Système de Visualisation de Grille avec Données Séries

## Aperçu
Ce projet est un **Système de Visualisation de Grille avec Données Séries** développé avec le framework Processing. Il permet de visualiser en temps réel les données reçues de 16 capteurs via une connexion série. Les capteurs sont répartis en deux groupes de 8, représentant les lignes horizontales et verticales d'une grille, formant ainsi des intersections qui réagissent en fonction des valeurs des capteurs.

## Fonctionnalités
- Le programme lit les données des capteurs en temps réel via un **port série**.
- Un **algorithme de lissage** est appliqué aux données des capteurs pour stabiliser les valeurs.
- Le système visualise les données sur une grille 8x8, où les intersections sont activées ou désactivées en fonction d'un seuil et d'une tolérance prédéfinis.
- Chaque ligne de la grille change de couleur selon les valeurs des capteurs :
  - **Blanc** : État inactif (par défaut).
  - **Rouge** : Le capteur dépasse le seuil.
  - **Gris atténué** : Une intersection associée à la ligne est active.

## Caractéristiques principales
1. **Visualisation de la grille** :
   - Une grille de 8 lignes horizontales et 8 lignes verticales est dessinée sur le canvas.
   - Les intersections sont mises en évidence lorsque les valeurs des capteurs horizontaux et verticaux dépassent un seuil défini avec tolérance.

2. **Communication Série** :
   - Les données sont reçues via un port série depuis des capteurs externes (par exemple, un Arduino).
   - Les données sont attendues sous forme de CSV avec exactement 16 valeurs (représentant les 16 capteurs).

3. **Algorithme de Lissage** :
   - Un **algorithme de lissage par moyenne glissante** est utilisé pour éviter des variations soudaines des valeurs des capteurs.
   - Un **facteur de lissage** permet de rendre les transitions plus douces entre les valeurs des capteurs.

4. **Mise à jour en temps réel** :
   - Le système met à jour la grille en temps réel au fur et à mesure que les valeurs des capteurs changent.

## Décomposition du code

### Bibliothèques
- **`import processing.serial.*;`** : Importe la bibliothèque série, permettant la communication avec du matériel externe (par exemple, Arduino).

### Variables Globales
- **`Serial myPort;`** : Gère la connexion au port série.
- **`String[] capteurData = ...`** : Stocke les valeurs brutes des capteurs reçues via le port série.
- **`float[] smoothedData = ...`** : Stocke les valeurs lissées après application de la moyenne glissante.
- **Couleurs** : Définit les couleurs pour les lignes de grille inactives, actives et atténuées.
- **Seuil et Tolérance** : Utilisés pour déterminer quand les intersections sont considérées comme actives.

### Initialisation
- **`setup()`** : 
  - Définit la taille de la fenêtre.
  - Établit la connexion avec le port série.
  - Initialise le tableau des valeurs lissées avec les données initiales des capteurs.

### Fonctionnement
- **`draw()`** :
  - Dessine la grille et les bandes verticales et horizontales sur le canvas.
  - Vérifie les valeurs des capteurs pour déterminer si une intersection doit être activée.
  - Applique les couleurs correspondantes aux bandes et intersections en fonction des valeurs des capteurs.

- **`serialEvent()`** :
  - Gère la réception des données depuis le port série.
  - Sépare les données reçues en 16 valeurs distinctes.
  - Applique l'algorithme de lissage pour chaque capteur afin de mettre à jour la grille de manière fluide.

## Utilisation
1. **Configuration du port série** :
   - Modifiez la variable `portName` dans la fonction `setup()` pour correspondre au port série utilisé par votre matériel (exemple : `"COM11"` pour Windows ou `"/dev/ttyUSB0"` pour Linux).
   
2. **Transmission des données** :
   - Les données doivent être envoyées sous forme de chaîne CSV (par exemple : `"123, 110, 95, 130, ..."`).
   
3. **Personnalisation** :
   - Vous pouvez ajuster le **seuil**, la **tolérance** et le **facteur de lissage** pour adapter le comportement de détection à vos capteurs et besoins spécifiques.

## Exigences
- **Processing** : Le projet nécessite l'installation de l'environnement Processing et de la bibliothèque `processing.serial`.
- **Capteurs** : Un dispositif externe tel qu’un Arduino doit être utilisé pour envoyer les données via le port série.

## Prochaines étapes
- Tester le programme avec des données réelles et ajuster les paramètres en conséquence (seuils, tolérance, etc.).
