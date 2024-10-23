import processing.serial.*;  // Importation de la bibliothèque série
import java.util.ArrayList;  // Utilisation de la liste dynamique pour stocker les particules

Serial myPort;               // Objet pour la connexion série
String serialData = "";       // Stocke les données CSV reçues

// Variables pour la boîte et les particules
boolean boxOpen = false;
boolean bottomOpen = false;  // Indique si le fond de la boîte est ouvert

// Paramètres des capteurs
int thresholdSensor1 = 40;   // Seuil pour capteur 1 (ex: canal 0)
int thresholdSensor2 = 40;   // Seuil pour capteur 2 (ex: canal 1)
int thresholdSensor3 = 40;   // Seuil pour capteur 3 (ex: canal 2)
int thresholdSensor4 = 40;   // Seuil pour capteur 4 (ex: canal 3)
int thresholdSensor5 = 40;   // Seuil pour capteur 5 (ex: canal 4)
int thresholdSensor6 = 40;   // Seuil pour capteur 6 (ex: canal 5)
int thresholdSensor7 = 40;   // Seuil pour capteur 7 (nouveau capteur pour changer la forme)
boolean applyEffectsToAll = false;  // Indique si les effets sont appliqués à toutes les particules

boolean colorChanged = false;  // Évite de changer la couleur en continu lorsque le capteur 3 est pressé
boolean sizeChanged = false;   // Évite de changer la taille en continu lorsque le capteur 4 est pressé
boolean gravityChanged = false; // Évite de changer la gravité en continu lorsque le capteur 5 est pressé
boolean shapeChanged = false;  // Évite de changer la forme en continu lorsque le capteur 7 est pressé

// Couleurs des particules
color[] colors = {
  color(0, 0, 255),    // Bleu
  color(0, 255, 0),    // Vert
  color(255, 0, 0),    // Rouge
  color(255, 255, 0),  // Jaune
  color(255, 165, 0),  // Orange
  color(75, 0, 130),   // Indigo
  color(238, 130, 238), // Rose
  color(0, 255, 255),  // Cyan
  color(0, 0, 0)       // Couleur dynamique (initialisé à noir)
};
int currentColorIndex = 0;  // Index actuel de la couleur

// Dimensions de la boîte (plus grande)
int boxWidth = 400;  // Largeur de la boîte agrandie
int boxHeight = 400; // Hauteur de la boîte agrandie
int boxX = (800 - boxWidth) / 2;  // Centrer horizontalement
int boxY = (800 - boxHeight) / 2; // Centrer verticalement

// Liste des particules
ArrayList<Particle> particles = new ArrayList<Particle>();
int currentSizeIndex = 1;  // Index actuel de la taille des particules (1: normal)
float[] sizes = {2, 5, 10, 20, 0};  // Ajout d'une nouvelle taille dynamique (initialisée à 0)
float dynamicSize = 5; // Taille dynamique initiale
float[] gravityValues = {0.01, 0.05, 0.5, 1.0, -0.2, 0};  // Ajout d'une gravité dynamique
float dynamicGravity = 0.05; // Gravité dynamique initiale
int currentGravityIndex = 1;  // Index actuel de la gravité

// Formes disponibles
String[] shapes = {"Cercle", "Carré", "Triangle", "Hexagone"};
int currentShapeIndex = 0;  // Index actuel de la forme

int lastSizeUpdateTime = 0;  // Temps du dernier changement de taille dynamique
int lastGravityUpdateTime = 0;  // Temps du dernier changement de gravité dynamique

void setup() {
  size(800, 800);  // Dimensions de la fenêtre graphique
  frameRate(60);  // Définir le taux de rafraîchissement à 60 fps

  // Initialisation de la connexion série sur le port COM11
  String portName = "COM11";  // Nom du port série à adapter si nécessaire
  myPort = new Serial(this, portName, 9600);  // Initialisation à 9600 bauds
  myPort.bufferUntil('\n');  // Attend la fin de ligne pour lire les données série
}

int particleCount = 0; // Compteur de particules
int collisionCount = 0;  // Compteur de collisions


int hiddenAchievements = 1;  // Nombre de succès cachés
ArrayList<String> achievements = new ArrayList<String>();  // Liste des succès débloqués


void draw() {
  int startTime = millis();
  background(255);  // Fond blanc
  updateDynamicColor();  // Mettre à jour la couleur dynamique
  updateDynamicSize();   // Mettre à jour la taille dynamique
  updateDynamicGravity();  // Mettre à jour la gravité dynamique
  drawBox();  // Dessine la boîte (le récipient)

  // Affiche la couleur actuelle, la taille, la gravité et la forme des particules
  fill(0);  // Couleur du texte
  textSize(16);  // Taille du texte
  text("Couleur actuelle : " + colorName(currentColorIndex), 10, 30);  // Affichage du message
  text("Taille actuelle : " + sizeName(currentSizeIndex), 10, 50);  // Affichage de la taille
  text("Gravité actuelle : " + gravityName(currentGravityIndex), 10, 70);  // Affichage de la gravité
  text("Forme actuelle : " + shapes[currentShapeIndex], 220, 30);  // Affichage de la forme

  // Affiche si les effets sont appliqués à toutes les particules
  textSize(16);
  text("Effets appliqués à toutes les particules : " + (applyEffectsToAll ? "Oui" : "Non"), 10, 790);

  // Affiche le nombre de particules en bas à droite
  textSize(20);
  String particleCountText = "Nombre de particules : " + particles.size();
  float particleCountWidth = textWidth(particleCountText);
  fill(0);  // Couleur du texte
  text(particleCountText, width - particleCountWidth - 10, height - 10);  // Affichage à droite

  // Affiche les FPS en haut à droite
  String fpsText = "FPS : " + Math.round(frameRate);
  textSize(20);
  float fpsWidth = textWidth(fpsText);
  text(fpsText, width - fpsWidth - 10, 30);  // Affichage en haut à droite

  // Affiche la latence en bas à droite
  int latency = millis() - startTime;  // Calcule la latence
  String latencyText = "Latence interface : " + latency + " ms";
  text(latencyText, width - textWidth(latencyText) - 10, height - 30);  // Affichage de la latence
  
  // Affiche le nombre de collisions en bas à gauche
  textSize(20);
  text("Nombre de collisions : " + collisionCount, 10, height - 40);

  // Affiche le nombre de succès cachés
  fill(0);
  textSize(12);
  text("Succès à débloquer : " + hiddenAchievements, 650, 180);  // Affichage à droite

  // Affiche les succès débloqués sous l'affichage des succès cachés
  if (achievements.size() > 0) {
    textSize(14);
    text("Succès débloqués :", 650, 220);  // Titre des succès
    for (int i = 0; i < achievements.size(); i++) {
      text(achievements.get(i), 650, 240 + i * 20);  // Affichage des succès
    }
  }

  // Appel à la fonction de dessin de la légende sur le côté gauche
  drawLegend();

  // Mise à jour et affichage des particules
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);

    // Si les effets sont activés pour toutes les particules, applique les changements
    if (applyEffectsToAll) {
      p.particleColor = colors[currentColorIndex];
      p.radius = sizes[currentSizeIndex];
      p.gravity = gravityValues[currentGravityIndex];
      p.shape = currentShapeIndex;  // Applique la forme actuelle
    }

    p.update();  // Mise à jour de la position de la particule
    p.display();  // Affichage de la particule

    // Si la particule sort de l'écran, on la retire de la liste
    if (p.isOutOfBounds()) {
      particles.remove(i);
    }
  }

  // Gérer les collisions entre les particules
  handleCollisions();

  // Vérifier les succès
  checkAchievements();
  
  drawAchievementLegend();
}


void drawAchievementLegend() {
  fill(240);  // Fond léger pour la légende
  rect(630, 190, 150, 150);  // Rectangle pour la légende à droite
  
  fill(0);  // Texte noir
  textSize(12);
  text("Succès débloqués :", 640, 210);  // Titre de la légende

  // Affiche les succès débloqués
  for (int i = 0; i < achievements.size(); i++) {
    text(achievements.get(i), 640, 230 + i * 20);  // Affichage des succès débloqués
  }
}

void checkAchievements() {
  // Vérifier le succès "Slow-Motion" (FPS ≤ 5)
  if (frameRate <= 10 && !achievements.contains("Slow-Motion")) {
    achievements.add("Slow-Motion");  // Ajouter le succès Slow-Motion
    hiddenAchievements--;  // Réduire le nombre de succès cachés
  }
}


// Fonction pour mettre à jour la couleur dynamique
void updateDynamicColor() {
  int r = (int)(map(sin(TWO_PI * frameCount / 180), -1, 1, 0, 255)); // Change red
  int g = (int)(map(sin(TWO_PI * frameCount / 180 + TWO_PI / 3), -1, 1, 0, 255)); // Change green
  int b = (int)(map(sin(TWO_PI * frameCount / 180 + TWO_PI * 2 / 3), -1, 1, 0, 255)); // Change blue
  colors[8] = color(r, g, b); // Mettre à jour la couleur dynamique
}

// Fonction pour mettre à jour la taille dynamique
void updateDynamicSize() {
  if (millis() - lastSizeUpdateTime > 500) {  // Changer toutes les 500ms
    dynamicSize = map(sin(TWO_PI * frameCount / 180), -1, 1, 2, 20);  // Taille oscillante entre 2 et 20
    sizes[4] = dynamicSize;  // Mettre à jour la taille dynamique dans le tableau des tailles
    lastSizeUpdateTime = millis();  // Réinitialiser le temps de mise à jour
  }
}

// Fonction pour mettre à jour la gravité dynamique
void updateDynamicGravity() {
  if (millis() - lastGravityUpdateTime > 100) {  // Changer toutes les 100ms
    dynamicGravity += 0.05;  // Incrémenter la gravité dynamique de 0.05
    if (dynamicGravity > 1) dynamicGravity = -1;  // Réinitialiser la gravité à -1 si elle dépasse 1
    gravityValues[5] = dynamicGravity;  // Mettre à jour la gravité dynamique dans le tableau des gravités
    lastGravityUpdateTime = millis();  // Réinitialiser le temps de mise à jour
  }
}

// Fonction pour dessiner la légende à gauche
void drawLegend() {
  fill(240);  // Couleur de fond pour la légende
  rect(0, 80, 160, height - 160);  // Fond de la légende

  fill(0);  // Texte noir
  textSize(12);
  int startX = 5;  // Position de départ en X, décalé davantage à gauche
  int startY = 100;  // Position de départ en Y
  int lineHeight = 15;  // Hauteur d'une ligne pour la légende
  int sectionSpacing = 30;  // Espacement entre les sections
  int itemSpacing = 15;  // Espacement entre les items
  int sizeSpacing = 35;  // Espacement spécifique pour les tailles

  // Affiche la légende pour les couleurs
  text("Couleurs disponibles :", startX, startY);
  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    rect(startX, startY + (i * lineHeight) + itemSpacing, 10, 10);  // Carré de couleur
    fill(0);
    text(colorName(i), startX + 20, startY + (i * lineHeight) + itemSpacing + 5);  // Nom de la couleur
  }
  startY += (colors.length * lineHeight) + sectionSpacing;  // Espacement après les couleurs

  // Ligne de séparation
  stroke(200);
  line(startX - 10, startY - 10, startX + 150, startY - 10);
  noStroke();

  // Affiche la légende pour les tailles
  text("Tailles disponibles :", startX, startY);
  for (int i = 0; i < sizes.length; i++) {
    fill(0);
    text(sizeName(i), startX + 40, startY + (i * sizeSpacing) + itemSpacing + 5);  // Nom de la taille

    // Indicateur de taille
    float sizeIndicator = sizes[i];
    fill(150);  // Couleur grise pour l'indicateur
    ellipse(startX + 20, startY + (i * sizeSpacing) + itemSpacing + 5, sizeIndicator * 2, sizeIndicator * 2);  // Cercle pour représenter la taille
  }
  startY += (sizes.length * sizeSpacing) + sectionSpacing + 10;  // Espacement après les tailles

  // Ligne de séparation
  stroke(200);
  line(startX - 10, startY - 10, startX + 150, startY - 10);
  noStroke();

  // Affiche la légende pour les gravités
  text("Gravités disponibles :", startX, startY);
  for (int i = 0; i < gravityValues.length; i++) {
    fill(0);
    text(gravityName(i) + " (" + gravityValues[i] + ")", startX, startY + (i * lineHeight) + itemSpacing + 5);  // Aligné à gauche
  }
  startY += (gravityValues.length * lineHeight) + sectionSpacing + 10;

  // Ligne de séparation
  stroke(200);
  line(startX - 10, startY - 10, startX + 150, startY - 10);
  noStroke();

  // Affiche la légende pour les formes avec illustrations
  text("Formes disponibles :", startX, startY);
  for (int i = 0; i < shapes.length; i++) {
    fill(0);
    text(shapes[i], startX + 40, startY + (i * lineHeight) + itemSpacing + 5);  // Nom de la forme
    
    // Illustration des formes
    drawShapeIllustration(startX + 20, startY + (i * lineHeight) + itemSpacing, 7, i);  // Appelle une fonction pour dessiner les formes
  }
}

// Fonction pour dessiner les illustrations des formes
void drawShapeIllustration(float x, float y, float size, int shapeIndex) {
  switch (shapeIndex) {
    case 0:  // Cercle
      ellipse(x, y, size * 2, size * 2);
      break;
    case 1:  // Carré
      rect(x - size, y - size, size * 2, size * 2);
      break;
    case 2:  // Triangle
      float h = sqrt(3) / 2 * size * 2;
      beginShape();
      vertex(x, y - h / 2);  // Sommet supérieur
      vertex(x - size, y + h / 2);  // Coin inférieur gauche
      vertex(x + size, y + h / 2);  // Coin inférieur droit
      endShape(CLOSE);
      break;
    case 3:  // Hexagone
      beginShape();
      for (int i = 0; i < 6; i++) {
        float angle = TWO_PI / 6 * i;
        vertex(x + cos(angle) * size, y + sin(angle) * size);
      }
      endShape(CLOSE);
      break;
  }
}


// Fonction pour dessiner la boîte
void drawBox() {
  if (!bottomOpen) {  // Si le capteur 2 est désactivé
    stroke(0);
    noFill();
    rect(boxX, boxY, boxWidth, boxHeight);  // Boîte (récipient)
    line(boxX, boxY + boxHeight, boxX + boxWidth, boxY + boxHeight);  // Ligne représentant le fond de la boîte
  }
}

// Classe Particule
class Particle {
  float x, y;
  float vx, vy;  // Vitesse horizontale et verticale
  float gravity;  // Gravité qui tire la particule vers le bas
  float radius;   // Taille de la particule
  color particleColor;  // Couleur de la particule
  int shape;  // Forme de la particule
  
  Particle(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.particleColor = c;  // Applique la couleur passée en argument
    this.radius = sizes[currentSizeIndex]; // Appliquer la taille actuelle
    this.vx = random(-1, 1);  // Vitesse horizontale aléatoire
    this.vy = random(1, 3);   // Vitesse verticale initiale vers le bas
    this.gravity = gravityValues[currentGravityIndex]; // Appliquer la gravité actuelle
    this.shape = currentShapeIndex;  // Appliquer la forme actuelle
  }
  
  // Mise à jour de la position de la particule
  void update() {
      vy += gravity;  // Appliquer la gravité
      x += vx;  // Mettre à jour la position horizontale
      y += vy;  // Mettre à jour la position verticale
      
      // Gestion des collisions avec les parois de la boîte
      if (!bottomOpen) {  // Si le fond est fermé, gérer les collisions
        if (x - radius < boxX) {  // Collision avec le mur gauche de la boîte
          x = boxX + radius;
          vx *= -0.3;  // Rebond horizontal réduit
        }
        if (x + radius > boxX + boxWidth) {  // Collision avec le mur droit de la boîte
          x = boxX + boxWidth - radius;
          vx *= -0.3;  // Rebond horizontal réduit
        }
  
        if (y - radius < boxY) {  // Collision avec le haut de la boîte
          y = boxY + radius; // Réinitialiser la position de la particule
          vy = 0;  // Arrêter la particule
        }
  
        if (y + radius > boxY + boxHeight) {  // Collision avec le fond de la boîte
          y = boxY + boxHeight - radius;
          vy *= -0.3;  // Rebond vertical réduit
        }
      }
  }
  
  // Afficher la particule selon sa forme
  void display() {
    fill(particleColor);  // Utilise la couleur spécifique de la particule
    noStroke();

    switch (shape) {
      case 0:  // Cercle
        ellipse(x, y, radius * 2, radius * 2);  // Dessiner un cercle
        break;
      case 1:  // Carré
        rect(x - radius, y - radius, radius * 2, radius * 2);  // Dessiner un carré
        break;
      case 2:  // Triangle
        float h = sqrt(3) / 2 * radius * 2;
        beginShape();
        vertex(x, y - h / 2);  // Sommet supérieur
        vertex(x - radius, y + h / 2);  // Coin inférieur gauche
        vertex(x + radius, y + h / 2);  // Coin inférieur droit
        endShape(CLOSE);
        break;
      case 3:  // Hexagone
        beginShape();
        for (int i = 0; i < 6; i++) {
          float angle = TWO_PI / 6 * i;
          vertex(x + cos(angle) * radius, y + sin(angle) * radius);
        }
        endShape(CLOSE);
        break;
    }
  }
  
  // Vérifier si la particule est sortie de l'écran
  boolean isOutOfBounds() {
    // La particule est hors des limites si elle sort par le haut, bas, gauche ou droite
    return (y - radius > height || y + radius < 0 || x - radius > width || x + radius < 0); 
  }
}

// Gérer les collisions entre les particules
void handleCollisions() {
  float restitution = 0.9; // Coefficient de restitution
  float minSeparationDistance = 0.05; // Distance minimale entre particules
  float repulsionForce = 0.1; // Force de répulsion

  for (int i = 0; i < particles.size(); i++) {
    Particle p1 = particles.get(i);
    for (int j = i + 1; j < particles.size(); j++) {
      Particle p2 = particles.get(j);
      
      // Calcul des différences de position entre les particules
      float dx = p2.x - p1.x;
      float dy = p2.y - p1.y;
      float distance = dist(p1.x, p1.y, p2.x, p2.y);
      float minDist = p1.radius + p2.radius;

      // Si les particules se chevauchent et respectent la distance minimale
      if (distance < minDist && distance > minSeparationDistance) {
        // Incrémente le compteur de collisions
        collisionCount++;

        // Appliquer une force de répulsion
        float forceMagnitude = repulsionForce * (minDist - distance);
        p1.vx -= forceMagnitude * (dx / distance);
        p1.vy -= forceMagnitude * (dy / distance);
        p2.vx += forceMagnitude * (dx / distance);
        p2.vy += forceMagnitude * (dy / distance);
      }

      // Si elles se chevauchent réellement, calcul de la collision
      if (distance < minDist) {
        // Calcul de l'angle de collision
        float angle = atan2(dy, dx);

        // Séparation des particules
        float overlap = minDist - distance + 0.1; // Ajuste pour la marge
        float separationX = cos(angle) * overlap / 2;
        float separationY = sin(angle) * overlap / 2;
        p1.x -= separationX;
        p1.y -= separationY;
        p2.x += separationX;
        p2.y += separationY;

        // Calcul de la vitesse relative
        float vxRel = p2.vx - p1.vx;
        float vyRel = p2.vy - p1.vy;

        // Projection des vitesses sur l'axe de collision
        float velocityAlongNormal = vxRel * cos(angle) + vyRel * sin(angle);

        // Si les particules se rapprochent, appliquer les lois de la conservation
        if (velocityAlongNormal > 0) continue;

        // Quantité de mouvement après collision
        float impulse = (-(1 + restitution) * velocityAlongNormal) / 2;

        // Modification des vitesses
        float impulseX = cos(angle) * impulse;
        float impulseY = sin(angle) * impulse;

        p1.vx -= impulseX;
        p1.vy -= impulseY;
        p2.vx += impulseX;
        p2.vy += impulseY;
      }
    }
  }
}


// Fonction pour obtenir le nom de la couleur actuelle
String colorName(int index) {
  switch (index) {
    case 0: return "Bleu";
    case 1: return "Vert"; 
    case 2: return "Rouge";
    case 3: return "Jaune";
    case 4: return "Orange";
    case 5: return "Indigo";
    case 6: return "Rose";
    case 7: return "Cyan";
    case 8: return "Dynamique"; // Couleur dynamique
    default: return "Inconnu";
  }
}

// Fonction pour obtenir le nom de la taille actuelle
String sizeName(int index) {
  switch (index) {
    case 0: return "Très petit";
    case 1: return "Normal";
    case 2: return "Grand";
    case 3: return "Énorme";
    case 4: return "Dynamique";  // Taille dynamique
    default: return "Inconnu";
  }
}

// Fonction pour obtenir le nom de la gravité actuelle
String gravityName(int index) {
  switch (index) {
    case 0: return "Faible";
    case 1: return "Moyenne";
    case 2: return "Élevée";
    case 3: return "Très Élevée";
    case 4: return "Inversé";
    case 5: return "Dynamique";  // Gravité dynamique
    default: return "Inconnu";
  }
}

// Fonction appelée lorsqu'une nouvelle donnée série est disponible
void serialEvent(Serial myPort) {
  serialData = myPort.readStringUntil('\n');  // Lire jusqu'à la fin de ligne
  serialData = trim(serialData);  // Supprimer les espaces superflus

  // Découper les données CSV (16 valeurs, une pour chaque canal du multiplexeur)
  String[] values = split(serialData, ',');

  if (values.length == 8) {  // Vérifier qu'on a bien 16 valeurs (une par canal)
    try {
      // Convertir les valeurs des capteurs
      int sensor1 = int(values[0]);  // Valeur du capteur sur le canal 0 (capteur 1)
      int sensor2 = int(values[1]);  // Valeur du capteur sur le canal 1 (capteur 2)
      int sensor3 = int(values[2]);  // Valeur du capteur sur le canal 2 (capteur 3)
      int sensor4 = int(values[3]);  // Valeur du capteur sur le canal 3 (capteur 4)
      int sensor5 = int(values[4]);  // Valeur du capteur sur le canal 4 (capteur 5)
      int sensor6 = int(values[5]);  // Valeur du nouveau capteur sur le canal 5
      int sensor7 = int(values[6]);  // Valeur du capteur 7 pour changer la forme

      // Capteur 1 : Si la valeur dépasse le seuil, créer des particules dans la boîte
      if (sensor1 > thresholdSensor1) {
        for (int i = 0; i < 5; i++) {  // Créer 5 nouvelles particules à chaque cycle
          particles.add(new Particle(boxX + boxWidth / 2, boxY + boxHeight / 2, colors[currentColorIndex]));  // Créer des particules au milieu de la boîte
        }
      }

      // Capteur 2 : Si la valeur dépasse le seuil, ouvrir le fond de la boîte
      bottomOpen = sensor2 > thresholdSensor2;

      // Capteur 3 : Si la valeur dépasse le seuil, changer la couleur des particules
      if (sensor3 > thresholdSensor3 && !colorChanged) {
        currentColorIndex = (currentColorIndex + 1) % colors.length;  // Passer à la couleur suivante
        colorChanged = true;  // Empêche les changements continus
      } else if (sensor3 <= thresholdSensor3) {
        colorChanged = false;  // Réinitialiser pour permettre un nouveau changement à la prochaine pression
      }

      // Capteur 4 : Si la valeur dépasse le seuil, changer la taille des particules
      if (sensor4 > thresholdSensor4 && !sizeChanged) {
        currentSizeIndex = (currentSizeIndex + 1) % sizes.length;  // Passer à la taille suivante
        sizeChanged = true;  // Empêche les changements continus
      } else if (sensor4 <= thresholdSensor4) {
        sizeChanged = false;  // Réinitialiser pour permettre un nouveau changement à la prochaine pression
      }

      // Capteur 5 : Si la valeur dépasse le seuil, changer la gravité des particules
      if (sensor5 > thresholdSensor5 && !gravityChanged) {
        currentGravityIndex = (currentGravityIndex + 1) % gravityValues.length;  // Passer à la gravité suivante
        gravityChanged = true;  // Empêche les changements continus
      } else if (sensor5 <= thresholdSensor5) {
        gravityChanged = false;  // Réinitialiser pour permettre un nouveau changement à la prochaine pression
      }

      // Capteur 6 : Si la valeur dépasse le seuil, appliquer les effets à toutes les particules
      applyEffectsToAll = sensor6 > thresholdSensor6;

      // Capteur 7 : Si la valeur dépasse le seuil, changer la forme des particules
      if (sensor7 > thresholdSensor7 && !shapeChanged) {
        currentShapeIndex = (currentShapeIndex + 1) % shapes.length;  // Passer à la forme suivante
        shapeChanged = true;  // Empêche les changements continus
      } else if (sensor7 <= thresholdSensor7) {
        shapeChanged = false;  // Réinitialiser pour permettre un nouveau changement à la prochaine pression
      }

    } catch (Exception e) {
      println("Erreur lors de la conversion des données : " + e.getMessage());
    }
  }
}
