-- MySQL dump 10.13  Distrib 5.7.33, for Linux (x86_64)
--
-- Host: localhost    Database: movie_booking
-- ------------------------------------------------------
-- Server version	5.7.33-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movie` (
  `movie_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `poster_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `age_rating` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `runtime` int(11) DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`movie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (1,'인터스텔라',NULL,'12',169,NULL),(2,'주토피아2',NULL,'All',108,NULL),(3,'데드풀과 울버린',NULL,'19',128,NULL),(4,'라라랜드',NULL,'12',128,NULL);
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reservation` (
  `reservation_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `showtime_id` int(11) NOT NULL,
  `reserved_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CONFIRMED',
  PRIMARY KEY (`reservation_id`),
  KEY `idx_resv_user` (`user_id`),
  KEY `idx_resv_showtime` (`showtime_id`),
  CONSTRAINT `fk_resv_showtime` FOREIGN KEY (`showtime_id`) REFERENCES `showtime` (`showtime_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_resv_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserved_seat`
--

DROP TABLE IF EXISTS `reserved_seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reserved_seat` (
  `reserved_seat_id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` int(11) NOT NULL,
  `seat_id` int(11) NOT NULL,
  `showtime_id` int(11) NOT NULL,
  PRIMARY KEY (`reserved_seat_id`),
  UNIQUE KEY `uq_rs_unique` (`showtime_id`,`seat_id`),
  KEY `fk_rs_seat` (`seat_id`),
  KEY `idx_rs_resv` (`reservation_id`),
  KEY `idx_rs_showtime` (`showtime_id`),
  CONSTRAINT `fk_rs_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`reservation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rs_seat` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_rs_showtime` FOREIGN KEY (`showtime_id`) REFERENCES `showtime` (`showtime_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserved_seat`
--

LOCK TABLES `reserved_seat` WRITE;
/*!40000 ALTER TABLE `reserved_seat` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserved_seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screen`
--

DROP TABLE IF EXISTS `screen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `screen` (
  `screen_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_rows` int(11) NOT NULL,
  `total_cols` int(11) NOT NULL,
  PRIMARY KEY (`screen_id`),
  UNIQUE KEY `uq_screen_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screen`
--

LOCK TABLES `screen` WRITE;
/*!40000 ALTER TABLE `screen` DISABLE KEYS */;
INSERT INTO `screen` VALUES (1,'1관',8,13),(2,'2관',8,13);
/*!40000 ALTER TABLE `screen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seat` (
  `seat_id` int(11) NOT NULL AUTO_INCREMENT,
  `screen_id` int(11) NOT NULL,
  `seat_row` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seat_col` int(11) NOT NULL,
  PRIMARY KEY (`seat_id`),
  UNIQUE KEY `uq_seat_screen_pos` (`screen_id`,`seat_row`,`seat_col`),
  CONSTRAINT `fk_seat_screen` FOREIGN KEY (`screen_id`) REFERENCES `screen` (`screen_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat`
--

LOCK TABLES `seat` WRITE;
/*!40000 ALTER TABLE `seat` DISABLE KEYS */;
INSERT INTO `seat` VALUES (2,1,'A',1),(3,1,'A',2),(4,1,'A',3),(5,1,'A',4),(6,1,'A',5),(7,1,'A',6),(8,1,'A',7),(9,1,'A',8),(10,1,'A',9),(11,1,'A',10),(12,1,'A',11),(13,1,'A',12),(14,1,'A',13),(15,1,'B',1),(16,1,'B',2),(17,1,'B',3),(18,1,'B',4),(19,1,'B',5),(20,1,'B',6),(21,1,'B',7),(22,1,'B',8),(23,1,'B',9),(24,1,'B',10),(25,1,'B',11),(26,1,'B',12),(27,1,'B',13),(28,1,'C',1),(29,1,'C',2),(30,1,'C',3),(31,1,'C',4),(32,1,'C',5),(33,1,'C',6),(34,1,'C',7),(35,1,'C',8),(36,1,'C',9),(37,1,'C',10),(38,1,'C',11),(39,1,'C',12),(40,1,'C',13),(41,1,'D',1),(42,1,'D',2),(43,1,'D',3),(44,1,'D',4),(45,1,'D',5),(46,1,'D',6),(47,1,'D',7),(48,1,'D',8),(49,1,'D',9),(50,1,'D',10),(51,1,'D',11),(52,1,'D',12),(53,1,'D',13),(54,1,'E',1),(55,1,'E',2),(56,1,'E',3),(57,1,'E',4),(58,1,'E',5),(59,1,'E',6),(60,1,'E',7),(61,1,'E',8),(62,1,'E',9),(63,1,'E',10),(64,1,'E',11),(65,1,'E',12),(66,1,'E',13),(67,1,'F',1),(68,1,'F',2),(69,1,'F',3),(70,1,'F',4),(71,1,'F',5),(72,1,'F',6),(73,1,'F',7),(74,1,'F',8),(75,1,'F',9),(76,1,'F',10),(77,1,'F',11),(78,1,'F',12),(79,1,'F',13),(80,1,'G',1),(81,1,'G',2),(82,1,'G',3),(83,1,'G',4),(84,1,'G',5),(85,1,'G',6),(86,1,'G',7),(87,1,'G',8),(88,1,'G',9),(89,1,'G',10),(90,1,'G',11),(91,1,'G',12),(92,1,'G',13),(93,1,'H',1),(94,1,'H',2),(95,1,'H',3),(96,1,'H',4),(97,1,'H',5),(98,1,'H',6),(99,1,'H',7),(100,1,'H',8),(101,1,'H',9),(102,1,'H',10),(103,1,'H',11),(104,1,'H',12),(105,1,'H',13),(106,2,'A',1),(107,2,'A',2),(108,2,'A',3),(109,2,'A',4),(110,2,'A',5),(111,2,'A',6),(112,2,'A',7),(113,2,'A',8),(114,2,'A',9),(115,2,'A',10),(116,2,'A',11),(117,2,'A',12),(118,2,'A',13),(119,2,'B',1),(120,2,'B',2),(121,2,'B',3),(122,2,'B',4),(123,2,'B',5),(124,2,'B',6),(125,2,'B',7),(126,2,'B',8),(127,2,'B',9),(128,2,'B',10),(129,2,'B',11),(130,2,'B',12),(131,2,'B',13),(132,2,'C',1),(133,2,'C',2),(134,2,'C',3),(135,2,'C',4),(136,2,'C',5),(137,2,'C',6),(138,2,'C',7),(139,2,'C',8),(140,2,'C',9),(141,2,'C',10),(142,2,'C',11),(143,2,'C',12),(144,2,'C',13),(145,2,'D',1),(146,2,'D',2),(147,2,'D',3),(148,2,'D',4),(149,2,'D',5),(150,2,'D',6),(151,2,'D',7),(152,2,'D',8),(153,2,'D',9),(154,2,'D',10),(155,2,'D',11),(156,2,'D',12),(157,2,'D',13),(158,2,'E',1),(159,2,'E',2),(160,2,'E',3),(161,2,'E',4),(162,2,'E',5),(163,2,'E',6),(164,2,'E',7),(165,2,'E',8),(166,2,'E',9),(167,2,'E',10),(168,2,'E',11),(169,2,'E',12),(170,2,'E',13),(171,2,'F',1),(172,2,'F',2),(173,2,'F',3),(174,2,'F',4),(175,2,'F',5),(176,2,'F',6),(177,2,'F',7),(178,2,'F',8),(179,2,'F',9),(180,2,'F',10),(181,2,'F',11),(182,2,'F',12),(183,2,'F',13),(184,2,'G',1),(185,2,'G',2),(186,2,'G',3),(187,2,'G',4),(188,2,'G',5),(189,2,'G',6),(190,2,'G',7),(191,2,'G',8),(192,2,'G',9),(193,2,'G',10),(194,2,'G',11),(195,2,'G',12),(196,2,'G',13),(197,2,'H',1),(198,2,'H',2),(199,2,'H',3),(200,2,'H',4),(201,2,'H',5),(202,2,'H',6),(203,2,'H',7),(204,2,'H',8),(205,2,'H',9),(206,2,'H',10),(207,2,'H',11),(208,2,'H',12),(209,2,'H',13);
/*!40000 ALTER TABLE `seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `showtime`
--

DROP TABLE IF EXISTS `showtime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `showtime` (
  `showtime_id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) NOT NULL,
  `screen_id` int(11) NOT NULL,
  `start_time` datetime NOT NULL,
  `remaining_seats` int(11) NOT NULL,
  PRIMARY KEY (`showtime_id`),
  KEY `fk_showtime_movie` (`movie_id`),
  KEY `idx_showtime_start` (`start_time`),
  KEY `idx_showtime_screen` (`screen_id`),
  CONSTRAINT `fk_showtime_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_showtime_screen` FOREIGN KEY (`screen_id`) REFERENCES `screen` (`screen_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `showtime`
--

LOCK TABLES `showtime` WRITE;
/*!40000 ALTER TABLE `showtime` DISABLE KEYS */;
INSERT INTO `showtime` VALUES (2,2,1,'2025-12-20 10:00:00',104),(3,4,1,'2025-12-20 12:10:00',104),(4,2,1,'2025-12-20 14:40:00',104),(5,4,1,'2025-12-20 16:50:00',104),(6,3,2,'2025-12-20 10:00:00',104),(7,1,2,'2025-12-20 12:30:00',104),(8,3,2,'2025-12-20 15:40:00',104),(9,1,2,'2025-12-20 18:10:00',104);
/*!40000 ALTER TABLE `showtime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('alice','pass','Alice','2025-12-13 13:39:36','2025-12-14 01:56:47');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-14 12:27:47
