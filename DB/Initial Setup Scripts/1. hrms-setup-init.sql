CREATE TABLE [dbo].[EmpCalendar_N] (
  [SrNo] [int] NULL,
  [EmpCd] [char](10) NOT NULL,
  [Date] [datetime] NULL,
  [Title] [varchar](50) NULL,
  [Holiday] [bit] NULL,
  [Narr] [varchar](50) NULL,
  [EntryBy] [char](5) NULL,
  [EntryDt] [datetime] NULL,
  [EditBy] [char](5) NULL,
  [EditDt] [datetime] NULL
)
ON [PRIMARY]

Go


CREATE TABLE [dbo].[MenuCtrl_N] (
  [AppCd] [CHAR](5) NOT NULL
 ,[MenuId] [CHAR](10) NOT NULL
 ,[Prnt] [CHAR](10) NULL
 ,[Caption] [VARCHAR](30) NULL
 ,[MenuOrder] [NUMERIC](5) NOT NULL
 ,[Typ] [CHAR](1) NULL
 ,[Frm] [VARCHAR](100) NULL
 ,[Active] [CHAR](1) NULL
 ,[Abbr] [CHAR](10) NULL
 ,[ProcessId] [VARCHAR](10) NULL
) ON [PRIMARY]

Go

CREATE TABLE [dbo].[UserPermission] (
  [UserCd] [VARCHAR](10) NOT NULL
 ,[MenuId] [CHAR](10) NOT NULL
 ,[uAdd] [CHAR](1) NULL
 ,[uEdit] [CHAR](1) NULL
 ,[uDelete] [CHAR](1) NULL
 ,[uView] [CHAR](1) NULL
 ,[uPrint] [CHAR](1) NULL
 ,[EntryBy] [CHAR](5) NULL
 ,[EntryDt] [DATETIME] NULL
 ,[EditBy] [CHAR](5) NULL
 ,[EditDt] [DATETIME] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserPermission]
ADD CONSTRAINT [PK_UserGroupMasters1] PRIMARY KEY CLUSTERED ([UserCd], [MenuId])
GO

ALTER TABLE [dbo].[UserPermission]
ADD CONSTRAINT [FK_UserGroupMasters_UserGroups1] FOREIGN KEY ([UserCd]) REFERENCES [dbo].[Users] ([Cd])

Go 

CREATE TABLE [dbo].[CalendarEventAttendees] (
  [EventCd] [VARCHAR](5) NOT NULL
 ,[EmpCd] [VARCHAR](10) NOT NULL
) ON [PRIMARY]

Go 

ALTER TABLE [dbo].[CodeGroups]
  ADD [Active] [bit] NULL

Go

ALTER TABLE [dbo].[CompanyLoanTypes]
  ADD [Active] [bit] NULL

Go

ALTER TABLE [dbo].[Codes]
  ADD [Active] [bit] NULL

GO

ALTER TABLE [dbo].[Branch]
  ADD [Image] [varchar](200) NULL

Go

ALTER TABLE [dbo].[EmpDocuments]
  ADD [Expiry] [bit] NULL

Go

ALTER TABLE [dbo].[CompanyLeave]
  ADD [Active] [bit] NULL

Go

ALTER TABLE [dbo].[NotificationDetail]
  ADD [EmpCd] [varchar](10) NULL

Go

ALTER TABLE [dbo].[NotificationMaster]
  ADD [EmailSubject] [varchar](100) NULL
GO

ALTER TABLE [dbo].[Employee]
  ADD [Email] varchar(50) NULL
  
GO

ALTER TABLE [dbo].[Designation]
  DROP CONSTRAINT [PK_Designation]
GO

ALTER TABLE [dbo].[Designation]
  ALTER
    COLUMN [Cd] [char](10) NOT NULL
Go
ALTER TABLE [dbo].[Designation]
  ADD CONSTRAINT [PK_Designation] PRIMARY KEY CLUSTERED ([Cd])
GO

ALTER TABLE [dbo].[Employee]
  ALTER
    COLUMN [Desg] [char](10) NOT NULL

Go
update EmpDocuments set Expiry = 1 where ExpDt is not null

Go

update Users set UPWD='MTIzNDU2' where Cd in('001','HR')