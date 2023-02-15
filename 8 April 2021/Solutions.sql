CREATE DATABASE Service

-- 1. Table Design


CREATE TABLE Users
(
 Id INT IDENTITY PRIMARY KEY,
 Username VARCHAR(30)NOT NULL UNIQUE,
 Password VARCHAR(50)NOT NULL,
 Name VARCHAR(50),
 Birthdate DATE,
 Age INT CHECK(Age BETWEEN 14 AND 110),
 Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL
)

CREATE TABLE Employees
(
 Id INT IDENTITY PRIMARY KEY,
 Firstname VARCHAR(25),
 Lastname VARCHAR(25),
 Birthdate DATE,
 Age INT CHECK(Age BETWEEN 18 AND 110),
 DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Categories
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Status
(
 Id INT IDENTITY PRIMARY KEY,
 Label VARCHAR(20) NOT NULL,
)

CREATE TABLE Reports
(
 Id INT IDENTITY PRIMARY KEY,
 CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
 StatusId INT NOT NULL FOREIGN KEY REFERENCES Status(Id),
 OpenDate DATE not null,
 CloseDate DATE,
 Description VARCHAR(200) NOT NULL,
 UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
 EmployeeId INT FOREIGN KEY REFERENCES Employees(Id)
)

-- 2. Insert

INSERT INTO Employees (Firstname, Lastname, Birthdate, DepartmentId)
VALUES
('Marlo', 'O''Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati','1959-07-20', 5)

INSERT INTO Reports (CategoryId, StatusId, OpenDate, CloseDate, Description, UserId, EmployeeId )
VALUES
(1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)

-- 3. Update

UPDATE Reports
SET CloseDate = GETDATE()
WHERE  CloseDate IS NULL

-- 4. Delete

DELETE FROM Reports
WHERE StatusId = 4

-- 5. Unassigned Reports

SELECT Description, FORMAT(r.OpenDate, 'dd-MM-yyyy') AS OpenDate 
FROM Reports AS r
WHERE EmployeeId IS NULL
ORDER BY r.OpenDate, Description

-- 6. Reports & Categories

SELECT r.Description, c.Name  FROM Reports AS r
JOIN Categories AS c
ON r.CategoryId = c.Id
WHERE CategoryId IS NOT NULL
ORDER BY Description, c.Name

-- 7. Most Reported Category

SELECT TOP(5) c.[Name] AS CategoryName, COUNT(r.Id) AS ReportsNumber 
FROM Categories AS c
JOIN Reports AS r
ON c.Id = r.CategoryId
GROUP BY c.[Name]
ORDER BY ReportsNumber DESC, CategoryName

-- 8. Birthday Report

SELECT u.Username,c.Name AS CategoryName FROM Reports AS r
JOIN Users AS u
ON r.UserId = u.Id
JOIN Categories AS c
ON r.CategoryId = c.Id
WHERE DAY(r.OpenDate) LIKE DAY(u.Birthdate)
ORDER BY u.Username, c.Name

-- 9. Users per Employee 

SELECT CONCAT_WS(' ', e.Firstname, e.Lastname) AS FullName,
COUNT(DISTINCT(u.Username)) AS UsersCount 
FROM Employees AS e
LEFT JOIN Reports AS r
ON e.Id = r.EmployeeId
LEFT JOIN Users AS u
ON r.UserId = u.Id
GROUP BY e.Firstname, e.Lastname
ORDER BY UsersCount DESC, FullName

-- 10. Full Info

SELECT
CASE
WHEN COALESCE(e.FirstName, e.LastName) IS NULL THEN 'None'
ELSE
CONCAT_WS(' ',e.Firstname, e.Lastname) END AS Employee, 
ISNULL(d.Name, 'None') AS Department,
ISNULL(c.Name, 'None') AS Category,
ISNULL(r.[Description], 'None') AS [Description],
ISNULL(FORMAT(r.OpenDate, 'dd.MM.yyyy'), 'None') AS OpenDate, 
ISNULL(s.Label, 'None') AS Status,
ISNULL(u.[Name], 'None') AS [User]
FROM Reports AS r
LEFT JOIN Employees AS e
ON r.EmployeeId = e.Id
LEFT JOIN Departments AS d
ON e.DepartmentId = d.Id
LEFT JOIN Categories AS c
ON  r.CategoryId = c.Id 
LEFT JOIN Status AS s
ON r.StatusId = s.Id
LEFT JOIN Users AS u
ON r.UserId = u.Id


ORDER BY 
e.Firstname DESC, 
e.Lastname DESC, 
d.Name, 
c.Name, 
r.Description, 
r.OpenDate, 
s.Label, 
u.Name


-- 11. Hours to Complete

CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME) 
       RETURNS INT
	            AS
		     BEGIN
			     DECLARE @totalHours INT = ISNULL(DATEDIFF(HOUR, @StartDate, @EndDate), 0)
                 RETURN @totalHours 
			   END
SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours FROM Reports

 