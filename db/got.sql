SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE IF NOT EXISTS `got_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(30) NOT NULL,
  `lname` varchar(30) DEFAULT NULL,
  `house_id` int(11) DEFAULT NULL,
  `origin` int(11) DEFAULT NULL,
  `weapon` varchar(30) DEFAULT NULL,
  `species` enum('human','White Walker','Giant','Children of the Forest', 'Warlock', 'Dragon') NOT NULL DEFAULT 'human',
  `status` enum('alive','dead','Wight') NOT NULL DEFAULT 'alive',
  `organization` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `origin` (`origin`),
  KEY `got_characters_ibfk_2` (`house_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

 
CREATE TABLE IF NOT EXISTS `got_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `location` int(11) DEFAULT NULL,
  `season` smallint(6) DEFAULT NULL,
  `episode` smallint(6) DEFAULT NULL,
  `summary` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `location` (`location`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `got_events_characters` (
  `event_id` int(11) DEFAULT NULL,
  `character_id` int(11) DEFAULT NULL,
  KEY `event_id` (`event_id`),
  KEY `character_id` (`character_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE IF NOT EXISTS `got_house` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `sigil` varchar(90),
  `status` enum('Great House','Extinct','Vassal') NOT NULL,
  `head` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `current_head` (`head`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;



CREATE TABLE IF NOT EXISTS `got_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `region` varchar(60) NOT NULL,
  `continent` enum('Westeros','Essos','Sothoryos') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;



-- Winterfell
INSERT INTO `got_locations` (`name`, `region`, `continent`) VALUES
('Winterfell', 'The North', 'Westeros');
-- house stark
INSERT INTO `got_house` (`name`, `status`) VALUES ('Stark', 'Great House');

-- characters Jon, Eddard, Hodor, Arya
INSERT INTO `got_characters` (`fname`, `lname`, `house_id`, `origin`, `weapon`, `species`, `status`, `organization`) VALUES
('Jon', 'Snow', 
 (select id from got_house where name = 'Stark'), 
 (select id from got_locations where name = 'Winterfell'), 
 'Longclaw', 'human', 'alive', 'Night\'s Watch'),
 
('Eddard', 'Stark', 
 (select id from got_house where name = 'Stark'), 
 (select id from got_locations where name = 'Winterfell'), 
 'Ice', 'human', 'dead', NULL),
 
('Hodor', NULL, NULL, NULL, NULL, 'human', 'dead', NULL),

('Arya', 'Stark', (select id from got_house where name = 'Stark'), 
 (select id from got_locations where name = 'Winterfell'),
 'Valyrian steel dagger', 'human', 'alive', NULL);
 
 -- battle of the bastards
INSERT INTO `got_events` (`name`, `location`, `episode`, `season`, `summary`) VALUES
('Battle of the Bastards', (select id from got_locations where name = 'Winterfell'), 9, 6, 'The Battle of the Bastards is a battle late in the War of the Five Kings in which Jon Snow and Sansa Stark retake Winterfell from Lord Ramsay Bolton, the Warden of the North, and restore House Stark as the ruling house of the North.');

 INSERT INTO `got_events_characters` (`event_id`, `character_id`) VALUES
((select id from `got_events` where name = 'Battle of the Bastards'),(select id from got_characters where fname = 'Jon'));

UPDATE `got_house` set head = (select id from `got_characters` where fname = 'Jon') where name = 'Stark';


ALTER TABLE `got_characters`
  ADD CONSTRAINT `got_characters_ibfk_1` FOREIGN KEY (`origin`) REFERENCES `got_locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `got_characters_ibfk_2` FOREIGN KEY (`house_id`) REFERENCES `got_house` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `got_events`
  ADD CONSTRAINT `got_events_ibfk_1` FOREIGN KEY (`location`) REFERENCES `got_locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `got_events_characters`
  ADD CONSTRAINT `got_events_characters_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `got_events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `got_events_characters_ibfk_2` FOREIGN KEY (`character_id`) REFERENCES `got_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `got_house`
  ADD CONSTRAINT `got_house_ibfk_1` FOREIGN KEY (`head`) REFERENCES `got_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
