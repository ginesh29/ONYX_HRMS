GO
/** Object:  Table [dbo].[WidgetMaster]    Script Date: 16/05/2024 12:31:04 **/
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
	[Type] [varchar](1) NULL
 CONSTRAINT [PK_WidgetMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [LSHRMS]
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP001', N'emp_basic_details', N'Employee Basic Details', N'EmpBasicDetail', 1, N'E')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP0010', N'return_list', N'Return List', N'EmpLeaves?type=4', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP0011', N'not_joined_list', N'Not Joined List', N'EmpLeaves?type=5', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP0012', N'birthday_events', N'Birthday/Work Anniversary', N'EmpBirthdayEvents', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP0013', N'doc_expiry_waiting', N'Document Expiry Waiting List', N'DocExpired', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP002', N'my_documents', N'My Documents', N'MyDocuments', 1, N'E')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP003', N'my_leaves', N'My Leave', N'MyLeaves', 1, N'E')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP004', N'my_loans', N'My Loans', N'MyLoans', 1, N'E')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP005', N'salary_chart', N'Employee Salary Chart', N'EmpSalaryChart', 1, N'E')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP006', N'user-salary_chart', N'User Salary Chart', N'UserSalaryChart', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP007', N'emp_analysis_chart', N'Employee Analysis', N'EmpAnalysisChart', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP008', N'emp_statistics_chart', N'Employee Statistics', N'EmpStatisticsChart', 1, N'U')
GO
INSERT [dbo].[WidgetMaster] ([Id], [Des], [Title], [Url], [Active], [Type]) VALUES (N'COMP009', N'leave_list', N'Leave List', N'EmpLeaves?type=3', 1, N'U')
GO


--select * from WidgetMaster






USE [LSHRMS]
GO

/****** Object:  Table [dbo].[UserWidgets]    Script Date: 16/05/2024 10:50:27 AM ******/
SET ANSI_NULLS ON
GO--drop table UserWidgets

SET QUOTED_IDENTIFIER ON
GO

USE [LSHRMS]
GO

/****** Object:  Table [dbo].[UserWidgets]    Script Date: 16/05/2024 10:50:27 AM ******/
SET ANSI_NULLS ON
GO--drop table UserWidgets

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserWidgets](
	[UserCd] [varchar](10) NOT NULL,
	[Widget_Id] [varchar](10) NOT NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[W] [int] NULL,
	[H] [int] NULL,
 CONSTRAINT [PK_UserWidgets] PRIMARY KEY CLUSTERED 
(
	[UserCd] ASC,
	[Widget_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserWidgets]  WITH CHECK ADD  CONSTRAINT [FK_UserWidgets_WidgetMaster] FOREIGN KEY([Widget_Id])
REFERENCES [dbo].[WidgetMaster] ([Id])
GO

ALTER TABLE [dbo].[UserWidgets] CHECK CONSTRAINT [FK_UserWidgets_WidgetMaster]
GO




ALTER TABLE [dbo].[UserWidgets]  WITH CHECK ADD  CONSTRAINT [FK_UserWidgets_WidgetMaster] FOREIGN KEY([Widget_Id])
REFERENCES [dbo].[WidgetMaster] ([Id])
GO

ALTER TABLE [dbo].[UserWidgets] CHECK CONSTRAINT [FK_UserWidgets_WidgetMaster]
GO





	
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
--,	@v_Widget_Id    Varchar(10)
As
	Go
	select 
			U.*,M.*
	from 
			UserWidgets U,WidgetMaster M
	where
				U.Widget_Id =M.Id
		and		(U.UserCd=@v_UserCd or @v_UserCd='')
		--and		(U.Widget_Id=@v_Widget_Id or @v_Widget_Id='')
		and		isnull(M.active,0)=1

End
Create or ALTER procedure [dbo].[WidgetMaster_GetRow]
--drop procedure [dbo].[dbo].[UserWidgets_GetRow] '',''
	
As
	select * from WidgetMaster  where	isnull(active,0)=1


