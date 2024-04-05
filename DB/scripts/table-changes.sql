ALTER TABLE CompanyLeave
ADD Active bit NULL;

CREATE TABLE [dbo].[CompanyCalendar_N] (
  [Cd] [VARCHAR](5) NOT NULL
 ,[Date] [DATETIME] NOT NULL
 ,[Invite] [BIT] NULL
 ,[Holiday] [BIT] NOT NULL
 ,[MessageBody] [VARCHAR](500) NULL
 ,[Title] [VARCHAR](100) NULL
 ,[EmailSubject] [VARCHAR](100) NULL
 ,[CoCd] [VARCHAR](5) NULL
 ,[EntryBy] [VARCHAR](50) NULL
 ,[EntryDt] [DATETIME] NULL
 ,[EditBy] [VARCHAR](50) NULL
 ,[EditDt] [DATETIME] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CompanyCalendar_N]
ADD CONSTRAINT [PK_CompanyCalendar_N] PRIMARY KEY CLUSTERED ([Cd])

CREATE TABLE [dbo].[EmpCalendar_N] (
  [SrNo] [INT] NULL
 ,[EmpCd] [CHAR](10) NOT NULL

 ,[Date] [DATETIME] NULL
 ,[Title] [VARCHAR](50) NULL
 ,[Holiday] [BIT] NULL
 ,[Narr] [VARCHAR](50) NULL

 ,[EntryBy] [CHAR](5) NULL
 ,[EntryDt] [DATETIME] NULL
 ,[EditBy] [CHAR](5) NULL
 ,[EditDt] [DATETIME] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EmpCalendar_N]
ADD CONSTRAINT [FK_EmpCalendar_Employee_N] FOREIGN KEY ([EmpCd]) REFERENCES [dbo].[Employee] ([Cd])

ALTER TABLE NotificationMaster
ADD EmailSubject varchar(100) NULL;

ALTER TABLE NotificationDetail
ADD EmpCd varchar(10) NULL;

ALTER TABLE Designation
DROP CONSTRAINT PK_Designation;

ALTER TABLE Designation
ALTER COLUMN CD CHAR(10) not null;

ALTER TABLE Designation
ADD CONSTRAINT PK_Designation PRIMARY KEY (Cd);