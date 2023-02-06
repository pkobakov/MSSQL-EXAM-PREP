--CREATE DATABASE NationalTouristSitesOfBulgaria

CREATE TABLE Categories
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 Municipality VARCHAR(50),
 Province VARCHAR(50)
)

CREATE TABLE Sites
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(100) NOT NULL,
 LocationId INT NOT NULL FOREIGN KEY
 REFERENCES Locations(Id),
 CategoryId INT NOT NULL FOREIGN KEY
 REFERENCES Categories(Id),
 Establishment VARCHAR(15)
)

CREATE TABLE Tourists
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 Age INT NOT NULL CHECK(Age>=0 AND Age<=120),
 PhoneNumber VARCHAR(20) NOT NULL,
 Nationality VARCHAR(30) NOT NULL,
 Reward VARCHAR(20)
)

CREATE TABLE SitesTourists
(
 TouristId INT NOT NULL FOREIGN KEY
 REFERENCES Tourists(Id),
 SiteId INT NOT NULL FOREIGN KEY
 REFERENCES Sites(Id),
 PRIMARY KEY( TouristId, SiteId)
)

CREATE TABLE BonusPrizes
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
)

CREATE TABLE TouristsBonusPrizes
(
 TouristId INT NOT NULL FOREIGN KEY
 REFERENCES Tourists(Id),
 BonusPrizeId INT NOT NULL FOREIGN KEY
 REFERENCES BonusPrizes,
 PRIMARY KEY (TouristId, BonusPrizeId)
)

-- INSERT

INSERT INTO Tourists (Name, Age, PhoneNumber, Nationality, Reward) VALUES
('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
('Peter Bosh', 48, '+447911844141', 'UK', NULL),
('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO Sites (Name, LocationId, CategoryId, Establishment) VALUES
('Ustra fortress', 90, 7, 'X'),
('Karlanovo Pyramids', 65, 7, NULL),
('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
('Sinite Kamani Natural Park', 17, 1, NULL),
('St. Petka of Bulgaria – Rupite', 92, 6, '1994')

-- UPDATE

UPDATE Sites 
SET Establishment = '(not defined)'
WHERE Establishment IS NULL

-- DELETE

DELETE FROM BonusPrizes
WHERE Id = 5
DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId = 5

-- Tourists

SELECT Name, Age, PhoneNumber, Nationality FROM Tourists
ORDER BY Nationality, Age DESC, Name

-- Sites with Their Location and Category

SELECT s.Name AS Site, l.Name AS Location, s.Establishment, c.Name AS Category FROM Sites AS s
JOIN Locations AS l
ON s.LocationId = l.Id
JOIN Categories AS c 
ON s.CategoryId = c.Id
ORDER BY c.Name DESC, l.Name, s.Name

-- Count of Sites in Sofia Province
SELECT Id FROM Locations
WHERE Name like 'Sofia'

SELECT l.Province, l.Municipality, l.Name AS Location, COUNT(s.Id) AS CountOfSites  FROM Sites AS s 
JOIN Locations AS l 
ON s.LocationId = l.Id
WHERE l.Province LIKE 'Sofia'
GROUP BY l.Province, l.Municipality, l.Name
ORDER BY COUNT(s.Id) DESC, l.Name

-- Tourist Sites established BC


SELECT s.Name AS Site, l.Name AS Location,  l.Municipality, l.Province, s.Establishment AS CountOfSites  
FROM Sites AS s 
JOIN Locations AS l 
ON s.LocationId = l.Id
WHERE LEFT(l.Name,1) NOT LIKE '[B,M,D]' 
AND s.Establishment LIKE '%BC'
ORDER BY s.Name

-- Tourists with their Bonus Prizes

SELECT 
t.Name, 
Age, 
PhoneNumber, 
Nationality, 
CASE
WHEN b.Name IS NULL THEN '(no bonus prize)'
ELSE b.Name
END AS Reward
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tb
ON t.Id = tb.TouristId
LEFT JOIN BonusPrizes AS b
ON tb.BonusPrizeId = b.Id
ORDER BY t.Name

-- Tourists visiting History and Archaeology sites

SELECT 
SUBSTRING(t.Name,CHARINDEX(' ', t.Name), LEN(t.Name)) 
AS LastName, 
t.Nationality, 
t.Age,
t.PhoneNumber
FROM Tourists AS t
JOIN SitesTourists AS st
ON t.Id = st.TouristId
JOIN Sites AS s 
ON st.SiteId = s.Id
JOIN Categories AS c
ON s.CategoryId = c.Id
WHERE c.Name LIKE 'History and archaeology'
GROUP BY SUBSTRING(t.Name,CHARINDEX(' ', t.Name), LEN(t.Name)), t.Nationality, t.Age, t.PhoneNumber 
ORDER BY SUBSTRING(t.Name,CHARINDEX(' ', t.Name), LEN(t.Name)) 











