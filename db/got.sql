create table got_characters(
	id INT PRIMARY KEY AUTO_INCREMENT, 
	fname varchar(30) NOT NULL, 
	lname varchar(30),
	house_id INT,
	origin INT,
	weapon varchar(30), 
	species enum('Human','White Walker', 'Giant', 'Children of the Forest') NOT NULL DEFAULT 1, 
	status enum('alive', 'dead', 'wight') NOT NULL DEFAULT 'alive', 
	organization varchar(60),
	FOREIGN KEY (origin)  REFERENCES got_locations (id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (house_id) REFERENCES got_house (id) ON DELETE CASCADE ON UPDATE CASCADE,
); 
create table got_locations(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name varchar(60) not null, 
	region varchar(60) not null, 
	continent enum('Westeros', 'Essos', 'Sothoryos') not null
);

create table got_house(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name varchar(60) not null,
	status enum('Great House', 'Vassal', 'Extinct') NOT NULL, 
	head INT, 
	FOREIGN KEY (head) REFERENCES got_characters (id) ON DELETE CASCADE ON UPDATE CASCADE
);

create table got_major_plot(
	name varchar(60)
	location INT,
	FOREIGN KEY (location) REFERENCES got_locations (id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO got_locations (name, region, continent) VALUES ('Winterfell', 'The North', 1);
INSERT INTO got_characters (name, weapon, organization) VALUES ('Jon Snow', 'Longclaw', 'Night\'s Watch');
update got_characters set origin = (select id from got_locations where name = 'Winterfell') where id = 1;


-- adding House Stark to house entity with current_head = jon snow using query
insert into got_house (name, status, current_head) values ('Stark', 1, (select id from got_characters where name = 'Jon Snow'));

-- updating jon snow house from null to Stark House id using query.
update got_characters set house_id = (select id from got_house where name = 'Stark') where id = 0;

-- adding foreign key constraint to existing table. 
ALTER TABLE got_characters ADD CONSTRAINT `got_characters_ibfk_2` FOREIGN KEY (`house_id`) REFERENCES `got_house` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
