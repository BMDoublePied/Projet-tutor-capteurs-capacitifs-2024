#include <CapacitiveSensor.h>

// Configuration du capteur capacitif sur les broches 8 et 10
CapacitiveSensor cs_8_10 = CapacitiveSensor(10, 8);  // Résistance entre les broches 8 et 10

// Broches de contrôle du multiplexeur
int S0 = 2;
int S1 = 3;
int S2 = 4;
int S3 = 5;

// Fonction pour configurer les broches de sélection du multiplexeur
void selectMuxChannel(int channel) {
    digitalWrite(S0, bitRead(channel, 0));
    digitalWrite(S1, bitRead(channel, 1));
    digitalWrite(S2, bitRead(channel, 2));
    digitalWrite(S3, bitRead(channel, 3));
}

void setup() {
    // Configuration des broches de sélection du multiplexeur
    pinMode(S0, OUTPUT);
    pinMode(S1, OUTPUT);
    pinMode(S2, OUTPUT);
    pinMode(S3, OUTPUT);

    // Désactiver l'auto-calibration du capteur capacitif
    cs_8_10.set_CS_AutocaL_Millis(0xFFFFFFFF);
    
    Serial.begin(9600);
}

void loop() {
    long start = millis();

    // Lire les 16 entrées du multiplexeur (Y0 à Y15)
    for (int i = 0; i < 16; i++) {
        selectMuxChannel(i);  // Sélectionner le canal i
        delay(1);  // Délai pour stabiliser la sélection du canal

        long total = cs_8_10.capacitiveSensor(1);  // Lire le capteur capacitif avec 30 échantillons

        // Affichage des données en format CSV (sans virgule à la fin)
        Serial.print(total);
        if (i < 15) {
            Serial.print(",");  // Ajoute une virgule tant que ce n'est pas la dernière valeur
        }
    }

    Serial.println();  // Nouvelle ligne pour le prochain cycle
    //Serial.println(millis() - start);  // Vérification des performances

    delay(1);  // Limitation des données envoyées sur le port série
}
