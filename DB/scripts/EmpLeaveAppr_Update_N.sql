CREATE procedure [dbo].[EmpLeaveAppr_Update_N]
@v_TransNo		char(10),
@v_ApprLvl		numeric(5),
@v_LvApprDays		numeric(5),
@v_LvApprBy		char(10),
@v_LvApprDt		datetime,
@v_Status		char(1),
@v_WP_FromDt		datetime,
@v_WP_ToDt		datetime,
@v_WOP_FromDt		datetime,
@v_WOP_ToDt		datetime,
@v_Narr			varchar(100),
@v_EntryBy		char(5),
@v_Reason		varchar(100)
as
begin
IF (SELECT COUNT(*) FROM EmpLeaveAppr WHERE TransNo = @v_TransNo and ApprLvl=@v_ApprLvl) = 0
    Begin
        insert into EmpLeaveAppr(TransNo,ApprLvl,LvApprDays,LvApprBy,LvApprDt,Status,WP_FromDt,WP_ToDt,WOP_FromDt,WOP_ToDt,Narr,EntryBy,EntryDt,Reason) values
			(
			@v_TransNo,
			@v_ApprLvl,
			@v_LvApprDays,
			@v_LvApprBy,
			@v_LvApprDt,
			@v_Status,
			@v_WP_FromDt,
			@v_WP_ToDt,
			@v_WOP_FromDt,
			@v_WOP_ToDt,
			@v_Narr,
			@v_EntryBy,
			getdate(),
			@v_Reason
			)
    end
Else
    Begin
        Update EmpLeaveAppr
		Set
			LvApprDays 	=@v_LvApprDays,
			LvApprBy	=@v_LvApprBy,
			LvApprDt	=@v_LvApprDt,
			Status		=@v_Status,
			WP_FromDt	=@v_WP_FromDt,
			WP_ToDt		=@v_WP_ToDt,
			WOP_FromDT	=@v_WOP_FromDt,
			WOP_ToDt	=@v_WOP_ToDt,
			Narr		=@v_Narr,
			EditBy		=@v_EntryBy,
			EditDt		=Getdate(),
			Reason		=@v_Reason
			WHERE TransNo = @v_TransNo and ApprLvl=@v_ApprLvl
		End
End
