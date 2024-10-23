import processing.serial.*;

Serial myPort;
String[] capteurData = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"};
float[] smoothedData = new float[16]; // Tableau pour stocker les valeurs filtrées
color offColor = color(255, 255, 255);  // Couleur par défaut (blanc)
color onColor = color(255, 0, 0);      // Couleur activée (rouge)
color dimColor = color(200, 200, 200); // Couleur atténuée pour les bandes associées à une intersection active

int threshold = 100;   // Seuil de détection de base
int tolerance = 50;   // Tolérance autour du seuil pour gérer les variations
float smoothingFactor = 0.2;  // Facteur de lissage (entre 0 et 1)

void setup() {
  size(800, 800);
  String portName = "COM11";  // Sélection du port COM (à adapter)
  try {
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil('\n');  // Lire jusqu'à la fin de ligne
  } catch (Exception e) {
    println("Error opening serial port: " + e.getMessage());
  }

  // Initialiser les données lissées avec les valeurs initiales des capteurs
  for (int i = 0; i < smoothedData.length; i++) {
    smoothedData[i] = float(capteurData[i]);
  }
}

void draw() {
  background(232, 220, 202);
  textSize(14);  // Taille de texte pour afficher les valeurs

  int gridSize = 8;  // Nombre de bandes (8 bandes horizontales et 8 verticales)
  
  // Calculer la taille et les marges pour occuper tout l'espace
  int bandeWidth = (width - 100) / gridSize;  // Largeur des bandes (adapté à la taille du canvas)
  int bandeHeight = (height - 100) / gridSize; // Hauteur des bandes (adapté à la taille du canvas)
  
  int marginX = (width - (bandeWidth * gridSize)) / 2;  // Calcul des marges horizontales
  int marginY = (height - (bandeHeight * gridSize)) / 2;  // Calcul des marges verticales

  boolean[][] intersections = new boolean[8][8];  // Pour stocker l'état des intersections

  // Calcul des intersections avec les données lissées
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      int horizontalValue = int(smoothedData[7 - i]);  // Capteurs horizontaux de bas en haut
      int verticalValue = int(smoothedData[15 - j]);   // Capteurs verticaux de droite à gauche

      // Condition pour activer une intersection avec tolérance
      intersections[i][j] = (horizontalValue > threshold - tolerance && verticalValue > threshold - tolerance);
    }
  }

  // Dessin des bandes horizontales (capteurs 0 à 7) de bas en haut
  for (int i = 0; i < gridSize; i++) {
    boolean hasActiveIntersection = false;

    // Vérifie s'il y a une intersection active sur cette bande
    for (int j = 0; j < gridSize; j++) {
      if (intersections[i][j]) {
        hasActiveIntersection = true;
        break;
      }
    }

    // Si une intersection est active sur cette bande, la dessiner en dimColor
    if (hasActiveIntersection) {
      fill(dimColor);
    } else if (int(smoothedData[7 - i]) > threshold - tolerance) {  // Inverser l'ordre des capteurs
      fill(onColor);
    } else {
      fill(offColor);
    }

    // Dessin de la bande horizontale
    rect(marginX, marginY + i * bandeHeight, width - 2 * marginX, bandeHeight - 10);  // Réduction de l'écart

    // Afficher la valeur du capteur horizontal à droite de la bande
    fill(0);  // Texte en noir
    text(int(smoothedData[7 - i]), width - marginX + 10, marginY + i * bandeHeight + bandeHeight / 2);  // Affiche la valeur à droite
  }

  // Dessin des bandes verticales (capteurs 8 à 15) de droite à gauche
  for (int j = 0; j < gridSize; j++) {
    boolean hasActiveIntersection = false;

    // Vérifie s'il y a une intersection active sur cette bande
    for (int i = 0; i < gridSize; i++) {
      if (intersections[i][j]) {
        hasActiveIntersection = true;
        break;
      }
    }

    // Si une intersection est active sur cette bande, la dessiner en dimColor
    if (hasActiveIntersection) {
      fill(dimColor);
    } else if (int(smoothedData[15 - j]) > threshold - tolerance) {  // Inverser l'ordre des capteurs
      fill(onColor);
    } else {
      fill(offColor);
    }

    // Dessin de la bande verticale
    rect(marginX + j * bandeWidth, marginY, bandeWidth - 10, height - 2 * marginY);  // Réduction de l'écart

    // Afficher la valeur du capteur vertical au-dessus de la bande
    fill(0);  // Texte en noir
    text(int(smoothedData[15 - j]), marginX + j * bandeWidth + bandeWidth / 2, marginY - 10);  // Affiche la valeur au-dessus
  }

  // Dessin des intersections (64 intersections dans une grille 8x8)
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (intersections[i][j]) {
        fill(onColor);  // Couleur activée uniquement pour les intersections
        rect(marginX + j * bandeWidth, marginY + i * bandeHeight, bandeWidth - 10, bandeHeight - 10);
      }
    }
  }
}

// Lire les données depuis le port série
void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  
  if (data != null) {  // Check if data is not null
    data = data.trim();  // Clean data
    
    capteurData = split(data, ',');

    // S'assurer que nous avons bien 16 éléments dans capteurData
    if (capteurData.length == 16) {
      // Appliquer la moyenne glissante aux capteurs
      for (int i = 0; i < 16; i++) {
        float newValue = float(capteurData[i]);
        smoothedData[i] = smoothingFactor * newValue + (1 - smoothingFactor) * smoothedData[i];
      }
    } else {
      println("Error: Incorrect data format received.");
    }
  } else {
    println("Error: No data received from serial.");
  }
}
