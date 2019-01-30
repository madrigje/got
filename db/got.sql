create table got_characters(
	id INT PRIMARY KEY AUTO_INCREMENT, 
	house_id INT ,
	origin INT,
	name varchar(30) NOT NULL, 
	weapon varchar(30), 
	species enum('human','White Walker', 'Giant', 'Children of the Forest') NOT NULL DEFAULT 'Human', 
	status enum('alive', 'dead', 'Wight') NOT NULL DEFAULT 'alive', 
	organization varchar(60),
	FOREIGN KEY (origin)  REFERENCES got_locations (id) ON DELETE CASCADE ON UPDATE CASCADE 

); 
create table got_locations(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name varchar(60) not null, 
	region varchar(60) not null, 
	continent enum('Westeros', 'Essos', 'Sothoryos') not null
);

INSERT INTO got_locations (name, region, continent) VALUES ('Winterfell', 'The North', 1);
INSERT INTO got_characters (name, weapon, organization) VALUES ('Jon Snow', 'Longclaw', 'Night\'s Watch');
update got_characters set origin = (select id from got_locations where name = 'Winterfell') where id = 1;
