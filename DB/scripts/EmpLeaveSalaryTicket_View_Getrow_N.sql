CREATE Procedure [dbo].[EmpLeaveSalaryTicket_View_Getrow_N]    
	@v_Empcd	char(10)
 ,  @v_TransNo	Char(10) 
 ,	@v_Typ		Char(1)=''
 ,	@v_Usercd		varchar(10)
As  --Drop Procedure [dbo].[EmpLeaveSalaryTicket_View_Getrow_N]  '','00012','D'    
begin    
	if @v_TransNo =''    
		select    
		el.TransNo    
	,	el.TransDt[AppDt]  
	,	CONVERT(varchar(20),el.TransDt,103)[FormatedTransDt]  
	,	el.EmpCd[EmpCd]    
	,	e.FName+' '+e.Mname+' '+e.Lname[Emp]    
	,	el.LvSalary[LvSalary]
	,	el.LvTicket [LvTicket]
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=el.ApprBy)  [ApprBy]    
	,	case el.ApprDt    
		when  '01/01/1900' then null    
		else el.ApprDt    
		end[ApprDt] 

	,	case el.ApprDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.ApprDt ,103)   
		end[FormatedApprDt] 
	,	(select (select des from branch where cd=E.Div) from employee E where cd=el.Empcd)[Div] 
 
		from    
		EmpLeaveSalaryTicket el   
	,	Employee e    
		where        
		 e.cd=el.EmpCd    
		and (e.Cd=@v_Empcd or @v_EmpCd = '')    
		and (@v_Typ='' and el.Status <> 'N' and el.Status <> 'C' and el.Status <> 'F' and el.Status <> 'R'
		or	@v_Typ='D'  and el.Status = 'F')
	
	else    
		select    
		el.TransNo    
	,	el.TransDt[AppDt]   
	,	CONVERT(varchar(20),el.TransDt,103)[FormatedTransDt]  
	,	el.EmpCd[EmpCd]    
	,	e.FName+' '+e.Mname+' '+e.Lname[Emp] 
	,	el.LvSalary[LvSalary]
	,	el.LvTicket [LvTicket]
	  
		   
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=el.ApprBy)  [ApprBy]   
	 
	,	case el.ApprDt    
		when  '01/01/1900' then null    
		else el.ApprDt    
		end[ApprDt]    
	,	case el.ApprDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.ApprDt ,103)   
		end[FormatedApprDt] 
	,	(select (select des from branch where cd=E.Div) from employee E where cd=el.Empcd)[Div] 
   
		from    
		EmpLeaveSalaryTicket el   
	,	Employee e    
		where        
		 e.cd=el.EmpCd    
		and el.TransNo=@v_TransNo
		and e.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	-- and el.Typ='M'    
	-- and el.LvStatus not in ('C','R')    
		and (@v_Typ='' and el.Status <> 'N' and el.Status <> 'C' and el.Status <> 'F' and el.Status <> 'R'
		or	@v_Typ='D'  and el.Status = 'F')    
End    

