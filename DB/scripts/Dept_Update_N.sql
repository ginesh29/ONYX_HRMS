CREATE Procedure [dbo].[Dept_Update_N]
	@v_Cd			Char(10)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(30)
,	@v_EntryBy		Char(5)
,	@v_Mode			Char(1) = null
As
Begin
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Dept WHERE Cd = @v_Cd)
	  Begin
		Insert into Dept Values
		(
			@v_Cd,
			@v_SDes,
			@v_Des,
			@v_EntryBy,
			getdate(),
			null,
			null
		)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else
		IF (@v_Mode = 'I')
			exec GetMessage 0,'Already exists'
		Else
		  Begin
			Update Dept
			Set
				SDes			= @v_SDes,
				Des				= @v_Des,
				EditBy			= @v_EntryBy,
				EditDt			= getdate()
			Where
				Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
		  End
			
End
