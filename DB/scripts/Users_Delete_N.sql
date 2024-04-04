-- select * from users userbranch sp_help users
CREATE Procedure [dbo].[Users_Delete_N]
	@v_cd		Varchar(10)
As		-- Drop Procedure Users_Delete_N '001'
Begin
	Begin Transaction
	Delete from UserMenu where UserCd=@v_cd
	Delete from UserPermission where UserCd =@v_cd
	Delete from UserBranch where UserCd =@v_cd
	Delete from Users where cd=@v_cd
	If @@error =0
		Commit Transaction
	Else
	  Begin
		Rollback Transaction	
		RAISERROR ('Can not Delete', 16,1)
	  End
End
