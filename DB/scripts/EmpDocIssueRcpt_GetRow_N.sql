
CREATE PROCEDURE [dbo].[EmpDocIssueRcpt_GetRow_N]
	@v_EmpCd		char(10)
,	@v_DocTyp		char(10)
,	@v_Typ			char(1)
,	@v_SrNo			numeric(5)
,	@v_LoginEmpCd		Char(10)
,	@v_EmpUser		Char(1)
--drop PROCEDURE [dbo].[EmpDocIssueRcpt_GetRow_N]'','','1','0','001','U'
as
select 
			
		ED.EmpCd[EmployeeCode]
	, Emp.Fname+' '+isnull(Emp.Mname,'')+' '+Emp.Lname [EmpName]
	,	ED.SrNo
	,	ED.DocTyp [DocType]
	,	ED.DocNo[DocNo]
	,	ED.IssueDt[IssueDt]
	,	ED.TrnDt
	,	ED.ExpDt[ExpDt]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Cod.SDes[DocTypeDes]
	,	CONVERT(Varchar(20),ED.TrnDt,103)[FormatedTransDate]
	,	ED.TrnDt[TransDate ]
	,	case when ED.TrnTyp='I' then 'Issue' else 'Receive' end [TrnTypDes]
	,	ED.TrnTyp
	,	Cod1.SDes[DocumentStatus]
	,	ED.Narr
	,	ED.DocStat[DocStat]
	,	ED.Stat[Status]
	,	ED.EntryBy[EntryBy]
	,	ED.EntryDt[EntryDate]
	,	ED.EditBy[EditedBy]
	,	ED.EditDt[EditDate]	
	,	ED.ApprDate[ApprDate]
	,	ED.ApprBy[ApprBy]
	,	CONVERT(Varchar(20),ED.ApprDate,103)[FormatedApprDate]
	
	,	case when @v_Typ = '2'
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD, Employee E
			where CPAD.ProcessId='HRPT8' 
			and CPAD.ApplTyp=ED.DocTyp
			and CPAD.Div=E.Div--(select Div from Employee where Cd=ED.EmpCd)
			and CPAD.Dept= E.Dept --(select Dept from Employee where Cd=ED.EmpCd)
			and E.cd=ED.EmpCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd))))
		
		end[Current_Approval_Level]
	,	case when @v_Typ = '2'
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT8' 
			and CPAD.ApplTyp=ED.DocTyp
			and CPAD.Div=(select Div from Employee where Cd=ED.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=ED.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd))))
		
		end[Current_Approval]
		
	from 
		Employee Emp
	,	EmpDocIssueRcpt ED
	,	Codes 	Cod
	,	Codes   cod1
	where 
		Emp.Cd=Ed.EmpCd
	and	Cod.Cd=Ed.DocTyp 
	and	Cod1.Cd=ED.DocStat	
	and Ed.Stat='N'
	and	emp.Status='HSTATPM'
	and(@v_DocTyp=''  or ED.DocTyp=@v_DocTyp)
	and(@v_EmpCd='' or  ED.EmpCd=@v_EmpCd)
	and (@v_Typ=0 or
	(@v_Typ=2 and ED.SrNo=@v_SrNo)or
	(@v_Typ=1 and ED.EmpCd in( select EDIR.EmpCd from EmpDocIssueRcpt as EDIR
				inner join Employee as emp on emp.Cd=EDIR.EmpCd
				inner join CompanyProcessApproval as CPA on TRIM(CPA.ProcessId)='HRPT8' and trim(CPA.ApplTyp)=EDIR.DocTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				 EDIR.Stat='N'
				and	emp.Status='HSTATPM'
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_LoginEmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT8' and ApplTyp=EDIR.DocTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_LoginEmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd))) )))
			and DocTyp in( select DocTyp from EmpDocIssueRcpt EDIR
				inner join Employee as emp on emp.Cd=EDIR.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT8' and CPA.ApplTyp=EDIR.DocTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where  
				EDIR.Stat='N'
				and	emp.Status='HSTATPM'
				and
				 ((isnull(ApprBy,'') ='' and ((@v_EmpUser='E' and CPAD.EmpCd=@v_LoginEmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd)))  and cpad.SrNo='1')
					or (isnull(ApprBy,'')<>'' 
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT8' and ApplTyp=EDIR.DocTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_LoginEmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd))) )))
			and SrNo in( select EDIR.SrNo from EmpDocIssueRcpt as EDIR
				inner join Employee as emp on emp.Cd=EDIR.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT8' and CPA.ApplTyp=EDIR.DocTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				EDIR.Stat='N'
				and	emp.Status='HSTATPM'
				and
				 ((isnull(ApprBy,'') ='' and ((@v_EmpUser='E' and CPAD.EmpCd=@v_LoginEmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd)))  and cpad.SrNo='1')
					or (isnull(ApprBy,'') <>''
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT8' and ApplTyp=EDIR.DocTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_LoginEmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_LoginEmpCd))) )))
	))
	order by 
		ED.EmpCd
	,	ED.SrNo

