


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
