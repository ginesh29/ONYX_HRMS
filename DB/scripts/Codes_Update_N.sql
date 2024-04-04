CREATE Procedure [dbo].[Codes_Update_N]
	@v_Cd			Char(10)
,	@v_Typ			Char(5)
,	@v_Abbr			Char(5)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(200)
,	@v_EntryBy		Char(5)
,   @v_Mode			Char(1) =null
,	@v_Active		bit
As		-- Drop Procedure dbo.[Codes_Update_N]  -- SP_HELP CODES
Begin
	--declare @NewCd  varchar(10)
	--set @NewCd = exec [Codes_Auto_GetRow] @v_Typ
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Codes WHERE Cd = @v_Cd)
	  Begin
		insert into Codes values(
			@v_Cd
		,	@v_Typ
		,	@v_Abbr
		,	@v_SDes
		,	@v_Des
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		,	@v_Active)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else 
		IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	  Else
		Begin
			Update Codes
				Set
				Typ= @v_Typ
			,	Abbr=@v_Abbr
			,	SDes=@v_SDes
			,	Des=@v_Des
			,	Active=@v_Active
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			Where
				Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
		End
End
