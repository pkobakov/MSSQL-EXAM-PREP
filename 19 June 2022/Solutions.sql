CREATE DATABASE Zoo

-- 1. Database design
CREATE TABLE Owners 
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 PhoneNumber VARCHAR(15) NOT NULL,
 Address VARCHAR(50)
)

CREATE TABLE AnimalTypes
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name VARCHAR(30) NOT NULL,
 BirthDate Date NOT NULL,
 OwnerId INT FOREIGN KEY REFERENCES Owners(Id),
 AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id) 
)

CREATE TABLE AnimalsCages
(
 CageId INT NOT NULL  FOREIGN KEY REFERENCES Cages(Id),
 AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id),
 PRIMARY KEY (CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers
(
 Id INT NOT NULL IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL,
 PhoneNumber VARCHAR(15) NOT NULL,
 Address VARCHAR(50),
 AnimalId INT FOREIGN KEY REFERENCES Animals(Id),
 DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
)

-- 2. Insert

INSERT INTO Volunteers (Name, PhoneNumber, Address, AnimalId, DepartmentId) VALUES
('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO Animals(Name, BirthDate, OwnerId, AnimalTypeId) VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)

