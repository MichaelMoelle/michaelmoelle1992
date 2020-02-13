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

CREATE TABLE IF NOT EXISTS `Bestellungen`
(`Name` VARCHAR(50) NOT NULL,
`Palettenanzahl` INT NOT NULL);

CREATE TABLE IF NOT EXISTS `Vorratslager`(
`Leere Flaschen` INT NOT NULL,
`Flaschendeckel` INT NOT NULL);

#Befüllen des Lagers mit Komponenten
INSERT INTO `Vorratslager`(`Leere Flaschen`,`Flaschendeckel`)VALUES
(50000,50000);
  
#Erstellung der Trigger zur Wertänderung der Tabelle Vorratslager
DELIMITER |
CREATE TRIGGER lager_flaschen_abzug
BEFORE INSERT ON `Limonaden_Produziert`
FOR EACH ROW
BEGIN
UPDATE `Vorratslager` SET `Leere Flaschen` = `Leere Flaschen` - 1
AND `Flaschendeckel` = `Flaschendeckel` - 1;
END |
DELIMITER ;

DELIMITER |
CREATE TRIGGER lager_flaschen_abzug2
BEFORE INSERT ON `Limonaden_Defekt`
FOR EACH ROW
BEGIN
UPDATE `Vorratslager` SET `Leere Flaschen` = `Leere Flaschen` - 1
AND `Flaschendeckel` = `Flaschendeckel` - 1;
END |
DELIMITER ;

#Anlegen einer MySQL-Variable


#Erstellen eines Triggers zur Wertveränderung der Tabelle Limonaden_Produziert
DELIMITER |
CREATE TRIGGER bestellungen_abzug
BEFORE INSERT ON `Bestellungen`
FOR EACH ROW
BEGIN
SET @FLASCHENANZAHL := 1;
SET @FLASCHENANZAHL = NEW.`Palettenanzahl` * 800;
#Löschen der Flaschen und Paletten
WHILE @FLASCHENANZAHL > 0
DO
DELETE FROM `Limonaden_produziert` WHERE `FlaschenID` = MIN(`FlaschenID`);
SET @FLASCHENANZAHL = @FLASCHENANZAHL - 1;
END WHILE;
END |

SHOW TRIGGERS;

#Anlegen der Unique-Schlüssel zur Sicherung der Datenintegrität

ALTER TABLE `bottlefillinglayout`.`limonaden_produziert`
ADD UNIQUE `Unique_Limonaden_Produziert` (`FlaschenID`, `FlaschenID_Palette`, `PalettenID`, `Abfuell-Datum`);

ALTER TABLE `bottlefillinglayout`.`limonaden_defekt`
ADD UNIQUE `FlaschenID` (`FlaschenID`, `Abfuell-Datum`);
