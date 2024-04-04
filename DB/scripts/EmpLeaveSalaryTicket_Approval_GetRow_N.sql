CREATE Procedure [dbo].[EmpLeaveSalaryTicket_Approval_GetRow_N]
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
,	@v_Usercd		varchar(10)
As		-- Drop Procedure [dbo].[EmpLeaveSalaryTicket_Approval_GetRow_N] '','3','100','HR','U'  
Begin	
	Declare @FinalAuth Char(10)
	Select @FinalAuth=Val from Parameters where Cd='LV_APPR_AUTH' and Appcd='HR' and Cocd=@v_CoCd
	Select
		TransNo[TransNo]
	,	TransDt[TransDt] 
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmpCd]  
	,	Rtrim(FName)+' '+Rtrim(MName)+' '+Rtrim(LName) [Emp]
	,	LvSalary
	,	LvTicket
		
	,	case when @v_Typ in ('1','4','3')
		then
		(select  SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS3' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval_Level]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS3' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(Case when((select  SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS3' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
			=(select Top 1 SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS3' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd order by SrNo Desc))
			then 
				(STUFF((SELECT ', ' + CAST((Select Fname From Employee where Cd=EmpCd) AS VARCHAR(10)) [text()]
				FROM CompanyProcessApprovalDetail as CPAD
				WHERE CPAD.ProcessId='HRPSS3' 
				and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
				and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
				and CPAD.CoCd=@v_CoCd
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '))
			End
		)
		end[Approvals]
	
		
	From	-- Modified by Rasheed( otherwise list all employees)
		EmpLeaveSalaryTicket EL left outer join Employee Emp on EL.empcd=Emp.Cd
	Where	-- Modified by Rasheed (Need to show only new applications for approval)
		Emp.Cd=EL.EmpCd and Emp.CoCd=@v_CoCd 
		 and emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd='')) and
	
	 (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and EL.Status = 'N'  or
		@v_Typ='1' and TransNo=@v_Param and EL.Status = 'N'  or
		@v_Typ='2' and EL.empcd=@v_Param and EL.Status = 'N'  or
		@v_Typ='4' and TransNo=@v_Param and EL.Status = 'F'  or
		@v_Typ='3' and EL.Status = 'N' and TransNo in( select TransNo as LeaveApproval  from EmpLeaveSalaryTicket
				inner join Employee as emp on emp.Cd=EmpLeaveSalaryTicket.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS3' and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				EmpLeaveSalaryTicket.Status='N' 
				and emp.CoCd=@v_CoCd
				and emp.Status='HSTATPM   '
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select top 1 SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS3' and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) )))
			
	)
	Order By
		TransNo
End
