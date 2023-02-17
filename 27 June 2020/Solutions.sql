-- 1. Database Design

-- CREATE DATABASE WMS

CREATE TABLE Clients
(
 ClientId INT IDENTITY PRIMARY KEY,
 FirstName NVARCHAR(50) NOT NULL,
 LastName NVARCHAR(50) NOT NULL,
 Phone VARCHAR(12) NOT NULL CHECK(LEN(Phone) = 12)
)

CREATE TABLE Mechanics
(
 MechanicId INT IDENTITY PRIMARY KEY,
 FirstName NVARCHAR(50) NOT NULL,
 LastName NVARCHAR(50) NOT NULL,
 Address NVARCHAR(255) NOT NULL
)

CREATE TABLE Models
(
  ModelId INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Jobs
(
 JobId INT IDENTITY PRIMARY KEY,
 ModelId INT NOT NULL FOREIGN KEY REFERENCES Models(ModelId),
 [Status] NVARCHAR(11) NOT NULL CHECK([Status] IN('Pending', 'In Progress', 'Finished')) DEFAULT 'Pending',
 ClientId INT  NOT NULL FOREIGN KEY REFERENCES Clients(ClientId),
 MechanicId INT NOT NULL FOREIGN KEY REFERENCES Mechanics(MechanicId),
 IssueDate DATE NOT NULL,
 FinishDate DATE 
)

CREATE TABLE Orders
(
 OrderId INT IDENTITY PRIMARY KEY,
 JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs(JobId),
 IssueDate DATE,
 Delivered BIT NOT NULL DEFAULT 0
)

 CREATE TABLE Vendors
 (
  VendorId INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(50) NOT NULL UNIQUE
 )

 CREATE TABLE Parts
 (
  PartId INT IDENTITY PRIMARY KEY,
  SerialNumber NVARCHAR(50) NOT NULL UNIQUE,
  Description NVARCHAR(255),
  Price DECIMAL (18,2) NOT NULL CHECK(Price > 0) DEFAULT 0,
  VendorId INT NOT NULL FOREIGN KEY REFERENCES Vendors(VendorId),
  StockQty INT NOT NULL CHECK(StockQty > 0) DEFAULT 0
 )

 CREATE TABLE OrderParts 
 (
  OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderId), 
  PartId INT NOT NULL FOREIGN KEY REFERENCES Parts(PartId),
  Quantity INT NOT NULL CHECK(Quantity > 0) DEFAULT 1,
  PRIMARY KEY (OrderId, PartId)
 )

 CREATE TABLE PartsNeeded
 (
  JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs(JobId), 
  PartId INT NOT NULL FOREIGN KEY REFERENCES Parts(PartId),
  Quantity INT NOT NULL CHECK(Quantity > 0) DEFAULT 1,
  PRIMARY KEY (JobId ,partId)
 )

 -- 2. Insert

 INSERT INTO Clients (FirstName, LastName, Phone)
 VALUES
 ('Teri', 'Ennaco', '570-889-5187'),
 ('Merlyn', 'Lawler', '201-588-7810'),
 ('Georgene', 'Montezuma', '925-615-5185'),
 ('Jettie', 'Mconnell', '908-802-3564'),
 ('Lemuel', 'Latzke', '631-748-6479'),
 ('Melodie', 'Knipp', '805-690-1682'),
 ('Candida', 'Corbley', '908-275-8357')

INSERT INTO Parts (SerialNumber, Description, Price, VendorId)
VALUES
('WP8182119', 'Door Boot Seal', 117.86, 2),
('W10780048', 'Suspension Rod', 42.81, 1),
('W10841140', 'Silicone Adhesive', 6.77, 4),
('WPY055980', 'High Temperature Adhesive', 13.94, 3)
