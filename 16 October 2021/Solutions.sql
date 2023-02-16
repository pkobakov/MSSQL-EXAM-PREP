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

