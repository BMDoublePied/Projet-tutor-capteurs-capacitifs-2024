#include <CapacitiveSensor.h>

CapacitiveSensor cs_3_2 = CapacitiveSensor(3, 2);   // 1M ohm entre les broches 3 et 2
CapacitiveSensor cs_3_4 = CapacitiveSensor(3, 4);   // 1M ohm entre les broches 3 et 4
CapacitiveSensor cs_6_5 = CapacitiveSensor(6, 5); // 1M ohm entre les broches 6 et 5
CapacitiveSensor cs_6_7 = CapacitiveSensor(6, 7); // 1M ohm entre les broches 6 et 7
CapacitiveSensor cs_9_8 = CapacitiveSensor(9, 8); // 1M ohm entre les broches 9 et 8
CapacitiveSensor cs_9_10 = CapacitiveSensor(9, 10); // 1M ohm entre les broches 9 et 10
CapacitiveSensor cs_12_11 = CapacitiveSensor(12, 11); // 1M ohm entre les broches 12 et 11
CapacitiveSensor cs_12_13 = CapacitiveSensor(12, 13); // 1M ohm entre les broches 12 et 13

void setup() {
    Serial.begin(9600);
      // Désactiver l'autocalibration
    cs_3_2.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_3_4.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_6_5.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_6_7.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_9_8.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_9_10.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_12_11.set_CS_AutocaL_Millis(0xFFFFFFFF);
    cs_12_13.set_CS_AutocaL_Millis(0xFFFFFFFF);
}

void loop() {
    long total1 = cs_3_2.capacitiveSensor(2);
    long total2 = cs_3_4.capacitiveSensor(2);
    long total3 = cs_6_5.capacitiveSensor(2);
    long total4 = cs_6_7.capacitiveSensor(2);
    long total5 = cs_9_8.capacitiveSensor(2);
    long total6 = cs_9_10.capacitiveSensor(2);
    long total7 = cs_12_11.capacitiveSensor(2);
    long total8 = cs_12_13.capacitiveSensor(2);

    // Envoyer les valeurs en CSV (séparées par des virgules)
    Serial.print(total1);
    Serial.print(",");
    Serial.print(total2);
    Serial.print(",");
    Serial.print(total3);
    Serial.print(",");
    Serial.print(total4);
    Serial.print(",");
    Serial.print(total5);
    Serial.print(",");
    Serial.print(total6);
    Serial.print(",");
    Serial.print(total7);
    Serial.print(",");
    Serial.println(total8);

    delay(1);  // Limiter la fréquence d'envoi pour éviter la surcharge
}
