/* 
Targeted Foster Acadamy Project 

In this project I created database, Functions, Tables, Views, Triggers, Indexes, Constraints, Stored Procedures and used complex queries to retrive information.

	Targeted Foster Academy is a preschool, and work hard to develop children's characters for academic preparedness in order to help

prepare young children for future success in life. Targeted Foster serves families with Infants through Kindergartners and teach using

character and phonics based academic curriculum.

*/
DROP DATABASE TargetedFoster;
CREATE DATABASE TargetedFoster;
GO

USE TargetedFoster;
GO

CREATE TABLE Parent 

(PId INT NOT NULL,
FName VARCHAR (30) NOT NULL,
MI CHAR (1) NULL, 
lName VARCHAR (30) NOT NULL, 
DoB DATE NULL, 
SSN CHAR (11) UNIQUE NOT NULL,
StAddress VARCHAR (30) NOT NULL, 
AptNo VARCHAR (30) NOT NULL, 
City VARCHAR (30) NOT NULL, 
[State] CHAR (2) NOT NULL, 
ZipCode CHAR (5) NOT NULL, 
WorkPhone CHAR (14) NULL,
CellPhone CHAR (14) UNIQUE NOT NULL,
EmailAddress VARCHAR (30) NULL, 
SpousePId INT NULL, 
ReferredByPId INT NULL,
CONSTRAINT PK_Parent_table PRIMARY KEY(PId),
--SpouseId refers to a PId of a spouse in this table which leads to self referencing tables 
CONSTRAINT Fk_SelfRefer_Parent_table_Spouse FOREIGN KEY (SpousePID) REFERENCES Parent(PId),
CONSTRAINT Fk_SelfRefer_Parent_table_ReferedPId FOREIGN Key (ReferredbyPID) REFERENCES Parent(PId),
CONSTRAINT SSN_Parent CHECK (SSN LIKE '[0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][0-9][0-9]')
);
GO


--B. Alter and add more columns and constraints to the tables
--1) Add gender and citizenShip information (columns) to Parent table
ALTER TABLE Parent 
ADD Gender CHAR(1);
GO

 
ALTER TABLE Parent
ADD Citizenship VARCHAR (30);
GO

Create table Child
(	CId INT NOT NULL, 
	PID INT NOT NULL, 
	FName VARCHAR (30), 
	MI CHAR(1), 
	lName VARCHAR (30), 
	DoB DATE, 
	EnrolledDate DATE, 
	SpecialConsideration VARCHAR (50),
	CONSTRAINT Pk_Child_Table PRIMARY KEY (CId), 
	CONSTRAINT Fk_Child_Parent_Table FOREIGN KEY (PId) REFERENCES Parent(PId)
);
GO

--2) Add gender and initialHeight and initialWeight columns to the Child table
ALTER TABLE CHILD
ADD 
	Gender CHAR (1),
	InitialHeight INT,
	InitialWeight INT;
GO


CREATE TABLE Parenting
(CId INT NOT NULL, 
PId INT NOT NULL,
pOrGuardian CHAR(8) NOT NULL,
CONSTRAINT Fk_Child_Parenting_Table FOREIGN KEY (cId) REFERENCES child(cId))

;
GO
	--3) Add Check Constraint on the Parenting table to Check -- pOrGuardian column takes 'Mother', 'Father', 'Guardian' values only

ALTER TABLE Parenting
ADD CONSTRAINT Check_Child_pOrGuardian CHECK (pOrGuardian in('Mother', 'Father', 'Guardian'))
GO

CREATE TABLE Nanny
(	NId INT NOT NULL, 
	CId int not null,
	FName VARCHAR (30) NOT NULL, 
	lName VARCHAR (30) NOT NULL, 
	SSN CHAR (30) UNIQUE NOT NULL, 
	Gender CHAR (1) NULL, 
	CellPhone CHAR (14) UNIQUE NOT NULL, 
	StAddress VARCHAR (30) NULL, 
	AptNo INT NULL, 
	City VARCHAR (30) NULL, 
	[state] CHAR (2) NULL, 
	ZipCode CHAR (5) NULL, 
	HiredDate DATE NOT NULL,
	CONSTRAINT Pk_Nanny PRIMARY KEY (NId),
	CONSTRAINT Fk_Child_Nanny FOREIGN KEY (CId) REFERENCES Child(CId),
	CONSTRAINT SSN_Nanny CHECK (SSN LIKE '[0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][0-9][0-9]')
);
GO

--4) Add a highestEducationAchieved column to the Nanny table
ALTER TABLE Nanny
ADD HighestEducationAchieved VARCHAR (30);
GO
--5) Create a table called Training (tId, trainingName, trainingDate,trainingDescription,offeringOrganization, trainerFullName,certificationIssued)

CREATE TABLE Training
(TId INT NOT NULL,
TrainingName VARCHAR (30) NOT NULL,
TrainingDate VARCHAR(30) NOT NULL,
TrainingDescription VARCHAR (50) NOT NULL,
OfferingOrganization VARCHAR (50) NOT NULL,
TrainerFullName VARCHAR (30) NOT NULL,
CertificationIssued VARCHAR (30) NOT NULL,
 CONSTRAINT Pk_Training_Table PRIMARY KEY (TId),
 CONSTRAINT Fk_Child_Training_Table FOREIGN KEY (cId) REFERENCES child(cId))

);
GO

CREATE TABLE ChildDrop
(CId INT NOT NULL,
ArrivalTime TIME NOT NULL,
PId INT NOT NULL,
NId INT NOT NULL,
SpecialConditionNote TEXT,
 CONSTRAINT fk_ChildDrop_table FOREIGN KEY (CId) REFERENCES child(CId),
 CONSTRAINT Fk_ChildDrop_Table_Parent FOREIGN KEY (PId) REFERENCES Parent (PId),
CONSTRAINT Fk_ChildDrop_Table_Nanny FOREIGN KEY (NId) REFERENCES  Nanny(NId)
);
GO

ALTER TABLE ChildDrop
ADD CdId INT NOT NULL
GO

ALTER TABLE ChildDrop
ADD CONSTRAINT  Pk_ChildDrop_table primary key (CdId)
GO


 CREATE TABLE  ChildPickup
(	CId INT NOT NULL,
	PickupTime TIME NOT NULL,
	NId INT NOT NULL, 
	PId INT NOT NULL,
	SpecialNotes TEXT,
	CONSTRAINT Fk_ChildPickup_Table FOREIGN KEY (CId) REFERENCES child(CId),
	CONSTRAINT Fk_ChildPickup_Table_Parent FOREIGN KEY (PId) REFERENCES Parent (PId),
	CONSTRAINT Fk_ChildPickup_Table_Nanny FOREIGN KEY (NId) REFERENCES  Nanny(NId)
);
GO

ALTER TABLE ChildPickup
ADD CpId INT NOT NULL
GO

ALTER TABLE ChildPickup
ADD CONSTRAINT Pk_Childpickup_table PRIMARY KEY (CpId);
GO

CREATE TABLE NannyTraining 
( NId INT NOT NULL, 
	TrainingDate DATE, 
	TrainerFullName VARCHAR (30), 
	TrainerOrganizationName VARCHAR (30), 
	TrainingTopic VARCHAR (50), 
	CertificationIssued VARCHAR (30),
	CONSTRAINT Pk_NannyTraining PRIMARY KEY (NId)
);
GO

--6) Alter the NannyTraining table and drop all columns but nId. And add tId and define FK on it (relate it with Training Table you created above)

ALTER TABLE NannyTraining 
DROP COLUMN  TrainingDate, 
	TrainerFullName, 
	TrainerOrganizationName, 
	TrainingTopic, 
	CertificationIssued

ALTER TABLE NannyTraining
ADD TId INT ;
GO

ALTER TABLE NannyTraining
ADD	CONSTRAINT Fk_Training_Nannytraining FOREIGN KEY (TId) REFERENCES Training(tId)
GO

ALTER TABLE NannyTraining
ADD	CONSTRAINT Fk_Nanny_Nannytraining FOREIGN KEY (NId) REFERENCES Nanny(NId)
GO


 
--In order to drop the columns of NannyTraining, we first need to drop the constraints

ALTER TABLE NannyTraining 
DROP CONSTRAINT 
	Pk_NannyTraining, 
	Fk_Training_NannyTraining


ALTER TABLE NannyTraining 
DROP COLUMN 
	TId,
	TrainingDate, 
	TrainerFullName, 
	TrainerOrganizationName, 
	TrainingTopic, 
	CertificationIssued;
GO


CREATE TABLE Menu 
(	MId	INT NOT NULL, 
	[Name] VARCHAR (30) NOT NULL, 
	Calories INT NOT NULL,
	CONSTRAINT Pk_dMenu PRIMARY KEY (MId)
);
GO

--7) Alter the Menu table and add a column that holds whether the meal can cause any kind of allergy (allergyCausing - 'Yes' or 'No')
ALTER TABLE Menu
ADD AllergyCausing VARCHAR (3)
GO

ALTER TABLE Menu
ADD CONSTRAINT Food_Allergy Check (AllergyCausing in ('yes', 'No'))
GO

ALTER TABLE Menu
ADD CId INT
GO

ALTER TABLE Menu
ADD CONSTRAINT fk_Menu_ChildId FOREIGN KEY (CId) REFERENCES Child(CId) 
GO


CREATE TABLE Feeding
(
	CId INT  NOT NULL,
	MId INT NOT NULL,
	MealTime DATETIME NOT NULL,
	CONSTRAINT Pk_Feeding_CId_MId PRIMARY KEY (CId, MId),
	CONSTRAINT Fk_feeding_Table_child FOREIGN KEY (CId) REFERENCES Child(CID),
	CONSTRAINT Fk_feeding_Table_Menu FOREIGN KEY (MId) REFERENCES Menu (MId),
	
);
GO

--8) Alter the Feeding table and add a column that holds information about anything happened when the child was fed
ALTER TABLE Feeding
ADD ReactiontoFood VARCHAR (50) NOT NULL,
	 ChildPreference VARCHAR (30)NOT NULL;
GO

ALTER TABLE Feeding
ADD CONSTRAINT Fk_Menu_Feeding FOREIGN KEY (MId) REFERENCES Menu(MId);
GO

CREATE TABLE Activity
(	ActId INT NOT NULL,
	ActName VARCHAR (30) NOT NULL,
	ActDescritption VARCHAR (50) NOT NULL,
	CONSTRAINT Pk_activitytable PRIMARY KEY (ActId)
);
GO

CREATE TABLE ChildActivity
(	
	CID INT NOT NULL,
	ActId INT NOT NULL,
	NId INT NOT NULL,
	ActDate DATE,
	StartTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	CONSTRAINT Pr_ChildId_ActId_ChildActivity PRIMARY KEY (cID, ActId),
	CONSTRAINT Fk_ChildId_ChildActivity FOREIGN KEY (CId) REFERENCES Child (cID) ,
	CONSTRAINT Fk_ActId_ChildActivity FOREIGN KEY (ActId) REFERENCES Activity(ActId) 
);
GO


--9) Alter the ChildActivity table and add a column that holds information about anything that happened during the child activity session  - I have already added ActDate to record the date.
 

--10) **** This is new request .... add price to Menu table, every menu item should have corresponding price

ALTER TABLE Menu
ADD Price MONEY
GO
--11) **** This is a new request... Create a table called ChildAppraisal as follows:
-- ChildAppraisal (cId, appraisalDate, score, appraisalType). 
--Add check constraints to the above columns Score should be between 50 and 100
--appraisalType should be one of: motivation, cooperation, analytical and language

CREATE TABLE ChildAppraisal
(	CId INT NOT NULL,
	AppraisalDate DATE,
	Score INT NOT NULL,
	AppraisalType VARCHAR(30) NOT NULL,
CONSTRAINT Fk_Child_Appraisal FOREIGN KEY (CId) REFERENCES Child(CId)
);
GO

ALTER TABLE ChildAppraisal
ADD AppId INT NOT NULL;
GO

ALTER TABLE ChildAppraisal 
ADD CONSTRAINT Pk_Appraisal_Table PRIMARY KEY (AppId);
GO

ALTER TABLE ChildAppraisal 
ADD CONSTRAINT Ch_Score_ChildAppraisal CHECK (Score between 50 and 100);
GO

ALTER TABLE ChildAppraisal
ADD CONSTRAINT Ch_appraisalType_ChildAppraisal CHECK(appraisalType in ('motivation', 'cooperation', 'analytical', 'language'));
GO


--D. DML ********
--1) Add ten Parents; four couples and other two moms only (the two moms are not related to each other, so their spouseIds will be NULL)

SELECT * FROM
Parent,
Child,
Menu,
Nanny,
NannyTraining,
Parenting,
Training;


INSERT INTO Parent
VALUES
(1, 'Helen', 'T', 'Kebede', '1988-05-25', '908-34-3565', '13th st NW', 'Apt215', 'Arlington', 'VA', '20102',NULL, '(703) 323-4564',  'Helen@gmail.com', 8, 1,'F', 'USA'),
(2, 'Selam', 'D','Tesema', '1987-03-24', '905-24-3656', '17th S Glebe rd ', 'Apt152', 'Alexandaria', 'VA', '20210', '(703) 656-6412', '(703)548-9865', 'Selam@yahoo.com', NULL, 2,'F', 'USA'),
(3, 'Eden', 'D', 'Solomon', '1979-12-18', '923-10-2755', '16 Oak st', 'Apt454', 'Washington', 'DC', '20224', NULL, '(202) 546-9526', 'Eden@gmail.com', 6, 6,'F', 'USA'),
(4, 'Samuel', 'G', 'Mesfin', '1978-07-11', '900-42-6458', '30 New Hampshire', 'Apt456', 'Washington', 'DC', '20221', NULL, '(202) 656-7855', 'Samuel@gmail.com', NULL, 4,'M', 'USA'),
(5, 'Blen', 'H', 'Tesfaye', '1974-06-08', '927-53-9547', '17 Irving st', 'Apt457', 'Washington', 'DC', '20148',NULL, '(202) 001-2512', 'Blen@gmail.com',NULL, 5,'F','USA'),
(6, 'Elias', 'G', 'Solomon', '1978-04-26', '944-23-8901', '16 Oak St', 'Apt123', 'Washington', 'DC', '20220',  NULL, '(202) 234-2315', 'Elias@gmail.com', 3, 6,'M', 'USA'),
(7, 'Abebe', 'S', 'Hailu', '1988-06-09', '910-11-8745', '30 columia pike', 'Apt445', 'Arlington', 'VA', '20013', NULL, '(703) 202-2134', 'Abebe@gmail.com', NULL, 7,'M', 'USA'),
(8, 'Abel', 'A', 'Kebede', '1970-09-04', '934-23-3211', '13th st NW', 'Apt456', 'Alexandaria', 'VA', '20016', NULL, '(703) 234-2315', 'Abel@gmail.com', 1, 1, 'M','USA'), 
(9, 'Sosina', 'C', 'Birhanu', '1986-05-27', '922-45-1244', '14th NW K st', 'Apt8l5', 'Arlington', 'VA', '20013', '(703) 230-2223', '(703) 564-6548', 'Sosina@gmail.com', 10, 9, 'F','USA'),
(10, 'Solomon', 'X', 'Birhanu', '1983-02-24', '903-65-7896', '14th NW K st', 'Apt542', 'Arlington','VA', '20013', '(703) 326-5666', '(703) 321-6532', 'Solomon@gmail.com', 9, 9,'M', 'USA')
GO

--2) Add 15 children - one parent(couple) has 4 kids, two couples have 2 kids each, the non couple parents also have 2 kids each, the rest three
	--couples have 1 kid each

INSERT INTO Child 
VALUES
	(1, 10, 'Lili', 'F', 'Birhanu', '2017-09-01', '2020-08-01', 'None', 'F', 3.02, 78),
	(2, 10, 'Kidus','S', 'Birhanu', '2017-08-02', '2020-08-01', 'None', 'M', 3.79, 79),
	(3, 8, 'Kirubel', 'J', 'Kebede', '2016-10-08', '2020-08-01','None', 'M', 3.56, 78),
	(4, 8, 'Rediet', 'L', 'Kebede', '2017-08-12', '2021-01-12', 'None', 'F', 3.15, 56),
	(5, 6, 'Saron', 'G', 'Solomon', '2017-09-12',  '2020-08-01', 'None', 'F', 3.48, 68),
	(6, 6, 'Bruktawit', 'G', 'Solomon', '2016-09-10', '2021-01-12', 'Does not participate/Very shy', 'F', 4.01, 59), 
	(7, 10, 'Abel', 'P', 'Birhanu', '2017-10-25', '2020-08-01', 'None', 'M', 3.26, 75), 
	(8, 10, 'Samson', 'M', 'Birhanu', '2017-10-19', '2020-08-01', 'none', 'M', 3.98, 78),
	(9, 8, 'Fitsum', 'X', 'Samuel', '2018-8-10', '2021-01-12', 'none', 'M', 3.46, 74),
	(10, 5, 'Soliana', 'A', 'Tesfaye', '2017-12-21', '2021-01-12', 'None', 'F', 4.02, 66),
	(11, 4, 'Samrawit', 'Y', 'Mesfin', '2017-01-23', '2020-08-01', 'Does not interact with other Kids', 'F', 3.78, 75),
	(12, 2, 'Elias', 'W', 'Tesema', '2016-09-15', '2020-08-01', 'None', 'M', 3.88, 68),
	(13, 6, 'Nathan', 'I', 'Hailu', '2017-02-23', '2020-08-01', 'None', 'M', 3.87, 77) 
GO	

---Let's create table that keeps a record of child's attendace

CREATE TABLE Child_Attendance 
(CId INT,
CONSTRAINT fk_Attendance_childId FOREIGN KEY(CId) REFERENCES Child(CId),
Attendance VARCHAR(10),
CONSTRAINT Absent_Present CHECK(Attendance IN  ('ABSENT', 'PRESENT'))
)
ALTER TABLE Child_Attendance
ADD AttendanceDate DATE

 INSERT INTO Child_Attendance
 VALUES (1,'PRESENT','2020-10-08'), (2,'PRESENT','2020-10-08'), (3,'PRESENT','2020-10-08'), (4,'PRESENT', '2020-10-08'), (5,'ABSENT', '2020-10-08'), (6,'PRESENT', '2020-10-08'), (7,'PRESENT','2020-10-08'), (8,'ABSENT','2020-10-08'), (9,'PRESENT','2020-10-08'), (10,'PRESENT','2020-10-08'), (11,'PRESENT','2020-10-08'), (12,'ABSENT','2020-10-08'), (13,'PRESENT','2020-10-08'),
  (1,'PRESENT','2020-10-09'), (2,'ABSENT','2020-10-09'), (3,'PRESENT','2020-10-09'), (4,'ABSENT','2020-10-09'), (5,'PRESENT', '2020-10-09'), (6,'PRESENT', '2020-10-09'), (7,'PRESENT','2020-10-09'), (8,'PRESENT','2020-10-09'), (9,'PRESENT','2020-10-09'), (10,'PRESENT','2020-10-09'), (11,'PRESENT','2020-10-09'), (12,'PRESENT','2020-10-09'), (13,'PRESENT','2020-10-09')



--3) Add 5 Nannys

INSERT INTO Nanny
VALUES 
(1, 5, 'Abeba', 'Tesfaye', '596-99-6589', 'F', '(703) 526-8958', '13th glebe Rd', '457', 'Arlington', 'VA', '22209', '2020-06-05', 'Diploma'),
(2, 4, 'Sinidu', 'Belay', '541-45-6541', 'F', '(202) 632-6544', '291 West main street', '285', 'Washington', 'DC', '20015', '2020-07-14', 'Diploma'),
(3, 3, 'Lema', 'Birhanu', '785-65-3621', 'M', '(202) 546-9657', '39  Oakland Ave', '15', 'Washington', 'DC', '20014', '2020-05-22', 'Diploma'),
(4, 2, 'Werku', 'Solomon', '456-54-8785', 'M', '(202) 996-9850', '345 NW 21 st', '132', 'Washington', 'DC', '20100', '2020-12-03', 'Diploma'), 
(5, 1, 'Sara', 'Getachew', '956-78-9647', 'F', '(703) 548-6326', '500 East st', '57', 'Arlington', 'VA', '22204', '2020-09-09', 'Diploma') 

--4) Add 2 drop and 2 pickup information for every child

INSERT INTO ChildDrop
VALUES
(1,'9:00', 10, 5, 'None',1),
(2,'9:00', 10, 4, 'None',2),
(3,'9:00', 8, 3, 'None',3),
(4,'9:00', 8, 2, 'None',4);
GO


INSERT INTO ChildPickup
VALUES
(1,'8:25', 5, 10, 'None',1),
(2,'8:30', 4, 10, 'None',2),
(3,'8:35', 3, 8, 'None',3),
(4,'8:22', 2, 8, 'None',4);
GO
--5) Add Nanny training - 2 Nannys got 4 trainings, 2 got 1 training each and 1 got 3 trainings
INSERT INTO NannyTraining
VALUES 
(1, 4),
(1, 3),
(1, 2),
(1, 1),
(2, 4),
(2, 3),
(2, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 4)
GO

INSERT INTO Training
VALUES
(1, 'Professional Development', '2021-02-05', 'learning & support activities', 'Targeted Academy', 'Seble Fekadu', 'Certificate'),
(2, 'Observation and Assessment', '2021-02-05', 'Information about development','Targeted Academy', 'Dawit Samason', 'Certificate'), 
(3, 'Guidance and Discipline', '2021-02-05', 'promote self-control', 'Targeted Academy', 'Hiwot Asif', 'Cerificate'), 
(4, 'Child Health', '2021-02-05', ' state of physical and emotional well-being ', 'Targeted Academy', 'Eden zelamlem', 'certificate'), 
(5, 'Interaction', '2021-02-05', 'Child anatomy and physiology growth', 'Targeted  Academy', 'Maraki Wesene', 'certificate') ,
(6, 'Feeding', '2021-02-05', 'Regulating if child has been properly Fed', 'Targeted Academy', 'Kidus Andualem', 'Certificate'),
(7, 'Prevention of Child Neglect', '2021-02-05', 'Preventing Child Abuse and Neglect', 'Targeted Academy', 'Fikir Debrbe', 'certificate')

--6) Add 5 Food Menu items

INSERT INTO Menu
VALUES
(6,'Granola bar', 780, 'No',3.5),
(7,'Scrambled Eggs', 780, 'No',3.00),
(8,'Biscuits with Gravey', 650, 'No',2.99),
(9,'Mac and Cheese', 620, 'Yes',3.65),
(10,'Yougurt', 700, 'No',1.99);
GO

----I am adding child ID as a foreign key constraint to an existing table 
UPDATE Menu
 SET CId = 1
 WHERE MId =1
 UPDATE Menu
 SET CId = 2
 WHERE MId =2
 UPDATE Menu
 SET CId = 3
 WHERE MId =3
 UPDATE Menu
 SET CId = 4
 WHERE MId =4
 UPDATE Menu
 SET CId = 5
 WHERE MId =5


--7) Each Child should be fed 4 times (twice each day) - add total of 60 rows to feeding table
INSERT INTO Feeding 
VALUES 
(1, 3,'2020-10-08','none', 'none'),
(1, 1,'2020-10-08', 'none', 'none'),
(1, 4,'2020-10-09','none', 'none'),
(1, 2,'2020-10-09','none', 'none'),
(2, 3,'2020-10-08','none', 'none'),
(2, 1,'2020-10-08', 'none', 'none'),
(2, 4,'2020-10-09','none', 'none'),
(2, 2,'2020-10-09','none', 'none'),
(3, 3,'2020-10-08','none', 'none'),
(3, 1,'2020-10-08','none', 'none'),
(3, 4,'2020-10-09','none','none'),
(3, 2,'2020-10-09','none', 'none'),
(4, 3,'2020-10-08','none', 'none'),
(4, 1,'2020-10-08','none', 'none'),
(4, 4,'2020-10-09','none', 'none'),
(4, 2,'2020-10-09','none', 'none'),
(5, 3,'2020-10-08', 'none', 'none'),
(5, 1,'2020-10-08', 'none', 'none'),
(5, 4,'2020-10-09', 'none', 'none'),
(5, 2,'2020-10-09','none', 'none'),
(6, 3,'2020-10-08', 'none', 'none'),
(6, 1,'2020-10-08', 'none', 'none'),
(6, 4,'2020-10-09','none', 'none'),
(6, 2,'2020-10-09', 'none','none'),
(7, 3,'2020-10-08', 'none', 'none'),
(7, 4,'2020-10-08', 'none', 'none'),
(7, 2,'2020-10-09', 'none', 'none'),
(7, 1,'2020-10-09','none', 'none'),
(8, 1,'2020-10-08','none', 'none'),
(8, 2,'2020-10-08','none', 'none'),
(8, 4,'2020-10-09', 'none', 'none'),
(8, 3,'2020-10-09', 'none', 'none'),
(9, 1,'2020-10-08', 'none', 'none'),
(9, 4,'2020-10-08', 'none', 'none'),
(9, 2,'2020-10-09', 'none', 'none'),
(9, 3,'2020-10-09', 'none', 'none'),
(10, 1,'2020-10-08', 'none','none'),
(10, 2,'2020-10-08', 'none', 'none'),
(10, 4,'2020-10-09','none', 'none'),
(10, 3,'2020-10-09', 'none', 'none'),
(11, 3,'2020-10-08', 'none', 'none'),
(11, 1,'2020-10-08', 'none', 'none'),
(11, 4,'2020-10-09','none', 'none'),
(11, 2,'2020-10-09','none', 'none'),
(12, 3,'2020-10-08','none', 'none'),
(12, 1,'2020-10-08','none', 'none'),
(12, 4,'2020-10-09', 'none', 'none'),
(12, 2,'2020-10-09', 'none', 'none'),
(13, 3,'2020-10-08', 'none', 'none'),
(13, 1,'2020-10-08','none', 'none'),
(13, 4,'2020-10-09', 'none', 'none'),
(13, 2,'2020-10-09', 'none', 'none');
GO


--8) Add 7 Activity types (to Activity table)
INSERT INTO Activity
VALUES 
(1, 'Hide and Seek','Looking for players and vice versa'),
(2, 'Water Play','Open-ended activity for extended learning'),
(3, 'Play Dough','explore ideas until they find one that works'),
(4, 'Dress-Up Play',' Builds vocabulary suitable for a character'),
(5, 'Music dancing/singing','Allows kids to expresss themselves'),
(6, 'Drawing and Painting',' Enhance their creative problem-solving abilities'),
(7, 'Blocks and shape sorters','Easy learning tool');
GO


--9) Each child to take part in 2 activities per day - add total of 60 activities (rows) to Child Activity table
(1, 1, 1, '2021-01-15','11:00AM','2:00PM' )

INSERT INTO ChildActivity
VALUES
(1, 1, 1, '2021-01-15','11:00AM','2:00PM'),
(1, 2, 2, '2021-01-15','10:00AM','1:00PM'),
(2, 3, 3, '2021-01-15','11:00AM','2:00PM'),
(2, 4, 4, '2021-01-15','11:00AM','2:00PM'),
(3, 5, 5, '2021-01-15','11:00AM','2:00PM'),
(3, 6, 1, '2021-01-15','11:00AM','2:00PM'),
(4, 7, 2, '2021-01-15','11:00AM','2:00PM'),
(4, 1, 3, '2021-01-15','11:00AM','2:00PM'),
(5, 2, 4, '2021-01-15','11:00AM','2:00PM'),
(5, 3, 5,'2021-01-15','11:00AM','2:00PM'),
(6, 4, 1,'2021-01-15','11:00AM','2:00PM'),
(6, 5, 2,'2021-01-15','11:00AM','2:00PM'),
(7, 6, 3,'2021-01-15','11:00AM','2:00PM'),
(7, 7, 4,'2021-01-15', '11:00AM','2:00PM'),
(8, 1, 3, '2021-01-15','11:00AM','2:00PM'),
(8, 2, 4, '2021-01-15', '11:00AM','2:00PM'),
(9, 3, 5,'2021-01-15', '11:00AM','2:00PM'),
(9, 4, 1,'2021-01-15','11:00AM','2:00PM'),
(10, 5, 2,'2021-01-15','11:00AM','2:00PM'),
(10, 6, 3,'2021-01-15','11:00AM','2:00PM'),
(11, 7, 4,'2021-01-15','11:00AM','2:00PM'), 
(11, 1, 3, '2021-01-15','11:00AM','2:00PM'),
(12, 2, 4, '2021-01-15','11:00AM','2:00PM'), 
(12, 3, 5,'2021-01-15','11:00AM','2:00PM'),
(13, 4, 1,'2021-01-15','11:00AM','2:00PM'),
(13, 5, 2,'2021-01-15','11:00AM','2:00PM'),
(1, 3, 4, '2021-08-11','11:00AM','2:00PM'),
(1, 4, 5, '2021-09-06','11:00AM','2:00PM'),
(1, 5, 1, '2021-01-05','11:00AM','2:00PM'),
(2, 5, 2, '2021-02-15','11:00AM','2:00PM'),
(2, 6, 3, '2021-03-05','11:00AM','2:00PM'),
(2, 7, 4, '2021-04-15','11:00AM','2:00PM'), 
(2, 1, 5,'2021-05-05','11:00AM','2:00PM'),
(3, 2, 1,'2021-06-10', '11:00AM','2:00PM'),
(3, 1, 2,'2021-07-25','11:00AM','2:00PM'),
(3, 7, 3,'2021-08-25','11:00AM','2:00PM'),
(3, 3, 4,'2021-09-25','11:00AM','2:00PM'),
(4, 2, 5,'2021-10-05','11:00AM','2:00PM'),
(4, 3, 31,'2021-11-10','11:00AM','2:00PM'),
(4, 4, 2,'2021-12-25','11:00AM','2:00PM'),
(4, 5, 3,'2021-01-25','11:00AM','2:00PM'),
(5, 1, 4,'2021-02-25', '11:00AM','2:00PM'),
(5, 4, 3, '2021-03-05','11:00AM','2:00PM'),
(5, 5, 4, '2021-03-15','11:00AM','2:00PM'),
(5, 6, 5,'2021-04-05','11:00AM','2:00PM'),
(6, 1, 1,'2021-05-10','11:00AM','2:00PM'),
(6, 2, 2,'2021-06-25','11:00AM','2:00PM'),
(6, 3, 4, '2021-07-11','11:00AM','2:00PM'),
(6, 6, 5, '2021-08-06','11:00AM','2:00PM'),
(7, 2, 1, '2021-09-05','11:00AM','2:00PM'),
(7, 3, 2, '2021-10-15','11:00AM','2:00PM'),
(7, 4, 3, '2021-11-05','11:00AM','2:00PM'),
(7, 5, 4, '2021-12-15','11:00AM','2:00PM'),
(8, 3, 5,'2021-01-05','11:00AM','2:00PM'),
(8, 4, 1,'2021-02-10','11:00AM','2:00PM'),
(8, 5, 2,'2021-03-25','11:00AM','2:00PM'),
(9, 1, 3,'2021-04-25','11:00AM','2:00PM'),
(9, 2, 4,'2021-05-25','11:00AM','2:00PM')  

GO

---10) ChildAppraisal each child should be atleast for tqo types of Appraisals 
INSERT INTO ChildAppraisal
VALUES 
	(1, '2020-08-06', 90,'motivation',1),
	(2, '2020-08-08', 86,'cooperation',2),
	(3, '2020-09-01',95,'analytical',3),
	(4, '2020-11-12', 89,'motivation',4),
	(5, '2020-09-01', 90,'motivation',5),
	(6, '2020-11-12', 95,'cooperation',6), 
	(7,  '2020-05-09',85,'analytical',7 ), 
	(8,  '2020-04-11',87,'language',8 ),
	(9, '2020-11-08',88,'language', 9 ),
	(10, '2020-06-12',88,'language',10),
	(11, '2020-07-16',90,'motivation',11),
	(12, '2020-06-15',98,'cooperation',12),
	(13, '2020-12-01',94,'motivation',13 ), 
	(1, '2020-08-12',89,'analytical',14 ),
	(2,  '2021-02-08',96,'language',15 ),
	(3,  '2021-01-17',92,'motivation',16),
	(4,  '2020-09-06',87,'cooperation',17),
	(5, '2020-08-09', 92,'language',18),
	(6,  '2020-06-12',95, 'analytical',19), 
	(7,  '2020-11-07',96,'analytical',20), 
	(8,  '2020-09-18', 97,'motivation',21),
	(9,  '2020-04-21', 87,'language',22),
	(10, '2020-12-21', 83,'cooperation',23),
	(11, '2020-07-09',85,'cooperation',24),
	(12,  '2020-01-10',88,'analytical',25),
	(13,  '2020-12-11',90,'analytical',26) 
GO	
	
	
SELECT * FROM Child
SELECT * FROM Activity
SELECT * FROM ChildActivity
SELECT * FROM ChildAppraisal
SELECT * FROM ChildDrop
SELECT * FROM ChildPickup
SELECT * FROM Feeding
SELECT * FROM Menu
SELECT * FROM Nanny
SELECT * FROM NannyTraining
SELECT * FROM Parent 
SELECT * FROM Parenting
SELECT * FROM Training 




--1) Children Full Name with their mothers' information
SELECT  C.FName+' '+ C.MI +' '+ C.LName [Childfullname], CONCAT (P.FName, ' ', P.MI, ' ', P.LName) AS MotherFullName
FROM Child C JOIN  Parent P ON C.PID = P.PId
WHERE P.Gender = 'F'
UNION 
SELECT  C.FName+' '+ C.MI +' '+ C.LName [Childfullname], CONCAT (PE.FName, ' ', PE.MI, ' ', PE.LName) AS MotherFullName
FROM Child C JOIN  Parent PE ON C.PID = PE.SpousePId
WHERE PE.Gender = 'F'

CREATE VIEW vw_ChildrenFullNameWithMotherInformation
AS
SELECT  C.FName+' '+ C.MI +' '+ C.LName [Childfullname], CONCAT (P.FName, ' ', P.MI, ' ', P.LName) AS MotherFullName
FROM Child C JOIN  Parent P ON C.PID = P.PId
WHERE P.Gender = 'F'
UNION 
SELECT  C.FName+' '+ C.MI +' '+ C.LName [Childfullname], CONCAT (PE.FName, ' ', PE.MI, ' ', PE.LName) AS MotherFullName
FROM Child C JOIN  Parent PE ON C.PID = PE.SpousePId
WHERE PE.Gender = 'F'

CREATE PROC Usp_ChildrenFullNameWithMotherInformation
(@PGender CHAR(1),
@PEGender CHAR(1))
AS 
BEGIN
SELECT  C.FName+' '+ C.MI +' '+ C.LName [Childfullname], CONCAT (P.FName, ' ', P.MI, ' ', P.LName) AS MotherFullName
FROM Child C JOIN  Parent P ON C.PID = P.PId
WHERE P.Gender = @PGender
UNION 
SELECT  C.FName+' '+ C.MI +' '+ C.LName [Childfullname], CONCAT (PE.FName, ' ', PE.MI, ' ', PE.LName) AS MotherFullName
FROM Child C JOIN  Parent PE ON C.PID = PE.SpousePId
WHERE PE.Gender = @PEGender
END;
GO 

--2) Children who are registered this year
SELECT * FROM Child
WHERE  EnrolledDate >= '2021-01-01'

CREATE VIEW vw_ChildrenRegisteredThisYear 
AS
SELECT * FROM Child
WHERE  EnrolledDate >= '2021-01-01'

CREATE PROC Usp_ChildrenRegisteredThisYear
(@BeginningOfYear INT)
AS
BEGIN
SELECT * FROM Child
WHERE  YEAR(EnrolledDate) = @BeginningOfYear
END 

--execute 
EXEC Usp_ChildrenRegisteredThisYear 2021

--3) Parents who are not referred by another parent 
--All parents were referred by other parents so in my case it doesn't return anyone

SELECT FName, MI, LName 
FROM Parent
WHERE  ReferredbyPID  NOT IN (SELECT ReferredByPID FROM Parent)

CREATE VIEW VW_ParentNotReferredByOtherParents 
AS
SELECT FName, MI, LName 
FROM Parent
WHERE  ReferredbyPID  NOT IN (SELECT ReferredByPID FROM Parent)

CREATE PROC Usp_ParentNotReferredByOtherParents
(@ReferredByPID INT)
AS
BEGIN
SELECT FName, MI, LName 
FROM Parent
WHERE  @ReferredbyPID  NOT IN (SELECT ReferredByPID FROM Parent)
END 

--EXECUTE 
Usp_ParentNotReferredByOtherParents 2

--4) All Nannys with their training information
SELECT FName, LName, TrainingName
FROM Nanny N  JOIN NannyTraining NT ON N.NID = NT.NID JOIN Training T ON NT.TrId = T.TId

CREATE VIEW vw_AllNannyTrainingInformation
AS
BEGIN
SELECT FName, LName, TrainingName 
FROM Nanny N JOIN NannyTraining NT ON N.NId= NT.NId JOIN Training T ON NT.TrId = T.TId
END 

CREATE usp_AllNannyTrainigInformation
AS
BEGIN
SELECT FName, LName, TrainingName 
FROM Nanny N JOIN NannyTraining NT ON N.NId = NT.NId JOIN Training T ON NT.TrId =T.TId
END


--5) All nannys who never got training
SELECT  NID, FName + ' ' + LName [Nanny FullName]
FROM    Nanny
WHERE   nID NOT IN (SELECT NID FROM NannyTraining)

CREATE VIEW vw_NannyNeverBeenTrained 
AS
SELECT NID, Fname + ' ' +LName [Nanny FullName]
FROM Nanny
WHERE NId NOT IN (SELECT NId FROM NannyTraining)
GO

CREATE PROC usp_NannyNeverBeenTrained 
(@NId INT)
AS
SELECT NId, FName + ' ' + LName [Nanny FullName]
FROM Nanny 
WHERE @NId NOT IN (SELECT NId FROM NannyTraining)
GO

--6) Number of trainings provided by trainingOrganizations (trainerOrganizationName, Number of Trainings offered)
SELECT offeringOrganization AS TrainerOrganizationName, COUNT (offeringOrganization) AS [number of trainings]
FROM Training
GROUP BY offeringOrganization

CREATE VIEW vw_NumberOfTraining
AS
SELECT offeringOrganization AS TrainerOrganizationName, COUNT (offeringOrganization) AS [number of trainings]
FROM Training
GROUP BY offeringOrganization
GO

CREATE PROC usp_NumberOfTraining 
(@OrgName VARCHAR (30))
AS
BEGIN 
SELECT offeringOrganization AS TrainerOrganizationName, COUNT (offeringOrganization) AS [number of trainings]
FROM Training
WHERE @OrgName = offeringOrganization
GROUP BY offeringOrganization
GO

--usp_NumberOfTraining 'Targeted Academy'

--8) ActivityId and number of children who partticipated in each activity

SELECT A.ActId, COUNT(C.CId)[Number of children that participated]
FROM childActivity CA JOIN Activity A ON CA.ActId = A.ActId JOIN Child C ON C.CId = CA.CID
GROUP BY A.ActId
GO


CREATE VIEW vw_NumberOfChildrenWhoParticipated 
AS
SELECT A.ActId, COUNT(C.CId)[Number of children that participated]
FROM childActivity CA JOIN Activity A ON CA.ActId = A.ActId JOIN Child C ON C.CId = CA.CID
GROUP BY A.ActId
GO

ALTER PROC usp_NumberOfChildrenWhoParticipated
(@ACTId INT)
AS
SELECT A.ActId, COUNT(C.CId)[Number of children that participated]
FROM childActivity CA JOIN Activity A ON CA.ActId = A.ActId JOIN Child C ON C.CId = CA.CID
WHERE  A.ActId =  @ACTId
GROUP BY A.ActId
GO

EXEC usp_NumberOfChildrenWhoParticipated --insert Activity ID 

--9) Parents whose children participated in particular activities (5 or more tables need to be joined for this)

SELECT DISTINCT P.PId, CONCAT (P.FName, ' ',  P.MI, ' ', P.LName) AS [Parent FullName], CONCAT (C.FName, ' ', C.MI, ' ', C.LName) AS [Child FullName]
FROM Parent P JOIN Child C ON p.pID = C.pID JOIN ChilDActivity CA ON C.CID = CA.CID JOIN Activity A  ON A.ActId = CA.ActId

CREATE VIEW vw_ParentsOfTheParticipatingChild
AS
SELECT DISTINCT P.PId, CONCAT (P.FName, ' ',  P.MI, ' ', P.LName) AS [Parent FullName], CONCAT (C.FName, ' ', C.MI, ' ', C.LName) AS [Child FullName]
FROM Parent P JOIN Child C ON p.pID = C.pID JOIN ChilDActivity CA ON C.CID = CA.CID JOIN Activity A  ON A.ActId = CA.ActId

CREATE PROC usp_ParentsOfTheParticipatingChild
(@CId INT)
AS
SELECT DISTINCT P.PId, C.CId, CONCAT (P.FName, ' ',  P.MI, ' ', P.LName) AS [Parent FullName], CONCAT (C.FName, ' ', C.MI, ' ', C.LName) AS [Child FullName]
FROM Parent P JOIN Child C ON p.pID = C.pID JOIN ChilDActivity CA ON C.CID = CA.CID JOIN Activity A  ON A.ActId = CA.ActId
WHERE C.CId = @CId

EXEC usp_ParentsOfTheParticipatingChild --enter Child Id here and it returns the parent 

--10) Menu (mId) and number of children who are fed the menu item on a given day 
 
SELECT  M.Name ,F.MealTime,  COUNT (C.CId) AS [Number of children fed]
FROM Menu M JOIN Feeding F ON M.MId = F.MId JOIN Child C ON C.CId = F.CId
WHERE F.MealTime = '2020-10-08'
GROUP BY M.Name, F.MealTime
 
CREATE VIEW vw_NumOfChildrenFed 
AS
SELECT  M.Name ,F.MealTime,  COUNT (C.CId) AS [Number of children fed]
FROM Menu M JOIN Feeding F ON M.MId = F.MId JOIN Child C ON C.CId = F.CId
WHERE F.MealTime = '2020-10-08'
GROUP BY M.Name, F.MealTime

CREATE PROC usp_NumOfChildrenFed
(@day DATETIME)
AS
SELECT  M.Name ,F.MealTime,  COUNT (C.CId) AS [Number of children fed]
FROM Menu M JOIN Feeding F ON M.MId = F.MId JOIN Child C ON C.CId = F.CId
WHERE F.MealTime = @day
GROUP BY M.Name, F.MealTime
 
 EXEC usp_NumOfChildrenFed '2020-10-08'----we only have data of children fed on two particular days 202-10-08 & 2020-10-09


--------------------------------------Stored Procs-----------------------------------------------------
---Create stored procs 
--1) for data insert into all tables

CREATE PROCEDURE usp_InsertInToActivity
(@actId INT,
@ActName VARCHAR(30),
@ActDescription VARCHAR(30)
)
AS
BEGIN 
	INSERT INTO Activity VALUES (@actId,@ActName,@ActDescription)
END 

CREATE PROC usp_InsertInToChild
(@CId INT,
@PId INT,
@FName VARCHAR(30),
@MI CHAR(1),
@LName VARCHAR(30),
@DOB DATE,
@EnrolledDate DATE,
@SpecialConsideration VARCHAR(30),
@Gender CHAR(1),
@InitialHeight  INT,
@InitialWeight INT
)
AS 
BEGIN
INSERT INTO Child 
VALUES (@CId, @PId,
@FName,
@MI,
@LName,
@DOB,
@EnrolledDate,
@SpecialConsideration,
@Gender,
@InitialHeight,
@InitialWeight
);
END 

CREATE PROC usp_InsertInToChildActivity
(@CId INT,
@ActId INT,
@NId INT,
@ActDate DATE, 
@StartTime TIME(7),
@EndTime TIME(7)
)
AS
BEGIN 
INSERT INTO ChildActivity 
VALUES (@CId,
@ActId,
@NId,
@ActDate, 
@StartTime,
@EndTime )
END 


---2) that update all tables - takes parameters to be used in WHERE clause and SET Clause of UPDATE statement


CREATE PROC Sp_updateChildActivityTable  
(@CId INT,
@ActId INT,
@NId INT,
@ActDate DATE,  
@StartTime TIME(7),
@EndTime TIME(7)
)
AS
BEGIN 
UPDATE ChildActivity 
SET
CId = @CId,
ActId = @ActId,
ActDate = @ActDate,
StartTime = @StartTime,
EndTime = @EndTime 
WHERE  ActId = @ActId  AND CId =@CId 
END

EXEC PROC Sp_updateChildActivityTable -- insert values 
 

---3) for the above select queries - make all to take parameters
---I have already created one for each below the select queries 

-------------------------------- Views and functions--------------------------------------------

----1) Create views for all the above Select queries
---I have already created one for each below the select queries 
----2) Children full name and father's name and mother's name for all childeren absent from school on a given day (simply choose one day)

SELECT CONCAT(C.FName,' ',C.LName) AS Child, CONCAT(P.FName,' ',P.LName) AS Parent, Attendance, AttendanceDate,
CASE P.gender WHEN 'F' THEN 'Mother' ELSE 'Father' END 'Parent' 
FROM Child C JOIN Parent P ON P.PId = C.PId  JOIN Child_Attendance A ON C.CId = A.CId
WHERE AttendanceDate != '2020-10-08'

CREATE FUNCTION udf_ChildenAbsent
(@date DATE)
RETURNS TABLE 
AS 
RETURN (SELECT CONCAT(C.FName,' ',C.LName) AS Child, CONCAT(P.FName,' ',P.LName) AS Parent, Attendance, AttendanceDate,
CASE P.gender WHEN 'F' THEN 'Mother' ELSE 'Father' END 'ParentGender' 
FROM Child C JOIN Parent P ON P.PId = C.PId  JOIN Child_Attendance A ON C.CId = A.CId
WHERE AttendanceDate != @DATE)
GO

-------- using stored proc or function will give you more flexibility - as you can pass date parameter.
--3) Children full information for those who are abscent more than 5 times - in a given calendar dates range (take one month)
CREATE VIEW vw_Absence 
AS
SELECT CId, Attendance, AttendanceDate
FROM Child_Attendance
WHERE Attendance = 'Absent'


SELECT CONCAT(C.FName,' ',C.LName) AS Child, COUNT(Attendance) AS [Number of dates absent]
FROM  Child C JOIN vw_Absence A ON C.CId = A.CId 
WHERE AttendanceDate BETWEEN '2020-01-08' AND '2020-01-08'
GROUP BY c.FName, c.lName
HAVING COUNT(Attendance)> 5 

ALTER FUNCTION udf_Absence 
(@NumberOfTimesAbsence INT)
RETURNS VARCHAR(10)
AS
BEGIN 
DECLARE @ChildAbsent VARCHAR;
SELECT @ChildAbsent = CONCAT(C.FName,' ',C.LName) 
FROM  Child C JOIN vw_Absence A ON C.CId = A.CId 
WHERE AttendanceDate BETWEEN '2020-01-08' AND '2020-01-08'
GROUP BY c.FName, c.lName
HAVING COUNT(Attendance)> @NumberOfTimesAbsence

RETURN @ChildAbsent
END


 -----It does not return any value because we only have attendance of two days in our data. 
 
---4) Children full information for those who have birthday today.

ALTER FUNCTION dbo.fn_Birthday 
(@date DATE )
RETURNS VARCHAR (10)
AS	
BEGIN
	
	DECLARE @BirthdayKid VARCHAR(10);

	SELECT @BirthdayKid = FName
	FROM Child 
	WHERE @date = Dob 
	GROUP BY FName 
	
	
	RETURN @BirthdayKid

END

CREATE VIEW vw_BirthdayKid 
AS
SELECT FName 
FROM Child 
WHERE day('DoB') =  day('GETDATE()')

ALTER FUNCTION udf_BirthDayKid 
(@date DATE)
RETURNS VARCHAR(30)
AS 
BEGIN 
DECLARE @Child VARCHAR(30);

SELECT @Child = FName 
FROM Child 
WHERE day('DoB') =  day(@date)

RETURN @Child
END
GO 

SELECT * FROM udf_BirthDayKid (GETDATE())

---5) Children who will be 6 years before or in June
  
  CREATE VIEW vw_ChildrenTurningSix 
  AS
  SELECT FName, DATEDIFF(YEAR,DoB,'2021-06-30') AS Age 
  FROM Child 
  WHERE DATEDIFF(YEAR,DoB,'2021-06-30') > 6 

CREATE FUNCTION udf_ChildrenTurningSix
 (@years INT)
RETURNS VARCHAR (30)
AS
BEGIN 
DECLARE @Child VARCHAR(30)
	
  SELECT @Child = FName
  FROM Child 
  WHERE DATEDIFF(YEAR,DoB,'2021-06-30') > @years

  RETURN @Child
  END
  
  ----All of the children enrolled are younger than six years old

	-- Before working on 6 and 7, first create an Accident table that is related to ChildActivity table
---6) Create view/ function that shows children who encountered accidents 
CREATE TABLE ChildAccident 
(ACCId INT PRIMARY KEY, 
CId INT,
ActId INT,
CONSTRAINT fk_Accident_Activity FOREIGN KEY(ActId) REFERENCES Activity(ActId),
CONSTRAINT fk_Accident_Child FOREIGN KEY(CId) REFERENCES Child(CId),
NumberOfAccident INT)

INSERT INTO ChildAccident 
VALUES (1,1,7,0),(2,2,5,0),(3,3,2,1),(4,4,6,1),(5,5,6,2),(6,6,2,1),(7,7,6,1),(8,8,4,0)


CREATE VIEW vw_Children_EncounteredAccidents 
AS 
SELECT CONCAT(C.FName,' ',C.LName),A.ActName,CA.NumberOfAccident
FROM Child C JOIN ChildAccident CA ON C.CId = CA.CId JOIN Activity A ON A.ActId =CA.ActId
GROUP BY C.FName, C.lName, A.ActName, CA.NumberOfAccident
GO 

CREATE FUNCTION udf_ChildAccident
(@Accidents INT)
RETURNS TABLE 
AS 
RETURN (SELECT CONCAT(C.FName,' ',C.LName) AS Child ,A.ActName,CA.NumberOfAccident
FROM Child C JOIN ChildAccident CA ON C.CId = CA.CId JOIN Activity A ON A.ActId =CA.ActId
WHERE CA.NumberOfAccident > @Accidents
GROUP BY C.FName, C.lName, A.ActName, CA.NumberOfAccident
)

SELECT * FROM udf_ChildAccident (1)

---7) Create a view/ function that shows Activities that have caused more accidents

CREATE VIEW vw_Children_EncounteredAccidents 
AS 
SELECT A.ActName, CA.NumberOfAccident
FROM Child C JOIN ChildAccident CA ON C.CId = CA.CId JOIN Activity A ON A.ActId =CA.ActId
ORDER BY CA.NumberOfAccident DESC
GO 

CREATE VIEW vw_Activities_with_more_Accidents
AS
SELECT TOP(1) Accidents FROM (SELECT A.ActName, CA.NumberOfAccident AS Accidents
FROM Child C JOIN ChildAccident CA ON C.CId = CA.CId JOIN Activity A ON A.ActId =CA.ActId
ORDER BY CA.NumberOfAccident DESC) X;
GO 

ALTER FUNCTION udf_ActivityType 
(@NUmberOfAccidents INT)
RETURNS VARCHAR(30)
AS
BEGIN 
DECLARE @ActType VARCHAR(30)

SELECT @ActType = A.ActName
FROM Child C JOIN ChildAccident CA ON C.CId = CA.CId JOIN Activity A ON A.ActId =CA.ActId
ORDER BY CA.NumberOfAccident DESC

RETURN @ActType 
END 

SELECT * FROM udf_ActivityType(2)
----------------------------------------------Triggers--------------------------------------------------------------

/*1) Create an after insert trigger on Nanny table that captures who inserted, which Nanny and the time the data is inserted. For this first
		create NannyAudit table that can hold the data*/

CREATE TABLE NannyAudit 
(ChangeId INT IDENTITY PRIMARY KEY, 
NId INT NOT NULL, 
FName VARCHAR(30) NOT NULL,
LName VARCHAR(30) NOT NULL,
Update_date DATE NOT NULL, 
Changer SYSNAME NOT NULL, 
Operation CHAR(1) NOT NULL,
Check(Operation = 'I' OR Operation = 'D')
); 

CREATE TRIGGER TR_NannyAudit
ON Nanny 
AFTER INSERT, UPDATE 
AS
BEGIN 
INSERT INTO NannyAudit 
(NId,
FName,
LName,
Update_date,
Changer, 
Operation)
SELECT 
I.NId,
I.FName,
I.LName, 
GETDATE(),
SYSTEM_USER,
'I'
FROM INSERTED AS I 
 
 UNION ALL 

SELECT 
D.NId,
D.FName,
D.LName, 
GETDATE(),
SYSTEM_USER,
'D'
FROM DELETED AS D
END 
GO 

INSERT INTO Nanny 
VALUES (6, 7, 'Alex', 'Belete', '596-99-0567', 'm', '(703) 526-2395', '14th glebe Rd', '567', 'Arlington', 'VA', '22209', '2020-06-06', 'Diploma')

SELECT * FROM NannyAudit

/*2) Create an after delete trigger on Child table that inserts data into WithdrawnChildren table for those Children who are deleted from Child table
		For this create a table like: WithdrawnChildren (ChildId, ChildFullName, MotherFullName, WithdrawnDate). 
		This table holds Children who are deleted and their Parents information together
		(Remember to allow deleting any Child - by redefining all the related foreign keys)*/

CREATE TABLE WithdrawnChildren 
(ChildId INT,
ChildFullName VARCHAR(30),
MotherFullName VARCHAR(30),
WithdrawnDate DATE)

ALTER TABLE Child 
ALTER COLUMN PId  INT NULL

CREATE TRIGGER TR_ChildWithdrawal 
ON Child 
AFTER DELETE 
AS 
BEGIN
INSERT INTO WithdrawnChildren
VALUES (D.CId,
D.FName+' '+D.LName AS [Child fullname], 
CASE WHEN P.Gender = 'F' THEN 'FName' ELSE NULL END [Mother],
GETDATE())
FROM DELETED D JOIN Parent P ON D.PId= P.PId
END 
GO 

DELETE FROM Child 
WHERE CId = 12 

SELECT * FROM WithdrawnChildren
	
	/*Below exercise requires you to create a simple table called EnrollmentCapacity(capId TINYINT, ChildAge, remainingCapacity) and add some data into it 
	as follows INSERT INTO EnrollmentCapacity VALUES (1, 1, 5), (2, 2, 10), (3, 3, 10), (4,4,8), (5,5,7), (6,6,5)*/

CREATE TABLE EnrollmentCapacity 
(CapId TINYINT, 
ChildAge INT,
RemainingCapacity INT);
GO 

INSERT INTO EnrollmentCapacity
VALUES (1, 1, 5), (2, 2, 10), (3, 3, 10), (4,4,8), (5,5,7), (6,6,5);
GO 

/*3) Create an instead of insert trigger on the Child table that first checks the EnrollmentCapacity table for the age category of the child
		and only allows the enrollment if we have space for the child. If the child is allowed, the trigger should go back and reduce the remaining capacity
		for that age group by one. If the remaining capacity is 0 (zero) the trigger should inform same and disallow registration*/

CREATE TRIGGER TR_enrollmentCapacity 
ON Child 
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @CId INT;
	DECLARE @PId INT;
	DECLARE @FName VARCHAR(30);
	DECLARE @MI CHAR(1);
	DECLARE @LName VARCHAR(30);
	DECLARE @DOB DATE;
	DECLARE @ChildAge INT;
	DECLARE @EnrolledDate DATE;
	DECLARE @SpecialConsideration VARCHAR(50);
	DECLARE @Gender CHAR(1);
	DECLARE @InitialHeight INT;
	DECLARE @InitialWeight INT;
	DECLARE @NewStudent INT;
	DECLARE @RemainingCapacity INT;

	SELECT	
	@CId = CId,@PId = PId, @FName = FName, @MI = MI,
			@LName = LName,
			@DOB = DOB, 
			@EnrolledDate = EnrolledDate,
			@SpecialConsideration = SpecialConsideration,
			@Gender = Gender,
			@InitialHeight = InitialHeight,
			@InitialWeight = InitialWeight,
			@NewStudent = COUNT(CId)
	FROM inserted
	GROUP BY CId,PId,FName,MI,LName,DOB,EnrolledDate,SpecialConsideration, Gender,InitialHeight,InitialWeight

	SELECT @RemainingCapacity = RemainingCapacity
	FROM EnrollmentCapacity
	WHERE ChildAge = DATEDIFF(YEAR,@DOB, GETDATE());

	IF @RemainingCapacity >= @NewStudent  
		BEGIN

			INSERT INTO Child(CId,PId,FName,MI,LName,DOB,EnrolledDate,SpecialConsideration, Gender,InitialHeight,InitialWeight)
			VALUES (@CId,@PId,@FName,@MI,@LName,@DOB,@EnrolledDate,@SpecialConsideration,@Gender,@InitialHeight,@InitialWeight)
		

			UPDATE EnrollmentCapacity
			SET RemainingCapacity = RemainingCapacity - @NewStudent
			WHERE ChildAge = DATEDIFF(YEAR,@DOB,GETDATE());
		END

	ELSE 
		BEGIN
			PRINT 'There is no space'
		END
END
GO

---TEST


INSERT INTO Child
VALUES (15, 6, 'Kirubel', 'T', 'Tadele', '2017-03-03', '2020-08-01', 'None', 'M', 3.87, 88) 
GO	

SELECT * FROM EnrollmentCapacity


