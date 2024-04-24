


CREATE OR ALTER   procedure [dbo].[Empleave_View_Getrow_N]    
	@v_Empcd	char(40)
 ,  @v_TransNo	Char(10) 
 ,	@v_Typ		Char(1)=''
 ,	@v_Div			char(5)='0'
 ,	@v_Dept			char(10)='0'
 ,	@v_UserCd		char(10)='001'
As  --Drop Procedure [Empleave_View_Getrow_N]  '','','' ,'0','0','001'   
begin 
	
	if @v_Empcd<>''
	Begin
	set @v_Empcd = ltrim(rtrim(@v_Empcd))   
	set @v_Empcd = '%' + ltrim(rtrim(@v_Empcd)) + '%'  
	end
	if @v_TransNo =''    
		select    
		el.TransNo    
	,	el.TransDt[AppDt]  
	,	CONVERT(varchar(20),el.TransDt,101)[FormatedTransDt]  
	,	el.EmpCd[EmpCd]    
	,	e.FName+' '+e.Mname+' '+e.Lname[Emp]    
	-- , (select SDes from Designation where Cd=e.Desg)[Desg]    
	-- , (select SDes from Branch where Cd=e.Div)[Div]    
	, e.Dept[Dept]    
	,	c.Sdes[LvTyp]    
	,	cast(el.LvTaken as int)[LvTaken]     
	,	el.DocDt[DocDt]   
	,	CONVERT(varchar(20),el.DocDt,101)[FormatedDocDt]  
	,	el.Substitute    
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=el.Substitute)  [Substitute]    
	,	el.FromDt  
	,	CONVERT(varchar(20),el.FromDt,101)[FormatedFromDt]   
	,	el.ToDt    
	,	CONVERT(varchar(20),el.ToDt,101)[FormatedToDt] 
	,	el.LvInter    
	
	,	case el.WP_FromDt    
		when '01/01/1900' then null    
		else el.WP_FromDt    
		end[WpFrom]  
	,	case el.WP_FromDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.WP_FromDt ,101)   
		end[FormatedWP_FromDt] 
		  
	,	case el.Wp_ToDt    
		when '01/01/1900' then null    
		else el.Wp_ToDt    
		end[WpTo]  
	,	case el.Wp_ToDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.Wp_ToDt ,101)   
		end[FormatedWp_ToDt] 
		  
	,	case el.WOP_FromDt    
		when '01/01/1900' then null    
		else el.WOP_FromDt    
		end[WopFrom]  
	,	case el.WOP_FromDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.WOP_FromDt ,101)   
		end[FormatedWOP_FromDt]
		  
	,	case el.WOP_ToDt    
		when  '01/01/1900' then null    
		else el.WOP_ToDt    
		end[WopTo] 
	,	case el.WOP_ToDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.WOP_ToDt ,101)   
		end[FormatedWOP_ToDt]
		  
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=el.LvApprBy)  [ApprBy]    
	,	case el.LvApprDt    
		when  '01/01/1900' then null    
		else el.LvApprDt    
		end[ApprDt] 

	,	case el.LvApprDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.LvApprDt ,101)   
		end[FormatedApprDt]  

	,	el.LvApprDays[ApprDays]
	,	Div
	,	(select des from branch where cd=(select div from Employee where cd=el.EmpCd))[Branch]
	,	(select des from Designation where cd=Desg)[Designation]
		from    
		EmpLeave el    
	,	CompanyLeave c    
	,	Employee e    
		where    
		C.cd= el.LvTyp     
		and e.cd=el.EmpCd    
		--and (e.Cd=@v_Empcd or @v_EmpCd = '')   
		and e.cd in( select cd from employee where (Div=@v_Div or (@v_Div='0' and div in (select div from UserBranch where UserCd=@v_UserCd))))
		and	 e.cd in(select cd from employee where (Dept=@v_Dept or @v_Dept='0'))
		and e.cd in (select cd from employee e where e.FName like ltrim(rtrim(@v_Empcd))  or e.MName like  ltrim(rtrim(@v_Empcd)) or e.LName like ltrim(rtrim(@v_Empcd)) or e.Cd like ltrim(rtrim(@v_Empcd))or ltrim(rtrim(@v_Empcd))='')
		and el.JoinDt is null    
	-- and el.Typ='M'    
	-- and el.LvStatus not in ('N','C','F')    
		and (@v_Typ='' and el.LvStatus <> 'N' and el.LvStatus <> 'C' and el.LvStatus <> 'F' and el.LvStatus <> 'R'
		or	@v_Typ='D'  and el.LvStatus = 'F')
	else    
		select    
		el.TransNo    
	,	el.TransDt[AppDt]   
	,	CONVERT(varchar(20),el.TransDt,101)[FormatedTransDt]  
	,	el.EmpCd[EmpCd]    
	,	e.FName+' '+e.Mname+' '+e.Lname[Emp]    
	-- , (select SDes from Designation where Cd=e.Desg)[Desg]    
	-- , (select SDes from Branch where Cd=e.Div)[Div]    
	, (select SDes from Dept where Cd=e.Dept)[Dept]    
	,	c.Sdes[LvTyp]    
	,	el.LvTaken[LvTaken]     
	,	el.DocDt[DocDt]    
	,	CONVERT(varchar(20),el.DocDt,101)[FormatedDocDt]  
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=el.Substitute)  [Substitute]    
	,	el.FromDt    
	,	CONVERT(varchar(20),el.FromDt,101)[FormatedFromDt]  
	,	el.ToDt  
	,	CONVERT(varchar(20),el.ToDt,101)[FormatedToDt]   
	,	el.LvInter  
	  
	,	case el.WP_FromDt    
		when '01/01/1900' then null    
		else el.WP_FromDt    
		end[WpFrom]  
	,	case el.WP_FromDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.WP_FromDt ,101)   
		end[FormatedWP_FromDt] 
		  
	,	case el.Wp_ToDt    
		when '01/01/1900' then null    
		else el.Wp_ToDt    
		end[WpTo]  
	,	case el.Wp_ToDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.Wp_ToDt ,101)   
		end[FormatedWp_ToDt] 
		  
	,	case el.WOP_FromDt    
		when '01/01/1900' then null    
		else el.WOP_FromDt    
		end[WopFrom]  
	,	case el.WOP_FromDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.WOP_FromDt ,101)   
		end[FormatedWOP_FromDt]
		  
	,	case el.WOP_ToDt    
		when  '01/01/1900' then null    
		else el.WOP_ToDt    
		end[WopTo] 
	,	case el.WOP_ToDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.WOP_ToDt ,101)   
		end[FormatedWOP_ToDt]
		   
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=el.LvApprBy)  [ApprBy]   
	 
	,	case el.LvApprDt    
		when  '01/01/1900' then null    
		else el.LvApprDt    
		end[ApprDt]    
	,	case el.LvApprDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.LvApprDt ,101)   
		end[FormatedApprDt] 

	,	el.LvApprDays[ApprDays] 
	,	el.Narr[ContactNumber]    
	,	Div
	,	(select des from branch where cd=(select div from Employee where cd=el.EmpCd))[Branch]
	,	(select des from Designation where cd=Desg)[Designation]
	,	Dept[DeptCd]
		from    
		EmpLeave el    
	,	CompanyLeave c    
	,	Employee e    
		where    
		C.cd= el.LvTyp     
		and e.cd=el.EmpCd    
		and el.TransNo=@v_TransNo  
		and e.cd in( select cd from employee where (Div=@v_Div or (@v_Div='0' and div in (select div from UserBranch where UserCd=@v_UserCd))))
		and	 e.cd in(select cd from employee where (Dept=@v_Dept or @v_Dept='0'))
		and e.cd in (select cd from employee e where e.FName like ltrim(rtrim(@v_Empcd))  or e.MName like  ltrim(rtrim(@v_Empcd)) or e.LName like ltrim(rtrim(@v_Empcd)) or e.Cd like ltrim(rtrim(@v_Empcd))or ltrim(rtrim(@v_Empcd))='')
		and e.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	-- and el.Typ='M'    
	-- and el.LvStatus not in ('C','R')    
		and (@v_Typ='' and el.LvStatus <> 'N' and el.LvStatus <> 'C' and el.LvStatus <> 'F' and el.LvStatus <> 'R'
		or	@v_Typ='D'  and el.LvStatus = 'F') 

End
 
 
 Go 



CREATE OR ALTER   Procedure [dbo].[EmpLeave_Approval_GetRow_N]
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
,	@v_Div			char(5)='0'
,	@v_Dept			char(10)='0'
,	@v_EmpCd1		varchar(40)=''
,	@v_Usercd		varchar(10)
As		-- Drop Procedure [dbo].[EmpLeave_Approval_GetRow_N] '','3','01','HR','U','0','0','145'  -- List all New Leave Applications for approval(Here @v_Type=3)
Begin	
	Declare @FinalAuth Char(10)
	Select @FinalAuth=Val from Parameters where Cd='LV_APPR_AUTH' and Appcd='HR' and Cocd=@v_CoCd
	Select
		TransNo[TransNo]
	,	TransDt[TransDt] 
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmpCd]  
	,	Rtrim(FName)+' '+Rtrim(MName)+' '+Rtrim(LName) [Emp]
	,	(select des from Designation where cd=Desg)[Desg]
	,	C.des [LvTyp]  
	,	EL.LvTyp [LvTypCd]
	,	EL.FromDt [LvFrom]
	,	CONVERT(varchar(20),EL.FromDt,103)[FormatedFromDt]
	,	EL.ToDt [LvTo]
	,	CONVERT(varchar(20),EL.ToDt,103)[FormatedToDt]
	
	,	Cast(EL.LvTaken As Int) [LvTaken]
	,	EL.DocRef [DocRef]
	,	EL.DocDt [DocDt]
	,	CONVERT(varchar(20),EL.DocDt,103)[FormatedDocDt]
	,	EL.SubStitute [SubCd]
	,	(select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName) from Employee where cd=EL.SubStitute) [SubName]
	,	(select Imagefile from Employee where cd= EL.EmpCd) [ImagePath]
	,	EL.Reason [Reason]
	
	,	case WP_FromDt
		when '01/01/1900' then null  
		else WP_FromDt
		end [WP_FromDt]
		
	,	case WP_FromDt
		when '01/01/1900' then null  
		else CONVERT(varchar(20),WP_FromDt,103)
		end [FormatedWPFromDt]
		
	,	case WP_ToDt
		when '01/01/1900' then null
		else WP_ToDt
		end [WP_ToDt]
		
	,	case WP_ToDt
		when '01/01/1900' then null
		else CONVERT(varchar(20),WP_ToDt,103)
		end [FormatedWPToDt]
		
	,	case WOP_FromDt
		when '01/01/1900' then null
		else WOP_FromDt
		end [WOP_FromDt]
		
	,	case WOP_FromDt
		when '01/01/1900' then null
		else CONVERT(varchar(20),WOP_FromDt,103)
		end [FormatedWOPFromDt]
		
	,	case WOP_ToDt
		when '01/01/1900' then null
		else WOP_ToDt
		end [WOP_ToDt]
		
	,	case WOP_ToDt
		when '01/01/1900' then null
		else CONVERT(varchar(20),WOP_ToDt,103)
		end [FormatedWOPToDt]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS2' 
			and CPAD.ApplTyp=EL.LvTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval_Level]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS2' 
			and CPAD.ApplTyp=EL.LvTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(Case when((select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS2' 
			and CPAD.ApplTyp=EL.LvTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
			=(select Top 1 SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS2' 
			and CPAD.ApplTyp=EL.LvTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd order by SrNo Desc))
			then 
				(STUFF((SELECT ', ' + CAST((Select Fname From Employee where Cd=EmpCd) AS VARCHAR(10)) [text()]
				FROM CompanyProcessApprovalDetail as CPAD
				WHERE CPAD.ProcessId='HRPSS2' 
				and CPAD.ApplTyp=EL.LvTyp
				and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
				and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
				and CPAD.CoCd=@v_CoCd
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '))
			End
		)
		end[Approvals]
	,	EL.Narr[ContactNumber]
	
	,	(select des from branch where cd=(select div from Employee where cd=el.EmpCd))[Branch]
	,	Div
	,	(select des from Dept where cd=(select Dept from Employee where cd=el.EmpCd))[Dept]
	,	Dept[DeptCd]
	,	DATEDIFF(dd,EL.FromDt,getdate())[Tobegin]
	
	into #LeaveApproval	
	From	-- Modified by Rasheed( otherwise list all employees)
		EmpLeave EL left outer join CompanyLeave C on EL.LvTyp=c.Cd  left outer join Employee Emp on EL.empcd=Emp.Cd
	Where	-- Modified by Rasheed (Need to show only new applications for approval)
		C.Cd= EL.LvTyp and Emp.Cd=EL.EmpCd and Emp.CoCd=@v_CoCd
	
	and (EL.JoinDt is null or Typ='S')
	and (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and EL.LvStatus = 'N'  or
		@v_Typ='1' and TransNo=@v_Param and EL.LvStatus = 'N'  or
		@v_Typ='2' and EL.empcd=@v_Param and EL.LvStatus = 'N'  or
		@v_Typ='4' and TransNo=@v_Param and EL.LvStatus = 'F'  or
		@v_Typ='3' and EL.LvStatus = 'N' and TransNo in( select TransNo as LeaveApproval  from EmpLeave
				inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS2' and CPA.ApplTyp=EL.LvTyp  and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				LvStatus='N' 
				and emp.CoCd=@v_CoCd
				and emp.Status='HSTATPM   '
				and ((LvApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (LvApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS2' and ApplTyp=EL.LvTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=LvApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) )))
			
	)
	and emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	and emp.Cd in(select cd from employee where Div=@v_Div or @v_Div='0')
	and emp.Cd in(select cd from employee where Dept=@v_Dept or @v_Dept='0')
	and (
	emp.Cd in 
	(select cd from Employee Emp where Emp.FName like ltrim(rtrim(@v_EmpCd1))  or Emp.MName like  ltrim(rtrim(@v_EmpCd1)) or Emp.LName like ltrim(rtrim(@v_EmpCd1)) or Emp.Cd like ltrim(rtrim(@v_EmpCd1)))
	or ltrim(rtrim(@v_EmpCd1))='')
	--Order By
	--	TransNo

	select * from #LeaveApproval	 ORDER BY ABS( DATEDIFF(DD,LvFrom, getdate()) ) 
	drop table #LeaveApproval
End
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Codes_GetRow_N]
	@v_Cd		Char(10)
--,	@v_CoCd		Char(10)
As		-- Drop Procedure dbo.Codes_GetRow_N 'Bank','02' select * from CodeGroups
Begin
	Select
		CG.sDes[CodeGrpSDes]
	,	CG.AddOn_Fields  --syed
	,	Right(rTrim(C.Cd),Len(rtrim(C.Cd))-Len(Rtrim(C.Typ)))[Code]
	,	C.Typ
	,	C.Abbr
	,	C.sDes
	,	C.Des
	,	C.EntryBy
	,	C.EntryDt
	,	C.Editby
	,	C.EditDt
	,	C.Cd
	,	C.Active
	From 
		Codes C
	,	CodeGroups CG 
--	,	Parameters Param
	Where
		(@v_cd = '' or C.Cd=@v_Cd)
	and	CG.Cd=C.Typ and CG.Typ='U'
--	and	CG.AppCd=param.AppCd
--	and	Param.val='Y' and Param.cd='ACTIVE'
--	and	Param.CoCd=@v_CoCd
	and	CG.AppCd in (Select AppCd From Parameters Where Val='Y' and Cd='ACTIVE') and CG.active='1'
	Order by
		C.Cd
End 
 Go 
CREATE OR ALTER Procedure [dbo].[CodeGroups_GetRow]
	@v_CoCd		Char(5)
As		-- Drop Procedure dbo.CodeGroups_GetRow '01'
Begin
	Select
		Cd
	,	SDes[ShortDes]
	,	AppCd 
	From
		CodeGroups		-- select * from codegroups
	Where
		Typ='U'
	and	AppCd in (Select AppCd From Parameters Where Val='Y' and Cd='ACTIVE' and (CoCd=@v_CoCd or Rtrim(@v_CoCd)='')) and active='1'
End 
 Go 

 CREATE OR ALTER PROCEDURE [dbo].[EmpProgressionDetail_GetRow]  
 @v_TransNo  Char(10)  
As -- Drop PROCEDURE [dbo].[EmpProgressionDetail_GetRow]  
Begin  
 Select   
  EPD.SrNo  
 , (Select SDes From SysCodes Where Cd=EPD.EdTyp)[PayTyp]  
 , (Select Cd From SysCodes Where Cd=EPD.EdTyp)[PayTypCd]  
 , (Select SDes From CompanyEarnDed Where Cd=EPD.EdCd and Typ=EPD.EdTyp)[PayCd]  
 , (Select Cd From CompanyEarnDed Where Cd=EPD.EdCd and Typ=EPD.EdTyp)[PayCodeCd]  
 , EPD.EffDt  
 , CONVERT(varchar(10), EPD.EffDt ,103)[FormatedEffDt]
 , Case EPD.PercAmt  
  When 'P' then 'PERCENT'  
  Else 'AMOUNT'  
  End [Perc / Amt]  
 , EPD.Val[Current]  
 , EPD.ApprVal[Incremented]  
 , EPD.Narr  
 , EPD.TransNo  
 From   
  EmpProgressionDetail EPD  
 Where   
  EPD.TransNo=@v_TransNo  
End   
 Go 

 CREATE OR ALTER PROCEDURE [dbo].[EmpProgressionDetail_GetRow_N]  
 @v_TransNo  Char(10)  
As -- Drop PROCEDURE [dbo].[EmpProgressionDetail_GetRow]  
Begin  
 Select   
  EPD.SrNo  
 , (Select SDes From SysCodes Where Cd=EPD.EdTyp)[PayTyp]  
 , (Select Cd From SysCodes Where Cd=EPD.EdTyp)[PayTypCd]  
 , (Select SDes From CompanyEarnDed Where Cd=EPD.EdCd and Typ=EPD.EdTyp)[PayCd]  
 , (Select Cd From CompanyEarnDed Where Cd=EPD.EdCd and Typ=EPD.EdTyp)[PayCodeCd]  
 , EPD.EffDt  
 , CONVERT(varchar(10), EPD.EffDt ,101)[FormatedEffDt]
 , Case EPD.PercAmt  
  When 'P' then 'PERCENT'  
  Else 'AMOUNT'  
  End [PercAmt]  
 , EPD.Val[Current]  
 , EPD.ApprVal[Incremented]  
 , EPD.Narr  
 , EPD.TransNo  
 From   
  EmpProgressionDetail EPD  
 Where   
  EPD.TransNo=@v_TransNo  
End   
 Go 
CREATE OR ALTER Procedure [dbo].[EmpProgressionHead_GetRow_N]
	@v_Param	Varchar(30)=null
,	@v_Typ		Char(1)=''
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
As	-- Drop Procedure [EmpProgressionHead_GetRow] '','','HR3'	,'U'
/*
	Declare	@v_Param varchar(30)
	Declare	@v_Typ Char(1)
	Declare	@v_EmpCd Char(10)
	Declare	@v_EmpUser Char(1)

	Set @v_Param = '3'
	Set	@v_Typ = '0'
	Set @v_EmpCd = 'HR3'
	Set	@v_EmpUser = 'U'
*/
Begin
	Select
		EP.TransNo[TransNo]
	,	EP.TransDt[TransDt]
	,	CONVERT(varchar(10), EP.TransDt,103)[FormatedTransDt]
	,	EP.EmpCd[EmpCode]
	,	Emp.FName[EmpName]
	,	(select Sdes From Designation where Designation.Cd=EP.FromDesg)[DesigFrom]
	,	(select Sdes From Designation where Designation.Cd =EP.ToDesg)[DesigTo]
	,	(select Cd From Designation where Designation.Cd=EP.FromDesg)[DesigFromCd]
	,	(select Cd From Designation where Designation.Cd =EP.ToDesg)[DesigToCd]
	,	(select Rtrim(FName)+' '+RTrim(MName)+' '+Rtrim(LName) from Employee where cd=Emp.Cd)[Name]
	,	(select Rtrim(FName)+' '+RTrim(MName)+' '+Rtrim(LName) from Employee where cd=EP.ApprBy)[ApprName]
	,	EP.ApprBy
	,	case EP.ApprDt
			when '01/01/1900' then ''
			else EP.ApprDt end[ApprDt]
	,	case EP.ApprDt
			when '01/01/1900' then ''
			else CONVERT(varchar(10),EP.ApprDt,103)end[FormatedApprDt]
			
	,	EP.Remarks
	,	case EP.Status
		when 'E' then 'Enter'
		when 'A' then 'Approve'
		when 'R' then 'Reject'
		end[Status]
	,	EP.Status[StatusCd]
	,	Emp.MName[MiddleName]
	,	Emp.LName[LastName]
	,	(Select SDes From SysCodes Where Cd=EP.Typ)[EP_Typ]
	,	Typ[EP_TypeCd]
	
	,	case when @v_Typ = '1'
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT6' 
			and CPAD.ApplTyp=EP.Typ
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval_Level]
	,	case when @v_Typ = '1'
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT6' 
			and CPAD.ApplTyp=EP.Typ
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval]
		
	From
		EmpProgressionHead EP	-- select *from EmpProgressionHead
	,	Employee Emp
	Where
		Emp.cd=EP.EmpCd
	and	(@v_Typ='0' and ltrim(str(month(EP.TransDt)))=@v_Param or
		@v_Typ='1' and EP.TransNo=@v_Param or
		@v_Typ='2' and EP.EmpCd=@v_Param or 
		@v_Typ='3' and EP.Status='E' or 
		@v_Typ='4' and EP.Status='A'  or
		@v_Typ ='' and TransNo in( select TransNo  from EmpProgressionHead
				inner join Employee as emp on emp.Cd=EmpProgressionHead.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT6' and CPA.ApplTyp=EP.Typ  and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				EmpProgressionHead.Status='E' 
				and emp.Status='HSTATPM   '
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail CPA where ProcessId='HRPT6' and CPA.ApplTyp=EP.Typ and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) )))
			)

	Order by
		EP.TransNo Desc
End 
 Go 
CREATE OR ALTER Procedure [dbo].[EmpProgressionHead_GetRow]
	@v_Param	Varchar(30)=null
,	@v_Typ		Char(1)=''
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
As	-- Drop Procedure [EmpProgressionHead_GetRow] '','','HR3'	,'U'
/*
	Declare	@v_Param varchar(30)
	Declare	@v_Typ Char(1)
	Declare	@v_EmpCd Char(10)
	Declare	@v_EmpUser Char(1)

	Set @v_Param = '3'
	Set	@v_Typ = '0'
	Set @v_EmpCd = 'HR3'
	Set	@v_EmpUser = 'U'
*/
Begin
	Select
		EP.TransNo[TransNo]
	,	EP.TransDt[TransDt]
	,	CONVERT(varchar(10), EP.TransDt,103)[FormatedTransDt]
	,	EP.EmpCd[EmpCode]
	,	Emp.FName[EmpName]
	,	(select Sdes From Designation where Designation.Cd=EP.FromDesg)[DesigFrom]
	,	(select Sdes From Designation where Designation.Cd =EP.ToDesg)[DesigTo]
	,	(select Cd From Designation where Designation.Cd=EP.FromDesg)[DesigFromCd]
	,	(select Cd From Designation where Designation.Cd =EP.ToDesg)[DesigToCd]
	,	(select Rtrim(FName)+' '+RTrim(MName)+' '+Rtrim(LName) from Employee where cd=Emp.Cd)[Name]
	,	(select Rtrim(FName)+' '+RTrim(MName)+' '+Rtrim(LName) from Employee where cd=EP.ApprBy)[ApprName]
	,	EP.ApprBy
	,	case EP.ApprDt
			when '01/01/1900' then ''
			else EP.ApprDt end[ApprDt]
	,	case EP.ApprDt
			when '01/01/1900' then ''
			else CONVERT(varchar(10),EP.ApprDt,103)end[FormatedApprDt]
			
	,	EP.Remarks
	,	case EP.Status
		when 'E' then 'Enter'
		when 'A' then 'Approve'
		when 'R' then 'Reject'
		end[Status]
	,	EP.Status[StatusCd]
	,	Emp.MName[MiddleName]
	,	Emp.LName[LastName]
	,	(Select SDes From SysCodes Where Cd=EP.Typ)[EP_Typ]
	,	Typ[EP_TypeCd]
	
	,	case when @v_Typ = '1'
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT6' 
			and CPAD.ApplTyp=EP.Typ
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval_Level]
	,	case when @v_Typ = '1'
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT6' 
			and CPAD.ApplTyp=EP.Typ
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval]
		
	From
		EmpProgressionHead EP	-- select *from EmpProgressionHead
	,	Employee Emp
	Where
		Emp.cd=EP.EmpCd
	and	(@v_Typ='0' and ltrim(str(month(EP.TransDt)))=@v_Param or
		@v_Typ='1' and EP.TransNo=@v_Param or
		@v_Typ='2' and EP.EmpCd=@v_Param or 
		@v_Typ='3' and EP.Status='E' or 
		@v_Typ='4' and EP.Status='A'  or
		@v_Typ ='' and TransNo in( select TransNo  from EmpProgressionHead
				inner join Employee as emp on emp.Cd=EmpProgressionHead.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT6' and CPA.ApplTyp=EP.Typ  and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				EmpProgressionHead.Status='E' 
				and emp.Status='HSTATPM   '
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail CPA where ProcessId='HRPT6' and CPA.ApplTyp=EP.Typ and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) )))
			)

	Order by
		EP.TransNo Desc
End 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyProcessApproval_Update_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_ApplTyp			char(10)
,	@v_Div				Char(5)
,	@v_Dept				Char(10)
As		-- Drop Procedure [dbo].[CompanyProcessApproval_Update_N]'01','HRPE2','1','10','B','HDTYP0001','Passport first'
Begin	
	Declare @v_Div1				char(5)
	Declare @v_Dept1				char(5)
		if(@v_Div='0' and @v_Dept='0')		
		Begin
			DECLARE db_cursor CURSOR FOR 
			select Distinct cd from branch order by Cd
			OPEN db_cursor  
			FETCH NEXT FROM db_cursor INTO @v_Div1 
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
					DECLARE db_cursor_Dept CURSOR FOR 
					select Distinct cd from Dept order by Cd
					OPEN db_cursor_Dept  
					FETCH NEXT FROM db_cursor_Dept INTO @v_Dept1 
					WHILE @@FETCH_STATUS = 0  
					BEGIN 
						IF (SELECT COUNT(*) FROM CompanyProcessApproval WHERE CoCd = @v_CoCd and ProcessId=@v_ProcessId and ApplTyp=@v_ApplTyp and Div=@v_Div1 and Dept=@v_Dept1) = 0
						Begin
							Insert into CompanyProcessApproval
							values(
								@v_CoCd
							,	@v_ProcessId
							,	@v_ApplTyp
							,	@v_Div1
							,	@v_Dept1)
						End
						FETCH NEXT FROM db_cursor_Dept INTO  @v_Dept1 
						END 
						CLOSE db_cursor_Dept  
						DEALLOCATE db_cursor_Dept

			FETCH NEXT FROM db_cursor INTO @v_Div1
			END 
			CLOSE db_cursor  
			DEALLOCATE db_cursor 
		End	
	if(@v_Div<>'0' and @v_Dept='0')		
		Begin	
			DECLARE db_cursor_Dept CURSOR FOR 
			select Distinct cd from Dept order by Cd
			OPEN db_cursor_Dept  
			FETCH NEXT FROM db_cursor_Dept INTO @v_Dept1 
			WHILE @@FETCH_STATUS = 0  
			BEGIN 
				IF (SELECT COUNT(*) FROM CompanyProcessApproval WHERE CoCd = @v_CoCd and ProcessId=@v_ProcessId and ApplTyp=@v_ApplTyp and Div=@v_Div and Dept=@v_Dept1) = 0
						Begin
							Insert into CompanyProcessApproval
							values(
								@v_CoCd
							,	@v_ProcessId
							,	@v_ApplTyp
							,	@v_Div
							,	@v_Dept1)
						End
			FETCH NEXT FROM db_cursor_Dept INTO  @v_Dept1 
			END 
			CLOSE db_cursor_Dept  
			DEALLOCATE db_cursor_Dept
		End	
	If(@v_Div<>'0' and @v_Dept<>'0')
		Begin
			IF (SELECT COUNT(*) FROM CompanyProcessApproval WHERE CoCd = @v_CoCd and ProcessId=@v_ProcessId and ApplTyp=@v_ApplTyp and Div=@v_Div and Dept=@v_Dept) = 0
						Begin
							Insert into CompanyProcessApproval
							values(
								@v_CoCd
							,	@v_ProcessId
							,	@v_ApplTyp
							,	@v_Div
							,	@v_Dept)
						End
		End
End 
 Go 
CREATE OR ALTER   procedure [dbo].[Employee_Find_N]
@v_Param	varchar(40),
@v_Typ		char(1),
@v_CoCd		Char(5)
As  --drop procedure [dbo].[Employee_Find_N] '00088','1','01'
if @v_Typ='0'	
BEGIN
	Select *
	, Emp.Fname+' '+isnull(Emp.Mname,'')+' '+isnull(Emp.Lname,'') [Name]
	, (Select Mobile from EmpAddress where AddTyp ='HADD0001  ' and EmpCd=Emp.Cd)[MobNo]
	,	CONVERT(varchar(20),Dob,103) as [FormatedDOB]
	,	CONVERT(varchar(20),Doj,103) as [FormatedDOJ] 
	,	CONVERT(varchar(20),Probation,103) as [FormatedProbation]
	,	CONVERT(varchar(20),Confrm,103) as [Formated	Confirmation] 
	,	CONVERT(varchar(20),Leaving,103) as [FormatedLeaving] 
	,	CONVERT(varchar(20),EntryDt,103) as [FormatedEntryDt] 
	,	CONVERT(varchar(20),EditDt,103) as [FormatedEditDt]
	,	CONVERT(varchar(20),LvDueDt,103) as [FormatedLvDueDt] 
	,	isnull((select LvOpBal from EmpLeaveMaster ELM where ELM.EmpCd=Cd),0)[LvOb]
	,	isnull((select LvMax from EmpLeaveMaster ELM where ELM.EmpCd=Cd),0)[LvMax]
	From Employee Emp
	where  CoCd = @v_CoCd
END

else 
if @v_Typ='1'	
BEGIN
	Select * 
	, Emp.Fname+' '+isnull(Emp.Mname,'')+' '+isnull(Emp.Lname,'') [Name]
	, (Select Mobile from EmpAddress where AddTyp ='HADD0001  ' and EmpCd=Emp.Cd)[MobNo]
	,	CONVERT(varchar(20),Dob,103) as [FormatedDOB]
	,	CONVERT(varchar(20),Doj,103) as [FormatedDOJ] 
	,	CONVERT(varchar(20),Probation,103) as [FormatedProbation]
	,	CONVERT(varchar(20),Confrm,103) as [FormatedConfirmation] 
	,	CONVERT(varchar(20),Leaving,103) as [FormatedLeaving] 
	,	CONVERT(varchar(20),EntryDt,103) as [FormatedEntryDt] 
	,	CONVERT(varchar(20),EditDt,103) as [FormatedEditDt]
	,	CONVERT(varchar(20),LvDueDt,103) as [FormatedLvDueDt] 
	,	isnull((select LvOpBal from EmpLeaveMaster ELM where ELM.EmpCd=Cd),0)[LvOb]
	,	isnull((select LvMax from EmpLeaveMaster ELM where ELM.EmpCd=Cd),0)[LvMax]
	FROM Employee Emp
	where CoCd = @v_CoCd 
	and Cd = @v_Param
	select * 
	from EmpAddress 
	where EmpCd=@v_Param 
	order by AddTyp -- and CoCd = @v_CoCd
END

else 
if @v_Typ='2'	
BEGIN
	Select * 
	, Emp.Fname+' '+isnull(Emp.Mname,'')+' '+isnull(Emp.Lname,'') [Name]
	,	CONVERT(varchar(20),Dob,103) as [FormatedDOB]
	,	CONVERT(varchar(20),Doj,103) as [FormatedDOJ] 
	,	CONVERT(varchar(20),Probation,103) as [FormatedProbation]
	,	CONVERT(varchar(20),Confrm,103) as [FormatedConfirmation]
	,	CONVERT(varchar(20),Leaving,103) as [FormatedLeaving] 
	,	CONVERT(varchar(20),EntryDt,103) as [FormatedEntryDt] 
	,	CONVERT(varchar(20),EditDt,103) as [FormatedEditDt]
	,	CONVERT(varchar(20),LvDueDt,103) as [FormatedLvDueDt] 
	,	isnull((select LvOpBal from EmpLeaveMaster ELM where ELM.EmpCd=Cd),0)[LvOb]
	,	isnull((select LvMax from EmpLeaveMaster ELM where ELM.EmpCd=Cd),0)[LvMax]
	From Employee Emp
	where Cd = @v_Param or Cd =(select distinct EmpCd from EmpAddress where left(Email,CHARINDEX('@',Email))=@v_Param+'@')
	select * 
	from EmpAddress 
	where EmpCd=@v_Param 
	order by AddTyp -- and CoCd = @v_CoCd
END

--select Email From EmpAddress


 
 
 Go 





CREATE OR ALTER Procedure [dbo].[Employee_GetRow]    
	@v_Param		varchar(40)    
,	@v_Typ			Char(2)    
,	@v_Cocd			Char(5)    
,	@v_RowsCnt		int 
,	@v_Div			varchar(40)		='0'
,	@v_Dept			varchar(40)		='0'
,	@v_Sponsor		varchar(40)		='0'
,	@v_Designation	varchar(40)		='0'
,	@v_Status		varchar(40)		='0'
,	@v_Usercd		varchar(10)	='001'
As  -- Drop Procedure [dbo].[Employee_GetRow] '','99','01','2','0','0','0','0','PW'
 /*
declare @v_Param char(40)    
declare @v_Typ  Char(2)    
declare @v_Cocd  Char(5)    
declare @v_RowsCnt int  
set @v_Param = ''
set @v_Typ = '99'
set @v_Cocd = '01'
set @v_RowsCnt = '0'
*/
Begin  
if  @v_Typ='1'
begin

--begin 
--set @v_Typ='99' 
--end
set @v_Param =@v_Param
end
else
begin
	 set @v_Param = ltrim(rtrim(@v_Param))   
	 
	 set @v_Param = '%' + @v_Param + '%'  
	 if  @v_Typ='2' or @v_Typ='3' or @v_Typ='4' or @v_Typ='99'    
 		set @v_Param = @v_Param +'%'   
	
  end 
  
	Declare @Prd		int
	Declare @Year		int
	Declare @AnnualLv	Char(10)
	Declare @BasicCd		Char(15)
	Declare @AmtDecs		int
	Declare @EDay		int
  
	select @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
	select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
	Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_Cocd
	Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_Cocd
	select @AmtDecs=AmtDecs From Company Where Cd=@v_Cocd
	Exec @EDay=Get_EDay @Prd,@Year
  
 select--Top (@v_RowsCnt)  
  Emp.Cd    
 , (select Codes.SDes from Codes where Codes.Cd=Emp.Salute)[Salutation]    
 , Emp.Fname[FirstName]    
 , Emp.Mname[MiddleName]    
 , Emp.Lname[LastName]    
 , Emp.Fname+' '+isnull(Emp.Mname,'')+' '+isnull(Emp.Lname,'') [Name]    
 , Emp.Sex[Sex]    
 , Emp.CoCd[Company]    
 , (select SDes FROM Branch where Cd=Emp.Div)[Branch]  
 , Emp.Div[BranchCd]    
 , (select SDes from CC where Cd=Emp.CC)[CC]    
 , (select SDes from Dept where Dept.Cd=Emp.Dept)[Department] 
 , Emp.Dept[DepartmentCd]   
 , (select SDes FROM Codes where Codes.cd=Emp.LocCd)[Location] 
 , Emp.LocCd[LocationCd]    
 , Emp.POB[POB]    
 , (select Nat FROM Country where Cd=Emp.Nat)[Nationality]    
 , (select SDes FROM Codes where cd=Emp.Relg and Typ='HRELG')[Religion]    
 , (select SDes FROM Codes where Cd=Emp.Marital)[MaritalStatus]    
 , (select SDes FROM Designation where Designation.cd=Emp.Desg)[Designation]
 ,TRIM(Emp.Desg)Desg
 , Emp.DOB[DOB]     
 , CONVERT(varchar(20), Emp.DOB,103)[FormatedDOB]    
 , Emp.DOJ[DOJ]    
 , CONVERT(varchar(20), Emp.DOJ,103)[FormatedDOJ] 
 , CONVERT(varchar(20), Emp.Probation,103)[FormatedProbation] 
 , CONVERT(varchar(20), Emp.Confrm,103)[FormatedConfrm]  
 , (select SDes FROM Codes where Codes.Cd=Emp.EmpCat1)[EmployeeCategory1]    
 , (select SDes FROM Codes where Codes.Cd=Emp.EmpCat2)[EmployeeCategory2]    
 , (select SDes FROM Codes where Codes.Cd=Emp.EmpCat3)[EmployeeCategory3]    
 , (select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName) from Employee where Cd=Emp.RepTo )[ReportingTo]    
 , Emp.Father    
 , Emp.Mother    
 , Emp.Spouse  -- select * from Employee where cd='456'   
 , Emp.Probation    
 , Emp.Confrm[Confirm]    
 , Emp.Basic
 ,	Emp.CurrCd[CurrencyCd]   
 , (select Abbr FROM Currency where Cd=Emp.CurrCd)[Currency] 
 ,	(select Rate from CurrencyRates where CurrCd=Emp.CurrCd and CoCd=@v_Cocd)[CurrencyExchangeRate]    
 , Emp.FareEligible[FareEligiblity]    
 , Emp.NoTickets[No. of Tickets]    
 , (select SDes FROM Codes where Codes.cd=Emp.TravSect)[TravelSector]    
 , (select SDes FROM Codes where Codes.cd=Emp.TravClass)[TravelClass]    
 , Emp.HomeBase[Home Base]  
 , (select SDes from SysCodes where Cd=Emp.PayMode)[PayMode]    
 , (select SDes from SysCodes where Cd=Emp.PayFreq)[PayFrequency]    
 , (select SDes from Codes where Typ='BANK' and Cd=Emp.BankCd)[Bank]    
 , Emp.LvDays[Leave Days]    
 , (select SDes from SysCodes where Cd=Emp.Status)[Status]    
 , (select Sdes from Codes where Cd=Emp.Sponsor)[Sponsor]    
  ,TRIM(Emp.Sponsor)SponsorCd
 , Emp.ImageFile[ImageFilePath]    
 , Emp.ImageSign[SignatureFilePath]    
 , Emp.RepTo[ReportingTo]    
 , Emp.OTEligible[OTEligible]    
 , Emp.LvPrd[Leaveperiod]    
 , (select Des from CompanyTradeClass CTC where CTC.Cd=Emp.TradeCd)[TradeCode]    
 , (select SDes from Codes where Typ='J_ET' and Codes.cd=Emp.EmpTyp)[Emptype] 
  ,	EmpTyp
 , Emp.ApprCd[ApprCd]    
 , Emp.BasicCurr    
 , (select UName from Users where Cd=Emp.UserCd)[UserId]    
 , (select Sdes from CompanyShiftMaster where Cd=Emp.ShiftCd)[Shift]    
 , CalcBasis    
 , GT    
 , LS    
 , LT    
 , Emp.Grade  
  ,Emp.Active[Active]
 , (Select Mobile from EmpAddress where AddTyp ='HADD0001  ' and EmpCd=Emp.Cd)[MobNo]
 , (Select round(((Select 
			isnull(sum(
			case PercAmt
				When 'P' then  case EdTyp
						when 'HEDT02'then  -PercVal*.01*(Basic*Cr.Rate)
						else PercVal*.01*Basic
						end
				When 'A' then  case EdTyp
						when 'HEDT02' then -AmtVal*Cr.Rate
						else AmtVal*Cr.Rate	
						end
			end),0)
		From 
			EmpEarnDed Ed
		,	Employee Emp1
		,	Currency Cr
		Where  
			Emp1.Cd=EmpCd
		and	Cr.Cd=Ed.Curr
		and	EmpCd=Emp.Cd
		and	rtrim(EdTyp)+rtrim(EdCd) <> @BasicCd
		and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd=@AnnualLv and CoCd=@v_Cocd)
		and	EffDate<=rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year) 
		and	(EndDate>=rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)  or EndDate='1/1/1900'))
		+(select Basic from Employee where cd=Emp.Cd)
		) ,@amtdecs))  [Total]
	,'/Emp_Photos/'+trim(Emp.CoCd)+'/'+ Emp.Imagefile[Image]
	, PassportLocation
--	,isnull((select top 1 lvstatus from empleave where EmpCd=Emp.cd and  cast(FromDt as date)<=cast(GETDATE() as date) and cast(ToDt as date)>=cast(getdate() as date) order by transno desc),'')[LvStatus]
 	,(select dbo.GetFunc_EmpWorkingStatus (emp.cd,getdate()) )[LvStatus]
 from  
  Employee Emp    
 Where  
  Emp.CoCd=@v_Cocd 
  and  (
  (@v_Typ='0' and Emp.Cd like @v_Param) or  
  (@v_Typ='1' and Emp.Cd = @v_Param) or 
  (@v_Typ='20' and Emp.Fname+' '+Emp.Mname+' '+Emp.Lname like @v_Param) or 
  (@v_Typ='2' and Emp.FName like @v_Param) or  
  (@v_Typ='3' and Emp.MName like @v_Param) or  
  (@v_Typ='4' and Emp.LName like @v_Param) or  
  (@v_Typ='5' and Emp.Desg=(select Cd FROM Designation where Designation.SDes=@v_Param)) or  
  (@v_Typ='6' and Emp.Div=(select Cd FROM Branch where SDes=@v_Param)) or  
  (@v_Typ='7' and Emp.CC=(select Cd from CC where SDes=@v_Param)) or  
  (@v_Typ='8' and Emp.Dept=(select Cd FROM Dept where SDes=@v_Param)) or  
  (@v_Typ='9' and Emp.LocCd=(select Cd FROM Codes where SDes=@v_Param and Typ='HLOC')) or  
  (@v_Typ='10' and Emp.Nat=(select Cd FROM Country where Nat=@v_Param)) or  
  (@v_Typ='11' and Emp.PayMode=(select Cd from SysCodes where SDes=@v_Param and Typ='HPMOD')) or  
  (@v_Typ='12' and Emp.Status=(select Cd FROM SysCodes where SDes=@v_Param and Typ='HSTAT')) or  
  (@v_Typ='13' and Emp.Relg=(select Cd FROM Codes where SDes=@v_Param and Typ='HRELG')) or  
  (@v_Typ='14' and Emp.Sponsor=(select Cd FROM Codes where SDes=@v_Param and Typ='ESPON')) or  
 -- (@v_Typ='15' and Emp.Fname+' '+Emp.Mname+' '+Emp.Lname like '%'+@v_Param+'%' and Emp.Status in (select Val from ParametersByProcess where CoCd=@v_Cocd and ProcessID='HRPT7' and ParameterCd in('DI','DO','PM')) and Emp.GT='Y' and Emp.Active='Y') or
  (@v_Typ='15' and (Emp.FName like @v_Param  or Emp.MName like  @v_Param or Emp.LName like @v_Param or Emp.Cd like @v_Param) and Emp.Status in (select Val from ParametersByProcess where CoCd=@v_Cocd and ProcessID in('HRPT7', 'OrgGratuity') and ParameterCd in('DI','DO','PM')) and Emp.GT='Y' and Emp.Active='Y') or
  (@v_Typ='18' and Emp.Cd like @v_Param and Emp.Status in (select Val from ParametersByProcess where CoCd=@v_Cocd and ProcessID in('HRPT7', 'OrgGratuity') and ParameterCd in('DI','DO','PM')) and Emp.GT='Y' and Emp.Active='Y') or
  (@v_Typ='19' and Emp.Fname+' '+Emp.Mname+' '+Emp.Lname like @v_Param and Emp.Status in (select Val from ParametersByProcess where CoCd=@v_Cocd and ProcessID in('HRPT7', 'OrgGratuity') and ParameterCd in('DI','DO','PM')) and Emp.GT='Y' and Emp.Active='Y') or
  (@v_Typ='16' and Emp.UserCd=@v_Param and Emp.Pwd=@v_Param) or  
  (@v_Typ='17' and Emp.Status in (select Des from SysCodes where Typ='HSTAT ')) or
  (@v_Typ='99' and 
  (
  Emp.FName like @v_Param  or Emp.MName like  @v_Param or Emp.LName like @v_Param or Emp.Cd like @v_Param or emp.Cd in(select empcd from EmpAddress where Mobile like @v_Param) 
  )
  )
  )
  and  (
  (@v_RowsCnt='0' and Emp.Status not in ('HSTATNP','HSTATTP','HSTATSR','HSTATST','HSTATES')) or
  (@v_RowsCnt='1' and Emp.Status in ('HSTATNP','HSTATTP','HSTATSR','HSTATST','HSTATES'))or
  (@v_RowsCnt='2' and Emp.Active='Y')or
  (@v_RowsCnt='3' and Emp.Active='N') or
  (@v_RowsCnt='100')
  )
  and emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
  and (Emp.Div=@v_Div or @v_Div='0')
  and (Emp.Dept=@v_Dept or @v_Dept='0')
  and (Emp.Sponsor=@v_Sponsor or @v_Sponsor='0')
  and (emp.Desg=@v_Designation or @v_Designation='0')
 Order By    
  EntryDt desc  
 , EditDt desc  
 , Emp.Cd  
 
End 
 Go 
CREATE OR ALTER   procedure [dbo].[EmpTrans_Incentives_GetRow_N]
	@DivCd				varchar(20)
,	@DeptCd   			varchar(20)
,	@v_EdCd 			varchar(30)
,	@v_EdTyp 			varchar(30)
,	@v_FromDt			datetime
,	@v_ToDt				datetime
,	@v_RPrd				Char(2)	
,	@v_RYear			Char(4)
,	@v_Empcd			char(10)
,	@v_EmpTyp			char(10)

As		-- Drop Procedure [EmpTrans_Incentives_GetRow]'18','27','','HEDT01','04/01/2023','04/30/2023','04','2023','','0'
Begin
	if @DivCd in ('ALL','0')
		Set @DivCd=''
	
	if @DeptCd in ('ALL','0')
		Set @DeptCd=''
	if @v_EmpTyp in ('ALL','0')
		Set @v_EmpTyp=''
	Declare @Month			int
	Declare @Year			int
	Select	@Month=val from Parameters where Cd='CUR_MONTH' 
	Select	@Year=Val from Parameters where Cd='CUR_YEAR' 
/*
	Declare	@DivCd			varchar(20)
	Declare	@CCCd			varchar(20)
	Declare	@DeptCd		varchar(20)
	Declare	@v_EdCd		varchar(30)
	Declare	@v_EdTyp		varchar(30)
	Declare	@v_FromDt		datetime
	Declare	@v_ToDt			datetime

	set @DivCd=''
	set @CCCd=''
	set @DeptCd=''
	set @v_EdCd='008'
	set @v_EdTyp='HEDT03'
	set @v_FromDt='03/01/2012'
	set @v_ToDt='03/31/2012'
*/
/*
	Declare @DivCd		Char(5)
	Declare @CCCd		Char(5)
	Declare @DeptCd		Char(5)
	Declare @v_EdTyp	Char(10)
	Declare @v_EdCd		Char(5)
	if @DivDes='ALL'
		Set @DivCd=''
	Else
		Select @DivCd=Cd from Branch where SDes=@DivDes
	if @CCDes='ALL'
		Set @CCCd=''
	Else
		Select @CCCd=Cd from CC where SDes=@CCDes
	if @DeptDes='ALL'
		Set @DeptCd=''
	Else
		Select @DeptCd=Cd from Dept where SDes=@DeptDes
	Select @v_EdTyp=cd from SysCodes where SDes=@v_EdTypDes and Typ='HEDT'
	Select @v_EdCd=cd from CompanyEarnDed where SDes=@v_EdCdDes and Typ=@v_EdTyp
	
	*/

	--if (Select count(1) from EmpTrans where EdCd in('207','MGRIN') and EdTyp = @v_EdTyp and FromDt = @v_FromDt and ToDt = @v_ToDt) = 0
	--  Begin
	--		Select
	--			Cd
	--		,	Case Len(Rtrim(MName))
	--				When 0 then Rtrim(FName)+ ' ' + Rtrim(LName)
	--				Else Rtrim(FName)+ ' ' + Rtrim(MName) +' ' + Rtrim(LName)
	--			End[EmpName]
	--		,	(Select sDes from Branch where Cd=Div)[Branch]
	--		,	(Select sDes from Designation where Cd=Desg)[Dept]	-- Select * from Employee
	--		,	0[Amt]
	--		,	0[Amt1]
	--		,	'False' as [Status]
	--		,	'/Emp_Photos/'+trim(E.CoCd)+'/'+ E.Imagefile[Image]
	--		, ((select isnull(sum(isnull(AmtVal,0)),0)  from EmpEarnDed where EdTyp='HEDT01' and empcd=cd)+
	--			(select isnull(sum(-1*isnull(AmtVal,0)),0) from EmpEarnDed where EdTyp='HEDT02' and empcd=e.Cd )+
	--			(select isnull(sum(isnull(AmtVal,0)),0) from EmpEarnDed where  EdTyp='HEDT03' and empcd=e.Cd) +
	--			(select isnull(basic,0) from employee where cd=e.Cd))[Salary]
	--		,	(select des from codes where cd=EmpTyp )[SalTyp]
	--		,	(select W_days-(Up_HDays) from EmpAttendance where EmpCd=cd and prd=@v_RYear+@v_RPrd)[Attendance]
	--		From 
	--			Employee E
	--		Where
	--			Rtrim(Status) not in ('HSTATAB','HSTATES','HSTATNP','HSTATSR','HSTATST')
	--		and	(@DivCd='' or @DivCd<>'' and Div=@DivCd)
	--		and	(@DeptCd='' or @DeptCd<>'' and Desg=@DeptCd)
	--	end
	--Else
	       begin
				Select
					EmpCd[Cd]
				,	(Select Rtrim(FName)+ ' ' + Rtrim(MName) +' ' + Rtrim(LName) From Employee Where Cd=EmpCd)[EmpName]
				,	(Select sDes from Branch where Cd=(select div from employee where cd=Emt.EmpCd))[Branch]
				,	(Select sDes from Designation where Cd=(select desg from employee where cd=empcd))[Dept]	-- Select * from Employee
				,	isnull((select top 1 isnull(Amt,0) from emptrans where empcd=Emt.EmpCd and EdCd='207' and HRDiv=emt.HRDiv),0)[Amt]
				,	isnull((select top 1 isnull(Amt,0) from emptrans where empcd=Emt.EmpCd and EdCd='MGRIN' and HRDiv=emt.HRDiv),0)[Amt1]
				,	'True' as [Status]
				,	(select E.Imagefile from employee E where cd=Emt.EmpCd) [Image]
				, ((select isnull(sum(isnull(AmtVal,0)),0)[Amt]  from EmpEarnDed where EdTyp='HEDT01' and empcd=Emt.EmpCd)+
					(select isnull(basic,0)[Amt] from employee where cd=Emt.EmpCd))[Salary]
				,	(select des from codes where cd=(select EmpTyp from employee where cd=Emt.EmpCd))[SalTyp]
				,	case when  Cast(@v_RYear as int) *100 +Cast(@v_RPrd as int) >= @Year *100 +@Month then
					(select W_days-(Up_HDays) from EmpAttendance where EmpCd=Emt.EmpCd and prd=@v_RYear+@v_RPrd and Div=emt.HRDiv)
					else (select W_days-(Up_HDays) from EmpAttendanceYtd where EmpCd=Emt.EmpCd and prd=@v_RYear+@v_RPrd and Div=emt.HRDiv) end [Attendance]
				,	isnull((Select isnull(Salesamt,0) from EmpIncentivesSales where empcd=Emt.EmpCd and div=Emt.HRDiv),0)[SalesAmt]
				From 
					EmpTrans Emt
				Where
					(@DivCd='' or HRDiv=@DivCd)
				--and	(@DeptCd='' or  HRDept=(select Dept from Employee where Desg=@DeptCd))
				and (Empcd=@v_Empcd or @v_Empcd='')
				and	(empcd in (select cd from employee where (Desg=@DeptCd or @DeptCd='') and( Div=@DivCd or @DivCd='')))
				and(EmpCd in(select cd from employee where EmpTyp=@v_EmpTyp or @v_EmpTyp=''))
				and	EdCd in('207','MGRIN') and EdTyp = @v_EdTyp and FromDt = @v_FromDt and ToDt = @v_ToDt
				Union 
				Select
					Cd
				,	Case Len(Rtrim(MName))
						When 0 then Rtrim(FName)+ ' ' + Rtrim(LName)
						Else Rtrim(FName)+ ' ' + Rtrim(MName) +' ' + Rtrim(LName)
					End[EmpName]
				,	(Select sDes from Branch where Cd=Div)[Branch]
				,	(Select sDes from Designation where Cd=Desg)[Dept]	-- Select * from Employee
				,	0[Amt]
				,	0[Amt1]
				,	'False' as [Status]
				,	Imagefile[Image]
				, ((select isnull(sum(isnull(AmtVal,0)),0)[Amt]  from EmpEarnDed where EdTyp='HEDT01' and empcd=E.Cd)+
					(select isnull(basic,0)[Amt] from employee where cd=E.Cd))[Salary]
				,	(select des from codes where cd=EmpTyp)[SalTyp]
				,	case when  Cast(@v_RYear as int) *100 +Cast(@v_RPrd as int) >= @Year *100 +@Month then
					(select W_days-(Up_HDays) from EmpAttendance where EmpCd=E.Cd and prd=@v_RYear+@v_RPrd and Div=E.Div)
					else (select W_days-(Up_HDays) from EmpAttendanceYtd where EmpCd=E.Cd and prd=@v_RYear+@v_RPrd and  Div=E.Div) end [Attendance]
				,	isnull((Select isnull(Salesamt,0) from EmpIncentivesSales where empcd=cd and div=E.Div),0)[SalesAmt]
				From
					Employee  E
				Where
					Rtrim(Status) not in ('HSTATAB','HSTATES','HSTATNP','HSTATSR','HSTATST')
				and	(@DivCd='' or Div=@DivCd)
				and	(@DeptCd='' or  Desg=@DeptCd)
				and(EmpTyp=@v_EmpTyp or @v_EmpTyp='')
				and (cd=@v_Empcd or @v_Empcd='')
				and Cd not in (Select EmpCd From EmpTrans Where
						(@DivCd='' or HRDiv=@DivCd)
					and	(@DeptCd='' or HRDept in(select Dept from Employee where Desg=@DeptCd))
						and	EdCd in('207','MGRIN') and EdTyp = @v_EdTyp and FromDt = @v_FromDt and ToDt = @v_ToDt)		
			order by EmpCd
		 End
End

 
 Go 

CREATE OR ALTER Procedure [dbo].[GetRepo_FixedPayrollCom]
	@v_CoCd Varchar(5)
,	@v_EmpCd Char(10)
,	@v_Div char(5)=''
,	@v_Dt1 datetime
,	@v_Dt2	datetime

As				-- Drop procedure [GetRepo_FixedPayrollCom] '01',''--'00032'
Begin

	Declare @Prd		int
	Declare @Year		int
	Declare @EDay		int
	Declare @AnnualLv		Char(10)
	Declare @BasicCd		Char(15)
	
	Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_CoCd
	Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_CoCd
	Exec @EDay=Get_EDay @Prd,@Year
	select @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
	select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
	
	Select distinct
		ED.EmpCd
	,	(Select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName) From Employee where Cd=ED.EmpCd)[Name]
	,	ED.EdCd
	,	(Select SDes From CompanyEarnDed Where Typ=ED.EdTyp and Cd=ED.EdCd)[PayCode]
	,	Ed.EdTyp
	,	(Select SDes From SysCodes Where Typ='HEDT' and Cd=ED.EdTyp)[PayType]
	,	Convert(Varchar,ED.SrNo)[SrNo]
	,	Case PercAmt
		When 'P' Then PercVal
		Else AmtVal
		End[Amount]	
	,	(Select Des From Currency Where Cd=ED.Curr)[CurrDes]	
	,	Case PercAmt
		When 'P' Then 'Percent'
		Else 'Amount'				
		End[AmtDes]
	,	Convert(Varchar,EffDate,103)EffDate
	,	Case Convert(Varchar,EndDate,103)
		When '01/01/1900' then Null
		Else Convert(Varchar,EndDate,103)
		End[EndDate]
	,	(Select Sdes From Branch Where Cd=Emp.Div)[Branch]
	,	(Select SDes From Codes Where Cd=Emp.LocCd)[Location]
	,	(Select SDes From CC Where Cd=Emp.CC)[CC]
	,	(Select Sdes From Dept Where cd=Emp.Dept)[Department]
	,	Case EdTyp
		When 'HEDT02' Then 'Deductions'
		Else 'Earnings'
		End[PTYP]
	,	(Select CoName From Company where Cd=@v_CoCd)[CoName]
	,	Emp.Basic[Basic]
	,	Convert(Varchar,(select top 1 EffDate from EmpEarnDed where empcd=Emp.Cd  order by EffDate desc ),103)[Last_Incr_Date]
	,	Case PercAmt
		When 'P' Then (select top 1 PercVal from EmpEarnDed where empcd=Emp.Cd  order by EffDate desc ) 
		Else 
		isnull((select top 1 AmtVal from EmpEarnDed where empcd=Emp.Cd and SrNo=(select top 1 srno from EmpEarnDed where empcd=Emp.Cd order by SrNo desc)  order by EffDate desc )
		-
		(select top 1 AmtVal from EmpEarnDed where empcd=Emp.Cd and SrNo=((select top 1 srno from EmpEarnDed where empcd=Emp.Cd order by SrNo desc)-1)  order by EffDate desc )
		,0)End[Last_Increment_Amount]
	,	(Select 
			isnull(sum(
			case PercAmt
				When 'P' then  case EdTyp
						when 'HEDT02'then  -PercVal*.01*(Basic*Cr.Rate)
						else PercVal*.01*Basic
						end
				When 'A' then  case EdTyp
						when 'HEDT02' then -AmtVal*Cr.Rate
						else AmtVal*Cr.Rate
						end
			end),0)[Total]		
		From 
				EmpEarnDed ED1
			,	Employee E1
			,	Currency CR
		Where  
			E1.Cd=ED1.EmpCd
		and	Cr.Cd=ED1.Curr
		and	ED1.EmpCd=ED.EmpCd
		and	rtrim(EdTyp)+rtrim(EdCd) <> @BasicCd
		and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd=@AnnualLv and CoCd=@v_CoCd)
		and	EffDate<=rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year) 
		and	(EndDate>=rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)  or EndDate='1/1/1900'))[Total]
	From 
		EmpEarnDed ED 		
	,	Employee Emp 
	,	Currency Cr
	where 
		Emp.Cd=EmpCd
	--	and	Cr.Cd=Ed.Curr
	--and	(@v_EmpCd='All' or @v_EmpCd<>'All' and ED.EmpCd=@v_EmpCd)
	--and (@v_Div='' or emp.Div=@v_Div)
	--and (ed.EffDate between @v_Dt1 and @v_Dt2)
End


 
 Go 
CREATE OR ALTER  

 Procedure [dbo].[Employee_GetRow_N]    
	@v_Empcd			varchar(40)
,	@v_Cocd				Char(5)  
,	@v_Div				varchar(40)		='0'
,	@v_Dept				varchar(40)		='0'
,	@v_Sponsor			varchar(40)		='0'
,	@v_Designation		varchar(40)		='0'
,	@v_EmpTyp			varchar(40)		='0'
,	@v_Status			varchar(40)		='0'
,	@v_Usercd			varchar(10)			
,	@v_Active			char(1)	
,	@v_PageNumber		int=0
,	@v_PageSize			int=100
,	@v_LvStatus			varchar(5)=''


As  -- Drop Procedure [dbo].[Employee_GetRow_N] '','01','0','0','0','0','0','0','001','',1,50,'N'
 /*
declare @v_Param char(40)    
declare @v_Typ  Char(2)    
declare @v_Cocd  Char(5)    
declare @v_RowsCnt int  
set @v_Param = ''
set @v_Typ = '99'
set @v_Cocd = '01'
set @v_RowsCnt = '0'
*/
Begin  
--if  @v_Typ='1'
--begin

----begin 
----set @v_Typ='99' 
----end
--set @v_Param =@v_Param
--end
--else
--begin
--	 set @v_Param = ltrim(rtrim(@v_Param))   
	 
--	 set @v_Param = '%' + @v_Param + '%'  
--	 if  @v_Typ='2' or @v_Typ='3' or @v_Typ='4' or @v_Typ='99'    
-- 		set @v_Param = @v_Param +'%'   
	
--  end 
  
	Declare @Prd		int
	Declare @Year		int
	Declare @AnnualLv	Char(10)
	Declare @BasicCd		Char(15)
	Declare @AmtDecs		int
	Declare @EDay		int
  
	select @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
	select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
	Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_Cocd
	Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_Cocd
	select @AmtDecs=AmtDecs From Company Where Cd=@v_Cocd
	Exec @EDay=Get_EDay @Prd,@Year
  
 select--Top (@v_RowsCnt)  
  Emp.Cd    
 , (select Codes.SDes from Codes where Codes.Cd=Emp.Salute)[Salutation]    
 , Emp.Fname[FirstName]    
 , Emp.Mname[MiddleName]    
 , Emp.Lname[LastName]    
 , Emp.Fname+' '+isnull(Emp.Mname,'')+' '+isnull(Emp.Lname,'') [Name]    
 , Emp.Sex[Sex]    
 , Emp.CoCd[Company]    
 , (select SDes FROM Branch where Cd=Emp.Div)[Branch]  
 , trim(Emp.Div)[BranchCd]    
 , (select SDes from CC where Cd=Emp.CC)[CC]    
 , (select SDes from Dept where Dept.Cd=Emp.Dept)[Department] 
 , Emp.Dept[DepartmentCd]   
 , (select SDes FROM Codes where Codes.cd=Emp.LocCd)[Location] 
 , Emp.LocCd[LocationCd]    
 , Emp.POB[POB]    
 , (select Nat FROM Country where Cd=Emp.Nat)[Nationality]    
 , (select SDes FROM Codes where cd=Emp.Relg and Typ='HRELG')[Religion]    
 , (select SDes FROM Codes where Cd=Emp.Marital)[MaritalStatus]    
 , (select SDes FROM Designation where Designation.cd=Emp.Desg)[Designation]
 ,TRIM(Emp.Desg)Desg
 , Emp.DOB[DOB]     
 , CONVERT(varchar(20), Emp.DOB,103)[FormatedDOB]    
 , Emp.DOJ[DOJ]    
 , CONVERT(varchar(20), Emp.DOJ,103)[FormatedDOJ] 
 , CONVERT(varchar(20), Emp.Probation,103)[FormatedProbation] 
 , CONVERT(varchar(20), Emp.Confrm,103)[FormatedConfrm]  
 , (select SDes FROM Codes where Codes.Cd=Emp.EmpCat1)[EmployeeCategory1]    
 , (select SDes FROM Codes where Codes.Cd=Emp.EmpCat2)[EmployeeCategory2]    
 , (select SDes FROM Codes where Codes.Cd=Emp.EmpCat3)[EmployeeCategory3]    
 , (select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName) from Employee where Cd=Emp.RepTo )[ReportingTo]    
 , Emp.Father    
 , Emp.Mother    
 , Emp.Spouse  -- select * from Employee where cd='456'   
 , Emp.Probation    
 , Emp.Confrm[Confirm]    
 , Emp.Basic
 ,	Emp.CurrCd[CurrencyCd]   
 , (select Abbr FROM Currency where Cd=Emp.CurrCd)[Currency] 
 ,	(select Rate from CurrencyRates where CurrCd=Emp.CurrCd and CoCd=@v_Cocd)[CurrencyExchangeRate]    
 , Emp.FareEligible[FareEligiblity]    
 , Emp.NoTickets[No. of Tickets]    
 , (select SDes FROM Codes where Codes.cd=Emp.TravSect)[TravelSector]    
 , (select SDes FROM Codes where Codes.cd=Emp.TravClass)[TravelClass]    
 , Emp.HomeBase[Home Base]  
 , (select SDes from SysCodes where Cd=Emp.PayMode)[PayMode]    
 , (select SDes from SysCodes where Cd=Emp.PayFreq)[PayFrequency]    
 , (select SDes from Codes where Typ='BANK' and Cd=Emp.BankCd)[Bank]    
 , Emp.LvDays[Leave Days]    
 , (select SDes from SysCodes where Cd=Emp.Status)[Status]    
 , (select Sdes from Codes where Cd=Emp.Sponsor)[Sponsor]    
  ,TRIM(Emp.Sponsor)SponsorCd
 , Emp.ImageFile[ImageFilePath]    
 , Emp.ImageSign[SignatureFilePath]    
 , Emp.RepTo[ReportingToCd]    
 , Emp.OTEligible[OTEligible]    
 , Emp.LvPrd[Leaveperiod]    
 , (select Des from CompanyTradeClass CTC where CTC.Cd=Emp.TradeCd)[TradeCode]    
 , (select SDes from Codes where Typ='J_ET' and Codes.cd=Emp.EmpTyp)[Emptype] 
  ,	EmpTyp
 , Emp.ApprCd[ApprCd]    
 , Emp.BasicCurr    
 , (select UName from Users where Cd=Emp.UserCd)[UserId]    
 , (select Sdes from CompanyShiftMaster where Cd=Emp.ShiftCd)[Shift]    
 , CalcBasis    
 , GT    
 , LS    
 , LT    
 , Emp.Grade  
  ,Emp.Active[Active]
 , (Select Mobile from EmpAddress where AddTyp ='HADD0001  ' and EmpCd=Emp.Cd)[MobNo]
 , (Select round(((Select 
			isnull(sum(
			case PercAmt
				When 'P' then  case EdTyp
						when 'HEDT02'then  -PercVal*.01*(Basic*Cr.Rate)
						else PercVal*.01*Basic
						end
				When 'A' then  case EdTyp
						when 'HEDT02' then -AmtVal*Cr.Rate
						else AmtVal*Cr.Rate	
						end
			end),0)
		From 
			EmpEarnDed Ed
		,	Employee Emp1
		,	Currency Cr
		
		Where  
			Emp1.Cd=EmpCd
		and	Cr.Cd=Ed.Curr
		and	EmpCd=Emp.Cd
		and	rtrim(EdTyp)+rtrim(EdCd) <> @BasicCd
		and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd=@AnnualLv and CoCd=@v_Cocd)
		and	EffDate<=rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year) 
		and	(EndDate>=rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)  or EndDate='1/1/1900'))
		+(select Basic from Employee where cd=Emp.Cd)
		) ,@amtdecs))  [Total]
	,'/Emp_Photos/'+trim(Emp.CoCd)+'/'+ Emp.Imagefile[Image]
	, PassportLocation
 	--,(select dbo.GetFunc_EmpWorkingStatus (emp.cd,getdate()) )[LvStatus]
	,	[Emp2].LvStatus [LvStatus]
--into dbo.#Employee
 from  
  Employee Emp  
  Join
		 (SELECT cd, dbo.GetFunc_EmpWorkingStatus(cd, GETDATE()) AS LvStatus FROM Employee) [Emp2] ON Emp.Cd = Emp2.cd
 Where  
			Emp.CoCd=@v_Cocd 
	and 	(Emp.cd = REPLACE(@v_Empcd, '%', '')  or Emp.Fname like @v_Empcd or Emp.Mname like @v_Empcd or Emp.Lname like @v_Empcd or @v_Empcd='')
	and		Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	and		(Emp.Div in (SELECT [Value] FROM dbo.SplitString(@v_Div, ',')) or @v_Div='0')
	and		(Emp.Dept in (SELECT [Value] FROM dbo.SplitString(@v_Dept, ',')) or @v_Dept='0')
	and		(Emp.Sponsor in (SELECT [Value] FROM dbo.SplitString(@v_Sponsor, ',')) or @v_Sponsor='0')
	and		(Emp.Desg in (SELECT [Value] FROM dbo.SplitString(@v_Designation, ',')) or @v_Designation='0')
	and		(Emp.EmpTyp in (SELECT [Value] FROM dbo.SplitString(@v_EmpTyp, ',')) or @v_EmpTyp='0')
	and		(Emp.Status=@v_Status or @v_Status='0')
	and		(Emp.Active=@v_Active or @v_Active='')
	AND		(Emp2.LvStatus = @v_LvStatus OR @v_LvStatus = '')
 Order By    
  EntryDt desc  
 , EditDt desc  
 , Emp.Cd  
	OFFSET (@v_PageNumber - 1) * @v_PageSize ROWS
	FETCH NEXT @v_PageSize ROWS ONLY;

--select * from #Employee --where LvStatus=@v_LvStatus or @v_LvStatus=''


	select count(*) from Employee Emp
	Join
		 (SELECT cd, dbo.GetFunc_EmpWorkingStatus(cd, GETDATE()) AS LvStatus FROM Employee) [Emp2] ON Emp.Cd = Emp2.cd
	Where  
			Emp.CoCd=@v_Cocd 
	and 	(Emp.cd like @v_Empcd or Emp.Fname like @v_Empcd or Emp.Mname like @v_Empcd or Emp.Lname like @v_Empcd or @v_Empcd='')
	and		Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	and		(Emp.Div in (SELECT [Value] FROM dbo.SplitString(@v_Div, ',')) or @v_Div='0')
	and		(Emp.Dept in (SELECT [Value] FROM dbo.SplitString(@v_Dept, ',')) or @v_Dept='0')
	and		(Emp.Sponsor in (SELECT [Value] FROM dbo.SplitString(@v_Sponsor, ',')) or @v_Sponsor='0')
	and		(Emp.Desg in (SELECT [Value] FROM dbo.SplitString(@v_Designation, ',')) or @v_Designation='0')
	and		(Emp.EmpTyp in (SELECT [Value] FROM dbo.SplitString(@v_EmpTyp, ',')) or @v_EmpTyp='0')
	and		(Emp.Status=@v_Status or @v_Status='0')
	and		(Emp.Active=@v_Active or @v_Active='')
	AND		(Emp2.LvStatus = @v_LvStatus OR @v_LvStatus = '')

--drop table #Employee
End 
 Go 
CREATE OR ALTER     Procedure [dbo].[GetRepo_EmpShortList_N]
	@v_CoCd				Varchar(5)	 
,   @v_Employee			Char(10)=''	
,   @v_Branch			char(500)=''
,   @v_Location			char(100)=''	
,   @v_Department		Char(100)=''	
,   @v_Sponsor			Char(500)=''	
,	@v_Desg				Char(5)=''
,	@v_Age				Char(5)='0'
,	@v_Qualification	Char(10)=''
,	@v_Status			Char(500)=''
,   @v_RowsCnt			Char(1)=''
,	@v_Nationality		Char(500)=''
,	@v_EmployeeType		Char(500)=''



As		-- Drop Procedure [dbo].[GetRepo_EmpShortList_N] '01','All ','All ','All ','All ','All ','All','0',' ','','2'
Begin
	Select
		distinct Emp.Cd [Code]
	,	rtrim(Emp.Fname)+' '+rtrim(Emp.Mname)+' '+rtrim(Emp.Lname) [EmpName]
	,	Emp.Sex [Sex] 
	,	(select SDes FROM Codes where Typ='HMS' and Codes.cd=Emp.Marital)[Marital]
	,	(Select SDes FROM Branch where Cd=Emp.Div)[Branch]
	,	(Select SDes FROM CC where Cd=Emp.CC)[CC]
	,	(Select SDes FROM Dept where Dept.Cd=Emp.Dept) [Department]
	,	(select SDes FROM Codes where Codes.cd=Emp.LocCd) [Location]
	,	(Select Nat from Country where cd=Emp.Nat) [Nationality]
	,	(select Des FROM Designation where Designation.Cd=Emp.Desg) [Designation]
	--,	Emp.Dob	[Dob]
	,	CONVERT(varchar(20),Emp.Dob,101)[Dob]
	--,	Emp.DOJ	[DOJ]
	,	CONVERT(varchar(20),Emp.DOJ,101)[
	DOJ]
	--,	(select SDes FROM Codes ,Employee where Codes.cd=Employee.EmpCat1 and Employee.cd=Emp.Cd)[Employee Category1]
	--,	(select SDes FROM Codes ,Employee where Codes.cd=Employee.EmpCat2 and Employee.cd=Emp.Cd)[Employee Category2]
	--,	(select SDes FROM Codes ,Employee where Codes.cd=Employee.EmpCat3 and Employee.cd=Emp.Cd)[Employee Category3]
	,	(select rtrim(FName)+' '+rtrim(MName)+rtrim(LName) from Employee where Cd=(select RepTo from Employee where Employee.cd=Emp.Cd))[ReportingTo]
	,	(Select Des from Currency where Cd= Emp.BasicCurr) [BasicCurr]
	,	Emp.Basic [Basic]
	,	Emp.Basic+(select Sum(isnull(AmtVal,0)) from empearnded where EmpCd=Emp.Cd and (Rtrim(EdCd)+RTrim(EdTyp))<>'001HEDT01' and CONVERT(varchar(10), EndDate,101)='01/01/1900') [Total]
	,	Emp.FareEligible [FareEligiblity]
	,	(select Des from codes where Typ='ESPON' and Cd=emp.Sponsor)[Sponsor]
	,	(select Des from Syscodes where cd=Emp.PayMode) [PayMode]
	,	(select Des from Syscodes where cd=Emp.PayFreq) [PayFrequency]
	,	(select Des from Syscodes where cd=Emp.Status) [Status]
	,	(select Des from CompanyShiftMaster where Cd=Emp.ShiftCd) [Shift]
	,	(select Des from Syscodes where Typ='HOTC1' and Cd=Emp.Relg) [Religion]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0001' and EmpCd=Emp.cd order by SrNo desc) [PassportNo]
	,	(select top 1 CONVERT(varchar(20),ExpDt,101) from EmpDocuments where DocTyp='HDTYP0001' and EmpCd=Emp.cd order by SrNo desc) [PassportExpDt]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0002' and EmpCd=Emp.cd order by SrNo desc) [VisaNo]
	,	(select top 1 CONVERT(varchar(20),ExpDt,101) from EmpDocuments where DocTyp='HDTYP0002' and EmpCd=Emp.cd order by SrNo desc) [VisaExpDt]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0003' and EmpCd=Emp.cd order by SrNo desc) [LabourCard]
	,	(select top 1 CONVERT(varchar(20),ExpDt,101) from EmpDocuments where DocTyp='HDTYP0003' and EmpCd=Emp.cd order by SrNo desc) [LabourCardExpDt]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0008' and EmpCd=Emp.cd order by SrNo desc) [EmiratedId]
	,	(select Phone from EmpAddress where AddTyp='HADD0001' and EmpCd=Emp.cd) [PhoneNo]
	,	(select Email from EmpAddress where AddTyp='HADD0001' and EmpCd=Emp.cd) [EmailId]
	--,	Emp.Basic+(select Sum(isnull(AmtVal,0)) from empearnded where EmpCd=Emp.Cd and (Rtrim(EdCd)+RTrim(EdTyp))<>'001HEDT01' and CONVERT(varchar(10), EndDate,101)='01/01/1900') [Total]
	,	(Select CoName from Company where Cd=@v_CoCd) [CoName]
	,	Emp.EmpTyp
	from 
		Employee Emp
		--,Codes    Cod2,Branch    Br,Codes    Cod1,Dept  Dep,EmpQualification Qua 
		--inner join   Codes    Cod2 on Cod2.Cd=Emp.Sponsor
		--inner join 	Branch    Br on Br.Cd=Emp.Div	
		--inner join   Codes    Cod1 on Cod1.Cd=Emp.LocCd  
		--inner join Dept       Dep on Dep.Cd=Emp.Dept 
		--inner join EmpQualification Qua on emp.Cd=qua.EmpCd
		--inner join Designation desg on desg.cd=Emp.Desg
	--,	Codes Cod
	where
		Emp.CoCd=@v_CoCd		
		and (@v_Employee='All' or Emp.Cd=@v_Employee)
		and (@v_Branch='All' or emp.Div in(SELECT [Value] FROM dbo.SplitString(@v_Branch, ',')))
		and (@v_location='All' or emp.LocCd=@v_location)
		and (@v_Department='All' or Emp.Dept=@v_Department)
		and (@v_Sponsor='All' or emp.Sponsor in(SELECT [Value] FROM dbo.SplitString(@v_Sponsor, ',')))
		and (@v_Desg='All' or  Emp.Desg=@v_Desg)
		and (@v_Age='0' or CONVERT(int,ROUND(DATEDIFF(hour,Emp.Dob,GETDATE())/8766.0,0))=@v_Age)
		and (@v_Qualification='All' or emp.cd in (select empcd from EmpQualification where Cd= @v_Qualification))
		and (@v_Nationality='All' or emp.Nat =(SELECT [Value] FROM dbo.SplitString(@v_Nationality, ',')))
		and (emp.EmpTyp in(SELECT [Value] FROM dbo.SplitString(@v_EmployeeType, ',')) or @v_EmployeeType='ALL')
		and (emp.Status in(SELECT [Value] FROM dbo.SplitString(@v_Status, ',')) or @v_Status='ALL')
		and	( Active=@v_RowsCnt)
		--and Cod2.Cd=Emp.Sponsor
		--and Br.Cd=Emp.Div	and Cod1.Cd=Emp.LocCd and Dep.Cd=Emp.Dept and emp.Cd=qua.EmpCd 
		--and (@v_Employee='All' or @v_Employee<>'All' and Emp.Cd=@v_Employee)
		--and (@v_Branch='All' or @v_Branch<>'All' and br.Cd=@v_Branch)
		--and (@v_location='All' or @v_location<>'All' and Cod1.Cd=@v_location)
		--and (@v_Department='All' or @v_Department<>'All' and Dep.Cd=@v_Department)
		--and (@v_Sponsor='All' or @v_Sponsor<>'All' and Cod2.Cd=@v_Sponsor)		
		--and	(@v_Desg='All' or  Emp.Desg=@v_Desg)
		--and (@v_Age='0' or CONVERT(int,ROUND(DATEDIFF(hour,Emp.Dob,GETDATE())/8766.0,0))=@v_Age)
		--and (@v_Qualification='All' or qua.QualCd=@v_Qualification)
		--and (@v_RowsCnt='0' and (Emp.Status in ('HSTATAB','HSTATDI','HSTATDO','HSTATNP','HSTATPM'))) 
		--	or (@v_RowsCnt='1' and Emp.Status in ('HSTATSR','HSTATST'))
		--	or (@v_RowsCnt='2' and  ltrim(rtrim(Emp.Status))=ltrim(rtrim(@v_Status))) or (@v_RowsCnt='')

	order by 
		Emp.Cd
End 
 Go 

CREATE OR ALTER Procedure [dbo].[GetRepo_FixedEarnDed]
@v_CoName Varchar(30)
,	@v_RPrd Char(2)
,	@v_RYear Char(4)
,	@v_EmpCd Char(10)
--Drop procedure [dbo].[GetRepo_FixedEarnDed]  'A4M Group - UAE ','09 ','2014 ','   '
as
	Declare @v_CoCd char(5)
	Declare @AmtDecs int
	Declare @Prd int
	Declare @Year int
	select @v_CoCd=Cd from Company where CoName=@v_CoName
	select @AmtDecs=AmtDecs from Company where Cd=@v_CoCd
	select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_CoCd
	select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_CoCd

	if cast(@v_RPrd as int) = @Prd and cast(@v_RYear as int)=@Year
		Select
			EmpTrans.EmpCd[Code]
		,	Emp.Fname[FName]
		,	Emp.Mname[MName]
		,	Emp.Lname[LName]
		,	EmpTrans.EdCd[Type Code]
		,	Sys.Sdes[Type Des]
		,	EmpTrans.EdTyp
		,	CoEd.Sdes[Pay Type]
		,	case EdTyp 
			when 'HEDT02' then -EmpTrans.Amt
			else EmpTrans.Amt
			end[Amt]
		,	Curr[Curr]
		,	ExRate
		,	CoEd.TrnTyp[Transaction Type]
		,	@v_CoName[Coname]
		,	Br.Sdes[Branch]
		,	(Select SDes from Codes where Cd=Emp.LocCd)[Location]
		,	(select SDes from CC where Cd=Emp.CC)[CC]
		,	(select Sdes from Dept Where cd=Emp.Dept)[Department]
		,	@AmtDecs[AmtDecs]
		,	case EdTyp
			when 'HEDT02' then 'Deductions'
			else 'Earnings'
			end[PTYP]
		From
			EmpTrans 		EmpTrans
		,	CompanyEarnDed 	CoED
		,	Employee 		Emp
		,	SysCodes		Sys
		,	Company		Co
		,	Branch			Br
		where
			Emp.cd=EmpTrans.Empcd
		and	(@v_EmpCd='' or @v_EmpCd<>'' and Emp.cd=@v_EmpCd)
		and	Sys.Cd=EmpTrans.EdTyp
		and	CoEd.Cd=EmpTrans.Edcd
		and	CoEd.Typ=EmpTrans.EdTyp
		and	Co.Cd=Emp.Cocd
		and	Co.Cd=@v_CoCd
		and	Br.cd=Emp.Div
		and	EdTyp<>'HEDT04'
		and	Emp.Status<>'HSTATNP'
		union
		Select
			Emp.Cd[Code]
		,	Emp.Fname[FName]
		,	Emp.Mname[MName]
		,	Emp.Lname[LName]
		,	''[Type Code]
		,	'Others'[Type Des]
		,	''[EdTyp]
		,	'Rounding'[Pay Type]
		,	isnull((select RoundedAmt-NetSalary from EmpSalRound where EmpCd=Emp.Cd),0)[Amt]
		,	BaseCurr[Curr]
		,	1[ExRate]
		,	''[Transaction Type]
		,	@v_CoName[Coname]
		,	Br.Sdes[Branch]
		,	(Select SDes from Codes where Cd=Emp.LocCd)[Location]
		,	(select SDes from CC where Cd=Emp.CC)[CC]
		,	(select Sdes from Dept Where cd=Emp.Dept)[Department]
		,	@AmtDecs[AmtDecs]
		,	''[PTYP]
		From
			Employee 		Emp
		,	Company		Co
		,	Branch			Br
		where
		(@v_EmpCd='' or @v_EmpCd<>'' and Emp.cd=@v_EmpCd)
		and	Co.Cd=Emp.Cocd
		and	Co.Cd=@v_CoCd
		and	Br.cd=Emp.Div
		and	Emp.Status<>'HSTATNP'
	else
		Select
			EmpTrans.EmpCd[Code]
		,	Emp.Fname[FName]
		,	Emp.Mname[MName]
		,	Emp.Lname[LName]
		,	EmpTrans.EdCd[Type Code]
		,	Sys.Sdes[Type Des]
		,	EmpTrans.EdTyp
		,	CoEd.Sdes[Pay Type]
		,	case EdTyp 
			when 'HEDT02' then -EmpTrans.Amt
			else EmpTrans.Amt
			end[Amt]
		,	Curr
		,	ExRate
		,	CoEd.TrnTyp[Transaction Type]
		,	@v_CoName[Coname]
		,	Br.Sdes[Branch]
		,	(Select SDes from Codes where Cd=Emp.LocCd)[Location]
		,	(select SDes from CC where Cd=Emp.CC)[CC]
		,	(select Sdes from Dept Where cd=Emp.Dept)[Department]
		,	@AmtDecs[AmtDecs]
		,	case EdTyp
			when 'HEDT02' then 'Deductions'
			else 'Earnings'
			end[PTYP]
		From
			EmpTransYtd 		EmpTrans
		,	CompanyEarnDed 	CoED
		,	Employee 		Emp
		,	SysCodes		Sys
		,	Company		Co
		,	Branch			Br
		where
			Emp.cd=EmpTrans.Empcd
		and (@v_EmpCd='' or @v_EmpCd<>'' and Emp.cd=@v_EmpCd)	
		and	Sys.Cd=EmpTrans.EdTyp
		and	CoEd.Cd=EmpTrans.Edcd
		and	CoEd.Typ=EmpTrans.EdTyp
		and	Co.Cd=Emp.Cocd
		and	Co.Cd=@v_CoCd
		and	Br.cd=Emp.Div
		and	EdTyp<>'HEDT04'
		and	Emp.Status<>'HSTATNP'
		and	Prd=rtrim(@v_RYear)+right('0'+rtrim(@v_RPrd),2)
		union
		Select
			Emp.Cd[Code]
		,	Emp.Fname[FName]
		,	Emp.Mname[MName]
		,	Emp.Lname[LName]
		,	''[Type Code]
		,	'Others'[Type Des]
		,	''[EdTyp]
		,	'Rounding'[Pay Type]
		,	isnull((select RoundedAmt-NetSalary from EmpSalRoundYtd where EmpCd=Emp.Cd and Prd=rtrim(@v_RYear)+right('0'+rtrim(@v_RPrd),2) ),0)[Amt]
		,	BaseCurr[Curr]
		,	1[ExRate]
		,	''[Transaction Type]
		,	@v_CoName[Coname]
		,	Br.Sdes[Branch]
		,	(Select SDes from Codes where Cd=Emp.LocCd)[Location]
		,	(select SDes from CC where Cd=Emp.CC)[CC]
		,	(select Sdes from Dept Where cd=Emp.Dept)[Department]
		,	@AmtDecs[AmtDecs]
		,	''[PTYP]
		From
			Employee 		Emp
		,	Company		Co
		,	Branch			Br
		where
		(@v_EmpCd='' or @v_EmpCd<>'' and Emp.cd=@v_EmpCd)
		and	Co.Cd=Emp.Cocd
		and	Co.Cd=@v_CoCd
		and	Br.cd=Emp.Div
		and	Emp.Status<>'HSTATNP'

 
 Go 
CREATE OR ALTER procedure [dbo].[EmpprovisionsadjAppr_Update_N]
@v_TransNo				char(10),
@v_ApprLvl				numeric(2,0),
@v_ApprBy				char(10),
@v_ApprDt				datetime,
@v_Status				char(1),
@v_Narr					varchar(200),
@v_EntryBy				char(5)
as  --drop procedure [dbo].[EmpprovisionsadjAppr_Update]
begin
IF (SELECT COUNT(*) FROM  EmpProvisionsAdjAppr WHERE TransNo = @v_TransNo and ApprLvl=@v_ApprLvl) = 0
    Begin
        insert into EmpProvisionsAdjAppr(TransNo,ApprLvl,ApprBy,ApprDt,Status,Narr,EntryBy,EntryDt) values
			(
			@v_TransNo				,
			@v_ApprLvl				,
			@v_ApprBy				,
			@v_ApprDt				,
			@v_Status				,
			@v_Narr					,
			@v_EntryBy				,
			GETDATE()				
			)
			exec GetMessage 1,'Inserted successfully'
    end
Else
    Begin
        Update EmpProvisionsAdjAppr
		Set
			ApprBy				=@v_ApprBy				,
			ApprDt				=@v_ApprDt				,
			Status				=@v_Status				,
			Narr				=@v_Narr				,
			EditBy				=@v_EntryBy				,
			EditDt				=GETDATE()				
			WHERE TransNo = @v_TransNo and ApprLvl=@v_ApprLvl
		End
		exec GetMessage 1,'Updated successfully'
End

 
 Go 
CREATE OR ALTER procedure [dbo].[Empprovisionsadj_Update_N]
		@v_TransNo	char(10)
	,	@v_TransDt	Datetime
	,	@v_EmpCd	char(10)
	,	@v_ProvTyp	char(10)
	,	@v_Days		Numeric(9,4)
	,	@v_Amt		Numeric(15,4)
	,	@v_Purpose	Varchar(50)
	,	@v_Narr		Varchar(100)
	,	@v_EntryBy	char(5)
as		--DROP procedure [dbo].[Empprovisionsadj_Update]'00613','08/21/2016','MHM/384   ','LS','0','111.82','','','MHM/413'
IF (SELECT COUNT(*) FROM empprovisionsadj WHERE TransNo= @v_TransNo) = 0
	Begin
	insert into empprovisionsadj(TransNo,TransDt,EmpCd,ProvTyp,Days,Amt,Purpose,Narr,Status,EntryBy,EntryDt)
	values
	(
		@v_TransNo
	,	@v_TransDt
	,	@v_EmpCd 	
	,	@v_ProvTyp 	
	,	@v_Days 	
	,	@v_Amt		
	,	@v_Purpose 	
	,	@v_Narr 
	,	'E'	
	,	@v_EntryBy
	,     	getdate()
        )
     exec GetMessage 1,'Inserted successfully'     
    if((select COUNT(*) From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT14' 
						and CPAD.ApplTyp=(select ProvTyp from EmpProvisionsAdj where TransNo=@v_TransNo)
						and CPAD.Div=(select Div from Employee where Cd=@v_EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=@v_EmpCd)
						and CPAD.CoCd=(select CoCd from Employee where Cd=@v_EmpCd))=0)
	BEGIN
			Update empprovisionsadj
			  Set
				Status='A'	
		,		ApprBy=@v_EntryBy
		,     	ApprDt=getdate()
			  where 
			TransNo=@v_TransNo
	END
		
end
Else  --TransNo,TransDt,RefDoc,RefDt,EmpCd,ProvTyp,Days,Amt,Purpose,Narr,ApprBy,ApprDt,EntryBy,EntryDt
    Begin
        Update empprovisionsadj
          Set
			TransDt=@v_TransDt
	,		EmpCd=@v_EmpCd 	
	,		ProvTyp=@v_ProvTyp 	
	,		Days=@v_Days 	
	,		Amt=@v_Amt		
	,		Purpose=@v_Purpose 	
	,		Narr=@v_Narr 	
	,		EditBy=@v_EntryBy
	,     	EditDt=getdate()
          where 
		TransNo=@v_TransNo
exec GetMessage 1,'Updated successfully'
    End
 
 Go 
CREATE OR ALTER procedure [dbo].[Empprovisionsadj_GetRow_N]
	@v_Param		Char(10)=null
,	@v_Typ			Char(1)=''
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
,	@v_Usercd		varchar(10)
As		-- Drop Procedure [dbo].[Empprovisionsadj_GetRow]'','6','HR','U','HR'
Begin	
	Select
		TransNo
	,	TransDt
	,	Convert(varchar(20),TransDt,103)[FormattedTransDt]
	,	RefDoc
	,	EmpCd
	,	(select Fname +' '+Mname+' '+LName from employee where cd=EmpCd)[Name]
	,	ProvTyp
	,	(select Des from CompanyProvisions where cd=ProvTyp)[Prov]
	,	Days
	,	Amt
	,	Purpose
	,	Narr
	,	ApprBy
	,	ApprDt
	
	,	case when @v_Typ = '2'
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT14' 
			and CPAD.ApplTyp=EP.ProvTyp
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval_Level]
	,	case when @v_Typ = '2'
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT14' 
			and CPAD.ApplTyp=EP.ProvTyp
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval]
		
	From
		empprovisionsadj EP
	Where
		(@v_Typ='0') or
		(@v_Typ='1' and ltrim(str(month(EP.TransDt)))=@v_Param) or
		(@v_Typ='2' and EP.TransNo=@v_Param) or
		(@v_Typ='3' and EP.EmpCd=@v_Param) or 
		(@v_Typ='4' and EP.Status='E') or 
		(@v_Typ='5' and EP.Status='A') or 
		(@v_Typ ='6' and TransNo in( select TransNo  from empprovisionsadj
				inner join Employee as emp on emp.Cd=empprovisionsadj.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT14' and CPA.ApplTyp=EP.ProvTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				empprovisionsadj.Status='E' 
				and emp.Status='HSTATPM '
				and emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT14' and CPA.ApplTyp=EP.ProvTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) )))
			)
	order by TransNo 
End
 
 Go 
CREATE OR ALTER procedure [dbo].[Empprovisionsadj_GetRow]
	@v_Param		Char(10)=null
,	@v_Typ			Char(1)=''
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
,	@v_Usercd		varchar(10)='001'
As		-- Drop Procedure [dbo].[Empprovisionsadj_GetRow]'','6','HR','U','HR'
Begin	
	Select
		TransNo
	,	TransDt
	,	Convert(varchar(20),TransDt,103)[FormattedTransDt]
	,	RefDoc
	,	EmpCd
	,	(select Fname +' '+Mname+' '+LName from employee where cd=EmpCd)[Name]
	,	ProvTyp
	,	(select Des from CompanyProvisions where cd=ProvTyp)[Prov]
	,	Days
	,	Amt
	,	Purpose
	,	Narr
	,	ApprBy
	,	ApprDt
	
	,	case when @v_Typ = '2'
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT14' 
			and CPAD.ApplTyp=EP.ProvTyp
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval_Level]
	,	case when @v_Typ = '2'
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT14' 
			and CPAD.ApplTyp=EP.ProvTyp
			and CPAD.Div=(select Div from Employee where Cd=EP.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EP.EmpCd)
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval]
		
	From
		empprovisionsadj EP
	Where
		(@v_Typ='0') or
		(@v_Typ='1' and ltrim(str(month(EP.TransDt)))=@v_Param) or
		(@v_Typ='2' and EP.TransNo=@v_Param) or
		(@v_Typ='3' and EP.EmpCd=@v_Param) or 
		(@v_Typ='4' and EP.Status='E') or 
		(@v_Typ='5' and EP.Status='A') or 
		(@v_Typ ='6' and TransNo in( select TransNo  from empprovisionsadj
				inner join Employee as emp on emp.Cd=empprovisionsadj.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT14' and CPA.ApplTyp=EP.ProvTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				empprovisionsadj.Status='E' 
				and emp.Status='HSTATPM '
				and emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT14' and CPA.ApplTyp=EP.ProvTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) )))
			)
	order by TransNo 
End
 
 Go 
CREATE OR ALTER procedure [dbo].[Empprovisionsadj_Update]
		@v_TransNo	char(10)
	,	@v_TransDt	Datetime
	,	@v_EmpCd	char(10)
	,	@v_ProvTyp	char(10)
	,	@v_Days		Numeric(9,4)
	,	@v_Amt		Numeric(15,4)
	,	@v_Purpose	Varchar(50)
	,	@v_Narr		Varchar(100)
	,	@v_EntryBy	char(5)
as		--DROP procedure [dbo].[Empprovisionsadj_Update]'00613','08/21/2016','MHM/384   ','LS','0','111.82','','','MHM/413'
IF (SELECT COUNT(*) FROM empprovisionsadj WHERE TransNo= @v_TransNo) = 0
	Begin
	insert into empprovisionsadj(TransNo,TransDt,EmpCd,ProvTyp,Days,Amt,Purpose,Narr,Status,EntryBy,EntryDt)
	values
	(
		@v_TransNo
	,	@v_TransDt
	,	@v_EmpCd 	
	,	@v_ProvTyp 	
	,	@v_Days 	
	,	@v_Amt		
	,	@v_Purpose 	
	,	@v_Narr 
	,	'E'	
	,	@v_EntryBy
	,     	getdate()
        )
        
    if((select COUNT(*) From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT14' 
						and CPAD.ApplTyp=(select ProvTyp from EmpProvisionsAdj where TransNo=@v_TransNo)
						and CPAD.Div=(select Div from Employee where Cd=@v_EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=@v_EmpCd)
						and CPAD.CoCd=(select CoCd from Employee where Cd=@v_EmpCd))=0)
	BEGIN
			Update empprovisionsadj
			  Set
				Status='A'	
		,		ApprBy=@v_EntryBy
		,     	ApprDt=getdate()
			  where 
			TransNo=@v_TransNo
	END
		
end
Else  --TransNo,TransDt,RefDoc,RefDt,EmpCd,ProvTyp,Days,Amt,Purpose,Narr,ApprBy,ApprDt,EntryBy,EntryDt
    Begin
        Update empprovisionsadj
          Set
			TransDt=@v_TransDt
	,		EmpCd=@v_EmpCd 	
	,		ProvTyp=@v_ProvTyp 	
	,		Days=@v_Days 	
	,		Amt=@v_Amt		
	,		Purpose=@v_Purpose 	
	,		Narr=@v_Narr 	
	,		EditBy=@v_EntryBy
	,     	EditDt=getdate()
          where 
		TransNo=@v_TransNo

    End
 
 Go 

CREATE OR ALTER   PROCEDURE [dbo].[Employee_GetRowItems_N] 
	@v_Empcd			char(10)
,	@v_Cocd				Char(5)  
,	@v_Div				varchar(40)		='0'
,	@v_Dept				varchar(40)		='0'
,	@v_Section			varchar(40)		='0'
,	@v_Designation		varchar(40)		='0'
,	@v_Usercd			varchar(10)			
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Cd,Salute,Dept,LocCd,POB,Nat,Relg,Marital,Desg,Dob,Doj,Basic,BasicCurr,FareEligible,LvDays,Status,Imagefile Image,ImageSign,UserCd
	 , Emp.Fname+' '+isnull(Emp.Mname,'')+' '+isnull(Emp.Lname,'') [Name]
	 from Employee Emp
	where 
	Active='Y' and CoCd =@v_Cocd
	and 	(Emp.cd=@v_Empcd or @v_Empcd='')
	and		Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	and		(Emp.Div in (SELECT [Value] FROM dbo.SplitString(@v_Div, ',')) or @v_Div='0')
	and		(Emp.Dept in (SELECT [Value] FROM dbo.SplitString(@v_Dept, ',')) or @v_Dept='0')
	and		(Emp.LocCd in (SELECT [Value] FROM dbo.SplitString(@v_Section, ',')) or @v_Section='0')
	and		(Emp.Desg in (SELECT [Value] FROM dbo.SplitString(@v_Designation, ',')) or @v_Designation='0')
	Order By    
  EntryDt desc  
 , EditDt desc  
 , Emp.Cd  
END
 
 
 Go 
CREATE OR ALTER Procedure [dbo].[Designation_GetRow]
	@v_Cd Char(5)
As		-- Drop Procedure [dbo].[Designation_GetRow] ''
Begin
	Select
		Cd
	,	Des
	,	SDes
	,	(Select SDes from Grade where Grade.Cd=GradeCd)[Grade]
	,	EntryBy
	,	EntryDt
	,	EditBy
	,	EditDt
	From 		
		Designation
	Where
		@v_Cd = '' or Cd = @v_Cd
	Order by
		cast(REPLACE(trim(Cd), 'DESG', '') as int)  asc
End
 
 Go 


CREATE OR ALTER Procedure [dbo].[EmpFund_Confirm_Revise_Cancel_Update]
	@v_CoCd				Char(5)
,	@v_Typ				Char(1)
,	@v_TransNo			Char(10)
,	@v_CancelBy			Char(10)
,	@v_CancelDt			Datetime
,	@v_Remarks			Varchar(100)
,	@v_LvSalary			numeric(9,3)='0'
,	@v_Disburse			char(1)='N'
,	@v_Appltyp			char(10)
As		-- Drop Procedure [dbo].[EmpFund_Confirm_Revise_Cancel_Update]'100','0','00002','admin','03/26/2016','','1200','2100','1','1'
Begin
CREATE table dbo.#EmpFundDays
		(	SlNo int identity,
			NoOfDays  numeric(18,0),
			DivCd  Char(10)
		)
	if @v_Typ='0'
	  Begin
	  -------------------------------------------------------------------------LEAVE SALARY/TICKET CALC.-----------------------------------------------------------
		Declare @Prd 			int
		Declare @Year 			int	
		Declare	@EmpCd			Char(10)
		Declare	@Days			Numeric(9,4)
		Declare	@LvSalaryDays	Numeric(9,4)
		Declare	@CumLvNOPay		Numeric(9,4)
		Declare @AmtDecs		int
		Declare @v_BeginDate 	datetime
		Declare @EDay 			int
		Declare @BasicCd		Char(15)
		Declare @AnnualLv		Char(10)
		Declare	@amt			Numeric(9,3)
		Declare	@Day			Numeric(9,4)
		Declare	@Div			char(5)
		Declare @StrtPrd		Datetime
		Declare @StrtPrdPrd		int
		Declare @StrtPrdYear	int
		Declare @Base_Curr		char(5)
		Declare @Ex_Rate		numeric(18,10)

		select @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
		select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
		select @AmtDecs=AmtDecs From Company Where Cd=@v_CoCd
		select @Prd=val From Parameters Where Cd='CUR_MONTH' and CoCd=@v_CoCd
		select @Year=Val From Parameters Where Cd='CUR_YEAR' and CoCd=@v_CoCd
		set    @v_BeginDate=rtrim(@Prd) + '/1/'+rtrim(@Year)
		Exec   @EDay=Get_EDay @Prd,@Year
		select @EmpCd=Empcd From EmpLeaveSalaryTicket where TransNo=@v_TransNo
		select @Days=case when wp_fromdt='1900-01-01' and wp_todt='1900-01-01' then 0 else DATEDIFF(dd,wp_fromdt,wp_todt)+1 end from EmpLeave where TransNo=@v_TransNo
		select @CumLvNOPay=case when WOP_FromDt='1900-01-01' and WOP_ToDt='1900-01-01' then 0 else DATEDIFF(dd,WOP_FromDt,WOP_ToDt)+1 end from EmpLeave where TransNo=@v_TransNo
		Select @StrtPrdPrd=substring((Select Val from Parameters where Cd='HR_ST_PRD' and CoCd=@v_CoCd),5,2)
		Select @StrtPrdYear=substring((Select Val from Parameters where Cd='HR_ST_PRD' and CoCd=@v_CoCd),1,4)
		select @StrtPrd=CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2)))
		Select @Base_Curr=basiccurr from Employee where cd=@EmpCd
		Select @Ex_Rate=Rate from Currency where cd=@Base_Curr

		
		
		declare @LSToDt datetime
		select @LSToDt=@v_CancelDt
		declare @LSFromDt datetime
		set @LSFromDt=(select isnull(
							(select Top 1 ConfirmDt as Dt from EmpFund where EmpCd=@EmpCd and Amount>0 and Status='F' order by ConfirmDt desc)
					,@StrtPrd)) end
				
		Declare @LSSlNo int
		Declare @LSMinSlNo int
		Declare @LSMaxSlNo int
		set @LSSlNo=isnull((select TOP 1 SrNo from EmpTransfers where EmpCd=@EmpCd and TransferDt between @LSFromDt and @LSToDt order by srno asc),0)
		set @LSMinSlNo=isnull((select TOP 1 SrNo from EmpTransfers where EmpCd=@EmpCd and TransferDt between @LSFromDt and @LSToDt order by srno asc),0)
		set @LSMaxSlNo=isnull((select TOP 1 SrNo from EmpTransfers where EmpCd=@EmpCd and TransferDt between @LSFromDt and @LSToDt order by srno desc),0)

		if((select Count(SrNo) from EmpTransfers where EmpCd=@EmpCd and TransferDt between @LSFromDt and @LSToDt)=0)
			insert into dbo.#EmpFundDays values(DATEDIFF(DD,@LSFromDt,@LSToDt),(select div from  Employee where Cd=@EmpCd))
		
		else if((select Count(SrNo) from EmpTransfers where EmpCd=@EmpCd and TransferDt between @LSFromDt and @LSToDt)=1)
		begin
			insert into dbo.#EmpFundDays values
			(datediff(dd,@LSFromDt,(select TransferDt from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
			  ,(select BrFrom from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
			  
			insert into dbo.#EmpFundDays values
			(datediff(dd,(select TransferDt from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd),@LSToDt)
			  ,(select BrTo from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
		end
		else
		begin
			while(@LSSlNo<=@LSMaxSlNo)
			begin
				if(@LSSlNo=@LSMinSlNo)
					insert into dbo.#EmpFundDays values
					(datediff(dd,@LSFromDt,(select TransferDt from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
					  ,(select BrFrom from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
				if(@LSSlNo=@LSMaxSlNo)
				begin
					insert into dbo.#EmpFundDays values
					(datediff(dd,(select TransferDt from EmpTransfers where SrNo=@LSSlNo-1 and EmpCd=@EmpCd),(select TransferDt from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
					  ,(select BrFrom from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
					  
					insert into dbo.#EmpFundDays values
					(datediff(dd,(select TransferDt from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd),@LSToDt)
					  ,(select BrTo from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
				end
				if(@LSSlNo!=@LSMinSlNo and @LSSlNo!=@LSMaxSlNo)
				Begin
					insert into dbo.#EmpFundDays values
					(datediff(dd,(select TransferDt from EmpTransfers where SrNo=@LSSlNo-1 and EmpCd=@EmpCd),(select TransferDt from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
					  ,(select BrFrom from EmpTransfers where SrNo=@LSSlNo and EmpCd=@EmpCd))
				set @LSSlNo=@LSSlNo+1
				End
			End
		End
		
			
		---------------------------------------------------------------------------------------------------------------------------------------------------------	
		 
		
		Update EmpFund Set
			ConfirmBy		=@v_CancelBy
		,	ConfirmDt		=@v_CancelDt
		,	ConfirmRemarks	=@v_Remarks
		,	Status			='F'
		,	Amount			=@v_LvSalary
		,	Hrdiv			=(select div from employee where cd=@EmpCd)
		Where
			TransNo=@v_TransNo
			if(@v_LvSalary>0)
			begin
				Declare @LSRowCount int
				set @LSRowCount=1
				while(@LSRowCount<=(select MAX(SlNo) from dbo.#EmpFundDays))
				begin
					set @Day=(@LvSalaryDays*(select isnull(NoOfDays,0) from dbo.#EmpFundDays where SlNo=@LSRowCount))/(select SUM(isnull(NoOfDays,0)) from dbo.#EmpFundDays)
					set @amt=(@v_LvSalary*(select isnull(NoOfDays,0) from dbo.#EmpFundDays where SlNo=@LSRowCount))/(select SUM(isnull(NoOfDays,0)) from dbo.#EmpFundDays)
					set @Div=(select DivCd from dbo.#EmpFundDays where SlNo=@LSRowCount)
					exec Update_EmpProvisions @Prd,@Year,@EmpCd,'EF','0',@amt,'A',@Div
					if(@v_Disburse='Y')
					begin
					exec EmpTrans_Update @EmpCd,'EF','HEDT03','',@Base_Curr,@Ex_Rate,@amt,'','',@LSRowCount,@LSFromDt,@v_CancelDt,'*S',@Div
					end
					set @LSRowCount=@LSRowCount+1
				end
			end
		
		DROP TABLE dbo.#EmpFundDays

	if @v_Typ='1'
	  Begin
		Update EmpFund Set
			CancelBy=@v_CancelBy
		,	CancelDt=@v_CancelDt
		,	CancelRemarks=@v_Remarks
		,	Status='C'
		Where
			TransNo=@v_TransNo
		--Update EmpLeave set JoinDt=null where TransNo=@v_TransNo
	  End
	  
End
 
 Go 

CREATE OR ALTER   Procedure [dbo].[CompanyDocuments_GetRow_N]
	@v_CoCd				Char(5)
,	@v_DocTypCd			Char(10)
,	@v_DivCd			Char(5)
,	@v_Usercd		varchar(10)
As		-- Drop Procedure CompanyDocuments_GetRow_N '01','',''
Begin
	Select
		(Select SDes from Codes Where Cd=Cd.DocTyp)+'_'+(Select SDes from Branch Where Cd=Cd.Div)[DocTypSDes]
    ,   (Select SDes from Branch Where Cd=Cd.Div)[DivSDes]
	,	Cd.DocNo[DocNo]
	,	Cd.IssueDt[IssueDt]
	,	CONVERT(varchar(10), Cd.IssueDt,103)[FormatedIssueDt]
	,	Cd.IssuePlace[IssuePlace]
	,	Cd.ExpDt[ExpDt]
	,	CONVERT(varchar(10), Cd.ExpDt,103)[FormatedExpDt]
	,	Cd.RefNo[RefNo]
	,	Case Cd.RefDt
		When '1/1/1900' then null
		Else Cd.RefDt
		End [RefDt]
	,	Case Cd.RefDt
		When '1/1/1900' then null
		Else CONVERT(varchar(10), Cd.RefDt,103)
		End [FormatedRefDt]
	,	CoCd
	,	Cd.Narr[Narr]
	,	ltrim(rtrim(Cd.DocTyp+'_'+Cd.Div))[DocTypCd]
	,   Cd.Div[DivCd]
	,	Cd.EntryBy[EntryBy]
	,	Cd.EntryDt[EntryDt]
	,	CONVERT(varchar(10), Cd.EntryDt,103)[FormatedEntryDt]
	,	Cd.EditBy[EditBy]
	,	Cd.EditDt[EditDt]	
	,	CONVERT(varchar(10), Cd.EditDt,103)[FormatedEditDt]
--	,	(Select SDes from Branch Where Cd=Cd.Div)[DivName]
	,	((Select SDes from Codes Where Cd=Cd.DocTyp and Typ='HCDOC') +(Select SDes from Branch Where Cd=Cd.Div))[Filter]
	,	Cd.Partners[Partners]
	,	CONVERT(varchar(10), Cd.EjariExpDt,103) [EjariExpDt]
	From
		CompanyDocuments Cd inner join Codes Cod on Cd.DocTyp=Cod.Cd
	Where 
		Rtrim(Cd.CoCd)=Rtrim(@v_CoCd)
	and	(@v_DivCd = '' or Cd.Div=Rtrim(@v_DivCd))
	and	(@v_DocTypCd = '' or Cd.DocTyp=Rtrim(@v_DocTypCd))
	 and Cd.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
--	Order By
--		Cd.EntryDt desc,Cd.EditDt desc
	Order By
		EntryDt desc
End
 
 
 Go 


CREATE OR ALTER Procedure [dbo].[GetRepo_ExpiredDocument_N]
 	@v_CoCd			Char(5)	
,   @v_FromDate		datetime
,   @v_ToDate		datetime
,   @v_Employee		Char(10)
,   @v_DocTyp		Char(10)
,   @v_Typ			Char(3)
,	@v_Usercd		varchar(10)
As				-- Drop Procedure [dbo].[GetRepo_ExpiredDocument]'100','','','626/ALH','All','EMP'
			
if(@v_Typ='EMP')
begin
		Select 
		ED.EmpCd[Cd]
	,	Rtrim((select FName from employee where Cd=ED.EmpCd)) +' ' +Rtrim((select Mname from employee where Cd=ED.EmpCd)) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	ED.SrNo[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	ED.IssueDt[IssueDt]
	,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	,	ED.ExpDt[ExpDt]
	,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL EMPLOYEE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL EMPLOYEES' else(select FName from employee where Cd=ED.EmpCd) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Employee'[Type]
	,	(select div from employee where cd=ED.EmpCd)  [BrCd]
	
	From
		EmpDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and ED.EmpCd=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
		AND SrNo =(select top 1 SrNo from EmpDocuments where EmpCd=ED.EmpCd and DocTyp=ED.DocTyp order by SrNo desc )
		and ED.EmpCd in(select cd from Employee where Active='Y')
		and ED.DocTyp <>(select ltrim(rtrim(val)) from ParametersByProcess where ParameterCd='DOCCD_VIS')
		and (Ed.EmpCd in(select cd from employee where Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))))
	
	order by ED.ExpDt ASC
end	
else if(@v_Typ='COM')
begin 
	 
	--	Select
	--	ED.Cocd[Cd]
	----,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	--,	Rtrim((select des from branch   where Cd=ED.Div))  [Name]
	--,	DocTyp [DocTypCd]
	--,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	--,	'1'[SrNo]
	--,	ED.DocNo[DocNo]
	--,	''[OthRefNo]
	--,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	--,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	--,	ED.IssuePlace[IssuePlace]
	--,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	--,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	--,	'Company'[Type]
	--From
	--	CompanyDocuments ED  
	--	Where	
	--     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
	--	and ((@v_FromDate='' and @v_ToDate='') or 
	--		 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
Select
		ED.Cocd[Cd]
	--,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	,	Rtrim((select des from branch   where Cd=ED.Div))  [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	''[OthRefNo]
	,	ED.IssueDt
	,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	,	ED.ExpDt
	,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Company'[Type]
	,	Rtrim(ED.Div)  [BrCd]
	From
		CompanyDocuments ED 
		Where	
	     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
	--order by ED.ExpDt ASC
union 
Select
	ED.Cocd[Cd]
	--,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	,	Rtrim((select des from branch   where Cd=ED.Div))  [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.ContrNo [DocNo]
	,	''[OthRefNo]
	,	ED.FromDt
	,	CONVERT(varchar(10), ED.FromDt,101)[FormatedIssueDt]
	,	ED.ToDt
	,	CONVERT(varchar(10), ED.ToDt,101)[FormatedExpDt]
	,	ED.Address  [IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Company'[Type]
	,	Rtrim(ED.Div)  [BrCd]
	From
		CompanyTenancyContract ED 
		Where	
	     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ToDt between @v_FromDate and @v_ToDate))	 
	order by ExpDt ASC
end
if(@v_Typ='VEH')
begin			 
	 
		Select
		(select Driver from CompanyVehicles where Cd=ED.VehCd)[Cd]
	,	Rtrim((select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) +' ' +Rtrim((select Mname from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	ED.IssueDt
	,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	,	ED.ExpDt
	,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL VEHICLE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL DRIVERS' else(select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd)) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Vehicle'[Type]
	,	''  [BrCd]
	From
		VehDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and (select Driver from CompanyVehicles where Cd=ED.VehCd)=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))	
			 
	order by ED.ExpDt ASC		 
end
if(@v_Typ='All')
begin		
		Select
		ED.EmpCd[Cd]
	,	Rtrim((select FName from employee where Cd=ED.EmpCd)) +' ' +Rtrim((select Mname from employee where Cd=ED.EmpCd)) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	ED.SrNo[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	ED.IssueDt
	,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	,	ED.ExpDt
	,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL EMPLOYEE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL EMPLOYEES' else(select FName from employee where Cd=ED.EmpCd) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Employee'[Type]
--	,	''  [BrCd]
	From
		EmpDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and ED.EmpCd=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
		and SrNo =(select top 1 SrNo from EmpDocuments where EmpCd=ED.EmpCd and DocTyp=ED.DocTyp order by SrNo desc )
		and (Ed.EmpCd in(select cd from employee where Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))))
union
	 
		Select
		ED.Cocd[Cd]
	,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	''[OthRefNo]
	,	ED.IssueDt
	,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	,	ED.ExpDt
	,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Company'[Type]
	--,	Rtrim(ED.Div)  [BrCd]
	From
		CompanyDocuments ED  
		Where	
	     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
union
		Select
		(select Driver from CompanyVehicles where Cd=ED.VehCd)[Cd]
	,	Rtrim((select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) +' ' +Rtrim((select Mname from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	ED.IssueDt
	,	CONVERT(varchar(10), ED.IssueDt,101)[FormatedIssueDt]
	,	ED.ExpDt
	,	CONVERT(varchar(10), ED.ExpDt,101)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL VEHICLE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL DRIVERS' else(select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd)) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,101) +' to '+CONVERT(varchar(10), @v_ToDate,101)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Vehicle'[Type]
	From
		VehDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and (select Driver from CompanyVehicles where Cd=ED.VehCd)=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
End	
		 
 Go 


CREATE OR ALTER Procedure [dbo].[GetRepo_ExpiredDocument]
 	@v_CoCd			Char(5)	
,   @v_FromDate		datetime
,   @v_ToDate		datetime
,   @v_Employee		Char(10)
,   @v_DocTyp		Char(10)
,   @v_Typ			Char(3)
,	@v_Usercd		varchar(10)
As				-- Drop Procedure [dbo].[GetRepo_ExpiredDocument]'100','','','626/ALH','All','EMP'
			
if(@v_Typ='EMP')
begin
		Select 
		ED.EmpCd[Cd]
	,	Rtrim((select FName from employee where Cd=ED.EmpCd)) +' ' +Rtrim((select Mname from employee where Cd=ED.EmpCd)) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	ED.SrNo[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL EMPLOYEE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL EMPLOYEES' else(select FName from employee where Cd=ED.EmpCd) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Employee'[Type]
	,	(select div from employee where cd=ED.EmpCd)  [BrCd]
	
	From
		EmpDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and ED.EmpCd=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
		AND SrNo =(select top 1 SrNo from EmpDocuments where EmpCd=ED.EmpCd and DocTyp=ED.DocTyp order by SrNo desc )
		and ED.EmpCd in(select cd from Employee where Active='Y')
		and ED.DocTyp <>(select ltrim(rtrim(val)) from ParametersByProcess where ParameterCd='DOCCD_VIS')
		and (Ed.EmpCd in(select cd from employee where Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))))
	
	order by ED.ExpDt ASC
end	
else if(@v_Typ='COM')
begin 
	 
	--	Select
	--	ED.Cocd[Cd]
	----,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	--,	Rtrim((select des from branch   where Cd=ED.Div))  [Name]
	--,	DocTyp [DocTypCd]
	--,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	--,	'1'[SrNo]
	--,	ED.DocNo[DocNo]
	--,	''[OthRefNo]
	--,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	--,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	--,	ED.IssuePlace[IssuePlace]
	--,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	--,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	--,	'Company'[Type]
	--From
	--	CompanyDocuments ED  
	--	Where	
	--     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
	--	and ((@v_FromDate='' and @v_ToDate='') or 
	--		 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
Select
		ED.Cocd[Cd]
	--,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	,	Rtrim((select des from branch   where Cd=ED.Div))  [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	''[OthRefNo]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Company'[Type]
	,	Rtrim(ED.Div)  [BrCd]
	From
		CompanyDocuments ED 
		Where	
	     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
	--order by ED.ExpDt ASC
union 
Select
	ED.Cocd[Cd]
	--,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	,	Rtrim((select des from branch   where Cd=ED.Div))  [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.ContrNo [DocNo]
	,	''[OthRefNo]
	,	CONVERT(varchar(10), ED.FromDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ToDt,103)[FormatedExpDt]
	,	ED.Address  [IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Company'[Type]
	,	Rtrim(ED.Div)  [BrCd]
	From
		CompanyTenancyContract ED 
		Where	
	     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ToDt between @v_FromDate and @v_ToDate))	 
	order by FormatedExpDt ASC
end
if(@v_Typ='VEH')
begin			 
	 
		Select
		(select Driver from CompanyVehicles where Cd=ED.VehCd)[Cd]
	,	Rtrim((select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) +' ' +Rtrim((select Mname from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL VEHICLE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL DRIVERS' else(select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd)) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Vehicle'[Type]
	,	''  [BrCd]
	From
		VehDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and (select Driver from CompanyVehicles where Cd=ED.VehCd)=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))	
			 
	order by ED.ExpDt ASC		 
end
if(@v_Typ='All')
begin		
		Select
		ED.EmpCd[Cd]
	,	Rtrim((select FName from employee where Cd=ED.EmpCd)) +' ' +Rtrim((select Mname from employee where Cd=ED.EmpCd)) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	ED.SrNo[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL EMPLOYEE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL EMPLOYEES' else(select FName from employee where Cd=ED.EmpCd) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Employee'[Type]
--	,	''  [BrCd]
	From
		EmpDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and ED.EmpCd=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
		and SrNo =(select top 1 SrNo from EmpDocuments where EmpCd=ED.EmpCd and DocTyp=ED.DocTyp order by SrNo desc )
		and (Ed.EmpCd in(select cd from employee where Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))))
union
	 
		Select
		ED.Cocd[Cd]
	,	Rtrim((select CoName from Company where Cd=ED.Cocd))  [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	''[OthRefNo]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL COMPANY DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+(Select CoName From Company Where Cd=@v_CoCd)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Company'[Type]
	--,	Rtrim(ED.Div)  [BrCd]
	From
		CompanyDocuments ED  
		Where	
	     (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
union
		Select
		(select Driver from CompanyVehicles where Cd=ED.VehCd)[Cd]
	,	Rtrim((select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) +' ' +Rtrim((select Mname from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd))) [Name]
	,	DocTyp [DocTypCd]
	,	(select SDes from Codes where Cd=DocTyp)[DocTypSDes]
	,	'1'[SrNo]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	Rtrim(case when @v_DocTyp='All' then 'ALL VEHICLE DOCUMENTS' else (select SDes from Codes where Cd=@v_DocTyp)end) +' OF '+Rtrim(case when @v_Employee='All' then 'ALL DRIVERS' else(select FName from employee where Cd=(select Driver from CompanyVehicles where Cd=ED.VehCd)) end)+' '++' FROM '+CONVERT(varchar(10), @v_FromDate,103) +' to '+CONVERT(varchar(10), @v_ToDate,103)[Seacrh]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	,	'Vehicle'[Type]
	From
		VehDocuments ED  
		Where	
	    (@v_Employee='All' or @v_Employee<>'' and (select Driver from CompanyVehicles where Cd=ED.VehCd)=@v_Employee)
	    and (@v_DocTyp='All' or @v_DocTyp<>'' and ED.DocTyp=@v_DocTyp)
		and ((@v_FromDate='' and @v_ToDate='') or 
			 (@v_FromDate<>'' and @v_ToDate<>'' and ED.ExpDt between @v_FromDate and @v_ToDate))
End	
		 
 Go 

CREATE OR ALTER Procedure [dbo].[GetRepo_EmpLeave_N]
 	@v_CoCd			Char(5)	
,   @v_Employee     Char(10)	
,   @v_Branch       char(5)
,   @v_Location     char(10)
,   @v_Department   Char(10)
,   @v_Sponsor      Char(10)
,	@v_LvStat		char(1)
,	@v_Typ			char(5)
,	@v_Dt1			Date
,	@v_Dt2			Date
,	@orderBy		varchar(100)
As	-- Drop Procedure [GetRepo_EmpLeave] '100','00185','All','All','All','All'
/*
	Declare @v_CoCd		char(5)
	Set @v_CoCd = '01'sp_help EmpLeave
*/

CREATE table #Temp
(
TransNo Char(10),
Remarks varchar(1000)
)
insert into #Temp
select TransNo,
(Select LTrim(RTrim(FName)) from Employee where Cd=empleaveappr.LvApprBy)
+' - '+convert(varchar(20),empleaveappr.LvApprDt,101)
from empleaveappr where TransNo in (select TransNo from EmpLeave where LvStatus in ('N','Y','R','J','F','C'))
order by TransNo,empleaveappr.LvApprDt desc

if @v_Dt2='' set @v_dt2=getdate()

if @v_Dt1='' set @v_dt1='01/01/1900'

declare @sql varchar(max)

Begin
	Select 
	 	TransNo
	,	TransDt
	,	LvTyp
	,   CASE 
		WHEN LvStatus = 'N' THEN 'Unapproved'
		WHEN LvStatus = 'R' THEN 'Rejected'
		WHEN LvStatus = 'Y' THEN 'Approved'
		WHEN LvStatus = 'F' THEN 'Confrimed' 
		WHEN LvStatus = 'V' THEN 'Revised'
		WHEN LvStatus = 'C' THEN 'Cancelled'
		WHEN LvStatus = 'J' THEN 'Rejoined'
		END[Caption]
	,   CASE 
		WHEN LvStatus = 'N' and LvApprBy='' THEN 
			'No One Is Approved'
		WHEN LvStatus = 'N' and LvApprBy<>'' THEN 
			
				(select distinct
				STUFF((SELECT distinct CHAR(13) + ',' + t1.Remarks
				from #Temp t1
				where t.[TransNo] = t1.[TransNo]
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') department
				from #Temp t where TransNo=EmpLeave.TransNo)
		WHEN LvStatus = 'R' THEN 
			'Rejected By ' +(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=(select LvApprBy From EmpLeaveAppr where TransNo=EmpLeave.TransNo and Status='R'))
		WHEN LvStatus = 'Y' THEN 
			'Approved By ' +--(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=LvApprBy)
			(select distinct
				STUFF((SELECT distinct CHAR(13) + ',' + t1.Remarks
				from #Temp t1
				where t.[TransNo] = t1.[TransNo]
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') department
				from #Temp t where TransNo=EmpLeave.TransNo)
		WHEN LvStatus = 'F' THEN 
			'Confirmed By ' +(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=ConfirmBy)
		WHEN LvStatus = 'V' THEN 
			'Revised By ' +(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=ConfirmBy)
		WHEN LvStatus = 'C' THEN 
			'Cancelled By ' +(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=ConfirmBy)
		END[Remarks]
	,	(Select SDes from CompanyLeave where Cd=LvTyp)[LeaveType]
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName))+' '+LTrim(RTrim(LName)) from Employee where Cd=(LvApprBy))[LastApprName]
	,	convert(varchar(20),LvApprDt,101)[FormatedLvApprDt]
	,	convert(varchar(20),JoinDt,101)[FormatedJoinDt]
	,	EmpCd
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName))+' '+LTrim(RTrim(LName)) from Employee where Cd=EmpCd)[Employee]
	,	(Select SDes from Branch where Cd=(select Div from Employee where Cd=EmpCd))[Branch]
	,	(Select SDes from Codes where Cd=(select LocCd from Employee where Cd=EmpCd) and Typ='HLOC')[Location]
	,	(Select SDes from CC where Cd=(select CC from Employee where Cd=EmpCd))[CC]
	,	(Select SDes from Dept where Cd=(select Dept from Employee where Cd=EmpCd))[Dept]
	,	CancelBy
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=CancelBy)[CancelByName]
	,	CancelDt
	,	CancelRemarks
	,	ConfirmBy
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=ConfirmBy)[ConfirmByName]
	,	ConfirmDt
	,	ConfirmRemarks
	,	ReviseBy
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=ReviseBy)[ReviseByName]
	,	ReviseDt
	,	ReviseRemarks
	,	convert(varchar(20),FromDt,101)[FromDt]
	,	convert(varchar(20),ToDt,101)[ToDt]
	,	DocRef
	,	DocDt
	,	LvStatus
	,	LvInter
	,	case WP_FromDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WP_FromDt,101) end[FormatedWP_FromDt]
	,	case WP_ToDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WP_ToDt,101) end[FormatedWP_ToDt]
	,	case WOP_FromDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WOP_FromDt,101) end[FormatedWOP_FromDt]
	,	case WOP_ToDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WOP_ToDt,101) end[FormatedWOP_ToDt]
	,	Reason
	,	Narr
	,	(Select CoName from Company where Cd=@v_CoCd)[CoName]	
	,	(Select count(*) from EmpLeaveAppr where EmpLeaveAppr.TransNo=EmpLeave.TransNo and Status='Y')[Count]
	,	JoinDt
	,	SysTransNo
	,	isnull(lvsalary,0)[lvsalary]
	,	isnull(lvfare,0)[lvfare]
	,	isnull(convert(varchar(20),(select Datediff(dd,FromDt,ToDt)+1 from EmpLeaveProvisions where TransNo=EmpLeave.TransNo and ProvTyp='GT'),101),0)[GT]
	,	isnull(convert(varchar(20),(select Datediff(dd,FromDt,ToDt)+1 from EmpLeaveProvisions where TransNo=EmpLeave.TransNo and ProvTyp='LS'),101),0)[LS]
	,	isnull(convert(varchar(20),(select Datediff(dd,FromDt,ToDt)+1 from EmpLeaveProvisions where TransNo=EmpLeave.TransNo and ProvTyp='LT'),101),0)[LT]
	--,	LvTaken[Days]
	,	DATEDIFF(DD,FromDt,JoinDt) [Days]
	,	FromDt[LvFromDt]
	,	ToDt[LvToDt]
	into #TempLeave
	From
		EmpLeave
		,	Employee	  Emp	
		inner join 	Branch    Br on Br.Cd=Emp.Div	
		inner join   Codes    Cod on Cod.Cd=Emp.LocCd  
		inner join Dept       Dep on Dep.Cd=Emp.Dept
		inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
		Where		
			Emp.cd=EmpLeave.EmpCd
		and	Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
		and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
		and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
		and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
		and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
		and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)			
		and (LvTyp=@v_Typ or @v_Typ='')
		and (LvStatus=@v_LvStat or @v_LvStat='')--complete leave between two dates		
		--and (@v_LvStat<>'' and (
		--(@v_LvStat='A'  and LvApprDt>= @v_Dt1 and LvApprDt<=@v_Dt2 or 
		--@v_LvStat='R' or
		--@v_LvStat='J' and JoinDt >= @v_Dt1 and JoinDt<=@v_Dt2 or
		--@v_LvStat='F' and ConfirmDt>= @v_Dt1 and ConfirmDt<=@v_Dt2 
		--)))
		--order by ToDt
if @orderBy<>''
		set @sql=' select * from #TempLeave order by '+@orderBy
	else
		set @sql=' select * from #TempLeave'

	exec (@sql)

Drop table #Temp
drop table #TempLeave

End
 
 Go 

CREATE OR ALTER Procedure [dbo].[GetRepo_EmpLoan_Analysis_N]
	@v_CoCd			Char(5)	
,   @v_Employee     Char(10)	
,   @v_Branch       char(5)
,   @v_Location     char(10)
,   @v_Department   Char(10)
,   @v_Sponsor      Char(10)
,	@v_LoanTyp		char(10)
,	@v_LoanStatus char(1)
As		-- Drop Procedure [dbo].[GetRepo_EmpLoan_Analysis] '100','All','05','All','All','All','001','C'

CREATE table #Temp
(
TransNo Char(10) collate SQL_Latin1_General_CP1_CI_AS,
Remarks varchar(1000)
)
insert into #Temp
select TransNo,
(Select LTrim(RTrim(FName)) from Employee where Cd=EmpLoanAppr.LoanApprBy)
+' - '+convert(varchar(20),EmpLoanAppr.LoanApprDt,101)
from EmpLoanAppr where TransNo in (select TransNo from EmpLoan where LoanStatus in ('N','Y'))
order by TransNo,EmpLoanAppr.LoanApprDt desc


Begin
	Select 
	 	TransNo
	,	TransDt
	,	LoanTyp
	,   CASE 
		WHEN LoanStatus = 'N' THEN 'Unapproved'
		WHEN LoanStatus = 'R' THEN 'Rejected'
		WHEN LoanStatus = 'A' THEN 'Approved'
		WHEN LoanStatus = 'D' THEN 'Disburse' 
		WHEN LoanStatus = 'C' THEN 'Cancelled'
		END[Caption]
	,   CASE 
		WHEN LoanStatus = 'N' and LoanApprBy='' THEN 
			'No One Is Approved'
		WHEN LoanStatus = 'N' and LoanApprBy<>'' THEN 
			
				(select distinct
				STUFF((SELECT distinct CHAR(13) + ',' + t1.Remarks
				from #Temp t1
				where t.[TransNo] = t1.[TransNo]
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') department
				from #Temp t where TransNo=EmpLoan.TransNo)
		WHEN LoanStatus = 'R' THEN 
			'Rejected By ' +(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=(select LoanApprBy From EmpLoanAppr where TransNo=EmpLoan.TransNo and Status='R'))
		WHEN LoanStatus = 'A' THEN 
			'Approved By ' +--(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName)) from Employee where Cd=LoanApprBy)
			(select distinct
				STUFF((SELECT distinct CHAR(13) + ',' + t1.Remarks
				from #Temp t1
				where t.[TransNo] = t1.[TransNo]
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') department
				from #Temp t where TransNo=EmpLoan.TransNo)
		WHEN LoanStatus = 'D' THEN 
			'Disbursed ' 
		WHEN LoanStatus = 'C' THEN 
			'Closed ' 
		END[Remarks]
	,	(Select Des from CompanyLoanTypes where Cd=LoanTyp)[LoanType]
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName))+' '+LTrim(RTrim(LName)) from Employee where Cd=(LoanApprBy))[LastApprName]
	,	LoanApprDt
	,	convert(varchar(20),LoanApprDt,101)[FormatedLoanApprDt]
	,	EmpCd
	,	(Select LTrim(RTrim(FName))+' '+LTrim(RTrim(MName))+' '+LTrim(RTrim(LName)) from Employee where Cd=EmpCd)[Employee]
	,	Amt
	,	ApprAmt
	,	NoInst
	,	DedStartDt
	,	convert(varchar(20),DedStartDt,101)[FormatedDedStartDt]
	,	RecoMode
	,	(select Des from SysCodes where Typ='HLREC' and Cd=RecoMode)[RecoModeDes]
	,	EmpLoan.PayMode
	,	(select Des from SysCodes where Typ='HLREC' and Cd=EmpLoan.PayMode)[PayModeDes]
	,	RecoPrd
	,	Guarantor
	,	GuarantorDetails
	,	(Select SDes from Branch where Cd=(select Div from Employee where Cd=EmpCd))[Branch]
	,	(Select SDes from Codes where Cd=(select LocCd from Employee where Cd=EmpCd) and Typ='HLOC')[Location]
	,	(Select SDes from CC where Cd=(select CC from Employee where Cd=EmpCd))[CC]
	,	(Select SDes from Dept where Cd=(select Dept from Employee where Cd=EmpCd))[Dept]
	,	DocRef
	,	DocDt
	,	LoanStatus
	,	Narr
	,	(Select CoName from Company where Cd=@v_CoCd)[CoName]	
	,	(Select count(*) from EmpLoanAppr where EmpLoanAppr.TransNo=EmpLoan.TransNo and Status='Y')[Count]
	,	isnull(((ApprAmt)-(select sum(RecoAmt) from EmpLoanRecovery where TransNo=EmpLoan.TransNo)),0)[Balance]
	From
		EmpLoan
		,	Employee	  Emp	
		inner join 	Branch    Br on Br.Cd=Emp.Div	
		inner join   Codes    Cod on Cod.Cd=Emp.LocCd  
		inner join Dept       Dep on Dep.Cd=Emp.Dept
		inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
		Where		
			Emp.cd=EmpLoan.EmpCd
		and	Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
		and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
		and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
		and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
		and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
		and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)	
		and(@v_LoanTyp='0' or LoanTyp=@v_LoanTyp)
		and(@v_LoanStatus='' or LoanStatus=@v_LoanStatus)
Drop table #Temp
End
 
 Go 
CREATE OR ALTER procedure [dbo].[GetRepo_EmpLoanDueList_N]
		@v_CoCd		Char(5)	
	 ,	@v_EmpCd	Char(10)=''	
--Drop procedure [dbo].[GetRepo_EmpLoanDueList]'100','MHM/516'
as
	select 
	EmpL.Empcd
	,	EmpL.TransNo[TransNo]
	,	CONVERT(varchar(20), empl.ApprDt,101)[FormattedAppDate]
	,	(SELECT Rtrim(Emp.FName) +' ' +Rtrim(Emp.MName) +' ' +Rtrim(Emp.LName))[EmpName]
	,	ApprAmt
	,	(select Sdes from CompanyLoanTypes where Cd=EmpL.LoanTyp)[LoanTyp]
	,	isnull((select SUM(AmtVal) from EmpLoanDetail where TransNo=EmpL.TransNo and typ='D'
	AND EffDate<=GETDATE()),0)[Deducted]
	--and DATEPART(MM, EffDate)<=(select Val from Parameters where cd='CUR_MONTH'and CoCd=@v_CoCd)
	--and DATEPART(YYYY, EffDate)<=(select Val from Parameters where cd='CUR_YEAR'and CoCd=@v_CoCd)),0)[Deducted]
	,	(ApprAmt-isnull((select SUM(AmtVal) from EmpLoanDetail where TransNo=EmpL.TransNo and typ='D'
	AND EffDate<=GETDATE()),0))
	--and DATEPART(MM, EffDate)<=(select Val from Parameters where cd='CUR_MONTH'and CoCd=@v_CoCd)
	--and DATEPART(YYYY, EffDate)<=(select Val from Parameters where cd='CUR_YEAR'and CoCd=@v_CoCd)),0))
	[Balance]
	,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
	
	from EmpLoan		as EmpL 
	inner join Employee as Emp on empl.EmpCd=emp.Cd
	
	where LoanStatus='D' 
	and emp.CoCd=@v_CoCd
	and (@v_EmpCd='' or @v_EmpCd<>'' and EmpL.EmpCd=@v_EmpCd)

   
 Go 

CREATE OR ALTER Procedure [dbo].[Getrepo_Emptransfers_N]
	@v_CoCd			Char(5)	
,   @v_Employee     Char(10)=''	
,   @v_Branch1       char(5)=''
,   @v_Branch2       char(5)=''
,   @v_Location1     char(10)=''
,   @v_Location2     char(10)=''
,   @v_Department1   Char(10)=''
,   @v_Department2   Char(10)=''
,	@v_Dt1			datetime='01/01/1900'
,	@v_Dt2			datetime='01/20/2050'

as
begin
select 
	empcd
,	e.Fname+' '+e.Mname+' '+e.Lname[Name] 
,	cast(et.TransferDt as date)[TransferDt]
,	(select des from branch where cd=et.BrFrom)[BrFrom]
,	BrFrom[BrFrom_cd]
,	(select des from branch where cd=et.BrTo)[BrTo]
,	BrTo[BrTo_cd]
,	(select des from Dept where cd=et.DeptFrom)[DeptFrom]
,	(select des from Dept where cd=et.DeptTo)[DeptTo]
,	(select des from codes where cd=et.LocFrom)[LocFrom]
,	(select des from codes where cd=et.LocTo)[LocTo]
,	(select Coname from Company where cd=@v_CoCd)[Coname]

from 
	EmpTransfers ET,Employee E 
where 
	Et.EmpCd=E.Cd
and(@v_Employee='All' or  et.EmpCd=@v_Employee)
and(@v_Branch1='0' or et.BrFrom=@v_Branch1)
and(@v_Branch2='0' or et.BrTo=@v_Branch2)
and(@v_Location1='0'  or et.LocFrom=@v_Location1)
and(@v_Location2=''  or et.LocTo=@v_Location2)
and(@v_Department1='0'  or et.DeptFrom=@v_Department1)
and(@v_Department2='0'  or et.DeptTo=@v_Department2)
and (TransferDt between @v_Dt1 and @v_Dt2)

End 
 Go 
CREATE OR ALTER Procedure [dbo].[EmpLeaveMaster_GetRow_N]
	@v_EmpCd	char(10)
,	@v_LvTyp	Char(5)
,	@v_Cocd		char(5)
as
--drop Procedure [dbo].[EmpLeaveMaster_GetRow]'','','03'
begin 
	select
		EL.EmpCd[EmpCd]
	,	rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmpName]
	,	EL.EmpCd+rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmpCd_Name]
	,	EL.LvTyp[LvTyp]
	,	(Select Sdes from CompanyLeave where Cd=EL.LvTyp)[LvTypDes]
	,	EL.LvMax[MaxLv]
	,	EL.LvOpBal[LvOpBal]
	,	El.LvUsed[LvUsed]
	,	El.LvAccr[LvAccr]
	,	EL.EntryBy
	,	EL.EntryDt
	,	EL.EditBy
	,	EL.EditDt
	,	EL.CumLvNoPay
	,	EL.LvOpBal-El.LvUsed+El.LvAccr[BalanceLeave]
	,	CONVERT(Varchar(20), dateadd(MM
	,	(select LvPrd from employee where Cd=EL.EmpCd)
	,	(select top 1 JoinDt from EmpLeave where EmpCd=EL.EmpCd order by JoinDt desc)),101)[LeaveDueDate]
	,	(Select CoName from Company where Cd=@v_CoCd)[CoName]		
	from
		EmpLeaveMaster EL
	,	Employee EMP
	where
		EMP.cd=EL.EmpCd and EMP.CoCd=@v_Cocd
	and	(@v_EmpCd = '' or EL.EmpCd=@v_EmpCd)
	and	(@v_LvTyp='' or EL.LvTyp=@v_LvTyp)
	order by
		EL.EmpCd
	,	EL.LvTyp
end

 
 Go 
CREATE OR ALTER Procedure [dbo].[GetRepo_PaySlip_Format_N] 
	@v_CoCd			char(5)
,	@v_Div			char(5)
,	@v_RPrd			Char(2)
,	@v_RYear		Char(4)
,	@v_EmpCd		Char(10)
As		-- Drop Procedure [dbo].[GetRepo_PaySlip_Format]'01','All','08','2016','All'
Begin
/*
	Declare @v_CoCd char(5)
	Declare @v_RPrd Char(2)
	Declare @v_RYear Char(4)
	Declare @v_EmpCd Char(10)

	Set @v_CoCd='01'
	Set @v_RPrd='06'
	Set @v_RYear='2015'
	Set @v_EmpCd='^'
*/
	--Declare @v_CoName Varchar(50)
	declare @W_days numeric(2,0)
	exec @W_days=  Get_Eday @v_RPrd,@v_RYear
	Declare @Prd int
	Declare @Period Char(6)
	Declare @Year Char(4)
	Declare @EDay int
	Declare @DHrs numeric(5,2)
	--Select @v_CoCd=Cd From Company Where CoName=@v_CoName
	DeClare @OT1C 		char(10)
	Declare @OT2C 		char(10)
	Declare @OT3C 		char(10)
	DeClare @ROT1C 		char(10)
	Declare @ROT2C 		char(10)
	Declare @ROT3C 		char(10)
	Select @OT1C=Val From Parameters Where Cd='OT1' and CoCd=@v_CoCd
	Select @OT2C=Val From Parameters Where Cd='OT2' and CoCd=@v_CoCd
	Select @OT3C=Val From Parameters Where Cd='OT3' and CoCd=@v_CoCd
	Select @ROT1C=Val From Parameters Where Cd='ROT1' and CoCd=@v_CoCd
	Select @ROT2C=Val From Parameters Where Cd='ROT2' and CoCd=@v_CoCd
	Select @ROT3C=Val From Parameters Where Cd='ROT3' and CoCd=@v_CoCd
	Select @Prd=val From Parameters Where Cd='CUR_MONTH' and CoCd=@v_CoCd
	Select @Year=Val From Parameters Where Cd='CUR_YEAR' and CoCd=@v_CoCd
	Set  @Period=@v_RYear*100+@v_RPrd
	Select @DHrs=Val From Parameters Where Cd='WORKHRS' and CoCd=@v_CoCd
	exec @Eday = Get_Eday @Prd,@Year

	if cast(@v_RPrd as int) = @Prd and cast(@v_RYear as int)=@Year
	  Begin
		Select 
			Tp.EmpCd
		,	(Select Personal_Id from EmpContract where EmpCd=Tp.EmpCd)[Official_Cd]
		,	Emp.FName+' '+Emp.MName+ ' '+Emp.LName[Name]
		,	Emp.Basic
		,	Emp.BasicCurr
		,	dbo.GetFunc_NoDecs(BasicCurr)[BasicNoDecs]
		,	(Select Des From CompanyEarnDed Where Cd=Tp.EdCd and Typ=Tp.EdTyp)[PayCode]
		,	(Select Des From CompanyEarnDed Where Cd=Tp.EdCd1 and Typ=Tp.EdTyp1)[PayCode1]
		,	(select Des from Currency where Cd=Curr1)[Curr1]
		,	(select Des from Currency where Cd=Curr2)[Curr2]
		,	ExRate1
		,	ExRate2
		
		,	case when EdTyp='HEDT01' 
			then
				case when EdCd='001' then round(((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*Emp.Basic/@EDay),(select NoDecs from Currency where Cd=Emp.BasicCurr))
				when EdCd in (Select Cd from companyearnded where EdTyp='HEDT01' and trntyp='P' and EdCd<>'001') 
						then IsNull((Select top 1 round(((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*AmtVal/@EDay),(select NoDecs from Currency where Cd=Emp.BasicCurr))
						from EmpEarnDed where EdCd=TP.EdCd and EdTyp='HEDT01' and	EffDate <= rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
						and	(EndDate >= rtrim(@Prd) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=Tp.Empcd order by EffDate desc),0) 
				else Isnull(Amt1,0) end
			else
			Isnull(Amt1,0) end	[Amt1]
		,	Isnull(Amt2,0) [Amt2]
		
		,	round((((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*Emp.Basic/@EDay)
				-IsNull((select Amt from EmpTrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=Tp.Empcd and HRDiv=Emp.Div),0))
			+(IsNull((Select top 1 ((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*AmtVal/@EDay)
					from EmpEarnDed where EdCd='009' and EdTyp='HEDT01' and	EffDate <= rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Prd) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=Tp.Empcd order by EffDate desc),0)
					-IsNull((select Amt from EmpTrans where EdCd='009' and EdTyp='HEDT01' and EmpCd=TP.Empcd and HRDiv=Emp.Div),0))
					,(select NoDecs from Currency where Cd=Emp.BasicCurr))[LOP]
		,	round(((((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*Emp.Basic/@EDay)
					-IsNull((select Amt from EmpTrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=Tp.Empcd and HRDiv=Emp.Div),0))*@W_days)/Emp.Basic,(select NoDecs from Currency where Cd=Emp.BasicCurr))[LeaveAbs]
			
		,	dbo.GetFunc_NoDecs(Curr1)[NoDecs1]
		,	dbo.GetFunc_NoDecs(Curr2)[NoDecs2]	
		,	Isnull((Select Des From Codes Where Typ='BANK' and Cd=Emp.BankCd and EmpCd=Tp.EmpCd),'')[Bank]
		,	(Select Max(Des) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay')[TrBank]
		,	(Select Max(EmpAc) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ='Net Pay')[AcNo]
		,	(Select Max(EmpAc) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrAcNo]
		,	(Select Max(CurrCd) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ='Net Pay')[NetPayCurr]
		,	(Select CurrCd From EmpBankAc Where EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrCurr]
		,	(Select Max(dbo.GetFunc_NoDecs(CurrCd)) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ='Net Pay')[NetPayNoDecs]
		,	(Select dbo.GetFunc_NoDecs(CurrCd) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrNoDecs]
		,	(Select Max(Cast(CR.Rate as Char(15))) From EmpBankAc EAC,Currency CR Where EAC.CurrCd=CR.Cd and EmpCd=Tp.EmpCd and Typ='Net Pay')[NetPayRate]
		,	(Select Cast(CR.Rate as Char(15)) From EmpBankAc EAC,Currency CR Where EAC.CurrCd=CR.Cd and EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrRate]
		,	(Select Isnull(ST.Amt,0) From EmpBankTransfer ST,EmpBankAc BA Where ST.EmpCd=BA.EmpCd and ST.Bank=BA.Bank and ST.Branch=BA.Branch and  ST.SrNo=BA.SrNo and BA.Typ='Net Pay' and BA.EmpCd=Tp.EmpCd)[BankAmt]
		,	(Select Isnull(ST.Amt,0) From EmpBankTransfer ST,EmpBankAc BA Where ST.EmpCd=BA.EmpCd and ST.Bank=BA.Bank and ST.Branch=BA.Branch and  ST.SrNo=BA.SrNo and BA.EmpCd=Tp.EmpCd and BA.Typ<>'Net Pay' and rtrim(BA.Bank)+rtrim(BA.Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrBankAmt]
		,	isnull((Select Des from Designation where Cd=(Select Desg from EmpContract where EmpCd=Tp.EmpCd)),(Select Des From Designation Where Cd=Emp.Desg))[Designation]
		,	(Select Des From DEPT Where cd=Emp.Dept)[Department]
		,	(Select SDes From CC Where Cd=Emp.CC)[CC]
		,	(Select SDes From Codes Where Typ='HLOC' and Cd=Emp.LocCd)[Loc]
	  --,	@v_CoName[Co.Name] 
		,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
		,	Br.Des[Branch]
		,	(select Des from Codes where Typ='ESPON' and Cd=Emp.Sponsor)[Sponsor]
		,	TrnInd
		,	TrnInd1
		,	@Prd[Prd]
		,	@Year[Yr]
		,	Isnull((Select RoundedAmt From EmpSalRound Where EmpCd=Tp.EmpCd),0)[Total]
		,	(select Des from Currency where Cd=Curr.Cd)[Currency]
		,	(select Des from Currency where Cd=Curr.SubCurr)[SubCurrency]
		,	Curr.Rate
		,	Curr.NoDecs[AmtDecs]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0001',@OT1C),'')[WOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0002',@OT2C),'')[OOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0003',@OT3C),'')[HOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0001',@ROT1C),'')[RWOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0002',@ROT2C),'')[ROOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0003',@ROT3C),'')[RHOT]
		,	Isnull(@OT1C,'')[WOTC]
		,	Isnull(@OT2C,'')[OOTC]
		,	Isnull(@OT3C,'')[HOTC]
		,	Isnull(@ROT1C,'')[RWOTC]
		,	Isnull(@ROT2C,'')[ROOTC]
		,	Isnull(@ROT3C,'')[RHOTC]
		,	EdTyp
		,	EdCd
		,	dbo.GetFunc_WorkDetails(@v_CoCd,@v_RPrd,@v_RYear,@EDay,Emp.Cd,@DHrs,'W')[WorkDays]
		,	dbo.GetFunc_WorkDetails(@v_CoCd,@v_RPrd,@v_RYear,@EDay,Emp.Cd,@DHrs,'F')[FBDays]
		,	dbo.GetFunc_WorkDetails(@v_CoCd,@v_RPrd,@v_RYear,@EDay,Emp.Cd,@DHrs,'O')[ODays]
--			,	(Select Isnull(W_DAYS,0)-Isnull(UP_HDAYS,0) From EMPATTENDANCE Where EMPCD=TP.EMPCD AND PRD=@Period) [W_days]
		,	@Eday[W_days]
		,	convert(int,(Select Isnull(sum(Up_HDays),0) From EMPATTENDANCE Where EMPCD=TP.EMPCD AND PRD=@Period)) [Up_Hdays]
		From
			TempPaySlip Tp
		,	Employee Emp
		,	Branch Br
		,	Currency Curr
		Where
			Emp.Cd=Tp.EmpCd
		and	Br.Cd=Emp.Div
		and Curr.Cd=Emp.CurrCd
		and	(SubString(TrnInd,1,1) <> '#' or TrnInd is null)
		and	(SubString(TrnInd1,1,1) <> '#' or TrnInd1 is null)
		and	(Emp.CoCd=@v_CoCd and @v_EmpCd='All' or Emp.Cd=@v_EmpCd and @v_EmpCd<>'^')
		and	(@v_Div='All' or @v_Div<>'' and Emp.div=@v_Div)
		Order by	-- Select * From currency
			Tp.EmpCd
		,	Isnull(EdTyp,'Z')
		,	Isnull(EdCd,'Z')
	  End
	Else
	  Begin
		Select 
			Tp.EmpCd
		,	(Select Personal_Id from EmpContract where EmpCd=Tp.EmpCd)[Official_Cd]
		,	Emp.FName+' '+Emp.MName+ ' '+Emp.LName[Name]
		,	Emp.Basic
		,	Emp.BasicCurr
		,	dbo.GetFunc_NoDecs(BasicCurr)[BasicNoDecs]
		,	(Select Des From CompanyEarnDed Where Cd=Tp.EdCd and Typ=Tp.EdTyp)[PayCode]
		,	(Select Des From CompanyEarnDed Where Cd=Tp.EdCd1 and Typ=Tp.EdTyp1)[PayCode1]
		,	(select Des from Currency where Cd=Curr1)[Curr1]
		,	(select Des from Currency where Cd=Curr2)[Curr2]
		,	ExRate1
		,	ExRate2
		
		,	case when EdTyp='HEDT01' 
			then
				case when EdCd='001' then round(((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*Emp.Basic/@EDay),(select NoDecs from Currency where Cd=Emp.BasicCurr))
				when EdCd in (Select Cd from companyearnded where EdTyp='HEDT01' and trntyp='P' and EdCd<>'001') 
						then IsNull((Select top 1 round(((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*AmtVal/@EDay),(select NoDecs from Currency where Cd=Emp.BasicCurr))
						from EmpEarnDed where EdCd=TP.EdCd and EdTyp='HEDT01' and	EffDate <= rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
						and	(EndDate >= rtrim(@Prd) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=Tp.Empcd order by EffDate desc),0) 
				else Isnull(Amt1,0) end
			else
			Isnull(Amt1,0) end	[Amt1]
		,	Isnull(Amt2,0) [Amt2]
		
		
		
		,	round((((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*Emp.Basic/@EDay)
				-IsNull((select Amt from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=Tp.Empcd and HRDiv=Emp.Div and prd=@Period),0))
			+(IsNull((Select top 1 ((@Eday-(case when DATEPART(YYYY,Emp.Doj)*100+DATEPART(MM,Emp.Doj)=@Year*100+@Prd then DATEPART(DD,Emp.Doj)-1 else 0 end))*AmtVal/@EDay)
					from EmpEarnDed where EdCd='009' and EdTyp='HEDT01' and	EffDate <= rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Prd) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=Tp.Empcd order by EffDate desc),0)
					-IsNull((select Amt from EmpTransYtd where EdCd='009' and EdTyp='HEDT01' and EmpCd=TP.Empcd and HRDiv=Emp.Div and prd=@Period),0))
					,(select NoDecs from Currency where Cd=Emp.BasicCurr))[LOP]
		,	round(((Emp.Basic-IsNull((select Amt from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=Tp.Empcd and HRDiv=Emp.Div and prd=@Period),0))*@W_days)/Emp.Basic,0)[LeaveAbs]
			
		,	dbo.GetFunc_NoDecs(Curr1)[NoDecs1]
		,	dbo.GetFunc_NoDecs(Curr2)[NoDecs2]	
		,	Isnull((Select Des From Codes Where Typ='BANK' and Cd=Emp.BankCd and EmpCd=Tp.EmpCd),'')[Bank]
		,	(Select Max(Des) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay')[TrBank]
		,	(Select EmpAc From EmpBankAc Where EmpCd=Tp.EmpCd and Typ='Net Pay')[AcNo]
		,	(Select EmpAc From EmpBankAc Where EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrAcNo]
		,	(Select CurrCd From EmpBankAc Where EmpCd=Tp.EmpCd and Typ='Net Pay')[NetPayCurr]
		,	(Select CurrCd From EmpBankAc Where EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrCurr]
		,	(Select dbo.GetFunc_NoDecs(CurrCd) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ='Net Pay')[NetPayNoDecs]
		,	(Select dbo.GetFunc_NoDecs(CurrCd) From EmpBankAc Where EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrNoDecs]
		,	(Select Cast(CR.Rate as Char(15)) From EmpBankAc EAC,Currency CR Where EAC.CurrCd=CR.Cd and  EmpCd=Tp.EmpCd and Typ='Net Pay')[NetPayRate]
		,	(Select Cast(CR.Rate as Char(15)) From EmpBankAc EAC,Currency CR Where EAC.CurrCd=CR.Cd and  EmpCd=Tp.EmpCd and Typ <> 'Net Pay' and rtrim(Bank)+rtrim(Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrRate]
		,	(Select Isnull(ST.Amt,0) From EmpBankTransfer ST,EmpBankAc BA Where ST.EmpCd=BA.EmpCd and ST.Bank=BA.Bank and ST.Branch=BA.Branch and  ST.SrNo=BA.SrNo and BA.Typ='Net Pay' and BA.EmpCd=Tp.EmpCd)[BankAmt]
		,	(Select Isnull(ST.Amt,0) From EmpBankTransfer ST,EmpBankAc BA Where ST.EmpCd=BA.EmpCd and ST.Bank=BA.Bank and ST.Branch=BA.Branch and  ST.SrNo=BA.SrNo and BA.EmpCd=Tp.EmpCd and BA.Typ<>'Net Pay' and rtrim(BA.Bank)+rtrim(BA.Branch) =(Select Max(rtrim(Bank)+rtrim(Branch)) From Codes,EmpBankAc Where Codes.Typ='BANK' and Cd=Bank and EmpCd=Tp.EmpCd and EmpBankAc.Typ <> 'Net Pay'))[TrBankAmt]
		,	isnull((Select Des from Designation where Cd=(Select Desg from EmpContract where EmpCd=Tp.EmpCd)),(Select Des From Designation Where Cd=Emp.Desg))[Designation]
		,	(Select Des From DEPT Where cd=Dept)[Department]
		,	(Select SDes From CC Where Cd=Emp.CC)[CC]
		,	(Select SDes From Codes Where Typ='HLOC' and Cd=Emp.LocCd)[Loc]
		--,	@v_CoName[Co.Name] 
		,	(Select CoName From Company Where Cd=@v_CoCd)[CoName]
		,	Br.Des[Branch]
		,	(select Des from Codes where Typ='ESPON' and Cd=Emp.Sponsor)[Sponsor]
		,	TrnInd
		,	TrnInd1
		,	cast(@v_RPrd as int)[Prd]
		,	cast(@v_RYear as int)[Yr]
		,	Isnull((Select RoundedAmt From EmpSalRoundYtd Where EmpCd=Tp.EmpCd and Prd=rtrim(@v_RYear)+right('0'+rtrim(@v_RPrd),2) ),0)[Total]
		,	(select Des from Currency where Cd=Curr.Cd)[Currency]
		,	(select Des from Currency where Cd=Curr.SubCurr)[SubCurrency]
		,	Curr.Rate
		,	Curr.NoDecs[AmtDecs]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0001',@OT1C),'')[WOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0002',@OT2C),'')[OOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0003',@OT3C),'')[HOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0001',@ROT1C),'')[RWOT]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0002',@ROT2C),'')[ROOT]
--			,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0003',@ROT3C),'')[ODays]
		,	Isnull(dbo.GetFunc_OTCaption(Emp.Cd,'HCOTT0003',@ROT3C),'')[RHOT]
		,	Isnull(@OT1C,'')[WOTC]
		,	Isnull(@OT2C,'')[OOTC]
		,	Isnull(@OT3C,'')[HOTC]
		,	Isnull(@ROT1C,'')[RWOTC]
		,	Isnull(@ROT2C,'')[ROOTC]
		,	Isnull(@ROT3C,'')[RHOTC]
		,	EdTyp
		,	EdCd
		,	dbo.GetFunc_WorkDetails(@v_CoCd,@v_RPrd,@v_RYear,@EDay,Emp.Cd,@DHrs,'W')[WorkDays]
		,	dbo.GetFunc_WorkDetails(@v_CoCd,@v_RPrd,@v_RYear,@EDay,Emp.Cd,@DHrs,'F')[FBDays]
		,	dbo.GetFunc_WorkDetails(@v_CoCd,@v_RPrd,@v_RYear,@EDay,Emp.Cd,@DHrs,'O')[ODays]
		,	right('0'+rtrim(@v_RPrd),2)+rtrim(@v_RYear)
--			,	(Select Isnull(W_DAYS,0)-Isnull(UP_HDAYS,0) From EMPATTENDANCE Where EMPCD=TP.EMPCD AND PRD=@Period) [W_days]
		,	@Eday[W_days]
		,	convert(int,(Select Isnull(sum(Up_HDays),0) From EmpAttendanceYtd Where EMPCD=TP.EMPCD AND PRD=@Period)) [Up_Hdays]
		From
			PaySlipYtd Tp
		,	Employee Emp
		,	Currency Curr
		,	Branch Br
		Where
			Emp.Cd=Tp.EmpCd
		and	Br.Cd=Emp.Div
		and Curr.Cd=Emp.CurrCd
		and	(SubString(TrnInd,1,1) <> '#' or TrnInd is null)
		and	(SubString(TrnInd1,1,1) <> '#' or TrnInd1 is null)
		and	(Emp.CoCd=@v_CoCd and @v_EmpCd='All' or Emp.Cd=@v_EmpCd and @v_EmpCd<>'^')
		and	(@v_Div='All' or @v_Div<>'' and Emp.div=@v_Div)
		and	Prd=rtrim(@v_RYear)+right('0'+rtrim(@v_RPrd),2)
		order by
			Tp.EmpCd
		,	EdTyp
		,	EdCd
	  end
End



 
 Go 
