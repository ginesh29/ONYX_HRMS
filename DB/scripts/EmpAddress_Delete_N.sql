CREATE procedure [dbo].[EmpAddress_Delete_N]
	@v_EmpCd       	Char(10),
	@v_AddTyp	VarChar(20)
As
Begin
	Delete from EmpAddress where EmpCd = @v_EmpCd  and AddTyp=@v_AddTyp 
End
