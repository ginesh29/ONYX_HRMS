USE [LSHRMS]
GO

/****** Object:  Table [dbo].[WidgetMaster]    Script Date: 15/05/2024 3:03:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WidgetMaster](
	[Id] [varchar](10) NOT NULL,
	[Des] [varchar](100) NULL,
	[Title] [varchar](100) NULL,
	[Url] [varchar](500) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_WidgetMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [LSHRMS]
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active]) VALUES (N'COMP001', N'emp_basic_details', N'Employee Basic Details', N'EmpBasicDetail', 1)
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active]) VALUES (N'COMP002', N'my_documents', N'My Documents', N'MyDocuments', 1)
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active]) VALUES (N'COMP003', N'my_leaves', N'My Leave', N'MyLeaves', 1)
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active]) VALUES (N'COMP004', N'my_loans', N'My Loans', N'MyLoans', 1)
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active]) VALUES (N'COMP005', N'salary_chart', N'Employee Salary Chart', N'EmpSalaryChart', 1)
GO




USE [LSHRMS]
GO

/****** Object:  Table [dbo].[UserWidgets]    Script Date: 15/05/2024 2:59:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO--drop table UserWidgets 

CREATE TABLE [dbo].[UserWidgets](
	[UserCd] [varchar](10) NOT NULL,
	[Widget_Id] [varchar](10) NOT NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[W] [int] NULL,
	[H] [int] NULL,
 CONSTRAINT [PK_UserWidgets] PRIMARY KEY CLUSTERED 
(
	[UserCd] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserWidgets]  WITH CHECK ADD  CONSTRAINT [FK_UserWidgets_WidgetMaster] FOREIGN KEY([Widget_Id])
REFERENCES [dbo].[WidgetMaster] ([Id])
GO

create or alter procedure  [dbo].[UserWidgets_Update]
		@v_UserCd                  	varchar(10)
	,	@v_Widget_Id              	Varchar(10)
	,	@v_XPos              		Int
	,	@v_YPos              		Int
	,	@v_Width              		Int
	,	@v_Height              		Int
	
as
begin
	IF ((SELECT COUNT(*) FROM UserWidgets WHERE usercd = @v_UserCd and Widget_Id=@v_Widget_Id) = 0)
	    Begin
		insert into UserWidgets (UserCd,Widget_Id,X,Y,W,H) 
		Values(
	        		@v_UserCd
	        	,	@v_Widget_Id
	        	,	@v_XPos
	        	,	@v_YPos
	        	,	@v_Width
	        	,	@v_Height
	        	)
	    end
	Else
	    Begin
	        Update UserWidgets
	     Set
			X		= @v_XPos
		,	Y		= @v_YPos
		,	W		= @v_Width
		,	H		= @v_Height
		
	where UserCd = @v_UserCd and Widget_Id=@v_Widget_Id
    End
End


create or alter procedure  [dbo].[UserWidgets_Delete]
		@v_UserCd                  	varchar(10)
	,	@v_Widget_Id              	Varchar(10)
as
begin
	Begin
	   delete from UserWidgets where UserCd = @v_UserCd and Widget_Id=@v_Widget_Id
    End
End


Create or ALTER procedure [dbo].[UserWidgets_GetRow]
--drop procedure [dbo].[dbo].[UserWidgets_GetRow] '',''
	@v_UserCd		varchar(10)
,	@v_Widget_Id    Varchar(10)
As
	select 
			U.*,M.*
	from 
			UserWidgets U,WidgetMaster M
	where
				U.Widget_Id =M.Id
		and		(U.UserCd=@v_UserCd or @v_UserCd='')
		and		(U.Widget_Id=@v_Widget_Id or @v_Widget_Id='')
		and		isnull(M.active,0)=1


Create or ALTER procedure [dbo].[WidgetMaster_GetRow]
--drop procedure [dbo].[dbo].[UserWidgets_GetRow] '',''
	
As
	select * from WidgetMaster  where	isnull(active,0)=1

ALTER TABLE WidgetMaster
ADD X varchar(5);

ALTER TABLE WidgetMaster
ADD Y varchar(5);

ALTER TABLE WidgetMaster
ADD H varchar(5);

ALTER TABLE WidgetMaster
ADD W varchar(5);
