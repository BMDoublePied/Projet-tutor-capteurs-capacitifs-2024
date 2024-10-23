# Récupération des valeurs venant des capateurs capacitifs sous arduino

Pour cela nous avons deux codes distincts utilisant des capteurs capacitifs : un pour une matrice de capteurs avec multiplexeur et un pour un jeu interactif.

## 1. Code de la Matrice de Capteurs

### Description

Le code de la matrice de capteurs est conçu pour lire les valeurs de plusieurs capteurs capacitifs à l'aide d'un multiplexeur. Il peut gérer jusqu'à 16 capteurs (Y0 à Y15) en utilisant une résistance entre les broches 8 et 10 de l'Arduino. Ce code sélectionne chaque canal du multiplexeur, lit la valeur du capteur capacitif associé, et envoie les données au port série au format CSV.

### Fonctionnement

- **Configuration du Multiplexeur** : Les broches S0 à S3 de l'Arduino sont configurées en tant que sorties pour contrôler le multiplexeur.
- **Lecture des Capteurs** : Dans la boucle principale, le code parcourt les 16 canaux du multiplexeur, sélectionne chacun d'eux, lit la valeur du capteur, et envoie les valeurs au port série.
- **Délai** : Un court délai est inséré après la sélection de chaque canal pour assurer une lecture stable.

## 2. Code du Jeu Interactif

### Description

Le code du jeu interactif utilise plusieurs capteurs capacitifs pour détecter les interactions des utilisateurs. Il lit les valeurs de plusieurs capteurs configurés et les envoie au port série au format CSV.

### Fonctionnement

- **Configuration des Capteurs** : Chaque capteur capacitif est configuré pour désactiver l'autocalibration, assurant une lecture stable.
- **Lecture des Capteurs** : Dans la boucle principale, le code lit les valeurs de plusieurs capteurs et les envoie au port série.
- **Délai** : Un délai est utilisé pour limiter la fréquence d'envoi des données afin d'éviter une surcharge sur le port série.

## Conclusion

Ces deux codes démontrent l'utilisation de capteurs capacitifs dans des applications différentes : une matrice de capteurs pour la détection de multiples points et un jeu interactif basé sur des interactions capacitives. Ils peuvent être adaptés et étendus pour créer des projets encore plus complexes et interactifs.
