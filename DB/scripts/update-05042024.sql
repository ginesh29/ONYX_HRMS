USE [LSHRMS_Telal_Live]
GO
/****** Object:  StoredProcedure [dbo].[Employee_LeaveHistory_N]    Script Date: 06-04-2024 12:31:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[Employee_LeaveHistory_N]
	@v_EmpCd		Char(10)
,	@v_FromDt		Datetime=''
,	@v_ToDt			Datetime=''
As		-- Drop Procedure [dbo].[Employee_LeaveHistory]'927','05/01/2023','05/30/2023'
Begin

	Declare @Prd			int
	Declare @Year			int
	Declare @StrtPrdPrd		int
	Declare @StrtPrdYear	int
	Declare @AnnualLv		Char(10)
	Declare	@CoCd			Char(5)
	Declare	@StrtPrd		Char(6)
	Declare @AmtDecs		int
	Declare @EDay			int
	Declare @BasicCd		Char(15)
	Declare @v_BeginDate 	datetime
	
	select @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
	select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
	select @CoCd=CoCd From Employee Where Cd=@v_EmpCd
	Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@CoCd
	Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@CoCd
	set @v_BeginDate=rtrim(@Prd) + '/1/'+rtrim(@Year)
	Select @StrtPrd=Val from Parameters where Cd='HR_ST_PRD' and CoCd=@CoCd
	select @AmtDecs=AmtDecs From Company Where Cd=@CoCd
	Select @StrtPrdPrd=substring(@StrtPrd,5,2)
	Select @StrtPrdYear=substring(@StrtPrd,1,4)
	Exec @EDay=Get_EDay @Prd,@Year
	   
	create table #tempLvSalary
	(
			LvSalary	Numeric(9,4)
		,	EmpCd		Char(10) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into #tempLvSalary
	 Select 
			round((isnull(sum(
			case PercAmt
				When 'P' then  case EdTyp
						when 'HEDT02'then  -PercVal*.01*(Basic*Cr.Rate)
						else PercVal*.01*Basic
						end
				When 'A' then  case EdTyp
						when 'HEDT02' then -AmtVal*Cr.Rate
						else AmtVal*Cr.Rate	
						end
			end),0)+(select Basic from Employee where cd=Ed.EmpCd)),@amtdecs),Ed.EmpCd
		From 
			EmpEarnDed Ed
		,	Employee
		,	Currency Cr
		Where  
			Employee.Cd=EmpCd
		and	Cr.Cd=Ed.Curr
		and	rtrim(EdTyp)+rtrim(EdCd) <> @BasicCd
		and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd=@AnnualLv and CoCd=@CoCd)
		and	EffDate<=(case when @v_FromDt='' then (rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)) else @v_FromDt end) 
		and	(EndDate>=(case when @v_FromDt='' then (rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)) else @v_FromDt end)  or EndDate='1/1/1900')
		group by EmpCd 
		
	CREATE TABLE dbo.#Temp
		(
			Amt  numeric(18,0)
		)
		
		
	select 
		Emp.Fname+' '+Emp.Mname+' '+Emp.Lname [Name]
	,	Emp.Cd[Code]  
	,	(select CoName from company where Cd= Emp.CoCd)[Company]    
	,	(select SDes FROM Branch where Cd=Emp.Div)[Branch]  
	,	(select SDes from Dept where Dept.Cd=Emp.Dept)[Department] 
	,	(select SDes FROM Codes where Codes.cd=Emp.LocCd)[Location]  
	,	(select SDes FROM Designation where Designation.cd=Emp.Desg)[Designation]
	,	(select Nat FROM Country where Cd=Emp.Nat)[Nationality]
	,	(select SDes from Codes where Typ='BANK' and Cd=Emp.BankCd)[Bank]    
	,	Emp.LvDays[Leave Days]    
	,	(select SDes from SysCodes where Cd=Emp.Status)[Status]    
	,	(select Sdes from Codes where Cd=Emp.Sponsor)[Sponsor]  
	,	CONVERT(varchar(10), Emp.Doj,101)[FormatedDoj]
	,	(select top 1 CONVERT(varchar(10), JoinDt,101) from EmpLeave where EmpLeave.EmpCd=Emp.Cd order by JoinDt desc)[LastRejoinDt]
	,	isnull((case @v_FromDt when '' then 0 else 
			case (select Convert(varchar(10),Wp_FromDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')) when '01/01/1900' then 0 else datediff(dd,(select Wp_FromDt from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')),(select Wp_ToDt from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')))+1 end
			+
			case (select Convert(varchar(10),WOp_FromDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')) when '01/01/1900' then 0 else datediff(dd,(select WOp_FromDt from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')),(select WOp_ToDt from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')))+1 end
			end),0)[ReqLv]
	,	(Select LvSalary from #tempLvSalary where EmpCd=Emp.Cd)[LvSal/Yr]
	,	(Select isnull(Provisions,0) from Country where Cd=Emp.Nat)[LvTic/Yr]
	,	case Leaving
		when '1/1/1900' then DateDiff(D,DOJ,@v_FromDt)+1
		else DateDiff(D,DOJ,Leaving)+1
		end[TotalDays]
	
	,	(select ISNULL(ELM.LvOpBal,0) from EmpLeaveMaster ELM where ELM.EmpCd=Emp.Cd and ELM.LvTyp=@AnnualLv)[LeaveOp]	
	
	,	isnull((select ISNULL(ELM.LvMax,0) from EmpLeaveMaster ELM where ELM.EmpCd=Emp.Cd and ELM.LvTyp=@AnnualLv),0)
		*((case Leaving
		when '1/1/1900' then DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) then Emp.Doj else CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) end,
                    case @v_FromDt when '' then CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@EDay AS VARCHAR(2))) else @v_FromDt end )+1
		else DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) then Emp.Doj else CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) end,Leaving)+1
		end)/365.0)[Leave]
		
		
		
	,	round((select ISNULL(ELM.LvUsed,0) from EmpLeaveMaster ELM where ELM.EmpCd=Emp.Cd and ELM.LvTyp=@AnnualLv),0)
		[LeaveTaken]
		
	,	isnull((select ISNULL(EPO.OpDays,0) from EmpProvisionsOpening EPO where EPO.EmpCd=Emp.Cd and EPO.Typ='LS'),0)[LvSalDaysOp]
		
	,	isnull((Select isnull(sum(provdays),0) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd<=DATEPART(YYYY,@v_FromDt)*100+datepart(MM,@v_FromDt)),0)
			+isnull((Select isnull(sum(days),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='LS' and Status='A' and TransDt<=@v_FromDt),0)
					+(select ISNULL(ELM.lvdays,0) from Employee ELM where ELM.Cd=Emp.Cd)
					*((DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) end,
                    case @v_FromDt when '' then CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@EDay AS VARCHAR(2))) else @v_FromDt end)+1
					)/365.0)[LvSalDays]
					
		
	,	round(isnull((select sum(ISNULL(EP.ActDays,0)) from EmpProvisions EP where EP.EmpCd=Emp.Cd and EP.Typ='LS' and EP.Yr*100+EP.Prd<=DATEPART(YYYY,@v_FromDt)*100+datepart(MM,@v_FromDt)),0),0)
		[LvSalDaysTaken]
		
	,	isnull((Select isnull(sum(provamt),0) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd<=DATEPART(YYYY,@v_FromDt)*100+datepart(MM,@v_FromDt)),0)
			+isnull((Select isnull(sum(amt),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='LS' and Status='A' and TransDt<=@v_FromDt),0)
					+(((datediff(DD,
					case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2)))end,case @v_FromDt when '' then 
                    CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@Eday AS VARCHAR(2))) else @v_FromDt end)+1)*(Select LvDays from employee where Cd=Emp.Cd)/365)
                    *((Select LvSalary from #tempLvSalary where EmpCd=Emp.Cd)*12/365))
                    [LvSalary]
                    
                    
	,	round(isnull((Select isnull(OpAmt,0) from empprovisionsopening where empcd=Emp.Cd and typ='LS'),0),@AmtDecs)[LvSalaryOp]
	,	round(isnull((Select isnull(sum(actamt),0) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd<=DATEPART(YYYY,@v_FromDt)*100+datepart(MM,@v_FromDt)),0),@AmtDecs)[LvSalaryTaken]
	
					
	,	round(isnull((Select isnull(sum(provamt),0) from empprovisions where empcd=Emp.Cd and typ='LT' and Yr*100+Prd<=DATEPART(YYYY,@v_FromDt)*100+datepart(MM,@v_FromDt)),0)
			+isnull((Select isnull(sum(amt),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='LT' and Status='A' and TransDt<=@v_FromDt),0)
					+((((Select NoTickets from employee where Cd=Emp.Cd)
						+isnull((select sum(FareFreq) From Dependents Where FareEligible='Y' and EmpCd=Emp.Cd),0))
					 *(Select Isnull(Provisions,0) from country where Cd=(Select Nat from employee where Cd=Emp.Cd)))
					 *(datediff(DD,
					case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LT' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LT' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2)))end,case @v_FromDt when '' then 
                    CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@Eday AS VARCHAR(2))) else @v_FromDt end)+1)/365) 
					,@AmtDecs)[LvTicket]
					
	,	round(isnull((Select isnull(OpAmt,0) from empprovisionsopening where empcd=Emp.Cd and typ='LT'),0),@AmtDecs)[LvTicketOp]
	,	round(isnull((Select isnull(sum(actamt),0) from empprovisions where empcd=Emp.Cd and typ='LT' and Yr*100+Prd<=datepart(YYYY,@v_FromDt)*100+datepart(MM,@v_FromDt)),0),@AmtDecs)[LvTicketTaken]
	,	isnull(case (select Convert(varchar(10),Wp_FromDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')) when '1900/01/01' then '-' else(select CONVERT(varchar(10),Wp_FromDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F'))End,'1900/01/01')[FormatedWPFromDt]
	,	isnull(case (select Convert(varchar(10),Wp_ToDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')) when '1900/01/01' then '-' else(select CONVERT(varchar(10),Wp_ToDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F'))End,'1900/01/01')[FormatedWPToDt]
	,	isnull(case (select Convert(varchar(10),WOp_FromDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')) when '1900/01/01' then '-' else(select CONVERT(varchar(10),Wop_FromDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F'))End,'1900/01/01')[FormatedWOPFromDt]
	,	isnull(case (select Convert(varchar(10),WOp_ToDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F')) when '1900/01/01' then '-' else(select CONVERT(varchar(10),Wop_ToDt,101) from empleave where empcd=Emp.Cd and fromdt=@v_FromDt and todt=@v_ToDt and LvStatus in ('N','Y','F'))End,'1900/01/01')[FormatedWOPToDt]
	,	isnull((select Cumlvnopay from EmpLeaveMaster where EmpCd=@v_EmpCd),0)[Cumlvnopay]
	
	from 
	Employee as Emp 
	where 
	Cd=@v_EmpCd
	
	
		select 
			CONVERT(varchar(10), EL.FromDt,101) [FromDate]
		,	CONVERT(varchar(10), EL.ToDt,101) [ToDate]
		,	case when EL.WP_FromDt='1900-01-01' and EL.WP_ToDt='1900-01-01' then 0 else DATEDIFF(DD,EL.WP_FromDt,EL.WP_ToDt)+1 end[WithPay]
		,	case when EL.WOP_FromDt='1900-01-01' and EL.WOP_ToDt='1900-01-01' then 0 else DATEDIFF(DD,EL.WOP_FromDt,EL.WOP_ToDt)+1 end[WithoutPay]
		,	DATEDIFF(DD,EL.FromDt,EL.ToDt)+1 [Total]
		from 
		EmpLeave as EL 
		where 
		EmpCd=@v_EmpCd  
		and	(EL.LvStatus='F' or el.LvStatus='J') --and EL.LvTyp=@AnnualLv
		
 
	if((select COUNT(*) from EmpEarnDed where EdCd='001' and EdTyp='HEDT01' and CONVERT(varchar(10), EndDate,101)='01/01/1900' and EmpCd=@v_EmpCd)=0)
	begin
		select
			'Allowances/Earnings'[Type]
		,	'Basic Salary'[Des]
		,	(Select Basic from Employee where Cd=@v_EmpCd) [AmtVal]
		
		union 
	
		select
			(select SDes from SysCodes where Cd=EMPED.EdTyp)[Type]
		,	(select SDes from CompanyEarnDed where Cd=EMPED.EdCd)[Des]
		,	AmtVal[AmtVal]
		from 
		EmpEarnDed as EMPED 
		where EmpCd=@v_EmpCd and (EdCd+EdTyp)<>'001HEDT01' 
		 and CONVERT(varchar(10), EMPED.EndDate,101)='01/01/1900'
	end
	else
	begin
		select
			(select SDes from SysCodes where Cd=EMPED.EdTyp)[Type]
		,	(select SDes from CompanyEarnDed where Cd=EMPED.EdCd)[Des]
		,	AmtVal[AmtVal]
		from 
		EmpEarnDed as EMPED 
		where EmpCd=@v_EmpCd and EdCd='001' and EdTyp='HEDT01' 
		 and CONVERT(varchar(10), EMPED.EndDate,101)='01/01/1900'
		 
		union
	
		select
			(select SDes from SysCodes where Cd=EMPED.EdTyp)[Type]
		,	(select SDes from CompanyEarnDed where Cd=EMPED.EdCd)[Des]
		,	AmtVal[AmtVal]
		from 
		EmpEarnDed as EMPED 
		where EmpCd=@v_EmpCd and (EdCd+EdTyp)<>'001HEDT01' 
		 and CONVERT(varchar(10), EMPED.EndDate,101)='01/01/1900'
	end
	
	insert into dbo.#Temp
	select 
	ApprAmt 
	-isnull((select sum(amtval) from emploandetail where Typ='D' and transno=EL.transno and effdate<=GETDATE() ),0)[Amount]
	from EmpLoan EL where EmpCd=@v_EmpCd and LoanStatus='D' --and RecoMode='HLREC03'
	
	select sum(Amt)[Outstanding] from dbo.#Temp
	
	drop table dbo.#Temp
	
	
	
		select 
			(select Fname+' '+Mname from Employee where Cd=ELA.LVApprBy)[LVApprBy]
		,	CONVERT(varchar(10), ELA.LVApprDt,101)[ApprDt]
		,	ELA.ApprLvl[ApprLvl]
		from 
		EmpLeave as EL 
		INNER JOIN EmpLeaveAppr as ELA on ELA.TransNo=EL.TransNo
		where 
		EmpCd=@v_EmpCd  
		and	EL.LvStatus in ('y','F','N')
		and EL.FromDt=@v_FromDt and EL.ToDt=@v_ToDt
		--order by ELA.ApprLvl ASC
		
		UNION
		
		select 
			(select Fname+' '+Mname from Employee where Cd=ELA.ApprBy)[LVApprBy]
		,	CONVERT(varchar(10), ELA.LVApprDt,101)[ApprDt]
		,	ELA.ApprLvl[ApprLvl]
		from 
		dbo.EmpLeaveSalaryTicket as EL 
		INNER JOIN dbo.EmpLeaveSalaryTicketAppr as ELA on ELA.TransNo=EL.TransNo
		where 
		EmpCd=@v_EmpCd  
		and	EL.Status in ('y','F','N')
		and EL.TransDt=@v_FromDt --and EL.ToDt=@v_ToDt
		order by ApprLvl asc
		
drop table #tempLvSalary

END

 

		