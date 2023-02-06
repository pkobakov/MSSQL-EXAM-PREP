CREATE DATABASE ColonialJourney
-- DATABASE DESIGN

CREATE TABLE Planets
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name VARCHAR(30) NOT NULL
)

CREATE TABLE Spaceports
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 PlanetId  INT NOT NULL FOREIGN KEY REFERENCES Planets(Id) 
)

CREATE TABLE Spaceships
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 Manufacturer VARCHAR(30) NOT NULL,
 LightSpeedRate INT DEFAULT 0
)

CREATE TABLE Colonists
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 FirstName VARCHAR(20) NOT NULL,
 LastName VARCHAR(20) NOT NULL,
 Ucn VARCHAR(10) UNIQUE NOT NULL,
 BirthDate DATE NOT NULL
)

CREATE TABLE Journeys
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 JourneyStart DATETIME NOT NULL,
 JourneyEnd DATETIME NOT NULL,
 Purpose NVARCHAR(11) CHECK (Purpose IN ('Medical', 'Technical', 'Educational', 'Military')),
 DestinationSpaceportId INT NOT NULL FOREIGN KEY REFERENCES Spaceports(Id),
 SpaceshipId INT NOT NULL FOREIGN KEY REFERENCES Spaceships(Id)
)

CREATE TABLE TravelCards
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 CardNumber VARCHAR(10) UNIQUE NOT NULL,
 JobDuringJourney VARCHAR(8) CHECK(JobDuringJourney IN('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
 ColonistId INT NOT NULL FOREIGN KEY REFERENCES Colonists(Id),
 JourneyId INT NOT NULL FOREIGN KEY REFERENCES Journeys(Id)
)

-- 2.INSERT

INSERT INTO Planets (Name) VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO Spaceships(Name, Manufacturer, LightSpeedRate) VALUES
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda', 4),
('Falcon9', 'SpaceX', 1),
('Bed', 'Vidolov', 6)


-- 3.UPDATE

UPDATE Spaceships
SET LightSpeedRate += 1
WHERE Id BETWEEN 8 AND 12

-- 4.DELETE

DELETE FROM TravelCards
WHERE JourneyId IN (1,2,3)
DELETE FROM Journeys
WHERE Id IN(1,2,3)
