CREATE Procedure [dbo].[CompDocImages_Update_N]
	@v_CoCd				Char(10)
,	@v_Div				Char(5)
,	@v_DocTyp			Char(10)		-- sp_help EmpDocImages Empdocuments
,	@v_SlNo				int
,	@v_ImageFile		VarChar(200)
,	@v_EntryBy			Char(5)
As		-- Drop Procedure [dbo].[CompDocImages_Update_N]
Begin
	set nocount on
	--declare @v_DocTyp Char(10)
	--select 	@v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes and Typ='HDTYP'
	IF (SELECT COUNT(*) FROM CompDocImages WHERE CompCd =@v_CoCd and Div=@v_Div and DocTyp=@v_DocTyp and SlNo=@v_SlNo) = 0
	  Begin
		insert into CompDocImages
		values
		(
			@v_CoCd
		,	@v_Div
		,	@v_DocTyp
		,	@v_SlNo
		,	@v_ImageFile
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		)
		print 'I'
	  end
	Else
	  Begin
		Update CompDocImages
		  Set
			ImageFile=@v_ImageFile
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		where
			CompCd =@v_CoCd and Div=@v_Div and DocTyp=@v_DocTyp and SlNo=@v_SlNo
			print 'U'
	  End
End
