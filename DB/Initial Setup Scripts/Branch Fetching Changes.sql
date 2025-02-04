alter table branch add Active Bit

USE [LSHRMS]
GO
/****** Object:  StoredProcedure [dbo].[GetUserBranches]    Script Date: 29/04/2024 11:25:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[GetUserBranches]
 @UserCd varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select Cd,b.Des Branch,ub.Des UserDes,[Image],isnull(Active,'0')[Active] into #Branch  from Branch b
	left join(select * from UserBranch where UserCd = @UserCd) ub on ub.Div = b.Cd  
	select * from #Branch where Active=1
	drop table #Branch
END

USE [LSHRMS]
GO
/****** Object:  StoredProcedure [dbo].[GetUserBranches_N]    Script Date: 29/04/2024 11:25:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[GetUserBranches_N]
 @UserCd varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select Cd,b.Des Branch,ub.Des UserDes,[Image], isnull(Active,'0')[Active] into #Branch  from Branch b
	left join(select * from UserBranch where UserCd = @UserCd) ub on ub.Div = b.Cd  
	select * from #Branch where Active=1
	drop table #Branch

END
 

USE [LSHRMS]
GO
/****** Object:  StoredProcedure [dbo].[Get_UserBranches]    Script Date: 29/04/2024 11:24:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Get_UserBranches]
@v_CoCd char(5),
@v_Abbr char(5)
as
begin
declare @User char(10)
select @User=cd from users where Abbr=@v_Abbr
select SDes from Branch 
	where Cd in(select Div from UserBranch where UserCd=@User) and
		CoCd = @v_CoCd and isnull(active,'0')='1'
	order by SDes
end

USE [LSHRMS]
GO
/****** Object:  StoredProcedure [dbo].[Branch_GetRow_N]    Script Date: 29/04/2024 11:22:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER     procedure [dbo].[Branch_GetRow_N]
	@v_Cd		varchar(5)=null
,	@v_CoCd		varchar(5)=null
As		-- Drop Procedure [dbo].[Branch_GetRow_N] '','01'
Begin	-- Select * from Branch
	Select
		Cd
	,	[Des]
	,	SDes
	,	[Image]
	,	EntryBy
	,	EntryDt
	,	EditBy
	,	EditDt
	,	BU_Cd
	,	(Select SDes From BusinessUnits Where Cd=BU_Cd)[BU_SDes]
	From
		Branch
	Where
		CoCd = @v_CoCd
	and	(Cd = @v_Cd or @v_Cd = '')
	and isnull(active,'0')='1'
	order by Des 
End
 
 
USE [LSHRMS]
GO
/****** Object:  StoredProcedure [dbo].[Branch_Count]    Script Date: 29/04/2024 11:39:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[Branch_Count]
@v_CoCd char(5)
As		-- Drop Procedure [dbo].[Branch_Count]'0'
Begin
    select COUNT(1) from branch where (@v_CoCd='' or CoCd=@v_CoCd) and isnull(Active,0)=1
End

