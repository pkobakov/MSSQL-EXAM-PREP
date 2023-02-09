-- 1. Create Tables
CREATE TABLE Passengers
(
 Id INT PRIMARY KEY IDENTITY,
 FullName VARCHAR(100) UNIQUE NOT NULL,
 Email VARCHAR(50) UNIQUE NOT NULL,

)

CREATE TABLE Pilots
(
 Id INT PRIMARY KEY IDENTITY,
 FirstName VARCHAR(30)UNIQUE NOT NULL,
 LastName VARCHAR(30) UNIQUE NOT NULL,
 Age TINYINT NOT NULL CHECK(Age>=21 AND Age<=62),
 Rating FLOAT CHECK(Rating >= 0.0 and Rating <=10.0 )
)

CREATE TABLE AircraftTypes
(
 Id INT PRIMARY KEY IDENTITY,
 TypeName VARCHAR(30) UNIQUE NOT NULL,
)

CREATE TABLE AirCraft
(
 Id INT PRIMARY KEY IDENTITY,
 Manufacturer VARCHAR(25) NOT NULL,
 Model VARCHAR(30) NOT NULL,
 [Year] INT NOT NULL,
 FlightHours INT,
 Condition CHAR NOT NULL,
 TypeId INT NOT NULL FOREIGN KEY REFERENCES AircraftTypes(Id)
)

CREATE TABLE PilotsAircraft
(
 AircraftId INT NOT NULL FOREIGN KEY REFERENCES Aircraft(Id),
 PilotId INT NOT NULL FOREIGN KEY REFERENCES Pilots(Id),
 PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports
(
 Id INT PRIMARY KEY IDENTITY,
 AirportName VARCHAR(70) UNIQUE NOT NULL,
 Country VARCHAR(100)UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations
(
 Id INT PRIMARY KEY IDENTITY,
 AirportId INT NOT NULL FOREIGN KEY REFERENCES Airports(Id),
 Start DATETIME NOT NULL,
 AircraftId INT NOT NULL FOREIGN KEY REFERENCES Aircraft(Id),
 PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id),
 TicketPrice DECIMAL(18,2) NOT NULL DEFAULT 15 
)

-- 2. Insert

INSERT INTO Passengers(Id, FullName, Email)
SELECT CONCAT_WS(' ', p.FirstName, p.LastName) AS FullName, CONCAT(p.FirstName,p.LastName,'@gmail.com') 
AS Email 
FROM Pilots AS p 
WHERE p.Id BETWEEN 5 AND 15

-- 3. Update

UPDATE AirCraft
SET Condition = 'A'
WHERE Condition IN ('C','B') AND FlightHours BETWEEN NULL AND 100 AND YEAR([Year]) >= 2013

-- 4. Delete

DELETE FROM Passengers
WHERE LEN(FullName) >= 10

-- 5. Aircraft
SELECT Manufacturer, Model, FlightHours, Condition FROM AirCraft
ORDER BY FlightHours DESC

-- 6. Pilots and Aircraft

SELECT p.FirstName, p.LastName, a.Manufacturer, a.Model, a.FlightHours FROM Pilots AS p
JOIN PilotsAircraft AS pa
ON p.Id = pa.PilotId
JOIN AirCraft AS a
ON pa.AircraftId = a.Id
WHERE FlightHours < 304
ORDER BY a.FlightHours DESC, p.FirstName