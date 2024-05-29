insert into MenuCtrl_N values('H','8','0','Q-Management',201,'O','/Queue/Q-Management','Y',NULL,'HRPTM')
insert into MenuCtrl_N values('H','81','8','Counters',202,'O','/Queue/Counters','Y',NULL,'HRPTM1')
insert into MenuCtrl_N values('H','82','8','Services',203,'O','/Queue/Services','Y',NULL,'HRPTM2')
insert into MenuCtrl_N values('H','83','8','Tokens',204,'O','/Queue/Tokens','Y',NULL,'HRPTM3')
insert into MenuCtrl_N values('H','84','8','Display',205,'O','/Queue/Display','Y',NULL,'HRPTM4')


USE [LSHRMS_Telal_Live]
GO
/****** Object:  Table [dbo].[Counters]    Script Date: 27/05/2024 14:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Counters](
	[Cd] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[EntryBy] [varchar](10) NULL,
	[EntryDt] [datetime] NULL,
	[EditBy] [varchar](10) NULL,
	[EditDt] [datetime] NULL,
 CONSTRAINT [PK_Counters] PRIMARY KEY CLUSTERED 
(
	[Cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 27/05/2024 14:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[Cd] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Prefix] [varchar](5) NOT NULL,
	[Active] [bit] NOT NULL,
	[EntryBy] [varchar](10) NULL,
	[EntryDt] [datetime] NULL,
	[EditBy] [varchar](10) NULL,
	[EditDt] [datetime] NULL,
 CONSTRAINT [PK_Services] PRIMARY KEY CLUSTERED 
(
	[Cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tokens]    Script Date: 27/05/2024 14:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tokens](
	[TokenNo] [varchar](20) NOT NULL,
	[ServiceCd] [varchar](20) NOT NULL,
	[MobileNo] [varchar](20) NULL,
	[Status] [bit] NOT NULL,
	[EntryBy] [varchar](10) NULL,
	[EntryDt] [datetime] NULL,
	[EditBy] [varchar](10) NULL,
	[EditDt] [datetime] NULL,
 CONSTRAINT [PK_Tokens_1] PRIMARY KEY CLUSTERED 
(
	[TokenNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- =============================================
-- Author:		Ginesh
-- CREATE OR ALTER date: 21/05/2024
-- =============================================
CREATE OR ALTER       PROCEDURE [dbo].[Token_Getrow]
	@v_TokenNo varchar(10)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select *
	,	(select name from Services where Cd = t.ServiceCd)[ServiceName]
		from Tokens as t where TokenNo= @v_TokenNo or @v_TokenNo = ''
END
 
 Go 
-- =============================================
-- Author:		Ginesh
-- CREATE OR ALTER date: 21/05/2024
-- =============================================
CREATE OR ALTER     PROCEDURE [dbo].[Service_Getrow]
	@v_ServiceCd varchar(10)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from Services where Cd= @v_ServiceCd or @v_ServiceCd = ''
END
 
 Go 
-- =============================================
-- Author:		Ginesh
-- CREATE OR ALTER date: 21/05/2024
-- =============================================
CREATE OR ALTER     PROCEDURE [dbo].[Token_Update]
	@v_TokenNo	varchar(20),
	@v_ServiceCd varchar(10),
	@v_MobileNo varchar(20),
	@v_Status varchar(5),
	@v_EntryBy varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

   Begin
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Tokens WHERE TokenNo = @v_TokenNo)
	  Begin
		insert into Tokens values(
			@v_TokenNo
		,	@v_ServiceCd
		,	@v_MobileNo
		,	@v_Status
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else 
		Begin
			Update Tokens Set
				@v_Status= @v_Status
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			Where
				TokenNo = @v_TokenNo
			exec GetMessage 1,'Updated successfully'
		End
End
	
END
 
 Go 
-- =============================================
-- Author:		Ginesh
-- CREATE OR ALTER date: 21/05/2024
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[Service_Update]
	@v_ServiceCd varchar(10),
	@v_ServiceName varchar(50),
	@v_ServicePrefix varchar(5),
	@v_Active bit,
	@v_EntryBy varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

   Begin
	--declare @NewCd  varchar(10)
	--set @NewCd = exec [Codes_Auto_GetRow] @v_Typ
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Services WHERE Cd = @v_ServiceCd)
	  Begin
		insert into Services values(
			@v_ServiceCd
		,	@v_ServiceName
		,	@v_ServicePrefix
		,	@v_Active
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else 
		Begin
			Update Services
				Set
				Name= @v_ServiceName
			,	Prefix= @v_ServicePrefix
			,	Active=@v_Active
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			Where
				Cd = @v_ServiceCd
			exec GetMessage 1,'Updated successfully'
		End
End
	
END
 
 Go 
-- =============================================
-- Author:		Ginesh
-- CREATE OR ALTER date: 21/05/2024
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[Counter_Update]
	@v_CounterCd varchar(10),
	@v_CounterName varchar(50),
	@v_Active bit,
	@v_EntryBy varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

   Begin
	--declare @NewCd  varchar(10)
	--set @NewCd = exec [Codes_Auto_GetRow] @v_Typ
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Counters WHERE Cd = @v_CounterCd)
	  Begin
		insert into Counters values(
			@v_CounterCd
		,	@v_CounterName
		,	@v_Active
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else 
		Begin
			Update Counters
				Set
				Name= @v_CounterName
			,	Active=@v_Active
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			Where
				Cd = @v_CounterCd
			exec GetMessage 1,'Updated successfully'
		End
End
	
END
 
 Go 
-- =============================================
-- Author:		Ginesh
-- CREATE OR ALTER date: 21/05/2024
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[Service_Delete]
	@v_ServiceCd varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

    Delete from Services where Cd= @v_ServiceCd
END
