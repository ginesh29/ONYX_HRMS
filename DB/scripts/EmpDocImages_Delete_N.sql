CREATE Procedure [dbo].[EmpDocImages_Delete_N]
	@v_EmpCd		Char(10)
,	@v_DocTyp		Char(20)
,   @v_srNo			int
As		-- Drop Procedure [dbo].[EmpDocImages_Delete_N]
Begin
	--Declare @v_DocTyp Char(10)
	--Select @v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes 
	Delete from EmpDocImages where EmpCd = @v_EmpCd and DocTyp=@v_DocTyp and SlNo = @v_srNo
	exec GetMessage 1,'Deleted successfully'
End
