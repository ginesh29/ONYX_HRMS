
CREATE Procedure [dbo].[Users_GetRow_N]
	@v_Cd		Varchar(10)
As		-- Drop Procedure [dbo].[Users_GetRow_N] ''
Begin	-- Select * from sp_help users
	Select
		U.Cd[Code]
	,	U.Abbr[Abbr]
	,	U.LoginId[LoginId]
	,	U.UPwd
	,	U.UName[UserName]
	,	U.Expirydt[ExpiryDt]
	,	U.EntryBy
	,	U.EntryDt
	,	U.EditBy
	,	U.EditDt
	From
		Users U
	Where
		(@v_Cd='' or U.Cd=@v_Cd)
	Order by
		U.Cd
End
