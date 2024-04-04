CREATE Procedure [dbo].[CompDocImages_Delete_N]
	@v_CoCd		Char(5)
,	@v_Div		Char(5)
,	@v_DocTyp		Char(10)
,	@v_SlNo		Char(5)
As		-- Drop Procedure [dbo].[CompDocImages_Delete_N]
Begin
	--Declare @v_DocTyp Char(10)
	--Select @v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes 
	Delete from CompDocImages where CompCd = @v_CoCd and Div=@v_Div and DocTyp=@v_DocTyp and SlNo=@v_SlNo
	exec GetMessage 1,'Deleted successfully'
End
