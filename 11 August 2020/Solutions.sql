-- 1. Database Design

CREATE DATABASE Bakery

CREATE TABLE Countries
(
 Id INT IDENTITY PRIMARY KEY,
 Name NVARCHAR(50) UNIQUE
)

CREATE TABLE Customers
(
 Id INT IDENTITY PRIMARY KEY,
 FirstName NVARCHAR(25),
 LastName NVARCHAR(25),
 Gender CHAR CHECK(Gender IN('M', 'F')),
 Age INT,
 PhoneNumber VARCHAR(10) CHECK(LEN(PhoneNumber) = 10),
 CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Products
(
 Id INT IDENTITY PRIMARY KEY,
 Name NVARCHAR(25) UNIQUE,
 Description NVARCHAR(250),
 Recipe NVARCHAR(MAX),
 Price DECIMAL CHECK(Price>=0)
)

CREATE TABLE Feedbacks
(
 Id INT IDENTITY PRIMARY KEY,
 Description NVARCHAR(255),
 Rate DECIMAL (18,2) CHECK(Rate BETWEEN 0 AND 10),
 ProductId INT FOREIGN KEY REFERENCES Products(Id),
 CustomerId INT FOREIGN KEY REFERENCES Customers(Id)
)

CREATE TABLE Distributors
(
 Id INT IDENTITY PRIMARY KEY,
 Name NVARCHAR(25) UNIQUE,
 AddressText NVARCHAR(30),
 Summary NVARCHAR(200),
 CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Ingredients
(
 Id INT IDENTITY PRIMARY KEY,
 Name NVARCHAR(30),
 Description NVARCHAR(200),
 OriginCountryId INT FOREIGN KEY REFERENCES Countries(Id),
 DistributorId INT FOREIGN KEY REFERENCES Distributors(Id)
)

CREATE TABLE ProductsIngredients
(
 ProductId INT FOREIGN KEY REFERENCES Products(Id),
 IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id),
 PRIMARY KEY (ProductId, IngredientId)
)

-- 2. Insert

INSERT INTO Distributors (Name, CountryId, AddressText, Summary)
VALUES
('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')


INSERT INTO Customers(FirstName, LastName, Age, Gender, PhoneNumber, CountryId)
VALUES
('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
('Kendra', 'Loud', 22 , 'F', '0063631526', 11),
('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8),
('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
('Tom', 'Loeza', 31, 'M', '0144876096', 23),
('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
('Josefa', 'Opitz', 43, 'F', '0197887645', 17)

-- 3. Update

UPDATE Ingredients
SET DistributorId = 35
WHERE [Name] IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8

-- 4. Delete 

DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5

-- 5. Products by Price

SELECT [Name], Price, Description FROM Products
ORDER BY Price DESC,Name

-- 6. Negative Feedback

SELECT 
ProductId, 
Rate,
Description, 
CustomerId, 
Age, 
Gender
FROM Feedbacks AS f
JOIN Customers AS c
ON f.CustomerId = c.Id
WHERE Rate < 5.0
ORDER BY ProductId DESC, Rate

-- 7. Customers without Feedback

SELECT
CONCAT_WS(' ',c.FirstName, c.LastName) AS CustomerName,
c.PhoneNumber,
c.Gender 
FROM Customers AS c
LEFT JOIN Feedbacks AS f
ON c.Id = f.CustomerId
WHERE f.Id IS NULL
ORDER BY CustomerId

-- 8. Customers by Criteria

SELECT cus.FirstName,
cus.Age, 
cus.PhoneNumber 
FROM Customers AS cus
JOIN Countries AS con
ON cus.CountryId = con.Id
WHERE (cus.Age >= 21 AND cus.FirstName LIKE '%an%') OR
(cus.PhoneNumber LIKE '%38' AND con.Name <>'Greece')
ORDER BY cus.FirstName, cus.Age DESC

-- 9. Middle Range Distributors

SELECT 
d.Name AS DistributorName,
i.Name AS IngredientName, 
p.Name AS ProductName,
AVG(f.Rate) AS AverageRate
FROM Distributors AS d
JOIN Ingredients AS i
ON d.Id = i.DistributorId
JOIN ProductsIngredients AS [ip]
ON i.Id = [ip].IngredientId
JOIN Products AS p
ON [ip].ProductId = p.Id
JOIN Feedbacks AS f
ON p.Id = f.ProductId

GROUP BY 
d.Name,
i.Name, 
p.Name

HAVING AVG(f.Rate) BETWEEN 5 AND 8
ORDER BY 
d.Name,
i.Name, 
p.Name

-- 10. Country Representative

SELECT 
q.CountryName, 
q.DistributorName
             FROM
                (
                 SELECT 
                 co.Name AS CountryName,
                  d.Name AS DistributorName,
                 DENSE_RANK() OVER(PARTITION BY co.Name ORDER BY COUNT(i.Id) DESC) AS Ranking
                 FROM Countries AS co
                 JOIN Distributors AS d
                 ON co.Id = d.CountryId
                 LEFT JOIN Ingredients AS i
                 ON d.Id = i.DistributorId
                 GROUP BY co.Name, d.Name
		       ) AS q
WHERE q.Ranking = 1
ORDER BY q.CountryName, q.DistributorName

