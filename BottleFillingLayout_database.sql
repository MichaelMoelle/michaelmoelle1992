#Anlegen der Datenbank für Sensordaten--------------------#

CREATE DATABASE IF NOT EXISTS `BottleFillingLayout`
CHARACTER SET utf8 COLLATE utf8_unicode_ci;

USE `BottleFillingLayout`;

#Zu Testzwecken wurden folgende Tabellen angelegt----------#
/*
CREATE TABLE IF NOT EXISTS `sensor1`
(`Flaschenanzahl` INT NOT NULL,
`Abfuelldatum` DATE NOT NULL);

CREATE TABLE IF NOT EXISTS `Limonaden`
(`FlaschenID` INT NOT NULL,
`Abfuellzeit` DATETIME NOT NULL,
`BatchID` INT NOT NULL);
*/

#Tabelle wurde mittels DROP TABLE wieder gelöscht----------#
#----------------------------------------------------------#
#Erstellung der endgültigen Tabellenaufteilung-------------#

CREATE TABLE IF NOT EXISTS `Limonaden_Produziert`
(`FlaschenID` INT NOT NULL,
 `FlaschenID_Palette` INT NOT NULL,
 `PalettenID` INT NOT NULL,
 `Abfuell-Datum` VARCHAR(30) NOT NULL);
 
 CREATE TABLE IF NOT EXISTS `Limonaden_Defekt`
 (`FlaschenID` INT NOT NULL,
  `Abfuell-Datum` VARCHAR(30) NOT NULL);
