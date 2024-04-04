CREATE Procedure [dbo].[VehDocImages_Delete_N]
	@v_VehCd		Char(10)
,	@v_DocTyp		Char(10)
,	@v_SlNo			Char(1) = null
As		-- Drop Procedure [dbo].[VehDocImages_Delete_N]
Begin
	--Declare @v_DocTyp Char(10)
	--Select @v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes 
	Delete from VehDocImages where VehCd = @v_VehCd and DocTyp=@v_DocTyp and SlNo= @v_SlNo
	exec GetMessage 1,'Deleted successfully'
End
