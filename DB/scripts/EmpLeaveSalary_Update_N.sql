CREATE Procedure [dbo].[EmpLeaveSalary_Update_N]	
	@v_TransNo		char(30)
,	@v_TransDt		datetime
,	@v_EmpCd		char(10)
,	@v_LvSalary		numeric(9,3)
,	@v_LvTicket		numeric(15,4)
,	@v_EntryBy		Char(5)
As  --DROP PROCEDURE [EmpLeaveSalary_Update_N]'00028','09/07/2016','MHM/020   ','3800','1200','Admin'
Begin
	IF (Select COUNT(*) From EmpLeaveSalaryTicket Where TransNo=@v_TransNo) = 0
	  Begin
		insert into EmpLeaveSalaryTicket(TransNo,TransDt,EmpCd,
		LvSalary,LvTicket,Status,EntryBy,EntryDt)
		Values(
			  @v_TransNo
		,     @v_TransDt
		,     @v_EmpCd
		,     @v_LvSalary
		,     @v_LvTicket
		,     'N'
		,     @v_EntryBy
		,     getdate())
		
		if((select COUNT(*) From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPSS3' 
						and CPAD.Div=(select Div from Employee where Cd=@v_EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=@v_EmpCd)
						and CPAD.CoCd=(select CoCd from Employee where Cd=@v_EmpCd))=0)
		BEGIN
				Update EmpLeaveSalaryTicket Set
				Status='Y'
			,	ApprBy=@v_EntryBy
			,	ApprDt=getdate()
			Where
				TransNo=@v_TransNo
				exec GetMessage 1,'Inserted successfully'
		END

	  End
	Else
	  Begin
		Update EmpLeaveSalaryTicket Set
			TransDt=@v_TransDt
		,	EmpCd=@v_EmpCd
		,	LvSalary=@v_LvSalary
		,	LvTicket=@v_LvTicket
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		Where
			TransNo=@v_TransNo
			exec GetMessage 1,'Updated successfully'
	  End
End
