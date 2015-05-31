/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `folder_id` int(11) DEFAULT NULL,
  `priority` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(500) DEFAULT NULL,
  `_subject` varchar(500) DEFAULT NULL,
  `start` varchar(500) DEFAULT NULL,
  `_start` varchar(500) DEFAULT NULL,
  `stop` varchar(500) DEFAULT NULL,
  `_stop` varchar(500) DEFAULT NULL,
  `due` varchar(500) DEFAULT NULL,
  `_due` varchar(500) DEFAULT NULL,
  `omit` varchar(500) DEFAULT NULL,
  `_omit` varchar(500) DEFAULT NULL,
  `omit_shift` varchar(500) DEFAULT NULL,
  `_omit_shift` varchar(500) DEFAULT NULL,
  `time_ssm` varchar(500) DEFAULT NULL,
  `_time_ssm` varchar(500) DEFAULT NULL,
  `remind` varchar(500) DEFAULT NULL,
  `_remind` varchar(500) DEFAULT NULL,
  `omit_remind` varchar(500) DEFAULT NULL,
  `_omit_remind` varchar(500) DEFAULT NULL,
  `message` text,
  `_message` text,
  `_folder_names` varchar(500) DEFAULT NULL,
  `_status` varchar(20) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
