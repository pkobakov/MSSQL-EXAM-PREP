--CREATE DATABASE Zoo

---- 1. Database design
--CREATE TABLE Owners 
--(
-- Id INT NOT NULL IDENTITY PRIMARY KEY,
-- Name VARCHAR(50) NOT NULL,
-- PhoneNumber VARCHAR(15) NOT NULL,
-- Address VARCHAR(50)
--)

--CREATE TABLE AnimalTypes
--(
-- Id INT NOT NULL IDENTITY PRIMARY KEY,
-- AnimalType VARCHAR(30) NOT NULL
--)

--CREATE TABLE Cages
--(
-- Id INT NOT NULL IDENTITY PRIMARY KEY,
-- AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
--)

--CREATE TABLE Animals
--(
-- Id INT NOT NULL IDENTITY PRIMARY KEY,
-- Name VARCHAR(30) NOT NULL,
-- BirthDate Date NOT NULL,
-- OwnerId INT FOREIGN KEY REFERENCES Owners(Id),
-- AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id) 
--)

--CREATE TABLE AnimalsCages
--(
-- CageId INT NOT NULL  FOREIGN KEY REFERENCES Cages(Id),
-- AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id),
-- PRIMARY KEY (CageId, AnimalId)
--)

--CREATE TABLE VolunteersDepartments
--(
-- Id INT NOT NULL IDENTITY PRIMARY KEY,
-- DepartmentName VARCHAR(30) NOT NULL
--)

--CREATE TABLE Volunteers
--(
-- Id INT NOT NULL IDENTITY PRIMARY KEY,
-- Name VARCHAR(50) NOT NULL,
-- PhoneNumber VARCHAR(15) NOT NULL,
-- Address VARCHAR(50),
-- AnimalId INT FOREIGN KEY REFERENCES Animals(Id),
-- DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
--)

---- 2. Insert

--INSERT INTO Volunteers (Name, PhoneNumber, Address, AnimalId, DepartmentId) VALUES
--('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
--('Dimitur Stoev', '0877564223', NULL, 42, 4),
--('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
--('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
--('Boryana Mileva', '0888112233', NULL, 31, 5)

--INSERT INTO Animals(Name, BirthDate, OwnerId, AnimalTypeId) VALUES
--('Giraffe', '2018-09-21', 21, 1),
--('Harpy Eagle', '2015-04-17', 15, 3),
--('Hamadryas Baboon', '2017-11-02', NULL, 1),
--('Tuatara', '2021-06-30', 2, 4)

---- 3. Update

--SELECT * FROM Owners
--UPDATE Animals
--SET OwnerId = 4
--WHERE OwnerId IS NULL

---- 4.Delete

--SELECT * FROM VolunteersDepartments
--DELETE FROM Volunteers
--WHERE DepartmentId = 2
--DELETE FROM VolunteersDepartments
--WHERE Id = 2

---- 5. Volunteers

--SELECT 
--Name, 
--PhoneNumber, 
--Address, 
--AnimalId, 
--DepartmentId FROM Volunteers 
--ORDER BY Name, AnimalId, DepartmentId

---- 6. Animals data

--SELECT 
--a.Name, 
--t.AnimalType, 
--FORMAT(a.BirthDate, 'dd.MM.yyyy') AS BirthDate
--FROM Animals AS a
--JOIN AnimalTypes AS t
--ON a.AnimalTypeId = t.Id
--ORDER BY a.Name

---- 7.Owners and Their Animals

--SELECT TOP(5) o.Name AS Owner, COUNT(a.Id) AS CountofAnimals FROM Owners AS o
--JOIN Animals AS a
--ON o.Id = a.OwnerId
--GROUP BY o.Name
--ORDER BY COUNT(a.Id) DESC

---- 8. Owners, Animals and Cages

--SELECT CONCAT_WS('-', o.Name, a.Name) AS OwnersAnimals, o.PhoneNumber, AC.CageId FROM Owners AS o
--JOIN Animals AS a
--ON o.Id = a.OwnerId
--JOIN AnimalTypes AS t
--ON a.AnimalTypeId = t.Id
--JOIN AnimalsCages AS ac
--ON a.Id = ac.AnimalId
--WHERE t.Id = 1
--ORDER BY o.Name, a.Name DESC

---- 9. Volunteers in Sofia

--SELECT v.Name, v.PhoneNumber, SUBSTRING(Address, CHARINDEX(',', Address) + 2, LEN(Address)) FROM Volunteers AS v
--JOIN VolunteersDepartments AS vc
--ON v.DepartmentId = vc.Id
--WHERE vc.Id = 2 AND v.Address LIKE '%Sofia%'
--ORDER BY v.Name


---- 10.	Animals for Adoption

--SELECT a.Name, YEAR(a.BirthDate) AS BirthYear, t.AnimalType FROM Animals AS a
--JOIN AnimalTypes AS t
--ON a.AnimalTypeId = t.Id
--WHERE a.OwnerId IS NULL AND DATEDIFF(year, a.BirthDate, '01/01/22') < 5  AND a.AnimalTypeId NOT LIKE 3
--ORDER BY a.Name

-- 11. All Vounteers in a Department

--CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
--             RETURNS INT
--			 AS
--			 BEGIN
--			     RETURN (SELECT COUNT(v.Id) FROM Volunteers AS v
--				 JOIN VolunteersDepartments AS vd
--				 ON v.DepartmentId = vd.Id
--				 WHERE vd.DepartmentName = @VolunteersDepartment)
--			 END

 -- 12. Animals with Owner or Not

 CREATE PROCEDURE usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
               AS
			   BEGIN
			     IF(SELECT OwnerId FROM Animals WHERE Name LIKE @AnimalName) IS NULL
				 BEGIN
				        SELECT Name, 'For adoption' AS OwnerName FROM Animals 
						WHERE Name LIKE @AnimalName
				        
				   END
				 ELSE
				 BEGIN
				      SELECT a.Name, o.Name AS OwnerName FROM Animals AS a
				      JOIN Owners AS o
				      ON a.OwnerId = o.Id
				      WHERE a.Name LIKE @AnimalName
				 END
			END

EXEC dbo.usp_AnimalsWithOwnersOrNot 'Hippo'
				 
			   



 
