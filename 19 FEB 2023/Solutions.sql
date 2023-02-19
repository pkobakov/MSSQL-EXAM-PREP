CREATE DATABASE Boardgames

-- 1. Database design
CREATE TABLE Categories
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
 Id INT IDENTITY PRIMARY KEY,
 StreetName NVARCHAR(100) NOT NULL,
 StreetNumber INT NOT NULL,
 Town VARCHAR(30) NOT NULL,
 Country VARCHAR(50) NOT NULL,
 ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(30)NOT NULL UNIQUE,
 AddressId INT FOREIGN KEY REFERENCES Addresses(Id),
 Website NVARCHAR(40) NOT NULL,
 Phone NVARCHAR(20) NOT NULL
)

CREATE TABLE PlayersRanges
(
 Id INT IDENTITY PRIMARY KEY,
 PlayersMin INT NOT NULL,
 PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames
(
 Id INT IDENTITY PRIMARY KEY,
 Name NVARCHAR(30) NOT NULL,
 YearPublished INT NOT NULL,
 Rating DECIMAL (18,2) NOT NULL,
 CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
 PublisherId INT NOT NULL FOREIGN KEY REFERENCES Publishers(Id),
 PlayersRangeId INT NOT NULL FOREIGN KEY REFERENCES PlayersRanges(Id)
)

CREATE TABLE Creators
(
 Id INT IDENTITY PRIMARY KEY,
 FirstName NVARCHAR(30) NOT NULL,
 LastName NVARCHAR(30) NOT NULL,
 Email NVARCHAR(30) NOT NULL
)

CREATE TABLE CreatorsBoardgames
(
 CreatorId INT NOT NULL FOREIGN KEY REFERENCES Creators(Id),
 BoardgameId INT NOT NULL FOREIGN KEY REFERENCES Boardgames(Id),
 PRIMARY KEY (CreatorId,  BoardgameId)
)

-- 2. INSERT

INSERT INTO Boardgames(Name, YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
VALUES
('Deep Blue', 2019, 5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7, 1, 5),
('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers(Name, AddressId, Website, Phone)
VALUES
('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

-- 3. UPDATE



UPDATE PlayersRanges
SET PlayersMax +=1
WHERE PlayersMax LIKE 2 AND PlayersMin LIKE 2


UPDATE Boardgames 
SET Name += 'V2'
WHERE YearPublished >= 2020

-- 4. DELETE

DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (SELECT Id FROM Boardgames WHERE PublisherId = 1)
 
DELETE FROM Boardgames
WHERE PublisherId IN (SELECT Id FROM Publishers WHERE AddressId = 5)
 
DELETE FROM Publishers
WHERE AddressId IN (SELECT Id FROM Addresses WHERE Town LIKE 'L%')
 
DELETE FROM Addresses
WHERE Town LIKE 'L%'





-- 5. Boardgames by Year of Publication
            
SELECT Name, Rating FROM Boardgames
ORDER BY YearPublished, Name DESC

-- 6. Boardgames by Category

SELECT B.Id, B.Name, B.YearPublished, C.Name AS CategoryName FROM Boardgames AS B
JOIN Categories AS C ON B.CategoryId = C.Id
WHERE c.Name IN ('Wargames',  'Strategy Games')
ORDER BY B.YearPublished DESC

-- 7. Creators without Boardgames

SELECT C.Id, CONCAT_WS(' ', C.FirstName, C.LastName) AS CreatorName, C.Email FROM Creators AS C
LEFT JOIN CreatorsBoardgames AS CB
ON CB.CreatorId = C.Id
LEFT JOIN Boardgames AS B
ON CB.BoardgameId = B.Id
WHERE B.Id IS NULL
ORDER BY C.FirstName

-- 8. First 5 Boardgames


SELECT TOP(5) 
B.Name, 
B.Rating,
C.Name AS CategoryName FROM Boardgames AS B
JOIN PlayersRanges AS PR ON B.PlayersRangeId = PR.Id
JOIN Categories AS C ON B.CategoryId = C.Id
WHERE (B.Rating > 7.00 AND B.Name LIKE '%a%') OR
(B.Rating > 7.50 AND PR.PlayersMin = 2 AND PR.PlayersMax = 5)
ORDER BY B.Name, B.Rating DESC

-- 9. Creators with Emails

SELECT 
      CONCAT_WS(' ', c.FirstName, c.LastName) AS FullName , 
      c.Email AS Email,
	  MAX(b.Rating) AS Rating
                             FROM 
                             Creators AS C
                             JOIN CreatorsBoardgames AS CB ON C.Id = CB.CreatorId
                             JOIN Boardgames AS B ON CB.BoardgameId = B.Id
                             WHERE C.Email LIKE '%.com'
GROUP BY c.FirstName, c.LastName, c.Email
ORDER BY c.FirstName








-- 10. Creators by Rating

SELECT 
	C.LastName, 
    CEILING(AVG(B.Rating)) AS Rating,
	P.Name AS PublisherName 
       FROM Creators AS C
       LEFT JOIN CreatorsBoardgames AS CB ON C.Id = CB.CreatorId
       LEFT JOIN Boardgames AS B ON CB.BoardgameId = B.Id
       LEFT JOIN Publishers AS P ON B.PublisherId = P.Id
       WHERE CB.BoardgameId IS NOT NULL AND P.Name LIKE 'Stonemaier Games'
       GROUP BY C.LastName, P.Name
	   ORDER BY AVG(B.Rating) DESC


-- 11.	Creator with Boardgames

CREATE FUNCTION udf_CreatorWithBoardgames(@name VARCHAR(30)) 
RETURNS INT 
        AS
		BEGIN
		      
			        DECLARE @result INT = (
			                        SELECT COUNT(B.Id) FROM Creators AS C
									JOIN CreatorsBoardgames AS CB
									ON C.Id = CB.CreatorId
									JOIN Boardgames AS B
									ON CB.BoardgameId = B.Id
									WHERE C.FirstName LIKE @name
			                       )
                 RETURN @result
		END 


-- 12. Search for Boardgame with Specific Category

CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(50)) 
AS 
BEGIN 
    
	SELECT 
	B.Name, 
	B.YearPublished, 
	B.Rating, 
	C.Name,
	P.Name,
	CONCAT_WS(' ',PR.PlayersMin, 'people') AS MinPlayres,
	CONCAT_WS(' ',PR.PlayersMax, 'people') AS MaxPlayers
	FROM Boardgames AS B
	JOIN Publishers AS P ON B.PublisherId = P.Id
	JOIN PlayersRanges AS PR ON B.PlayersRangeId = PR.Id 
	JOIN Categories AS C ON B.CategoryId = C.Id
	WHERE C.Name LIKE @category
	ORDER BY P.Name, B.YearPublished DESC

END



