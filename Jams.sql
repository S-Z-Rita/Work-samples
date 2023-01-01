-- Create database:

CREATE DATABASE jams;

-- Create tables:

DROP TABLE IF EXISTS fruits;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS jams;

CREATE TABLE fruits (
    id SERIAL PRIMARY KEY,
    fruit_name VARCHAR(20),
    homegrown BOOLEAN DEFAULT TRUE
);

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30)
);

CREATE TABLE jams (
    id SERIAL PRIMARY KEY,
    fruit_id INT,
    CONSTRAINT FK_jamsfruits
    FOREIGN KEY (fruit_id) REFERENCES fruits(id),
    people_id INT,
    quantity INT
);

-- Add a Foreign key constraint to an existing table:

ALTER TABLE jams ADD CONSTRAINT FK_jamspeople FOREIGN KEY (people_id) REFERENCES people(id);

-- Add a Date column to the People table with default value:

ALTER TABLE people ADD date DATE DEFAULT(now());

-- Add values for the columns of the table:

INSERT INTO fruits (fruit_name) VALUES ('strawberry'), ('raspberry'), ('blackberry'), ('blueberry'), ('orange');
INSERT INTO people (name) VALUES ('Mrs Smith'), ('Mr Black'), ('Mrs Wilson');
INSERT INTO jams (fruit_id, people_id, quantity) VALUES (1, 2, 16), (2, 1, 10), (3, 1, 12), (4, 2, 9), (5, 3, 23);

-- Get all columns from all the tables:

SELECT * FROM fruits;
SELECT * FROM people;
SELECT * FROM jams;

-- Join queries:

SELECT jams.fruit_id, jams.quantity, people.name FROM jams 
JOIN people ON jams.people_id = people.id;

SELECT fruits.fruit_name, jams.quantity, people.name FROM jams 
JOIN people ON jams.people_id = people.id 
JOIN fruits ON jams.fruit_id = fruits.id;

-- The person who made the most jams:

SELECT people.name, SUM(jams.quantity) AS Total FROM jams
JOIN people ON jams.people_id = people.id 
WHERE people.name = 'Mrs Smith'
GROUP BY people.name;

-- The person with ID=3 how many types of jams has made: 

SELECT jams.people_id, people.name, COUNT(jams.fruit_id) FROM jams
JOIN people ON jams.people_id = people.id
GROUP BY jams.people_id, people.name
HAVING people_id = 3;

SELECT people.name, COUNT(jams.fruit_id) FROM jams
JOIN people ON jams.people_id = people.id
GROUP BY people.name
HAVING name = 'Mrs Wilson';

SELECT people.name, COUNT(jams.fruit_id) FROM jams
JOIN people ON jams.people_id = people.id
WHERE people_id = 3
GROUP BY people.name;

-- People who made jams, in descending order:

SELECT people.name, SUM(jams.quantity) AS Quantity FROM jams
JOIN people ON jams.people_id = people.id
GROUP BY people.name
ORDER BY people.name ASC, quantity DESC;

-- This person made the most jams:

SELECT people.name, SUM(jams.quantity) AS Quantity FROM jams
JOIN people ON jams.people_id = people.id
GROUP BY people.name
ORDER BY people.name ASC, quantity DESC
LIMIT 1;