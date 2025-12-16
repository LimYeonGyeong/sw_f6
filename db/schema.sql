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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=418 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-16 11:59:56
