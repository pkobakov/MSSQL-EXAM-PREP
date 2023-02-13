CREATE DATABASE TripService

CREATE TABLE Cities
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name NVARCHAR(20) NOT NULL,
 CountryCode CHAR(2) NOT NULL
)


CREATE TABLE Hotels
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name NVARCHAR(20) NOT NULL,
 CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
 EmployeeCount INT NOT NULL,
 BaseRate DECIMAL (7,2)
)

CREATE TABLE Rooms
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Price DECIMAL (18,2) NOT NULL,
 Type NVARCHAR(20) NOT NULL,
 Beds INT NOT NULL,
 HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id)
)

CREATE TABLE Trips
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id),
 BookDate DATE NOT NULL,
 ArrivalDate DATE NOT NULL,
 ReturnDate DATE NOT NULL,
 CancelDate DATE,
 CONSTRAINT Book_date CHECK(BookDate<ArrivalDate),
 CONSTRAINT Arrival_date CHECK(ArrivalDate<ReturnDate)
)

CREATE TABLE Accounts
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 FirstName NVARCHAR(50) NOT NULL,
 MiddleName NVARCHAR(20),
 LastName NVARCHAR(50) NOT NULL,
 CityId INT NOT NULL FOREIGN KEY REFERENCES Cities(Id),
 BirthDate DATE NOT NULL,
 Email NVARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE AccountsTrips
(
 AccountId INT NOT NULL FOREIGN KEY REFERENCES Accounts(Id),
 TripId INT NOT NULL FOREIGN KEY REFERENCES Trips(Id),
 Luggage INT NOT NULL CHECK(Luggage>=0),
 PRIMARY KEY (TripId, AccountId)
)

-- 2. Insert

INSERT INTO Accounts (FirstName, MiddleName, LastName, CityId, BirthDate, Email) 
VALUES
('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg')

INSERT INTO Trips (RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate) 
VALUES
(101, '2015-04-12','2015-04-14','2015-04-20', '2015-02-02'),
(102, '2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103, '2013-07-17','2013-07-23','2013-07-24',NULL),
(104, '2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109, '2017-08-07','2017-08-28','2017-08-29', NULL)

-- 3. Update

UPDATE Rooms
SET Price *= 1.14
WHERE HotelId IN(5,7,9)

-- 4. Delete

DELETE FROM AccountsTrips
WHERE AccountId = 47

-- 5. EEE-Mails

SELECT 
FirstName, 
LastName, 
FORMAT(BirthDate, 'MM-dd-yyyy'),
c.Name AS HomeTown,
Email FROM Accounts AS a
JOIN Cities AS c
ON a.CityId = c.Id
WHERE Email LIKE 'e%'
ORDER BY c.Name

-- 6. City Statistics

SELECT c.Name, COUNT(h.Id) AS Hotels FROM Cities AS c
JOIN Hotels AS h
ON c.Id = h.CityId
GROUP BY c.Name
ORDER BY COUNT(h.Id) DESC, c.Name 


-- 7. Longest and Shortest Trips

SELECT a.Id AS AccounttId, CONCAT_WS(' ', a.FirstName, a.LastName) AS FullName,
MAX(DATEDIFF(DAY,tr.ArrivalDate, tr.ReturnDate)) AS LongestTrip,
MIN(DATEDIFF(DAY,tr.ArrivalDate, tr.ReturnDate)) AS ShortestTrip
FROM Trips AS tr
JOIN AccountsTrips AS [at]
ON tr.Id = [at].TripId
JOIN Accounts AS a
ON [at].AccountId = a.Id
WHERE a.MiddleName IS NULL
GROUP BY a.Id,
CONCAT_WS(' ', a.FirstName, a.LastName)
ORDER BY LongestTrip DESC,
ShortestTrip

-- 8. Metropolis

SELECT TOP(10) c.Id, c.Name AS City, c.CountryCode AS Country, COUNT(aa.Id) AS Accounts  FROM Cities AS c
JOIN Accounts AS aa
ON c.Id = aa.CityId
GROUP BY c.Id, c.Name,C.CountryCode
ORDER BY Accounts DESC


-- 9. Romantic Getaways

SELECT acc.Id AS Id, acc.Email AS Email, c.Name AS City, COUNT(t.Id) AS Trips 
FROM Accounts AS acc
JOIN AccountsTrips AS ac
ON acc.Id = ac.AccountId
JOIN Trips AS t
ON ac.TripId = t.Id
JOIN Rooms AS r
ON t.RoomId = r.Id
JOIN Hotels AS h
ON r.HotelId = h.Id
JOIN Cities AS c
ON h.CityId = c.Id
WHERE h.CityId = acc.CityId
GROUP BY acc.Id, acc.Email, c.Name
ORDER BY COUNT(t.Id) DESC, acc.Id




