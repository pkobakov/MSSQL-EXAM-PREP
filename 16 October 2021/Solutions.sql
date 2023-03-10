CREATE DATABASE CigarShop

CREATE TABLE Sizes
(
 Id INT IDENTITY PRIMARY KEY,
 [Length] INT NOT NULL CHECK([Length] BETWEEN 10 AND 25),
 RingRange DECIMAL (8,2) NOT NULL CHECK(RingRange BETWEEN 1.5 AND 7.5)
)

CREATE TABLE Tastes
(
 Id INT IDENTITY PRIMARY KEY,
 TasteType VARCHAR(20) NOT NULL,
 TasteStrength VARCHAR(15) NOT NULL,
 ImageURL VARCHAR(100) NOT NULL
)

CREATE TABLE Brands
(
 Id INT IDENTITY PRIMARY KEY,
 BrandName VARCHAR(30) UNIQUE NOT NULL,
 BrandDescription VARCHAR(MAX)
)

CREATE TABLE Cigars
(
 Id INT IDENTITY PRIMARY KEY,
 CigarName VARCHAR(80) NOT NULL,
 BrandId INT NOT NULL FOREIGN KEY REFERENCES Brands(Id),
 TastId INT NOT NULL FOREIGN KEY REFERENCES Tastes(Id),
 SizeId INT NOT NULL FOREIGN KEY REFERENCES Sizes(Id),
 PriceForSingleCigar DECIMAL NOT NULL,
 ImageURL VARCHAR(100) NOT NULL
)

CREATE TABLE Addresses
(
 Id INT IDENTITY PRIMARY KEY,
 Town VARCHAR(30) NOT NULL,
 Country VARCHAR(30) NOT NULL,
 Streat VARCHAR(100) NOT NULL,
 ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients
(
 Id INT IDENTITY PRIMARY KEY,
 FirstName VARCHAR(30) NOT NULL,
 LastName VARCHAR(30) NOT NULL,
 Email VARCHAR(50) NOT NULL,
 AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE ClientsCigars
(
 ClientId INT NOT NULL FOREIGN KEY REFERENCES Clients(Id),
 CigarId INT NOT NULL FOREIGN KEY REFERENCES Cigars(Id),
 PRIMARY KEY (ClientId, CigarId)
)

-- 2. Insert

INSERT INTO Cigars (CigarName, BrandId, TastId, SizeId,  PriceForSingleCigar, ImageURL)
VALUES
('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town, Country,Streat, ZIP)
VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', '1000'),
('Athens', 'Greece', '4342 McDonald Avenue', '10435'),
('Zagreb', 'Croatia', '4333 Lauren Drive', '10000')


-- 3. Update

UPDATE Cigars
SET PriceForSingleCigar *= 1.2
WHERE  TastId = 1
UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

-- 4. Delete

DELETE FROM ClientsCigars
DELETE FROM Clients
DELETE FROM Addresses
WHERE Country LIKE 'C%'


-- 5. Cigars by Price

SELECT CigarName, PriceForSingleCigar, ImageURL FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

-- 6. Cigars by Taste

SELECT c.Id, c.CigarName, c.PriceForSingleCigar, t.TasteType, t.TasteStrength FROM Cigars AS c
JOIN Tastes AS t
ON c.TastId = t.Id
WHERE t.TasteType IN('Earthy', 'Woody')
ORDER BY c.PriceForSingleCigar DESC


-- 7. Clients without Cigars

SELECT c.Id, CONCAT_WS(' ', c.FirstName, c.LastName) AS ClientName, c.Email FROM Clients AS c
LEFT JOIN ClientsCigars AS cc
ON c.Id = cc.ClientId
LEFT JOIN Cigars AS cig
ON cc.CigarId = cig.Id
WHERE cig.Id IS NULL
ORDER BY c.FirstName

-- 8. First 5 Cigars

SELECT TOP(5) c.CigarName, c.PriceForSingleCigar, c.ImageURL 
FROM Cigars AS c
JOIN Sizes AS s
ON c.SizeId = s.Id
WHERE 
s.Length >= 12 AND 
(c.CigarName LIKE '%ci%' OR
c.PriceForSingleCigar > 50) 
AND s.RingRange > 2.55
ORDER BY c.CigarName, 
c.PriceForSingleCigar DESC


-- 9. Clients with ZIP Codes

SELECT 
CONCAT_WS(' ', cl.FirstName, cl.LastName) AS FullName, 
a.Country, 
a.ZIP, 
CONCAT('$',MAX(cg.PriceForSingleCigar)) AS CigarPrice
FROM Addresses AS a
JOIN Clients AS cl
ON a.Id = cl.AddressId
JOIN ClientsCigars AS cc
ON cl.Id = cc.ClientId
JOIN Cigars AS cg
ON cc.CigarId = cg.Id
WHERE ISNUMERIC(ZIP) = 1 
GROUP BY CONCAT_WS(' ', cl.FirstName, cl.LastName), a.Country, a.ZIP
ORDER BY FullName


-- 10. Cigars by Size

SELECT 
cl.LastName, 
AVG(s.Length) AS CigarLength, 
CEILING(AVG(s.RingRange)) AS CigarRingRange
FROM Clients AS cl
JOIN ClientsCigars AS cc
ON cl.Id = cc.ClientId
JOIN Cigars AS cg
ON cc.CigarId = cg.Id
JOIN Sizes AS s
ON cg.SizeId = s.Id
WHERE cc.CigarId IS NOT NULL
GROUP BY cl.LastName
ORDER BY AVG(s.Length) DESC


-- 11. Client with Cigars

CREATE FUNCTION udf_ClientWithCigars(@name VARCHAR(30)) 
            RETURNS INT
			AS 
			BEGIN
			   RETURN 
			          (
					    SELECT COUNT(cg.Id) FROM Clients AS cl
						JOIN ClientsCigars AS cc
						ON cl.Id = cc.ClientId
						JOIN Cigars AS cg
						ON cc.CigarId = cg.Id
						WHERE cl.FirstName LIKE @name
			          )
			END



-- 12. Search for Cigar with Specific Taste

CREATE PROCEDURE usp_SearchByTaste(@taste VARCHAR(20))
              AS
			  BEGIN
			       SELECT c.CigarName, 
				   CONCAT('$',c.PriceForSingleCigar) AS Price,
				   t.TasteType,
				   b.BrandName, 
				   CONCAT_WS(' ', s.Length, 'cm') AS CigarLenght,
				   CONCAT_WS(' ',s.RingRange, 'cm') AS CigarRingRange
				   FROM Cigars AS c
				   JOIN Tastes AS t
				   ON c.TastId = t.Id
				   JOIN Sizes AS s
				   ON c.SizeId = s.Id
				   JOIN Brands AS b
				   ON c.BrandId = b.Id
				   WHERE t.TasteType LIKE @taste
				   ORDER BY CigarLenght, CigarRingRange DESC
			  END
