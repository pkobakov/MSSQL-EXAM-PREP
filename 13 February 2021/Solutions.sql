CREATE DATABASE Bitbucket

CREATE TABLE Users
(
 Id INT IDENTITY PRIMARY KEY,
 Username VARCHAR(30) NOT NULL,
 Password VARCHAR(30) NOT NULL,
 Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors
(
 RepositoryId INT NOT NULL FOREIGN KEY REFERENCES Repositories(Id),
 ContributorId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
 PRIMARY KEY (RepositoryId, ContributorId)
)

CREATE TABLE Issues
(
 Id INT IDENTITY PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 IssueStatus CHAR(6) NOT NULL,
 RepositoryId INT NOT NULL FOREIGN KEY REFERENCES Repositories(Id),
 AssigneeId INT NOT NULL FOREIGN KEY REFERENCES Users(Id)
 )

CREATE TABLE Commits
(
 Id INT IDENTITY PRIMARY KEY,
 Message VARCHAR(255) NOT NULL,
 IssueId INT FOREIGN KEY REFERENCES Issues(Id),
 RepositoryId INT NOT NULL FOREIGN KEY REFERENCES Repositories(Id),
 ContributorId INT NOT NULL FOREIGN KEY REFERENCES Users(Id)
)

CREATE TABLE Files
(
 Id INT IDENTITY PRIMARY KEY,
 Name VARCHAR(100) NOT NULL,
 Size DECIMAL(7,2) NOT NULL,
 ParentId INT FOREIGN KEY REFERENCES Files(Id),
 CommitId INT NOT NULL FOREIGN KEY REFERENCES Commits(Id)
)

-- 2. Insert

INSERT INTO Files (Name, Size, ParentId, CommitId) VALUES
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues (Title, IssueStatus, RepositoryId, AssigneeId) VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)

-- 3. Update

UPDATE Issues
SET IssueStatus = 'closed'
WHERE AssigneeId LIKE 6

-- 4. Delete

DELETE FROM RepositoriesContributors
WHERE RepositoryId = 
(SELECT Id FROM Repositories
 WHERE Name LIKE 'Softuni-Teamwork' )

DELETE FROM Issues WHERE RepositoryId = 
(SELECT Id FROM Repositories
 WHERE Name LIKE 'Softuni-Teamwork' )

-- 5. Commits

SELECT 
Id,
Message, 
RepositoryId, 
ContributorId FROM Commits
ORDER BY 
Id,
Message, 
RepositoryId, 
ContributorId

-- 6. Front-end

SELECT Id, Name, Size FROM Files
WHERE Size > 1000 AND Name LIKE '%html%'
ORDER BY Size DESC, Id, Name
