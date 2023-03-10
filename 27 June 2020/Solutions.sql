---- 1. Database Design

--CREATE DATABASE WMS

-- Judge result 30/30

--CREATE TABLE Clients
--(
-- ClientId INT IDENTITY PRIMARY KEY,
-- FirstName NVARCHAR(50) NOT NULL,
-- LastName NVARCHAR(50) NOT NULL,
-- Phone VARCHAR(12) NOT NULL CHECK(LEN(Phone) = 12)
--)

--CREATE TABLE Mechanics
--(
-- MechanicId INT IDENTITY PRIMARY KEY,
-- FirstName NVARCHAR(50) NOT NULL,
-- LastName NVARCHAR(50) NOT NULL,
-- Address NVARCHAR(255) NOT NULL
--)

--CREATE TABLE Models
--(
--  ModelId INT IDENTITY PRIMARY KEY,
--  Name NVARCHAR(50) NOT NULL UNIQUE
--)

--CREATE TABLE Jobs
--(
-- JobId INT IDENTITY PRIMARY KEY,
-- ModelId INT NOT NULL FOREIGN KEY REFERENCES Models(ModelId),
-- [Status] NVARCHAR(11) NOT NULL CHECK([Status] IN('Pending', 'In Progress', 'Finished')) DEFAULT 'Pending',
-- ClientId INT  NOT NULL FOREIGN KEY REFERENCES Clients(ClientId),
-- MechanicId INT NOT NULL FOREIGN KEY REFERENCES Mechanics(MechanicId),
-- IssueDate DATE NOT NULL,
-- FinishDate DATE 
--)

--CREATE TABLE Orders
--(
-- OrderId INT IDENTITY PRIMARY KEY,
-- JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs(JobId),
-- IssueDate DATE,
-- Delivered BIT NOT NULL DEFAULT 0
--)

-- CREATE TABLE Vendors
-- (
--  VendorId INT IDENTITY PRIMARY KEY,
--  Name NVARCHAR(50) NOT NULL UNIQUE
-- )

-- CREATE TABLE Parts
-- (
--  PartId INT IDENTITY PRIMARY KEY,
--  SerialNumber NVARCHAR(50) NOT NULL UNIQUE,
--  Description NVARCHAR(255),
--  Price DECIMAL (18,2) NOT NULL CHECK(Price > 0) DEFAULT 0,
--  VendorId INT NOT NULL FOREIGN KEY REFERENCES Vendors(VendorId),
--  StockQty INT NOT NULL CHECK(StockQty > 0) DEFAULT 0
-- )

-- CREATE TABLE OrderParts 
-- (
--  OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderId), 
--  PartId INT NOT NULL FOREIGN KEY REFERENCES Parts(PartId),
--  Quantity INT NOT NULL CHECK(Quantity > 0) DEFAULT 1,
--  PRIMARY KEY (OrderId, PartId)
-- )

-- CREATE TABLE PartsNeeded
-- (
--  JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs(JobId), 
--  PartId INT NOT NULL FOREIGN KEY REFERENCES Parts(PartId),
--  Quantity INT NOT NULL CHECK(Quantity > 0) DEFAULT 1,
--  PRIMARY KEY (JobId ,partId)
-- )


-- Dataset friendly 

--CREATE TABLE Clients
--(
-- ClientId INT IDENTITY PRIMARY KEY,
-- FirstName NVARCHAR(50) NOT NULL,
-- LastName NVARCHAR(50) NOT NULL,
-- Phone VARCHAR(12) NOT NULL CHECK(LEN(Phone) = 12)
--)

--CREATE TABLE Mechanics
--(
-- MechanicId INT IDENTITY PRIMARY KEY,
-- FirstName NVARCHAR(50) NOT NULL,
-- LastName NVARCHAR(50) NOT NULL,
-- Address NVARCHAR(255) NOT NULL
--)

--CREATE TABLE Models
--(
--  ModelId INT IDENTITY PRIMARY KEY,
--  Name NVARCHAR(50) NOT NULL UNIQUE
--)

--CREATE TABLE Jobs
--(
-- JobId INT IDENTITY PRIMARY KEY,
-- ModelId INT NOT NULL FOREIGN KEY REFERENCES Models(ModelId),
-- [Status] NVARCHAR(11) NOT NULL CHECK([Status] IN('Pending', 'In Progress', 'Finished')) DEFAULT 'Pending',
-- ClientId INT  NOT NULL FOREIGN KEY REFERENCES Clients(ClientId),
-- MechanicId INT FOREIGN KEY REFERENCES Mechanics(MechanicId),
-- IssueDate DATE NOT NULL,
-- FinishDate DATE 
--)

--CREATE TABLE Orders
--(
-- OrderId INT IDENTITY PRIMARY KEY,
-- JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs(JobId),
-- IssueDate DATE,
-- Delivered BIT NOT NULL DEFAULT 0
--)

-- CREATE TABLE Vendors
-- (
--  VendorId INT IDENTITY PRIMARY KEY,
--  Name NVARCHAR(50) NOT NULL UNIQUE
-- )

-- CREATE TABLE Parts
-- (
--  PartId INT IDENTITY PRIMARY KEY,
--  SerialNumber NVARCHAR(50) NOT NULL UNIQUE,
--  Description NVARCHAR(255),
--  Price DECIMAL (18,2) NOT NULL CHECK(Price > 0) DEFAULT 0,
--  VendorId INT NOT NULL FOREIGN KEY REFERENCES Vendors(VendorId),
--  StockQty INT NOT NULL CHECK(StockQty >= 0) DEFAULT 0
-- )

-- CREATE TABLE OrderParts 
-- (
--  OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderId), 
--  PartId INT NOT NULL FOREIGN KEY REFERENCES Parts(PartId),
--  Quantity INT NOT NULL CHECK(Quantity > 0) DEFAULT 1,
--  PRIMARY KEY (OrderId, PartId)
-- )

-- CREATE TABLE PartsNeeded
-- (
--  JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs(JobId), 
--  PartId INT NOT NULL FOREIGN KEY REFERENCES Parts(PartId),
--  Quantity INT NOT NULL CHECK(Quantity > 0) DEFAULT 1,
--  PRIMARY KEY (JobId ,PartId)
-- )

-- -- 2. Insert

-- INSERT INTO Clients (FirstName, LastName, Phone)
-- VALUES
-- ('Teri', 'Ennaco', '570-889-5187'),
-- ('Merlyn', 'Lawler', '201-588-7810'),
-- ('Georgene', 'Montezuma', '925-615-5185'),
-- ('Jettie', 'Mconnell', '908-802-3564'),
-- ('Lemuel', 'Latzke', '631-748-6479'),
-- ('Melodie', 'Knipp', '805-690-1682'),
-- ('Candida', 'Corbley', '908-275-8357')

--INSERT INTO Parts (SerialNumber, Description, Price, VendorId)
--VALUES
--('WP8182119', 'Door Boot Seal', 117.86, 2),
--('W10780048', 'Suspension Rod', 42.81, 1),
--('W10841140', 'Silicone Adhesive', 6.77, 4),
--('WPY055980', 'High Temperature Adhesive', 13.94, 3)

---- 3. Update

--SELECT LastName, MechanicId FROM Mechanics
--WHERE LastName LIKE 'Har%'

--UPDATE Jobs
--SET MechanicId = 3, Status = 'In Progress'
--WHERE Status LIKE 'Pending'

---- 4. Delete

--DELETE FROM OrderParts
--WHERE OrderId LIKE 19

--DELETE FROM Orders
--WHERE OrderId LIKE 19


---- 5. Mechanics Assignments

--SELECT
--CONCAT_WS(' ', m.FirstName, m.LastName) AS Mechanic,
--j.Status,
--j.IssueDate
--FROM Mechanics AS m
--JOIN Jobs AS j
--ON m.MechanicId = j.MechanicId
--ORDER BY 
--m.MechanicId, 
--j.IssueDate,
--j.JobId

---- 6. Current Clients

--SELECT 
--CONCAT_WS(' ', c.FirstName, C.LastName) AS Client,
--DATEDIFF(DAY, j.IssueDate, '2017-04-24' ) AS [Days going],
--j.Status
--FROM Clients AS c
--JOIN Jobs AS j
--ON c.ClientId = j.ClientId
--WHERE j.Status <> 'Finished'
--ORDER BY [Days going] DESC, c.ClientId

---- 7. Mechanic Performance

--SELECT
--CONCAT_WS(' ', m.FirstName, m.LastName) AS Mechanic,
--AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)) AS [Average daays]
--FROM Mechanics AS m
--JOIN Jobs AS j
--ON m.MechanicId = j.MechanicId
--GROUP BY m.MechanicId, m.FirstName, m.LastName
--ORDER BY m.MechanicId


---- 8. Available Mechanics

--SELECT 
--CONCAT_WS(' ', m.FirstName, m.LastName) AS Available
--FROM Mechanics AS m
--LEFT JOIN Jobs AS j
--ON m.MechanicId = J.MechanicId
--WHERE (
--       SELECT COUNT(JobId) FROM Jobs
--	   WHERE Status <> 'Finished' 
--	   AND m.MechanicId = MechanicId
--	   GROUP BY  MechanicId, Status
--      ) IS NULL OR j.JobId IS NULL
--GROUP BY m.MechanicId, m.FirstName, m.LastName
--ORDER BY m.MechanicId

---- 9. Past Expenses

--SELECT j.JobId, SUM(ISNULL(op.Quantity*p.Price,0)) AS Total FROM Jobs AS j
--LEFT JOIN Orders AS o
--ON j.JobId = o.JobId
--LEFT JOIN OrderParts AS op
--ON o.OrderId = op.OrderId
--LEFT JOIN Parts AS p
--ON op.PartId = p.PartId
--WHERE j.Status LIKE 'Finished'
--GROUP BY j.JobId
--ORDER BY Total DESC, j.JobId

---- 10. Missing Parts

--SELECT 
--p.PartId,
--p.Description, 
--pn.Quantity AS [Required],
--p.StockQty AS [In Stock],
--IIF(o.Delivered = 0, op.Quantity, 0) AS Ordered
--FROM Parts AS p
--LEFT JOIN PartsNeeded AS pn
--ON p.PartId = pn.PartId
--LEFT JOIN OrderParts AS op
--ON pn.PartId = op.PartId
--LEFT JOIN Jobs AS j
--ON pn.JobId = j.JobId
--LEFT JOIN Orders AS o
--ON j.JobId = o.JobId
--WHERE j.Status <> 'Finished' AND 
--p.StockQty + IIF(o.Delivered = 0, op.Quantity,0) < pn.Quantity 
--ORDER BY p.PartId



-- 11. Place Order

--CREATE PROCEDURE usp_PlaceOrder (@jobId INT, @serialNumber NVARCHAR(50), @quantity INT)
--              AS 
--			  BEGIN

--			     IF((SELECT Status FROM Jobs WHERE JobId LIKE @jobId) = 'Finished')
--				 THROW 50011, 'This job is not active!', 1
				 
--				 IF((SELECT StockQty FROM Parts WHERE SerialNumber LIKE @serialNumber) < 0)
--				 THROW 50012, 'Part quantity must be more than zero!', 1
			     
--				 IF ((SELECT JobId FROM Jobs WHERE JobId LIKE @jobId) IS NULL)
--				 THROW 50013, 'Job not found!', 1

--				 IF ((SELECT PartId FROM Parts WHERE SerialNumber LIKE @serialNumber ) IS NULL)
--			     THROW 50014, 'Part not found', 1


--				 IF((SELECT OrderId FROM Orders WHERE JobId LIKE @jobId AND IssueDate IS NULL) IS NULL)
--				 INSERT INTO Orders (JobId,IssueDate, Delivered) VALUES
--				 (@jobId, NULL, 0)

--				 DECLARE @partId INT = (
--                    				    SELECT PartId FROM Parts
--										WHERE SerialNumber LIKE @serialNumber 
--				                       )

--				 DECLARE @orderId INT = ( 
--				                         SELECT OrderId FROM Orders
--				                         WHERE JobId = @jobId AND IssueDate IS NULL
--										)
                 
--				 DECLARE @orderPartsQuantity INT =
--				                             (
--											  SELECT Quantity  FROM OrderParts
--                                              WHERE OrderId = @orderId  
--											  AND PartId = @partId
--											 )
               
--			     IF(@orderPartsQuantity IS NULL)
--				 INSERT INTO OrderParts (OrderId, PartId, Quantity) VALUES
--				 (@orderId, @partId, @quantity)

--				 ELSE 
--				 UPDATE OrderParts
--				 SET Quantity +=@quantity
--				 WHERE OrderId = @orderId AND PartId = @partId


			      
--			  END

-- 12. Cost of Order

CREATE FUNCTION udf_GetCost (@jobId INT)
         RETURNS DECIMAL(18,2)
		          AS
				  BEGIN
				       DECLARE @result DECIMAL(18,2) = (
					                                     SELECT SUM(op.Quantity * p.Price) 
														 FROM Jobs AS j
														 JOIN Orders AS o ON j.JobId = o.JobId
														 JOIN OrderParts AS op ON o.OrderId = op.OrderId
														 JOIN Parts AS p ON op.PartId = p.PartId
														 WHERE j.JobId LIKE @jobId
														 GROUP BY j.JobId
					                                   )
                       
						
						IF(@result IS NULL)	
						SET @result = 0	

					    RETURN @result

				  END




