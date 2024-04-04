CREATE Procedure [dbo].[Users_Update_N]
		@v_Cd			varchar(10)=null
	,	@v_LoginId		varchar(15)=null
	,	@v_Abbr			varchar(5)=null
	,	@v_UPWD			varchar(200)=null
	,	@v_UName		varchar(30)=null
	,	@v_ExpiryDt		varchar(10)=null
	,	@v_EntryBy		varchar(5)=null
	,   @v_Mode			char(1) = null
As	
Begin	
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Users WHERE Cd = @v_Cd)
		Begin
			Insert into Users (Cd, LoginId, Abbr, UPwd, UName, ExpiryDt, EntryBy, EntryDt)
			Values (@v_Cd, @v_LoginId, @v_Abbr, @v_UPWD, @v_UName, @v_ExpiryDt, @v_EntryBy, Getdate())
			exec GetMessage 1,'Inserted successfully'
		End
	Else
		IF (@v_Mode = 'I')
			exec GetMessage 0,'Already Exists'
		Else
		  Begin
			Update Users
			Set
				LoginId = @v_LoginId
			,	Abbr=@v_abbr
			,	Uname=@v_UName
			,   UPWD=@v_UPWD
			,	expirydt=@v_ExpiryDt
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
  			Where
				Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
		  End
End
