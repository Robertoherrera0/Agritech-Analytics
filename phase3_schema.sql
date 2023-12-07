-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: project
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `crop`
--

DROP TABLE IF EXISTS `crop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crop` (
  `CropID` int NOT NULL AUTO_INCREMENT,
  `Health_status` varchar(50) DEFAULT NULL,
  `Planting_date` date DEFAULT NULL,
  `Crop_yield` decimal(10,2) DEFAULT NULL,
  `Crop_name` varchar(255) DEFAULT NULL,
  `Locations` varchar(255) DEFAULT NULL,
  `Irrigation_Method` enum('Drip','Sprinkler','Surface','Subsurface','Flood','Manual','Automated') NOT NULL,
  `Equipment_necessary` varchar(255) DEFAULT NULL,
  `FarmID` int DEFAULT NULL,
  `FarmerID` int DEFAULT NULL,
  `Weather_Conditions` varchar(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`CropID`),
  KEY `FarmID` (`FarmID`),
  KEY `FarmerID` (`FarmerID`),
  CONSTRAINT `crop_ibfk_1` FOREIGN KEY (`FarmID`) REFERENCES `farm` (`FarmID`) ON DELETE CASCADE,
  CONSTRAINT `crop_ibfk_2` FOREIGN KEY (`FarmerID`) REFERENCES `farmer` (`FarmerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crop`
--

LOCK TABLES `crop` WRITE;
/*!40000 ALTER TABLE `crop` DISABLE KEYS */;
INSERT INTO `crop` VALUES (1,'Fair','2023-03-01',500.00,'Wheat','Field 1A','Drip','Tractor',1,1,'Challenging',100.00),(2,'Poor','2023-04-15',400.00,'Corn','Field 1B','Sprinkler','Harvester',1,1,'Variable',120.00),(3,'Excellent','2023-02-20',600.00,'Tomatoes','Field 2A','Surface','Fertilizer Spreader',2,1,'Adverse',95.50),(4,'Good','2023-05-10',450.00,'Onions','Field 2B','Subsurface','Cultivator',2,1,'Challenging',110.00),(5,'Good','2023-03-05',550.00,'Rice','Field 3A','Flood','Seeder',3,2,'Optimal',105.00),(6,'Good','2023-06-01',300.00,'Potatoes','Field 3B','Manual','Plow',3,2,'Challenging',130.00),(7,'Excellent','2023-02-25',650.00,'Carrots','Field 4A','Automated','Tractor',4,3,'Optimal',90.00),(8,'Good','2023-05-15',500.00,'Lettuce','Field 4B','Drip','Harvester',4,3,'Adverse',115.00);
/*!40000 ALTER TABLE `crop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crop_monitoring`
--

DROP TABLE IF EXISTS `crop_monitoring`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crop_monitoring` (
  `SensorID` int NOT NULL,
  `MonitoringRange` decimal(10,2) DEFAULT NULL,
  `Water_Quality` enum('Excellent','Good','Fair','Poor','Critical') NOT NULL,
  `Soil_Moisture` enum('Dry','Optimal','Wet') NOT NULL,
  `Plague_Detection` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`SensorID`),
  CONSTRAINT `crop_monitoring_ibfk_1` FOREIGN KEY (`SensorID`) REFERENCES `sensors` (`SensorID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crop_monitoring`
--

LOCK TABLES `crop_monitoring` WRITE;
/*!40000 ALTER TABLE `crop_monitoring` DISABLE KEYS */;
INSERT INTO `crop_monitoring` VALUES (1,8.65,'Critical','Optimal',0),(2,8.86,'Excellent','Dry',1),(3,12.63,'Poor','Wet',0),(4,0.46,'Critical','Optimal',1),(5,3.98,'Poor','Optimal',0),(6,9.09,'Critical','Wet',0),(7,6.61,'Poor','Optimal',1),(8,0.88,'Fair','Wet',0);
/*!40000 ALTER TABLE `crop_monitoring` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farm`
--

DROP TABLE IF EXISTS `farm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farm` (
  `FarmID` int NOT NULL AUTO_INCREMENT,
  `Size` decimal(10,2) DEFAULT NULL,
  `Location` varchar(255) NOT NULL,
  `FarmerID` int DEFAULT NULL,
  PRIMARY KEY (`FarmID`),
  KEY `FarmerID` (`FarmerID`),
  CONSTRAINT `farm_ibfk_1` FOREIGN KEY (`FarmerID`) REFERENCES `farmer` (`FarmerID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farm`
--

LOCK TABLES `farm` WRITE;
/*!40000 ALTER TABLE `farm` DISABLE KEYS */;
INSERT INTO `farm` VALUES (1,120.00,'North Valley',1),(2,95.00,'East Hill',1),(3,150.00,'South Ridge',2),(4,180.00,'West Plains',3);
/*!40000 ALTER TABLE `farm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmer`
--

DROP TABLE IF EXISTS `farmer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmer` (
  `FarmerID` int NOT NULL AUTO_INCREMENT,
  `Company_name` varchar(255) DEFAULT NULL,
  `Email` varchar(255) NOT NULL,
  PRIMARY KEY (`FarmerID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmer`
--

LOCK TABLES `farmer` WRITE;
/*!40000 ALTER TABLE `farmer` DISABLE KEYS */;
INSERT INTO `farmer` VALUES (1,'Green Acres','contact@greenacres.com'),(2,'Sunny Farm','info@sunnyfarm.com'),(3,'Harvest Fields','support@harvestfields.com');
/*!40000 ALTER TABLE `farmer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmer_address`
--

DROP TABLE IF EXISTS `farmer_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmer_address` (
  `FarmerID` int NOT NULL,
  `Address` varchar(255) NOT NULL,
  PRIMARY KEY (`FarmerID`,`Address`),
  CONSTRAINT `farmer_address_ibfk_1` FOREIGN KEY (`FarmerID`) REFERENCES `farmer` (`FarmerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmer_address`
--

LOCK TABLES `farmer_address` WRITE;
/*!40000 ALTER TABLE `farmer_address` DISABLE KEYS */;
INSERT INTO `farmer_address` VALUES (1,'101 Greenway, Farmville'),(2,'202 Sunshine Blvd, Agritown'),(3,'303 Harvest Lane, Cropsburg');
/*!40000 ALTER TABLE `farmer_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `farmer_phone`
--

DROP TABLE IF EXISTS `farmer_phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `farmer_phone` (
  `FarmerID` int NOT NULL,
  `Phone` varchar(10) NOT NULL,
  PRIMARY KEY (`FarmerID`,`Phone`),
  CONSTRAINT `farmer_phone_ibfk_1` FOREIGN KEY (`FarmerID`) REFERENCES `farmer` (`FarmerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `farmer_phone`
--

LOCK TABLES `farmer_phone` WRITE;
/*!40000 ALTER TABLE `farmer_phone` DISABLE KEYS */;
INSERT INTO `farmer_phone` VALUES (1,'5551234567'),(2,'5552345678'),(3,'5553456789');
/*!40000 ALTER TABLE `farmer_phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monitoring`
--

DROP TABLE IF EXISTS `monitoring`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monitoring` (
  `CropID` int NOT NULL,
  `SensorID` int NOT NULL,
  PRIMARY KEY (`CropID`,`SensorID`),
  KEY `SensorID` (`SensorID`),
  CONSTRAINT `monitoring_ibfk_1` FOREIGN KEY (`CropID`) REFERENCES `crop` (`CropID`) ON DELETE CASCADE,
  CONSTRAINT `monitoring_ibfk_2` FOREIGN KEY (`SensorID`) REFERENCES `sensors` (`SensorID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monitoring`
--

LOCK TABLES `monitoring` WRITE;
/*!40000 ALTER TABLE `monitoring` DISABLE KEYS */;
INSERT INTO `monitoring` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8);
/*!40000 ALTER TABLE `monitoring` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensors`
--

DROP TABLE IF EXISTS `sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensors` (
  `SensorID` int NOT NULL AUTO_INCREMENT,
  `Sensor_Type` enum('Weather','Monitoring') NOT NULL,
  `Sensor_Status` enum('Active','Inactive','Under Maintenance','Faulty') NOT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `Installation_date` date DEFAULT NULL,
  `Last_Maintenance_Date` date DEFAULT NULL,
  `CropID` int DEFAULT NULL,
  PRIMARY KEY (`SensorID`),
  KEY `CropID` (`CropID`),
  CONSTRAINT `sensors_ibfk_1` FOREIGN KEY (`CropID`) REFERENCES `crop` (`CropID`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensors`
--

LOCK TABLES `sensors` WRITE;
/*!40000 ALTER TABLE `sensors` DISABLE KEYS */;
INSERT INTO `sensors` VALUES (1,'Weather','Active','Field 1A','2023-01-01','2023-03-01',1),(2,'Monitoring','Active','Field 1A','2023-01-01','2023-03-01',1),(3,'Weather','Active','Field 1B','2023-01-01','2023-03-01',2),(4,'Monitoring','Active','Field 1B','2023-01-01','2023-03-01',2),(5,'Weather','Active','Field 2A','2023-01-01','2023-03-01',3),(6,'Monitoring','Active','Field 2A','2023-01-01','2023-03-01',3),(7,'Weather','Active','Field 2B','2023-01-01','2023-03-01',4),(8,'Monitoring','Active','Field 2B','2023-01-01','2023-03-01',4),(9,'Weather','Active','Field 3A','2023-01-01','2023-03-01',5),(10,'Monitoring','Active','Field 3A','2023-01-01','2023-03-01',5),(11,'Weather','Active','Field 3B','2023-01-01','2023-03-01',6),(12,'Monitoring','Active','Field 3B','2023-01-01','2023-03-01',6),(13,'Weather','Active','Field 4A','2023-01-01','2023-03-01',7),(14,'Monitoring','Active','Field 4A','2023-01-01','2023-03-01',7),(15,'Weather','Active','Field 4B','2023-01-01','2023-03-01',8),(16,'Monitoring','Active','Field 4B','2023-01-01','2023-03-01',8);
/*!40000 ALTER TABLE `sensors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weather_sensors`
--

DROP TABLE IF EXISTS `weather_sensors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather_sensors` (
  `SensorID` int NOT NULL,
  `Wind` decimal(5,2) DEFAULT NULL,
  `Precipitation` decimal(5,2) DEFAULT NULL,
  `Humidity` decimal(5,2) DEFAULT NULL,
  `Temperature` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`SensorID`),
  CONSTRAINT `weather_sensors_ibfk_1` FOREIGN KEY (`SensorID`) REFERENCES `sensors` (`SensorID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather_sensors`
--

LOCK TABLES `weather_sensors` WRITE;
/*!40000 ALTER TABLE `weather_sensors` DISABLE KEYS */;
INSERT INTO `weather_sensors` VALUES (1,12.47,94.10,83.50,17.33),(2,5.12,22.39,35.11,7.93),(3,7.30,57.50,77.92,10.98),(4,10.35,7.38,81.69,35.22),(5,17.32,73.97,10.05,14.92),(6,2.32,72.87,29.61,15.31),(7,11.68,3.64,43.02,6.46),(8,18.37,46.73,58.08,22.57);
/*!40000 ALTER TABLE `weather_sensors` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-06 23:42:16
