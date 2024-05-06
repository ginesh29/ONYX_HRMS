CREATE OR ALTER     Procedure [dbo].[EmplLoanAndLeaveApproval_N]
	@v_CoCd		char(5)
,	@v_EmpCd	Char(10)
,	@v_Typ		Char(1)

AS
--Drop Procedure [dbo].[EmplLoanAndLeaveApproval_N]'01','HR','U'

select COUNT(TransNo) as LeaveApplied from EmpLeave
inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
where GETDATE() between FromDt and ToDt and LvStatus='N' and emp.CoCd=@v_CoCd --and emp.Status='HSTATPM   '

select COUNT(TransNo) as OnLeave from EmpLeave
inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
where GETDATE() between FromDt and ToDt and LvStatus='F' and emp.CoCd=@v_CoCd --and emp.Status='HSTATPM   '

select EmpCd [Working] into #Working from EmpLeave
inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
where GETDATE() between FromDt and ToDt and LvStatus='F' and emp.CoCd=@v_CoCd --and emp.Status='HSTATPM   '

select count(cd) [Working] from Employee where cd not in (select [Working] from #Working)  --where Status='HSTATPM   '
drop table #Working

--select COUNT(TransNo) as LeaveApproval  from EmpLeave
--inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS2' and CPA.ApplTyp=EmpLeave.LvTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	LvStatus='N' 
--	and emp.CoCd=@v_CoCd
--	and emp.Status='HSTATPM   '
--	and ((LvApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (LvApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS2' and ApplTyp=EmpLeave.LvTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=LvApprBy or (select UserCd from Employee where Cd=EmpCd)=LvApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))

--select COUNT(TransNo) as LeaveSalaryTicketApproval  from EmpLeaveSalaryTicket ELST
--inner join Employee as emp on emp.Cd=ELST.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS3' and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	ELST.Status='N' 
--	and emp.CoCd=@v_CoCd
--	and emp.Status='HSTATPM   '
--	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (ApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS3' and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))

--select COUNT(TransNo) as LoanApproval  from EmpLoan
--inner join Employee as emp on emp.Cd=EmpLoan.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS1' and CPA.ApplTyp=EmpLoan.LoanTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	LoanStatus='N' 
--	and emp.CoCd=@v_CoCd
--	and emp.Status='HSTATPM   '
--	and ((LoanApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (LoanApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS1' and ApplTyp=EmpLoan.LoanTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=LoanApprBy or (select UserCd from Employee where Cd=EmpCd)=LoanApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))

		
--select COUNT(EDI.EmpCd) as  DocumentIssue from EmpDocIssueRcpt as EDI
--inner join  Employee as emp on emp.Cd=EDI.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT8' and CPA.ApplTyp=EDI.DocTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	EDI.Stat='N' 
--	and emp.CoCd=@v_CoCd 
--	and emp.Status='HSTATPM   '   
--	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (ApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT8' and ApplTyp=EDI.DocTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))



--select COUNT(EmpProgressionHead.EmpCd) as EmpProgression  from EmpProgressionHead
--inner join Employee as emp on emp.Cd=EmpProgressionHead.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT6' and CPA.ApplTyp=EmpProgressionHead.Typ and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	EmpProgressionHead.Status='E' 
--	and emp.CoCd=@v_CoCd
--	and emp.Status='HSTATPM   '
--	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (ApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT6' and ApplTyp=EmpProgressionHead.Typ and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))
	
--select COUNT(empprovisionsadj.EmpCd) as ProvAdj  from empprovisionsadj
--inner join Employee as emp on emp.Cd=empprovisionsadj.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT14' and CPA.ApplTyp=empprovisionsadj.ProvTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	empprovisionsadj.Status='N' 
--	and emp.CoCd=@v_CoCd
--	and emp.Status='HSTATPM   '
--	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (ApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT14' and ApplTyp=empprovisionsadj.ProvTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))
			 
	
select SysCodes.Cd[Cd],SysCodes.Des,COUNT(Emp.Cd) as HeadCount from Employee as Emp 
right   join SysCodes on Emp.Status=SysCodes.Cd  
group by  SysCodes.Des,typ,emp.CoCd,SysCodes.Cd 
having  typ='HSTAT ' or emp.CoCd=@v_CoCd


declare @CurMonth int
set @CurMonth=(select Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_MONTH           ')


--order by Abbr
--or Prd=
--(select (CONVERT(varchar(10),(select Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            ')))+
--(CONVERT(varchar(10),(select right ('00'+ltrim(str( (@CurMonth-1) )),2 ))))) 

--select * from syscodes where typ='HEDT ' and cd<>'HEDT04    '
declare @monthname as varchar(50)
set @monthname=
 case @CurMonth
when 1 then 'January'  
when 2 then 'February' 
when 3 then 'March' 
when 4 then 'April' 
when 5 then 'May' 
when 6 then 'June' 
when 7 then 'July' 
when 8 then 'August' 
when 9 then 'September' 
when 10 then 'October' 
when 11 then 'November' 
when 12 then 'December' 
end 
select @monthname +' '+Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            '

declare @monthnameminusone as varchar(50)
set @monthnameminusone=
case @CurMonth-1
when 0 then 'December' 
when 1 then 'January'  
when 2 then 'February' 
when 3 then 'March' 
when 4 then 'April' 
when 5 then 'May' 
when 6 then 'June' 
when 7 then 'July' 
when 8 then 'August' 
when 9 then 'September' 
when 10 then 'October' 
when 11 then 'November' 
when 12 then 'December' 
end 
if( @monthnameminusone = 'December' )
begin
select @monthnameminusone +' '+
(select CONVERT(varchar, CONVERT(int, Val)-1) from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            ')
end
else
begin
select @monthnameminusone +' '+Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            '
end


SELECT 
    p.Prd,
	(select des from syscodes where cd=e.EdTyp)Name,
    ISNULL(SUM(Amt), 0) AS PayElementDetailsCount
FROM 
    (SELECT DISTINCT Prd FROM EmpTransYtd WHERE EmpCd = @v_EmpCd) p
CROSS JOIN 
    (SELECT DISTINCT EdTyp FROM EmpTransYtd WHERE EmpCd = @v_EmpCd) e
LEFT JOIN 
    EmpTransYtd t ON p.Prd = t.Prd AND e.EdTyp = t.EdTyp AND t.EdCd <> 'HEDT04' AND t.EmpCd = @v_EmpCd
GROUP BY 
    p.Prd, e.EdTyp
order by prd
--select SysCodes.Des,isnull(CONVERT(decimal(18,2), SUM(Amt)),0) as  PayElementDetailsCount ,Prd 
--from EmpTransDetailYtd
--right  join SysCodes on EmpTransDetailYtd.EdTyp=SysCodes.Cd  
 
--group by  SysCodes.Des,typ,cd,Abbr,Prd
--having typ='HEDT' and cd<>'HEDT04'
--and Prd=(select Val++convert(varchar(10),RIGHT('00' + CONVERT(VARCHAR,@CurMonth-1), 2)) from  Parameters where CoCd='03' and Cd='CUR_YEAR')
--(select Val*100+(@CurMonth-1) from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR')

--select COUNT(TransNo) as FundApproval  from EmpFund
--inner join Employee as emp on emp.Cd=EmpFund.EmpCd
--inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS4' and CPA.ApplTyp=EmpFund.Typ and CPA.Div=emp.Div and CPA.Dept=emp.Dept
--inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
--where 
--	EmpFund.[Status]='N' 
--	and emp.CoCd=@v_CoCd
--	and emp.Status='HSTATPM'
--	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
--		or (ApprBy is not null
--			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS4' and ApplTyp=EmpFund.typ and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
--			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))




DECLARE @startdate AS DATETIME = GETDATE()
SELECT   Sum(AmtVal)[LoanRecoveryAmount] from EmpLoanDetail where EffDate>= DATEADD(MONTH, DATEDIFF(MONTH, 0, @startdate) , 0) and EndDate<=cast(EOMONTH(@startdate) as datetime) and Typ='D' 
 Go 
CREATE OR ALTER Procedure [dbo].[ActivityLogHead_Update]
	@v_CoCd			Char(5)
,	@v_ActivityId	bigint=''
,	@v_SessionId	Varchar(40)=''
,	@v_UserCd		Char(5)=''
,	@v_IP			Varchar(20)=''
,	@v_OS			Varchar(20)=''
,	@v_Browser		Varchar(20)=''
,	@v_StartTime	datetime=''
,	@v_EndTime		datetime=''
,	@v_typ			Char(1)=''
As		-- Drop Procedure [dbo].[ActivityLogHead_Update]'03','13','','','','','','','05/13/2015','U'
Begin
	if @v_typ='I'
	begin
		Insert into ActivityLogHead
		Values(
			@v_CoCd
		,	@v_SessionId
		,	@v_UserCd
		,	@v_IP
		,	@v_OS
		,	@v_Browser
		,	@v_StartTime
		,	@v_EndTime)
		select @@identity
	end
	else if @v_typ='U'
	begin
		update ActivityLogHead
		set EndTime=@v_EndTime
		where CoCd=@v_CoCd and ActivityId=@v_ActivityId
		select @@identity
	end
End

 
 Go 
CREATE OR ALTER   Procedure [dbo].[GetRepo_PaySlip_Format_N] 
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
			trim(Tp.EmpCd)[EmpCd]
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
			trim(Tp.EmpCd)[EmpCd]
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


CREATE OR ALTER   Procedure [dbo].[GetRepo_ExpiredDocument_N]
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


CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpPayDetail_Format_N]
 	@v_CoCd			Char(5)		
,	@v_RPrd			Char(2)	
,	@v_RYear		Char(4)
,   @v_Employee     Char(10)	
,   @v_Branch       char(5)	
,   @v_Location     char(10)
,   @v_Department   Char(10)
,   @v_Sponsor      Char(10)
As				-- Drop Procedure [GetRepo_EmpPayDetail_Format_N]'01','11','2023','All','All','All ','All','All'
				
Begin

	declare @W_days numeric(2,0)
	exec @W_days=  Get_Eday @v_RPrd,@v_RYear
	--select @W_days
	print @v_RYear+ RIGHT('0' +convert(varchar(10),@v_RPrd),3)
	Declare @v_CoName		Varchar(50)
	Declare @AmtDecs		int
	Declare @Prd			Char(6)
	Declare @EDay 				int
	Declare @Month			int
	Declare @Year			int
	Declare @Days 			numeric(5,2)
	Declare @DHrs 			numeric(5,2)
	Declare @CoCalcBasis	varChar(2)
	Declare @MnthDays			Varchar(10)
	Declare @MnthDays1			Varchar(10)
	Declare @FixedDays			Numeric(12,10)
	Select  @MnthDays=Val From Parameters Where Cd='MNTHDAYS' and CoCd='#'
	Select  @MnthDays1=Val From Parameters Where Cd='MNTHDAYS1' and CoCd='#'
	Select  @FixedDays=Cast(@MnthDays as Float)/Cast(@MnthDays1 as Float)
	Select	@v_CoName=CoName from Company where Cd=@v_CoCd
	Select	@AmtDecs=AmtDecs from Company where Cd=@v_CoCd
	Select	@Month=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_CoCd
	Select	@Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_CoCd
	Select	@DHrs=Val from Parameters where Cd='WORKHRS' and CoCd=@v_CoCd
	Select  @CoCalcBasis=Val  From Parameters Where Cd='CALC_BASIS' and CoCd=@v_CoCd
	Exec    @Eday=dbo.Get_Eday @Month,@Year
	select  @Days=case when @CoCalcBasis='Y' then @FixedDays  when @CoCalcBasis='M' then @Eday else @CoCalcBasis end
	select  @Prd=case when LEN(convert(varchar(10),@Month))=1 then convert(varchar(10),@Year)+RIGHT('0' +convert(varchar(10),@Month),3) else convert(varchar(10),@Year)+convert(varchar(10),@Month) end
	--print @Eday
	--print @FixedDays

	If Cast(@v_RYear as int) *100 +Cast(@v_RPrd as int) >= @Year *100 +@Month
		BEGIN

			Select 	distinct
				EmT.Empcd[Cd]	
			,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
			--,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) ),2)[BasicSalaray]
			--,	round((IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days-Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[OtherAllowance]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='004' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) ),2)[OtherAllowance]

			,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[ElSal]
			,	round((Emp.Basic/@Days)*(select SUM(Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[LOP]
			--,	(select SUM(Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)[WorkingDays]
			
			--,case when(select count(*) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)>1
			--then abs(Isnull(((Select Isnull(sum(Up_HDays),0) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)),0)
			---Isnull((@Days),0))
			--else Isnull((Select Isnull(sum(Up_HDays),0) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd),0) 
			--end [WorkingDays] 
			,	case when(select count(*) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)>1
				then abs(Isnull(((Select Isnull(sum(Up_HDays),0) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)),2)
				-Isnull((@Days),0))
				else Isnull((Select abs(Isnull(sum(Up_HDays),0)-Isnull((@Days),0)) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd),0) 
				end [WorkingDays] 
			,	(Select Sdes from CompanyEarnDed where Cd=EmT.EdCd and Typ=EmT.EdTyp)[Sdes]
			,	isnull(Amt,0)[Amt]
			,	RIGHT('0' +convert(varchar(10),@Month),3)[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select sdes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			,	(select des from Branch where cd=EmT.HRDiv)[Branch]
			into dbo.#temp_Sal
			From
		 		EmpTrans EmT	
			inner join 	Branch    Br on Br.Cd=EmT.HRDiv	
			inner join   Codes    Cod on Cod.Cd=EmT.LocCd  
			inner join Dept       Dep on Dep.Cd=EmT.HRDept
			,Employee	  Emp
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Emp.cd=Emt.EmpCd
			and	Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and EdTyp <> 'HEDT04'
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
			and Emp.Active='Y'
			union 

			Select 	distinct
				Emp.cd[Cd]	
			,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName]
			--,	isnull(round(isnull(Emp.Basic,0),2),0)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=Emp.Div) ),2)[BasicSalaray]
			--,	round(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0),2)[OtherAllowance]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='004' and EdTyp='HEDT01' and EmpCd=Emp.cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=Emp.Div) ),2)[OtherAllowance]
			,	round(Emp.Basic
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)),2)[ElSal]
			,	round(Emp.Basic
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)),2)[LOP]
			,	@Days[WorkingDays]
			,	(Select Sdes from CompanyEarnDed, EmpTrans EmT where Cd=EmT.EdCd and Typ=EmT.EdTyp and  EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=Emp.Div))[Sdes]
			,	0[Amt]

			,	Cast(@v_RPrd as CHAR(2))[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select SDes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			--,	(select des from Branch where cd=emp.Div)[Branch]
			,	(select des from Branch where cd=(select top 1 hrdiv from EmpTransYtd where empcd=emp.cd and prd=@Prd))[Branch]

			
			From
			Employee	  Emp	
			inner join 	Branch    Br on Br.Cd=Emp.Div	
			inner join   Codes    Cod on Cod.Cd=Emp.LocCd  
			inner join Dept       Dep on Dep.Cd=Emp.Dept
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
			and Emp.Active='Y'
			and emp.cd not in (select Empcd from EmpTrans)
			--and	Emp.Cd not in (select Cd From Employee Where Status in ('HSTATNP','HSTATTP','HSTATSR','HSTATST','HSTATES'))
			order by Cd
			select * from  dbo.#temp_Sal 
			group by cd,Branch,EmpName,BasicSalaray,
			OtherAllowance,ElSal,LOP,WorkingDays,
			Prd,Yr,CompanyName,
			CompanyFax,CompanyAdress,CompanyPhone,CompanyEmail,CompanyLogo,
			Search,Desg,Doj,dept,Sponsor,secttion,Paymode
			
			drop table dbo.#temp_Sal
		END
	Else
		BEGIN
			Set	@Month=@v_RPrd
			Set	@Year=@v_RYear
			Exec    @Eday=dbo.Get_Eday @Month,@Year
			select  @Days=case when @CoCalcBasis='Y' then @FixedDays  when @CoCalcBasis='M' then @Eday else @CoCalcBasis end
			select  @Prd=case when LEN(convert(varchar(10),@Month))=1 then convert(varchar(10),@Year)+RIGHT('0' +convert(varchar(10),@Month),3) else convert(varchar(10),@Year)+convert(varchar(10),@Month) end
		
			Select 	distinct
				EmT.Empcd[Cd]	
					,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName]
			--,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) and prd=@Prd ),2)[BasicSalaray]
			--,	round((IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[OtherAllowance]
			,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdCd='004'  and EdTyp='HEDT01' and prd=@Prd and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=EmT.HRDiv)),0),2)[OtherAllowance]
			,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[ElSal]
			,	round((Emp.Basic/@Days)*(select SUM(Up_HDays) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(Up_HDays) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[LOP]
			--,	(select SUM(Up_HDays) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)[WorkingDays]
			,	case when(select count(*) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)>1
				then abs(Isnull(((Select Isnull(sum(Up_HDays),0) From EmpAttendanceYtd Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)),2)
				-Isnull((@Days),0))
				else Isnull((Select abs(Isnull(sum(Up_HDays),0)-Isnull((@Days),0)) From EmpAttendanceYtd Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd),0) 
				end [WorkingDays] 
			,	(Select Sdes from CompanyEarnDed where Cd=EmT.EdCd and Typ=EmT.EdTyp)[Sdes]
			,	isnull(Amt,0)[Amt]
			,	RIGHT('0' +convert(varchar(10),@Month),3)[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select SDes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			,	(select des from Branch where cd=(EmT.HRDiv))[Branch]
			into  dbo.#temp_Sal1
			From
		 		EmpTransYtd EmT	
			inner join 	Branch    Br on Br.Cd=EmT.HRDiv	
			inner join   Codes    Cod on Cod.Cd=EmT.LocCd  
			inner join Dept       Dep on Dep.Cd=EmT.HRDept
			,Employee	  Emp
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Emp.cd=Emt.EmpCd
			and	Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and EdTyp <> 'HEDT04'
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
		--	and Emp.Active='Y'
			and Emt.Prd=@Prd
			--order by Cd
			union 

			Select 	distinct
				Emp.cd[Cd]	
					,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName]
			--,	isnull((Emp.Basic/@Days),0)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=emp.Div) ),2)[BasicSalaray]

			,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdCd='004'  and EdTyp='HEDT01' and prd=@Prd and EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=emp.Div)),0),2)[OtherAllowance]
			--,	(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)/@Days)[OtherAllowance]
			,	(Emp.Basic/@Days)*
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)/@Days)[ElSal]
			,	Emp.Basic
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0))[LOP]
			,	@Days[WorkingDays]
			,	(Select Sdes from CompanyEarnDed, EmpTransYtd EmT where Cd=EmT.EdCd and prd=@Prd and Typ=EmT.EdTyp and  EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=Emp.Div))[Sdes]
			,	0[Amt]
			,	Cast(@v_RPrd as CHAR(2))[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select SDes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			,	(select des from Branch where cd=(select top 1 hrdiv from EmpTransYtd where empcd=emp.cd and prd=@Prd))[Branch]
			From
				Employee	  Emp	
			inner join 	Branch    Br on Br.Cd=Emp.Div	
			inner join   Codes    Cod on Cod.Cd=Emp.LocCd  
			inner join Dept       Dep on Dep.Cd=Emp.Dept
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
			and Emp.Active='Y'
			and emp.cd not in (select Empcd from EmpTransYtd)
			--and	Emp.Cd not in (select Cd From Employee Where Status in ('HSTATNP','HSTATTP','HSTATSR','HSTATST','HSTATES'))
			order by Cd

			--select * from dbo.#temp_Sal1 --group by cd

DECLARE 
		@pivotcols AS NVARCHAR(MAX)
,		@query  AS NVARCHAR(MAX)

select distinct Sdes into #EmpTransYtd1 from #temp_Sal1 


select @pivotcols=Coalesce(@pivotcols+',','')+QUOTENAME(Sdes)  from #EmpTransYtd1 

--select @pivotcols
Set @query=N'Select cd,Empname,Prd,Yr,CompanyName,CompanyAdress,CompanyFax,CompanyEmail,CompanyLogo,Desg,DOj,Dept,secttion,Paymode,Sponsor,Branch,'+@pivotcols+'  from #temp_Sal1 Pivot (sum(Amt) for Sdes in('+@pivotcols+')) as Pivot1'
--select @query

exec sp_executesql @query



drop table  #EmpTransYtd1
drop table dbo.#temp_Sal1

END
End 
 Go 
CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpTransactionDetail]    
	@v_CoCd   Char(5)   
,	@v_EmpCd char(10)   
,	@v_RFrmPrd  Char(6)   
,	@v_RToPrd  Char(6)   
As    -- Drop Procedure [GetRepo_EmpTransactionDetail] '01','523','202110','202310'  
Begin     

/*
declare @v_CoCd   Char(5)   
declare @v_EmpCd char(10)   
declare @v_RFrmPrd  Char(6)   
declare @v_RToPrd  Char(6)
Select @v_CoCd   ='01' 
Select @v_EmpCd ='001' 
Select @v_RFrmPrd  ='201001'   
Select @v_RToPrd  ='201506'
*/

Declare @Prd int   
Declare @Year int   
Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd='01'   
Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd='01'         
	--Select Cd[Cd]     
	--, rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	--, (select SDes from Branch where Cd=Employee.Div) [Branch]
	--, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	--  +left(@v_RFrmPrd,4)     
	--  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	--  +left(@v_RToPrd,4)[Period]  
	--from Employee    
	--where Cd=@v_EmpCd               
	
If @Year *100 +@Prd between @v_RFrmPrd and @v_RToPrd    
Begin
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,@Prd), 0 ) - 1 ))[Month]    
	, @Year[Yr]    
	, convert(char(4),@Year)+ +right ('00'+ltrim(str( @Prd)),2 )[Prd]
		, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	,Emp.Cd[Cd]     
		,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
		, (select SDes from Branch where Cd=emp.Div) [Branch]
	,	round((select isnull(sum(amt),0) from emptrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd ),2)[BasicSalaray]
	--,	round(IsNull((Select isnull(sum(Amt),0) from EmpTrans where EdTyp in('HEDT01 ','HEDT03') and edcd<>'STFFP' and TrnInd='M' and EmpCd=EmT.Empcd ),0),2)[ExtraMnthly]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where edcd not in('TMF1','TMF2','TMF3','004','PENSI','211','203','201  ') and EdTyp='HEDT02' and EmpCd=EmT.Empcd ),0),2)[Deductions]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='004' and EdTyp='HEDT02' and EmpCd=EmT.Empcd ),0),2)[Recovery]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('TMF1','TMF2','TMF3') and EdTyp='HEDT02' and EmpCd=EmT.Empcd  ),0),2)[TMF]

	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd ),0),2)[FOTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('052','051','004','FOTA')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[Allowance]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[LivingAllowance]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[OverTime]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in ('MGRIN','207' )  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[Incentives]

	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='053'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[LastSalary]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[StaffAdvGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('211','004','203','201  ')  and EdTyp='HEDT02' and EmpCd=EmT.Empcd  ),0),2)[StaffAdvCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('FUNDW','STFFP')  and EdTyp in('HEDT01','HEDT03') and EmpCd=EmT.Empcd  ),0),2)[StaffFundGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[StaffFundCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  ),0),2)[TMFPay]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  ),0),2)[LSA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('LTA','008  ')   and EdTyp='HEDT03' and EmpCd=EmT.Empcd  ),0),2)[LTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='PENSI'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd  ),0),2)[Pension]
	into #EmpTrans
	From     EmpTrans EmT, Employee Emp     
	where	emp.Cd=@v_EmpCd 
			and emt.EmpCd=@v_EmpCd     
	group by emt.EmpCd,emp.Basic,emp.Cd  ,emp.Fname,emp.Mname,emp.Lname,emp.Div 
	
	
union       
	

Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	, left(Prd,4)[Yr] 
	, EmT.Prd  [Prd] 
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	,Emp.Cd[Cd]     
		,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
		, (select SDes from Branch where Cd=emp.Div) [Branch]
	--, Isnull(Emp.Basic,0)+ IsNull((Select sum(Amt) from EmpTransYtd where EdCd<>'001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[Eligible]    
	--, Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LOP]
	--, IsNull((select Amt from EmpTransYtd where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LS]   
	--, IsNull((select Amt from EmpTransYtd where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LT]     
	--, IsNull((select sum(Amt) from EmpTransYtd where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd and Prd=EmT.Prd),0)[Recovery]    
	--, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=EmT.Prd and EmpCd=@v_EmpCd),0)[Advance]    
	,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and Prd=EmT.Prd),2)[BasicSalaray]

	--,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdTyp in('HEDT01 ','HEDT03') and edcd<>'STFFP'   and TrnInd='M' and EmpCd=EmT.Empcd ),0),2)[ExtraMnthly]
	,	round(IsNull((select sum(Amt) from EmpTransYtd where edcd not in('TMF1','TMF2','TMF3','004','PENSI','211','203','201  ') and EdTyp='HEDT02'  and EmpCd=EmT.Empcd and Prd=EmT.Prd),0),2)[Deductions]
	--,	round(IsNull((select sum(Amt) from EmpTransYtd where EdCd='004' and EdTyp='HEDT02'  and EmpCd=EmT.Empcd    and Prd=EmT.Prd),0),2)[Recovery]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('TMF1','TMF2','TMF3') and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and prd=EmT.Prd),0),2)[TMF]

	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[FOTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('052','051','004','FOTA')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Allowance]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LivingAllowance]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[OverTime]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('207  ','MGRIN')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Incentives]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='053  '  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[LastSalary]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('211','004','203','201  ')  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('FUNDW','STFFP')  and EdTyp in('HEDT01','HEDT03') and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffFundGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[StaffFundCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[TMFPay]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LSA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('LTA','008  ')  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='PENSI'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Pension]
	From     EmpTransYtd EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by EmT.EmpCd,Prd,emp.Basic,emp.Cd  ,emp.Fname,emp.Mname,emp.Lname,emp.Div 
	order by  Prd asc
	select *,[Month]+' '+cast(Yr as char(4))[Decsription] from  #EmpTrans
	drop table #EmpTrans
	End
else       
Begin
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	, left(Prd,4)[Yr] 
	, emt.Prd    [Prd]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	,Emp.Cd[Cd]     
		,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
		, (select SDes from Branch where Cd=emp.Div) [Branch]
	--,format( Isnull(Emp.Basic,0),'###,###,###.###')[Eligible]    
	--, format(Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=emt.Prd),0),'###,###,###.###')[LOP]  
	--, format(IsNull((select Amt from EmpTransYtd where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0),'###,###,###.###')[LS]   
	--, format(IsNull((select Amt from EmpTransYtd where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0),'###,###,###.###')[LT]   
	--, format(IsNull((select sum(Amt) from EmpTransYtd where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd and Prd=emt.Prd),0),'###,###,###.###')[Recovery]    
	--, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=EmT.Prd and EmpCd=@v_EmpCd),0)[Advance]    
	,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and Prd=EmT.Prd),2)[BasicSalaray]
	--,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdTyp in('HEDT01 ','HEDT03') and edcd not in('STFFP','MGRIN','208') and TrnInd='M' and EmpCd=EmT.Empcd and  Prd=EmT.Prd),0),2)[ExtraMnthly]
	,	round(IsNull((select sum(Amt) from EmpTransYtd where edcd not in('TMF1','TMF2','TMF3','004','PENSI','211','203','201  ')and EdTyp='HEDT02'  and EmpCd=EmT.Empcd and Prd=EmT.Prd),0),2)[Deductions]
	--,	round(IsNull((select sum(Amt) from EmpTransYtd where EdCd='004' and EdTyp='HEDT02'   and EmpCd=EmT.Empcd    and Prd=EmT.Prd),0),2)[Recovery]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('TMF1','TMF2','TMF3') and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and prd=EmT.Prd ),0),2)[TMF]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[FOTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('052','051','004','FOTA')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Allowance]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LivingAllowance]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[OverTime]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('207  ','MGRIN')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Incentives]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='053  '  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[LastSalary]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('211','004','203','201  ')  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('FUNDW','STFFP')  and EdTyp in('HEDT01','HEDT03') and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffFundGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[StaffFundCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[TMFPay]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LSA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('LTA','008  ')  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='PENSI'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Pension]
	into #EmpTransYtd
	From     EmpTransYtd EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and emt.Prd between @v_RFrmPrd and @v_RToPrd     
	group by emt.EmpCd,Prd,emp.Basic,emp.Cd   ,emp.Fname,emp.Mname,emp.Lname ,emp.Div 
	order by Prd asc 
	select *,[Month]+' '+cast(Yr as char(4))[Decsription] from #EmpTransYtd
	drop table #EmpTransYtd
	--EdCd ='004' and
ENd
End 
 
 Go 

CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpLeave]
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
+' - '+convert(varchar(20),empleaveappr.LvApprDt,103)
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
	,	convert(varchar(20),LvApprDt,103)[FormatedLvApprDt]
	,	convert(varchar(20),JoinDt,103)[FormatedJoinDt]
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
	,	convert(varchar(20),FromDt,103)[FromDt]
	,	convert(varchar(20),ToDt,103)[ToDt]
	,	DocRef
	,	DocDt
	,	LvStatus
	,	LvInter
	,	case WP_FromDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WP_FromDt,103) end[FormatedWP_FromDt]
	,	case WP_ToDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WP_ToDt,103) end[FormatedWP_ToDt]
	,	case WOP_FromDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WOP_FromDt,103) end[FormatedWOP_FromDt]
	,	case WOP_ToDt
		when '01/01/1900' then null
		else
		convert(varchar(20),WOP_ToDt,103) end[FormatedWOP_ToDt]
	,	Reason
	,	Narr
	,	(Select CoName from Company where Cd=@v_CoCd)[CoName]	
	,	(Select count(*) from EmpLeaveAppr where EmpLeaveAppr.TransNo=EmpLeave.TransNo and Status='Y')[Count]
	,	JoinDt
	,	SysTransNo
	,	isnull(lvsalary,0)[lvsalary]
	,	isnull(lvfare,0)[lvfare]
	,	isnull(convert(varchar(20),(select Datediff(dd,FromDt,ToDt)+1 from EmpLeaveProvisions where TransNo=EmpLeave.TransNo and ProvTyp='GT'),103),0)[GT]
	,	isnull(convert(varchar(20),(select Datediff(dd,FromDt,ToDt)+1 from EmpLeaveProvisions where TransNo=EmpLeave.TransNo and ProvTyp='LS'),103),0)[LS]
	,	isnull(convert(varchar(20),(select Datediff(dd,FromDt,ToDt)+1 from EmpLeaveProvisions where TransNo=EmpLeave.TransNo and ProvTyp='LT'),103),0)[LT]
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


CREATE OR ALTER   procedure [dbo].[EmpTransfers_GetRow]
	@v_Srno		Numeric(5,0)
,	@v_EmpCd	Char(10)
,	@v_Usercd		varchar(10)
As			--Drop Procedure [EmpTransfers_GetRow] '01','0',''
Begin
	select
		EmpTr.EmpCd
	,	Emp.Fname+' '+Emp.Mname+' '+Emp.Lname[Fname]
	,	EmpTr.SrNo
	,	EmpTr.TransferDt
	,	CONVERT(varchar(20),EmpTr.TransferDt,103)[FormatedTransferDt]
	,	(select SDes from Dept where EmpTr.DeptFrom=Dept.Cd)[DeptFrDes]
	,	(select SDes from Dept where EmpTr.DeptTo=Dept.Cd)[DeptToDes]
	,	Emptr.DeptFrom[DeptFrom]
	,	Emptr.DeptTo[DeptTo]
	,	(select SDes from Codes where EmpTr.LocFrom=Codes.Cd)[LocFrDes]
	,	(select SDes from Codes where EmpTr.LocTo=Codes.Cd)[LocToDes]
	,	Emptr.LocFrom[LocFrom]
	,	Emptr.LocTo[LocTo]
	,	(Select SDes From Branch where Emptr.BrFrom=Branch.Cd)[BrFrDes]
	,	(Select SDes From Branch where Emptr.BrTo=Branch.Cd)[BrToDes]
	,	Emptr.BrFrom[BrFrom]
	,	Emptr.BrTo[BrTo]
	,	EmpTr.EntryBy
	,	EmpTr.EntryDt
	,	EmpTr.EditBy
	,	EmpTr.EditDt
	,	(Select CoName From Company where EmpTr.BU_From=Company.Cd)[CompFrDes]
	,	(Select CoName From Company where EmpTr.BU_To=Company.Cd)[CompToDes]
	,	EmpTr.BU_To[CompTo]
	,	EmpTr.Narr[Narration]
	From
		Emptransfers 	EmpTr
	,	Employee	Emp
	where
		Emp.Cd=EmpTr.Empcd
	and	(@v_EmpCd='' or @v_EmpCd<>'' and EmpTr.EmpCd=@v_EmpCd)
	and (@v_Srno='0' or @v_Srno<>'0' and EmpTr.SrNo=@v_Srno)
	and (Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd='')))

	order by TransferDt desc

End

 
 
 Go 




CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpShortList]
	@v_CoCd				Varchar(5)	 
,   @v_Employee			Char(10)=''	
,   @v_Branch			char(5)=''
,   @v_Location			char(10)=''	
,   @v_Department		Char(10)=''	
,   @v_Sponsor			Char(10)=''	
,	@v_Desg				Char(5)=''
,	@v_Age				Char(5)='0'
,	@v_Qualification	Char(10)=''
,	@v_Status			Char(10)=''
,   @v_RowsCnt			Char(1)=''
,	@v_Nationality		Char(10)=''
,	@v_EmployeeType		Char(10)=''



As		-- Drop Procedure [dbo].[GetRepo_EmpShortList] '01','All ','All ','All ','All ','All ','All','0','HQUAL0001 ','','2'
Begin
	Select
		distinct Emp.Cd [Code]
	,	rtrim(Emp.Fname)+' '+rtrim(Emp.Mname)+' '+rtrim(Emp.Lname) [Emp Name]
	,	Emp.Sex [Sex] 
	,	(select SDes FROM Codes where Typ='HMS' and Codes.cd=Emp.Marital)[Martial]
	,	(Select SDes FROM Branch where Cd=Emp.Div)[Branch]
	,	(Select SDes FROM CC where Cd=Emp.CC)[CC]
	,	(Select SDes FROM Dept where Dept.Cd=Emp.Dept) [Department]
	,	(select SDes FROM Codes where Codes.cd=Emp.LocCd) [Location]
	,	(Select Nat from Country where cd=Emp.Nat) [Nationality]
	,	(select Des FROM Designation where Designation.Cd=Emp.Desg) [Designation]
	--,	Emp.Dob	[Dob]
	,	CONVERT(varchar(20),Emp.Dob,103)[FormatedDob]
	--,	Emp.DOJ	[DOJ]
	,	CONVERT(varchar(20),Emp.DOJ,103)[FormatedDOJ]
	--,	(select SDes FROM Codes ,Employee where Codes.cd=Employee.EmpCat1 and Employee.cd=Emp.Cd)[Employee Category1]
	--,	(select SDes FROM Codes ,Employee where Codes.cd=Employee.EmpCat2 and Employee.cd=Emp.Cd)[Employee Category2]
	--,	(select SDes FROM Codes ,Employee where Codes.cd=Employee.EmpCat3 and Employee.cd=Emp.Cd)[Employee Category3]
	,	(select rtrim(FName)+' '+rtrim(MName)+rtrim(LName) from Employee where Cd=(select RepTo from Employee where Employee.cd=Emp.Cd))[Reporting To]
	,	(Select Des from Currency where Cd= Emp.BasicCurr) [BasicCurr]
	,	Emp.Basic [Basic]
	,	Emp.Basic+(select Sum(isnull(AmtVal,0)) from empearnded where EmpCd=Emp.Cd and (Rtrim(EdCd)+RTrim(EdTyp))<>'001HEDT01' and CONVERT(varchar(10), EndDate,103)='01/01/1900') [Total]
	,	Emp.FareEligible [FareEligiblity]
	,	(select Des from codes where Typ='ESPON' and Cd=emp.Sponsor)[Sponsor]
	,	(select Des from Syscodes where cd=Emp.PayMode) [Pay Mode]
	,	(select Des from Syscodes where cd=Emp.PayFreq) [Pay Frequency]
	,	(select Des from Syscodes where cd=Emp.Status) [Status]
	,	(select Des from CompanyShiftMaster where Cd=Emp.ShiftCd) [Shift]
	,	(select Des from Syscodes where Typ='HOTC1' and Cd=Emp.Relg) [Religion]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0001' and EmpCd=Emp.cd order by SrNo desc) [PassportNo]
	,	(select top 1 CONVERT(varchar(20),ExpDt,103) from EmpDocuments where DocTyp='HDTYP0001' and EmpCd=Emp.cd order by SrNo desc) [PassportExpDt]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0002' and EmpCd=Emp.cd order by SrNo desc) [VisaNo]
	,	(select top 1 CONVERT(varchar(20),ExpDt,103) from EmpDocuments where DocTyp='HDTYP0002' and EmpCd=Emp.cd order by SrNo desc) [VisaExpDt]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0003' and EmpCd=Emp.cd order by SrNo desc) [LabourCard]
	,	(select top 1 CONVERT(varchar(20),ExpDt,103) from EmpDocuments where DocTyp='HDTYP0003' and EmpCd=Emp.cd order by SrNo desc) [LabourCardExpDt]
	,	(select top 1 DocNo from EmpDocuments where DocTyp='HDTYP0008' and EmpCd=Emp.cd order by SrNo desc) [EmiratedId]
	,	(select Phone from EmpAddress where AddTyp='HADD0001' and EmpCd=Emp.cd) [PhoneNo]
	,	(select Email from EmpAddress where AddTyp='HADD0001' and EmpCd=Emp.cd) [EmailId]
	--,	Emp.Basic+(select Sum(isnull(AmtVal,0)) from empearnded where EmpCd=Emp.Cd and (Rtrim(EdCd)+RTrim(EdTyp))<>'001HEDT01' and CONVERT(varchar(10), EndDate,103)='01/01/1900') [Total]
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
		and (@v_Branch='All' or emp.Div=@v_Branch)
		and (@v_location='All' or emp.LocCd=@v_location)
		and (@v_Department='All' or Emp.Dept=@v_Department)
		and (@v_Sponsor='All' or emp.Sponsor=@v_Sponsor)
		and (@v_Desg='All' or  Emp.Desg=@v_Desg)
		and (@v_Age='0' or CONVERT(int,ROUND(DATEDIFF(hour,Emp.Dob,GETDATE())/8766.0,0))=@v_Age)
		and (@v_Qualification='All' or emp.cd in (select empcd from EmpQualification where Cd= @v_Qualification))
		and (@v_Nationality='All' or emp.Nat =@v_Nationality)
		and (emp.EmpTyp=@v_EmployeeType or @v_EmployeeType='ALL')
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
		and (@v_RowsCnt='0' and (Emp.Status in ('HSTATAB','HSTATDI','HSTATDO','HSTATNP','HSTATPM'))) 
			or (@v_RowsCnt='1' and Emp.Status in ('HSTATSR','HSTATST'))
			or (@v_RowsCnt='2' and  ltrim(rtrim(Emp.Status))=ltrim(rtrim(@v_Status))) or (@v_RowsCnt='')
	order by 
		Emp.Cd
End




 
 
 Go 
CREATE OR ALTER   procedure [dbo].[EmpLeave_Allowances_WithoutLeave]
	@v_CoCd			Char(5)
,	@v_Empcd			char(10)
As		-- Drop Procedure [dbo].[EmpLeave_Allowances_WithoutLeave]'01','488'
Begin
	Declare @BasicCd		Char(15)
	Declare @AmtDecs		int
	select  @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
	select  @AmtDecs=AmtDecs From Company Where Cd=@v_CoCd
	select
			case when E.LT='Y'
				then 1
				else 0 end[LvTicket]
			,case when E.FareEligible='Y'
				then (SELECT isnull(Provisions,0) FROM Country where Cd=(select Nat from Employee where Cd=@v_Empcd))
				 end[FareAmount]
			,case when E.LS='Y'
				then isnull((select isnull(OpAmt,0) from EmpProvisionsOpening where empcd=e.cd and Typ='LS'),0)+ROUND(E.Basic+
				isnull((select (
				case PercAmt
					When 'P' then  case EdTyp
							when 'HEDT02'then  -PercVal*.01*(Basic*(Select Rate From CurrencyRates CR where CR.CurrCd=ED.Curr))
							else PercVal*.01*Basic
							end
					When 'A' then  case EdTyp
							when 'HEDT02' then -AmtVal*(Select Rate From CurrencyRates CR where CR.CurrCd=ED.Curr)
							else AmtVal*(Select Rate From CurrencyRates CR where CR.CurrCd=ED.Curr)	
							end
				end) from EmpEarnDed ED where 
					EmpCd=E.Cd				
				and	rtrim(EdTyp)+rtrim(EdCd) <> @BasicCd
				and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd='AL')
				and	EffDate<=getdate() 
				and	(EndDate>=getdate()   or EndDate='1/1/1900')),0),@AmtDecs)
				else 0 end[LvSalary]
			From 
				Employee E
			Where
				E.Cd=@v_Empcd
				and Rtrim(Status) not in ('HSTATNP','HSTATTP','HSTATSR','HSTATST')
End 
 
 Go 


CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpPayDetail_Format]
 	@v_CoCd			Char(5)		
,	@v_RPrd			Char(2)	
,	@v_RYear		Char(4)
,   @v_Employee     Char(10)	
,   @v_Branch       char(5)	
,   @v_Location     char(10)
,   @v_Department   Char(10)
,   @v_Sponsor      Char(10)
As				-- Drop Procedure [GetRepo_EmpPayDetail_Format]'01','09','2023','1131       ','All','All ','All','All'
				
Begin

	declare @W_days numeric(2,0)
	exec @W_days=  Get_Eday @v_RPrd,@v_RYear
	--select @W_days
	print @v_RYear+ RIGHT('0' +convert(varchar(10),@v_RPrd),3)
	Declare @v_CoName		Varchar(50)
	Declare @AmtDecs		int
	Declare @Prd			Char(6)
	Declare @EDay 				int
	Declare @Month			int
	Declare @Year			int
	Declare @Days 			numeric(5,2)
	Declare @DHrs 			numeric(5,2)
	Declare @CoCalcBasis	varChar(2)
	Declare @MnthDays			Varchar(10)
	Declare @MnthDays1			Varchar(10)
	Declare @FixedDays			Numeric(12,10)
	Select  @MnthDays=Val From Parameters Where Cd='MNTHDAYS' and CoCd='#'
	Select  @MnthDays1=Val From Parameters Where Cd='MNTHDAYS1' and CoCd='#'
	Select  @FixedDays=Cast(@MnthDays as Float)/Cast(@MnthDays1 as Float)
	Select	@v_CoName=CoName from Company where Cd=@v_CoCd
	Select	@AmtDecs=AmtDecs from Company where Cd=@v_CoCd
	Select	@Month=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_CoCd
	Select	@Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_CoCd
	Select	@DHrs=Val from Parameters where Cd='WORKHRS' and CoCd=@v_CoCd
	Select  @CoCalcBasis=Val  From Parameters Where Cd='CALC_BASIS' and CoCd=@v_CoCd
	Exec    @Eday=dbo.Get_Eday @Month,@Year
	select  @Days=case when @CoCalcBasis='Y' then @FixedDays  when @CoCalcBasis='M' then @Eday else @CoCalcBasis end
	select  @Prd=case when LEN(convert(varchar(10),@Month))=1 then convert(varchar(10),@Year)+RIGHT('0' +convert(varchar(10),@Month),3) else convert(varchar(10),@Year)+convert(varchar(10),@Month) end
	--print @Eday
	--print @FixedDays

	If Cast(@v_RYear as int) *100 +Cast(@v_RPrd as int) >= @Year *100 +@Month
		BEGIN

			Select 	distinct
				EmT.Empcd[Cd]	
			,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
			--,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) ),2)[BasicSalaray]
			--,	round((IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days-Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[OtherAllowance]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='004' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) ),2)[OtherAllowance]

			,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[ElSal]
			,	round((Emp.Basic/@Days)*(select SUM(Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[LOP]
			--,	(select SUM(Up_HDays) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)[WorkingDays]
			
			--,case when(select count(*) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)>1
			--then abs(Isnull(((Select Isnull(sum(Up_HDays),0) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)),0)
			---Isnull((@Days),0))
			--else Isnull((Select Isnull(sum(Up_HDays),0) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd),0) 
			--end [WorkingDays] 
			,	case when(select count(*) from EmpAttendance where EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)>1
				then abs(Isnull(((Select Isnull(sum(Up_HDays),0) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)),2)
				-Isnull((@Days),0))
				else Isnull((Select abs(Isnull(sum(Up_HDays),0)-Isnull((@Days),0)) From EmpAttendance Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd),0) 
				end [WorkingDays] 
			--,	round(IsNull((Select isnull(sum(Amt),0) from EmpTrans where EdCd<>'001' and EdCd<>'009' and EdTyp='HEDT01' and TrnInd<>'M' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=EmT.HRDiv)),0),2)[Add.]
			,	round(IsNull((Select isnull(sum(Amt),0) from EmpTrans where EdTyp in('HEDT01 ','HEDT03') and TrnInd='M' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=EmT.HRDiv)),0),2)[ExtraMnthly]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd<>'004' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[Deductions]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='004' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[Recovery]


			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMF1' and EdTyp='HEDT02' and EmpCd=EmT.Empcd   and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF1]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMF2' and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF2]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMF3' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF3]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMF4' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF4]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMFC' and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMFC]

			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[FOTA]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='052'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TransportAllowance]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LivingAllowance]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[OverTime]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='MGRIN'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[ManagerIncentives]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='207'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[Incentives]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='053'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LastSalary]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffAdvGiven]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='211'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffAdvCollected]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='FUNDW'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffFundGiven]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffFundCollected]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMFPay]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LSA]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('LTA','008')  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LTA]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('PENSI')   and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[Pension]

			,	RIGHT('0' +convert(varchar(10),@Month),3)[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select sdes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			,	(select des from Branch where cd=EmT.HRDiv)[Branch]
			into dbo.#temp_Sal
			From
		 		EmpTrans EmT	
			inner join 	Branch    Br on Br.Cd=EmT.HRDiv	
			inner join   Codes    Cod on Cod.Cd=EmT.LocCd  
			inner join Dept       Dep on Dep.Cd=EmT.HRDept
			,Employee	  Emp
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Emp.cd=Emt.EmpCd
			and	Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and EdTyp <> 'HEDT04'
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
		--	and Emp.Active='Y'
			
			--order by Cd

			union 

			Select 	distinct
				Emp.cd[Cd]	
			,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName]
			--,	isnull(round(isnull(Emp.Basic,0),2),0)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=Emp.Div) ),2)[BasicSalaray]
			--,	round(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0),2)[OtherAllowance]
			,	round((select isnull(sum(amt),0) from emptrans where EdCd='004' and EdTyp='HEDT01' and EmpCd=Emp.cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=Emp.Div) ),2)[OtherAllowance]
			,	round(Emp.Basic
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)),2)[ElSal]
			,	round(Emp.Basic
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)),2)[LOP]
			,	@Days[WorkingDays]
			--,	0[Add.]
			,	0[ExtraMnthly]
			,	0[Deductions]
			,	0[Recovery]
			,	0[TMF1]
			,	0[TMF2]
			,	0[TMF3]
			,	0[TMF4]
			,	0[TMFC]
			,	0[FOTA]
			,	0[TransportAllowance]
			,	0[LivingAllowance]
			,	0[OverTime]
			,	0[ManagerIncentives]
			,	0[Incentives]
			,	0[LastSalary]
			,	0[StaffAdvGiven]
			,	0[StaffAdvCollected]
			,	0[StaffFundGiven]
			,	0[StaffFundCollected]
			,	0[TMFPay]
			,	0[LSA]
			,	0[LTA]
			,	0[Pension]

			,	Cast(@v_RPrd as CHAR(2))[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select SDes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			--,	(select des from Branch where cd=emp.Div)[Branch]
			,	(select des from Branch where cd=(select top 1 hrdiv from EmpTransYtd where empcd=emp.cd and prd=@Prd))[Branch]

			
			From
				Employee	  Emp	
			inner join 	Branch    Br on Br.Cd=Emp.Div	
			inner join   Codes    Cod on Cod.Cd=Emp.LocCd  
			inner join Dept       Dep on Dep.Cd=Emp.Dept
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
			--and Emp.Active='Y'
			and emp.cd not in (select Empcd from EmpTrans)
			--and	Emp.Cd not in (select Cd From Employee Where Status in ('HSTATNP','HSTATTP','HSTATSR','HSTATST','HSTATES'))
			order by Cd
			select * from  dbo.#temp_Sal 
			group by cd,Branch,EmpName,BasicSalaray,
			OtherAllowance,ElSal,LOP,WorkingDays,
			ExtraMnthly,Deductions,Recovery,Prd,Yr,CompanyName,
			CompanyFax,CompanyAdress,CompanyPhone,CompanyEmail,CompanyLogo,
			Search,Desg,Doj,dept,Sponsor,secttion,Paymode,TMF1,TMF2,TMF3,TMF4,TMFPay,ManagerIncentives,Incentives,StaffAdvCollected,StaffAdvGiven,StaffFundCollected,StaffFundGiven,FOTA,
			TransportAllowance,LivingAllowance,OverTime,LastSalary,LSA,LTA,Pension,TMFC
			drop table dbo.#temp_Sal
		END
	Else
		BEGIN
			Set	@Month=@v_RPrd
			Set	@Year=@v_RYear
			Exec    @Eday=dbo.Get_Eday @Month,@Year
			select  @Days=case when @CoCalcBasis='Y' then @FixedDays  when @CoCalcBasis='M' then @Eday else @CoCalcBasis end
			select  @Prd=case when LEN(convert(varchar(10),@Month))=1 then convert(varchar(10),@Year)+RIGHT('0' +convert(varchar(10),@Month),3) else convert(varchar(10),@Year)+convert(varchar(10),@Month) end
		
			Select 	distinct
				EmT.Empcd[Cd]	
					,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName]
			--,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) and prd=@Prd ),2)[BasicSalaray]
			--,	round((IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[OtherAllowance]
			,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdCd='004'  and EdTyp='HEDT01' and prd=@Prd and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=EmT.HRDiv)),0),2)[OtherAllowance]
			,	round(isnull((Emp.Basic/@Days),0)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(W_days) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[ElSal]
			,	round((Emp.Basic/@Days)*(select SUM(Up_HDays) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)
				+(IsNull((Select top 1 AmtVal from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900') and EmpCd=EmT.Empcd order by EffDate desc),0)/@Days)*(select SUM(Up_HDays) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd),2)[LOP]
			--,	(select SUM(Up_HDays) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or @v_Branch<>'All' and Div=EmT.HRDiv) and Prd=@Prd)[WorkingDays]
			,	case when(select count(*) from EmpAttendanceYtd where EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)>1
				then abs(Isnull(((Select Isnull(sum(Up_HDays),0) From EmpAttendanceYtd Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd)),2)
				-Isnull((@Days),0))
				else Isnull((Select abs(Isnull(sum(Up_HDays),0)-Isnull((@Days),0)) From EmpAttendanceYtd Where  EmpCd=EmT.EmpCd and (@v_Branch='All' or Div=@v_Branch) and Prd=@Prd),0) 
				end [WorkingDays] 
			
			--,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdCd<>'001' and EdCd<>'004' and EdTyp='HEDT01' and prd=@Prd and TrnInd<>'M' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=EmT.HRDiv) and Prd=@Prd),0),2)[Add.]
			,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdTyp in('HEDT01 ','HEDT03') and prd=@Prd and TrnInd='M' and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=EmT.HRDiv)),0),2)[ExtraMnthly]
			,	round(IsNull((select sum(Amt) from EmpTransYtd where EdCd<>'004' and EdTyp='HEDT02' and prd=@Prd and EmpCd=EmT.Empcd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) and Prd=@Prd),0),2)[Deductions]
			,	round(IsNull((select sum(Amt) from EmpTransYtd where EdCd='004' and EdTyp='HEDT02'  and prd=@Prd and EmpCd=EmT.Empcd   and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv) and Prd=@Prd),0),2)[Recovery]


			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMF1' and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF1]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMF2' and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF2]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMF3' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF3]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMF4' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMF4]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMFC' and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMFC]

			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[FOTA]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='052'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TransportAllowance]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LivingAllowance]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[OverTime]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='MGRIN'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[ManagerIncentives]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='207  '  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[Incentives]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='053  '  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LastSalary]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffAdvGiven]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='211'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffAdvCollected]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='FUNDW'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffFundGiven]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=@Prd  and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[StaffFundCollected]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[TMFPay]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LSA]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('LTA','008')   and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[LTA]
			,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('PENSI')   and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=@Prd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=EmT.HRDiv)),0),2)[Pension]
			,	RIGHT('0' +convert(varchar(10),@Month),3)[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select SDes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			,	(select des from Branch where cd=(EmT.HRDiv))[Branch]
			into  dbo.#temp_Sal1
			From
		 		EmpTransYtd EmT	
			inner join 	Branch    Br on Br.Cd=EmT.HRDiv	
			inner join   Codes    Cod on Cod.Cd=EmT.LocCd  
			inner join Dept       Dep on Dep.Cd=EmT.HRDept
			,Employee	  Emp
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Emp.cd=Emt.EmpCd
			and	Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and EdTyp <> 'HEDT04'
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
		--	and Emp.Active='Y'
			and Emt.Prd=@Prd
			--order by Cd
			union 

			Select 	distinct
				Emp.cd[Cd]	
					,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName]
			--,	isnull((Emp.Basic/@Days),0)[BasicSalaray]
			,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'All' and HRDiv=emp.Div) ),2)[BasicSalaray]

			,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdCd='004'  and EdTyp='HEDT01' and prd=@Prd and EmpCd=Emp.Cd and (@v_Branch='All' or @v_Branch<>'' and HRDiv=emp.Div)),0),2)[OtherAllowance]
			--,	(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
			--		and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)/@Days)[OtherAllowance]
			,	(Emp.Basic/@Days)*
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0)/@Days)[ElSal]
			,	Emp.Basic
				+(IsNull((Select top 1 isnull(AmtVal,0) from EmpEarnDed where EdCd='004' and EdTyp='HEDT01' and	EffDate <= rtrim(@Month) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)
					and	(EndDate >= rtrim(@Month) + '/1/'+rtrim(@Year) or EndDate='1/1/1900')and EmpCd=Emp.Cd order by EffDate desc),0))[LOP]
			,	@Days[WorkingDays]
			--,	0[Add.]
			,	0[ExtraMnthly]
			,	0[Deductions]
			,	0[Recovery]
			,	0[TMF1]
			,	0[TMF2]
			,	0[TMF3]
			,	0[TMF4]
			,	0[TMFC]
			,	0[FOTA]
			,	0[TransportAllowance]
			,	0[LivingAllowance]
			,	0[OverTime]
			,	0[ManagerIncentives]
			,	0[Incentives]
			,	0[LastSalary]
			,	0[StaffAdvGiven]
			,	0[StaffAdvCollected]
			,	0[StaffFundGiven]
			,	0[StaffFundCollected]
			,	0[TMFPay]
			,	0[LSA]
			,	0[LTA]
			,	0[Pension]
			,	Cast(@v_RPrd as CHAR(2))[Prd]
			,	Cast(@v_RYear as CHAR(4))[Yr]
			,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
			,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
			,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
			,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
			,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
			,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]
			,	(case when @v_Employee<>'All' then 'Employee-'+(select Fname+Mname from employee where Cd= @v_Employee)
					  when @v_Branch<>'All' then 'Branch-'+(select Des from Branch where Cd= @v_Branch)
					  when @v_location<>'All' then 'location-'+(select Des from Codes where Typ='HLOC' and Cd= @v_location)
					  when @v_Department<>'All' then 'Department-'+(select Des from Dept where Cd= @v_Department)
					  when @v_Sponsor<>'All' then 'Sponsor-'+(select Des from Codes where Typ='ESPON' and Cd= @v_Sponsor) end)[Search]
			,	(select SDes from Designation where cd =emp.Desg)[Desg]
			,	CONVERT(VARCHAR(11), emp.Doj, 113)[Doj]
			,	(select SDes from Dept where cd=emp.Dept)[Dept]
			,	(select sdes from codes where cd=emp.LocCd)[secttion]
			,	(select des from syscodes where ltrim(rtrim(cd))= ltrim(rtrim(Emp.PayMode)))[Paymode]
			,	(select des from codes where typ='ESPON' and cd=emp.Sponsor)[Sponsor]
			,	(select des from Branch where cd=(select top 1 hrdiv from EmpTransYtd where empcd=emp.cd and prd=@Prd))[Branch]
			From
				Employee	  Emp	
			inner join 	Branch    Br on Br.Cd=Emp.Div	
			inner join   Codes    Cod on Cod.Cd=Emp.LocCd  
			inner join Dept       Dep on Dep.Cd=Emp.Dept
			inner join   Codes    Cod1 on Cod1.Cd=Emp.Sponsor
			Where		
				Isnull(Emp.Leaving,'01-01-1900') ='01-01-1900' 
			and (@v_Employee='All' or @v_Employee<>'' and Emp.Cd=@v_Employee)
			and (@v_Branch='All' or @v_Branch<>'' and br.Cd=@v_Branch)
			and (@v_location='All' or @v_location<>'' and Cod.Cd=@v_location)
			and (@v_Department='All' or @v_Department<>'' and Dep.Cd=@v_Department)
			and (@v_Sponsor='All' or @v_Sponsor<>'' and Cod1.Cd=@v_Sponsor)
			and Emp.Active='Y'
			and emp.cd not in (select Empcd from EmpTransYtd)
			--and	Emp.Cd not in (select Cd From Employee Where Status in ('HSTATNP','HSTATTP','HSTATSR','HSTATST','HSTATES'))
			order by Cd

			select * from dbo.#temp_Sal1 --group by cd
			drop table dbo.#temp_Sal1
		END
		
		
		
End

 
 
 Go 
CREATE OR ALTER   PROCEDURE [dbo].[GetMenuWithPermissions] 
	@UserCd varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT mc.MenuId,mc.ProcessId,Prnt,MenuOrder,Typ,Caption,Frm,um.Visible Visible,uAdd,uEdit,uDelete,uView,uPrint FROM MenuCtrl_N mc
	left join (select * from UserMenu where UserCd = @UserCd) um on um.MenuId = mc.MenuId
	left join (select * from UserPermission where UserCd = @UserCd) up on up.MenuId = mc.MenuId 
	WHERE AppCd ='H' AND Active= 'Y'
	order by MenuOrder
END
 
 
 Go 
CREATE OR ALTER   PROCEDURE [dbo].[GetUserBranches]
 @UserCd varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select Cd,b.Des Branch,ub.Des UserDes,[Image] from Branch b
	left join(select * from UserBranch where UserCd = @UserCd) ub on ub.Div = b.Cd 
END
 
 
 Go 
CREATE OR ALTER   procedure [dbo].[UserBranch_GetRow] --  Drop Procedure UserBranch_GetRow 'Youne' ,'100' ,''
	@v_UserCd	Char(10)
,	@v_CoCd		Char(5)
,	@v_Div		Char(5)
As
Begin--UserBranch_GetRow '001','01',''
	--If (@v_UserCd='' and @v_Div='')
	--	Select 
	--		ub.UserCd
	--	,	ub.Div
	--	,	u.UName
	--	,	Br.SDes[Division]
	--	,	ub.Des
	--	,	ub.EntryBy
	--	,	ub.Entrydt
	--	,	ub.EditBy
	--	,	ub.EditDt 
	--	From 
	--		UserBranch ub
	--	,	Branch Br
	--	,	Users u 
	--	Where
	--		ub.Div=Br.Cd 
	--	and u.cd=ub.usercd  
	--	and	CoCd=@v_CoCd
	--	Order by 
	--		u.UName
	--Else
	Select 
			ub.Div	
		,(select des from branch where cd=ub.Div)[Branch]
		,	ub.UserCd
		,	ub.Div	
		,	u.UName
		,	Br.SDes[Division]
		,	ub.Des[UserDes]
		,	ub.EntryBy
		,	ub.Entrydt
		,	ub.EditBy
		,	ub.EditDt 
	From 
			UserBranch ub left join Branch Br on Ub.Div=Br.cd
			left join Users U on  ub.UserCd=U.Cd

		--,	Branch Br
		--,	Users u 
	Where
			--Ub.Div = Br.Cd and U.Cd=Ub.UserCd and 
			CoCd=@v_CoCd
--		and	(Ub.UserCd = @v_UserCd and @v_UserCd <> '' or @v_UserCd = '')
		and	(Ub.UserCd = @v_UserCd or @v_UserCd = '')
--		and (Ub.Div = @v_Div and @v_Div <> '' or @v_Div='')
		and (Ub.Div = @v_Div or @v_Div='')
	Order by
		u.UName
End 
 
 Go 

-- =============================================
-- Author:		<Author,,Name>
-- CREATE OR ALTER OR ALTER date: <CREATE OR ALTER OR ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[GetMessage]
	@success bit,
	@message VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select @success success,@message [message]
END
 
 
 Go 

CREATE OR ALTER     PROCEDURE [dbo].[VerifyExistingLvApplication]
    @EmpCd Char(10),
	@StartDt varchar(20),
	@EndDt varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    -- Select entries from EmpLeave table satisfying the conditions
	if (SELECT count(0)
    FROM EmpLeave
    WHERE EmpCd = @EmpCd
	AND LvStatus != 'R'
    AND JoinDt is null
    AND (FromDt <= @EndDt) AND (ToDt >= @StartDt))=0
		select 0;
	else
		select 1;
END 
 
 Go 
 CREATE OR ALTER       Procedure [dbo].[GetRepo_EmpTransactionDetail_New_N]    
	@v_CoCd   Char(5)   
,	@v_EmpCd char(10)   
,	@v_RFrmPrd  Char(6)   
,	@v_RToPrd  Char(6)   
As    -- Drop Procedure [GetRepo_EmpTransactionDetail_New_N] '01','101','202110','202310'  
Begin     

/*
declare @v_CoCd   Char(5)   
declare @v_EmpCd char(10)   
declare @v_RFrmPrd  Char(6)   
declare @v_RToPrd  Char(6)
Select @v_CoCd   ='01' 
Select @v_EmpCd ='001' 
Select @v_RFrmPrd  ='201001'   
Select @v_RToPrd  ='201506'
*/

Declare @Prd int   
Declare @Year int   
Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd='01'   
Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd='01'         
	--Select Cd[Cd]     
	--, rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	--, (select SDes from Branch where Cd=Employee.Div) [Branch]
	--, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	--  +left(@v_RFrmPrd,4)     
	--  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	--  +left(@v_RToPrd,4)[Period]  
	--from Employee    
	--where Cd=@v_EmpCd               
	
If @Year *100 +@Prd between @v_RFrmPrd and @v_RToPrd        
Begin
Select      
	 
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	,	left(Prd,4)[Yr] 
	,	 EmT.Prd  [Prd] 
	,	emt.EdTyp
	,	sum(amt)[Amt]
	,	emt.EdCd
	,	(select upper(trim(SDes)) from CompanyEarnDed where cd=edcd and typ=EdTyp)[Component]	
	,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName) +' '+rtrim(Emp.Lname)[EmpName]    
	,	(select SDes from Branch where Cd=Emp.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period]  
	into	#EmpTransYtd
	From     EmpTransYtd EmT  , Employee Emp    
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by Prd,edcd,edtyp	,Fname,Mname,Lname,Div
	
union       

Select   
	(Select DateName( month , DateAdd( month ,convert (numeric,@Prd), 0 ) - 1 ))[Month]    
	, @Year[Yr]    
	, convert(char(4),@Year)+ +right ('00'+ltrim(str( @Prd)),2 )[Prd]
	,	emt.EdTyp
	,	sum(amt)[Amt]
	,	emt.EdCd
	,	(select upper(trim(SDes)) from CompanyEarnDed where cd=edcd and typ=EdTyp)[Component]
	,	rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	,	(select SDes from Branch where Cd=Emp.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	
	From	EmpTrans EmT     , Employee Emp     
	where	emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd     
	group by emt.EmpCd,edcd,EdTyp,Fname,Mname,Lname,Div
	order by  Prd asc

	select * from #EmpTransYtd  order by  Month asc
	drop table #EmpTransYtd
End
else       
Begin
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	,	left(Prd,4)[Yr] 
	,	 EmT.Prd  [Prd] 
	,	emt.EdTyp
	,	sum(amt)[Amt]
	,	emt.EdCd
	,	(select upper(trim(SDes)) from CompanyEarnDed where cd=edcd and typ=EdTyp)[Component]	
	,	rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	,	(select SDes from Branch where Cd=Emp.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	into	#EmpTransYtd1
	From     EmpTransYtd EmT     , Employee Emp    
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by emt.EmpCd,edcd,EdTyp,Prd,Fname,Mname,Lname,Div
	order by  Prd asc
	select * from #EmpTransYtd1 order by  Month asc
	drop table #EmpTransYtd1
	--EdCd ='004' and
	End
End


 
 
 Go 

CREATE OR ALTER     PROCEDURE [dbo].[VerifyExistingLvApplication_N]
    @EmpCd Char(10),
	@StartDt varchar(20),
	@EndDt varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    -- Select entries from EmpLeave table satisfying the conditions
	if (SELECT count(0)
    FROM EmpLeave
    WHERE EmpCd = @EmpCd
	AND LvStatus != 'R'
    AND (JoinDt is null OR (FromDt <= @EndDt AND ToDt >= @StartDt)))=0
		select 0;
	else
		select 1;
END 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpTransfers_Update_N]
@v_Empcd 		char(10),
@v_Srno			Numeric(5,0),
@v_TransferDt	Datetime,
@v_DeptFr		Varchar(10),
@v_DeptTo		Varchar(10),
@v_LocFr		Varchar(10),
@v_LocTo		Varchar(10),
@v_BrFr			Varchar(5),
@v_BrTo			Varchar(5),
@v_BU_From		Varchar(5),
@v_BU_To		Varchar(5),
@v_EntryBy		Char(5),
@v_Narr			Varchar(50)
--drop Procedure [dbo].[EmpTransfers_Update_N]'001','1','05/27/2015','002','S/W','HLOC0002','HLOC0001','BH','BH','','','Admin',''
As
 
IF (SELECT COUNT(*) FROM EmpTransfers WHERE EmpCd = @v_Empcd) = 0
Begin
	Insert into Emptransfers values
	(
		@v_Empcd
	,	@v_Srno
	,	@v_TransferDt
	,	@v_DeptFr
	,	@v_DeptTo
	,	@v_LocFr
	,	@v_LocTo
	,	@v_BrFr
	,	@v_BrTo
	,	@v_BU_From
	,	@v_BU_To
	,	@v_EntryBy
	,	getdate()
	,	null
	,	null
	,	@v_Narr)
	exec GetMessage 1,'Inserted successfully'
End
Else
Begin
	Update Emptransfers 
	Set
		TransferDt=@v_TransferDt
	,	DeptFrom=@v_DeptFr
	,	DeptTo=@v_DeptTo
	,	LocFrom=@v_LocFr
	,	LocTo=@v_LocTo
	,	BrFrom=@v_BrFr
	,	BrTo=@v_BrTo
	,	BU_From=@v_BU_From
	,	BU_To=@v_BU_To
	,	EditBy=@v_EntryBy
	,	EditDT=getdate()
	,	Narr=@v_Narr
	where
		EmpCd=@v_EmpCd
	and	SrNo=@v_SrNo
	exec GetMessage 1,'Updated successfully'
End
	-- Added 13/05/2004  Maju.
If @v_Empcd <> '' 
	Begin
		Update Employee set
			 Dept=@v_DeptTo
		,	Div=@v_BrTo
		,	LocCd=@v_LocTo
		where Cd=@v_Empcd		
	End
	--


 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyProcessApproval_Detail_Insert_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_ApplTyp			char(10)
,	@v_Div				char(5)
,	@v_Dept				char(10)
,	@v_SrNo				Numeric(3,0)
,	@v_EmpCd			Char(10)
As		-- Drop Procedure [dbo].[CompanyProcessApproval_Detail_Insert]
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
						insert into CompanyProcessApprovalDetail 	  
						values(
										@v_CoCd
									,	@v_ProcessId
									,	@v_ApplTyp
									,	@v_Div1
									,	@v_Dept1
									,	@v_SrNo
									,	@v_EmpCd)
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
				insert into CompanyProcessApprovalDetail 	  
				values(
						@v_CoCd
					,	@v_ProcessId
					,	@v_ApplTyp
					,	@v_Div
					,	@v_Dept1
					,	@v_SrNo
					,	@v_EmpCd)
			FETCH NEXT FROM db_cursor_Dept INTO  @v_Dept1 
			END 
			CLOSE db_cursor_Dept  
			DEALLOCATE db_cursor_Dept
		End	
	If(@v_Div<>'0' and @v_Dept<>'0')
		Begin
			Insert into CompanyProcessApprovalDetail
			values(
				@v_CoCd
			,	@v_ProcessId
			,	@v_ApplTyp
			,	@v_Div
			,	@v_Dept
			,	@v_SrNo
			,	@v_EmpCd)
		End
End 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[GetUserBranches_N]
 @UserCd varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select Cd,b.Des Branch,ub.Des UserDes,[Image] from Branch b
	left join(select * from UserBranch where UserCd = @UserCd) ub on ub.Div = b.Cd 
END
 
 
 
 Go 

CREATE OR ALTER       procedure [dbo].[UserBranch_GetRow_N] --  Drop Procedure UserBranch_GetRow 'Youne' ,'100' ,''
	@v_UserCd	Char(5)
,	@v_CoCd		Char(5)
,	@v_Div		Char(5)
As
Begin
select Cd[Div],b.Des Branch,ub.Des UserDes,[Image] from Branch b
	left join(select * from UserBranch where UserCd = @v_UserCd) ub on ub.Div = b.Cd 
End 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[Branch_GetRow_N]
	@v_Cd		varchar(5)=null
,	@v_CoCd		varchar(5)=null
As		-- Drop Procedure [dbo].[Branch_GetRow_N] '','01'
Begin	-- Select * from Branch
	Select
		Cd
	,	[Des]
	,	SDes
	,	[Image]
	,	EntryBy
	,	EntryDt
	,	EditBy
	,	EditDt
	,	BU_Cd
	,	(Select SDes From BusinessUnits Where Cd=BU_Cd)[BU_SDes]
	From
		Branch
	Where
		CoCd = @v_CoCd
	and	(Cd = @v_Cd or @v_Cd = '')
	order by Des 
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpLeaveSalaryTicket_View_Getrow_N]    
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

 
 
 
 Go 

CREATE OR ALTER     procedure [dbo].[EmpTransfers_GetRow_N]
	@v_Srno		Numeric(5,0)
,	@v_EmpCd	Char(10)
,	@v_Usercd		varchar(10)
As			--Drop Procedure [EmpTransfers_GetRow_N] '01','0',''
Begin
	select
		EmpTr.EmpCd
	,	Emp.Fname+' '+Emp.Mname+' '+Emp.Lname[Name]
	,	EmpTr.SrNo
	,	EmpTr.TransferDt
	,	CONVERT(varchar(20),EmpTr.TransferDt,103)[FormatedTransferDt]
	,	(select SDes from Dept where EmpTr.DeptFrom=Dept.Cd)[DeptFrDes]
	,	(select SDes from Dept where EmpTr.DeptTo=Dept.Cd)[DeptToDes]
	,	Emptr.DeptFrom[DeptFrom]
	,	Emptr.DeptTo[DeptTo]
	,	(select SDes from Codes where EmpTr.LocFrom=Codes.Cd)[LocFrDes]
	,	(select SDes from Codes where EmpTr.LocTo=Codes.Cd)[LocToDes]
	,	Emptr.LocFrom[LocFrom]
	,	Emptr.LocTo[LocTo]
	,	(Select SDes From Branch where Emptr.BrFrom=Branch.Cd)[BrFrDes]
	,	(Select SDes From Branch where Emptr.BrTo=Branch.Cd)[BrToDes]
	,	Emptr.BrFrom[BrFrom]
	,	Emptr.BrTo[BrTo]
	,	EmpTr.EntryBy
	,	EmpTr.EntryDt
	,	EmpTr.EditBy
	,	EmpTr.EditDt
	,	(Select CoName From Company where EmpTr.BU_From=Company.Cd)[CompFrDes]
	,	(Select CoName From Company where EmpTr.BU_To=Company.Cd)[CompToDes]
	,	EmpTr.BU_To[CompTo]
	,	EmpTr.Narr[Narration]
	From
		Emptransfers 	EmpTr
	,	Employee	Emp
	where
		Emp.Cd=EmpTr.Empcd
	and	(@v_EmpCd='' or @v_EmpCd<>'' and EmpTr.EmpCd=@v_EmpCd)
	and (@v_Srno='0' or @v_Srno<>'0' and EmpTr.SrNo=@v_Srno)
	and (Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd='')))
	order by TransferDt desc

End

 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyProcessApproval_GetRow_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_ApplTyp			char(10)
,	@v_Div				char(5)
,	@v_Dept				char(10)
,	@v_typ				Char(1)
,	@v_Usercd		varchar(10)
As		-- Drop Procedure [dbo].[CompanyProcessApproval_GetRow_N]'01','0','02','jl','','0'
Begin	
	SELECT 
		(select CoName from Company where Cd=CPA.CoCd)[CoCd]
	,	CoCd[CoCdCd]
	,	(select Caption from MenuCtrl where ProcessId=CPA.ProcessId)[ProcessId]
	,	ProcessId[ProcessIdCd]
	,	(Case when ProcessId='HRPSS2' then (select Des from CompanyLeave where Cd=CPA.ApplTyp)
						when ProcessId='HRPSS1' then (select Des from CompanyLoanTypes where Cd=CPA.ApplTyp)
						when ProcessId='HRPT8' then (select Des from Codes where Typ='HDTYP' and Cd=CPA.ApplTyp)
						when ProcessId='HRPT6' then (select Des from SysCodes where Typ='HREP' and Cd=CPA.ApplTyp)
						when ProcessId='HRPSS3' then (select Des from CompanyLeave where Cd=CPA.ApplTyp)
						when ProcessId='HRPT14' then (select Des from CompanyProvisions where Cd=CPA.ApplTyp) end)[ApplTyp]
	,	ApplTyp[ApplTypCd]
	,	(select Des from Branch where Cd=CPA.Div)[Branch]
	,	Div[BranchCd]
	,	(select Des from Dept where Cd=CPA.Dept)[Dept]
	,	Dept[DeptCd]
	FROM CompanyProcessApproval  as CPA
	WHERE  @v_typ='0'
	 or(@v_typ='1' 
		and CoCd = @v_CoCd 
		and (@v_ProcessId= '0' or ProcessId= @v_ProcessId)
		and (@v_ApplTyp='0' or ApplTyp=@v_ApplTyp )
		and (@v_Div='0' or Div=@v_Div )
		and (@v_Dept='0' or Dept=@v_Dept)
		and CPA.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd='')))
End 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpCalendar_GetRow_N]
@v_EmpCd char(10),
@v_Usercd		varchar(10)
as			
	select SrNo,EmpCd,[Date],Holiday,Title,Narr
	,	Emp.Fname+' '+Emp.Mname+' '+Emp.Lname[EmpName]
	from 
	EmpCalendar_N Ec
	join  Employee	Emp on Ec.EmpCd = Emp.Cd
	where EmpCd=@v_EmpCd or @v_EmpCd = ''
	and Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpEarnDed_View_GetRow_N]
	@v_EmpCd	char(10)
,	@v_EdCd		char(5) 
,	@v_EdTyp	char(10)
,	@v_SrNo		int
,	@v_Typ		char(1)
,	@v_Usercd		varchar(10)
As		-- DROP PROCEDURE [EmpEarnDed_View_GetRow_N] '', '','','0','3'
Begin	-- Select * from EmpEarnDed
	Select
		EED.EmpCd[EmpCd]
--	,	(Select Rtrim(FName)+' '+Rtrim(MName)+' ' +Rtrim(LName) From Employee Where Cd=EmpCd)[Emp]
	,	(Rtrim(E.FName)+' '+Rtrim(E.MName)+' ' +Rtrim(E.LName))[Emp]
	,	(Select SDes From SysCodes Where Cd=EdTyp)[Type]
	,	EdTyp
	,	(Select SDes From CompanyEarnDed Where Cd=EdCd and Typ=EdTyp)[Description]
	,	(Select [Des] From Currency Where Cd=Curr)[Currency]
	,	CAST(Amtval AS DECIMAL(18,2))[Amt]		-- Select * from Currency
	,	PercVal[PercVal]
	,	(select CAST([Basic] AS DECIMAL(18,2)) from employee where Cd=EED.EmpCd)[Basic]
	,	effdate as EffDt  --,	convert(varchar, effdate, 103)[EffDt]
	,	CONVERT(varchar(20),effdate,103)[FormatedEffDt]
	,	enddate as  EndDt --,	convert(varchar, enddate, 103)[EndDt]
	,	CONVERT(varchar(20),enddate,103)[FormatedEndDt]
	,	EdCd[EdCd]
	,	EdTyp[EdTyp]
	,	Curr[CurrCd]
	,	PercAmt[PercAmt]
	,	SrNo
	,	EED.Curr
	From
		EmpEarnDed EED
	,	Employee E
	Where
		--(@v_EmpCd='' or EmpCd = @v_EmpCd) and (@v_EdCd='' or EdCd=@v_EdCd) and (@v_EdTyp='' or EdTyp = @v_EdTyp) and (@v_SrNo='' or SrNo=@v_SrNo)
		
	 (@v_Typ='0' and E.Cd=EED.EmpCd)
	or (EmpCd = @v_EmpCd and EdCd=@v_EdCd and EdTyp=@v_EdTyp and SrNo=@v_SrNo and @v_Typ='1' and E.Cd=EED.EmpCd)
	or (EmpCd = @v_EmpCd and EdCd=@v_EdCd and EdTyp=@v_EdTyp and  @v_Typ='2' and E.Cd=EED.EmpCd)
	or @v_Typ='3' and E.Cd=EED.EmpCd and(@v_EmpCd='' or (EED.EmpCd = @v_EmpCd and @v_EmpCd<>''))
	 and E.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	Order by
		EED.EntryDt desc
	,	EmpCd
	,	EED.EdTyp
	,	EdCd
	,	SrNo
End

--select * from EmpEarnDed
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpBankAc_GetRow_N]      
@v_EmpCd VarChar(50)=null,  
@v_BankCd varchar(10)=null,  
@v_BankBrCd varchar(10)=null,  
@v_SrNo int=null,
@v_Usercd		varchar(10)
  
as      --drop procedure [dbo].[EmpBankAc_GetRow_N]'hr'     
Begin      
  select       
  Emp.Cd[EmpCd]      
 , rtrim(Emp.FName) +' ' +rtrim(Emp.MName) +' ' +rtrim(Emp.LName)[EmployeeName]      
 , EBA.SrNo      
 , EBA.EmpAcName[EmployeeAcName]      
 , (select SDes from Codes where Cd=EBA.Bank) as [Bank]      
 , (select SDes from Codes where Cd=EBA.Branch) as [Branch]      
 , EBA.Typ      
 , EBA.EmpAc      
 , (select Des from Currency where Cd=EBA.CurrCd)[Currency]      
 ,   (select Cd from Currency where Cd=EBA.CurrCd)[CurrCd]      
 , EBA.Amt      
 , (select SDes from Codes where Typ='BKGRP' and Cd=BankGrp)[BankGrp]      
 , (select Cd from Codes where Typ='BKGRP' and Cd=BankGrp)[BankGrpCd]      
 , Bank [BankCd]      
 , Branch [BankBrCd] 
 , RouteCd     
       
 from       
 EmpBankAc EBA left outer join Employee Emp on EBA.EmpCd=Emp.Cd      
 Where ((Emp.FName like @v_EmpCd  or Emp.MName like  @v_EmpCd or Emp.LName like @v_EmpCd or Emp.Cd like @v_EmpCd or @v_EmpCd='')  
	and (Bank=@v_BankCd or @v_BankCd is null)  
    and (Branch=@v_BankBrCd or @v_BankBrCd is null)  
    and (SrNo=@v_SrNo or @v_SrNo is null)  )
	and Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
 order by      
  EBA.EmpCd, EBA.SrNo      
      
End  
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpDocuments_GetRow_N]
	@v_EmpCd		Char(10)
,	@v_DocTyp		Varchar(30)
,	@v_SrNo			numeric(5,0)
,	@v_Typ			Char(1)
,	@v_Usercd		varchar(10)
As	-- Drop Procedure [dbo].[EmpDocuments_GetRow_N]'',''
Begin
	Select
		ED.EmpCd[EmpCd]
	,	Rtrim(Emp.FName) +' ' +Rtrim(Emp.MName) +' ' +Rtrim(Emp.LName)[EmpName]
	,	Cod.SDes[DocTypSDes]
	,	ED.DocNo[DocNo]
	,	ED.OthRefNo[OthRefNo]
	,	ED.IssueDt[IssueDt]
	,	ED.Expiry[Expiry]
	,	ED.ExpDt[ExpDt]
	,	CONVERT(varchar(10), ED.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), ED.ExpDt,103)[FormatedExpDt]
	,	ED.IssuePlace[IssuePlace]
	,	ED.EntryBy[EntryBy]
	,	ED.EntryDt[EntryDt]
	,	CONVERT(varchar(10), ED.EntryDt,103)[FormatedEntryDt]
	,	ED.EditBy[EditBy]
	,	ED.EditDt[EditDt]
	,	CONVERT(varchar(10), ED.EditDt,103)[FormatedEditDt]
	,	Rtrim(ED.EmpCd)+Rtrim(Cod.SDes)[Filter]
	,   DocTyp [DocTypCd] 
	,	SrNo[SrNo] 
	From
		Employee Emp
	,	EmpDocuments ED
	,	Codes Cod
	Where
		Emp.Cd=Ed.EmpCd and Cod.Cd=Ed.DocTyp
	and	((Ed.EmpCd=@v_EmpCd and @v_EmpCd<>'') or @v_EmpCd='')
	and	((Ed.DocTyp=@v_DocTyp and @v_DocTyp<>'') or @v_DocTyp='')
	and ((ED.SrNo=@v_SrNo and @v_SrNo<>0) or (@v_SrNo=0 and ED.SrNo=(select Top 1 SrNo from EmpDocuments where EmpCd=ED.EmpCd and DocTyp=ED.DocTyp order by SrNo desc)))
	and ((@v_Typ='E' and ED.ExpDt<GETDATE()) or (@v_Typ='N' and (ED.ExpDt is null or ED.ExpDt>=GETDATE())) or(@v_Typ='A'))
	and  Emp.Status not in ('HSTATNP','HSTATSR','HSTATST','HSTATES')
	and Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
	Order by
		ED.SrNo desc
End

 
 
 
 Go 

CREATE OR ALTER     procedure [dbo].[EmpDocuments_Update_N]
		@v_EmpCd		Char(10)
	,	@v_DocTyp		VarChar(20)
	,	@v_SrNo			numeric(5,0)
	,	@v_DocNo		Char(20)
	,	@v_OthRefNo		Char(20)=''
	,	@v_IssueDt		Datetime
	,	@v_IssuePlace	VarChar(30)
	,	@v_Expiry		bit
	,	@v_ExpDt		Datetime
	,	@v_EntryBy		Char(5)
	,	@v_Sponsor1		Char(10)=''
	,	@v_Sponsor2		Char(10)=''
	,	@v_Mode			Char(1)
As		-- Drop Procedure [dbo].[EmpDocuments_Update_N]
Begin
	Set NoCount on
	IF (SELECT COUNT(1) FROM EmpDocuments WHERE EmpCd = trim(@v_EmpCd) and DocTyp=trim(@v_DocTyp)) = 0
		Begin
			insert into EmpDocuments(EmpCd,DocTyp,SrNo,DocNo,OthRefNo,IssueDt,IssuePlace,Expiry,ExpDt,EntryBy,EntryDt,Sponsor1,Sponsor2)
			values(
				@v_EmpCd
			,	@v_DocTyp
			,	@v_SrNo
			,	@v_DocNo
			,	@v_OthRefNo
			,	@v_IssueDt
			,	@v_IssuePlace
			,	@v_Expiry
			,	@v_ExpDt
			,	@v_EntryBy
			,	getdate()
			,	@v_Sponsor1
			,	@v_Sponsor2)
			exec GetMessage 1,'Inserted successfully'
		End
	Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
		Begin
				Update EmpDocuments Set
				DocNo=@v_DocNo
			,	IssueDt=@v_IssueDt
			,	IssuePlace=@v_IssuePlace
			,	Expiry=@v_Expiry
			,	ExpDt=@v_ExpDt
			,	EditBy=@v_EntryBy
			,	EditDt=Getdate()
			,	OthRefNo=@v_OthRefNo
			,	Sponsor1=@v_Sponsor1
			,	Sponsor2=@v_Sponsor2
			Where
				EmpCd=@v_EmpCd and DocTyp=@v_DocTyp and SrNo=@v_SrNo
				exec GetMessage 1,'Updated successfully'
		End
End

 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpFund_View_Getrow_N]    
	@v_Empcd	char(10)
 ,  @v_TransNo	Char(10) 
 ,	@v_Typ		Char(1)=''
As  --Drop Procedure [dbo].[EmpFund_View_Getrow_N]  '','',''    
begin    
	if @v_TransNo =''    
		select    
		el.TransNo    
	,	el.TransDt[AppDt]  
	,	CONVERT(varchar(20),el.TransDt,103)[FormatedTransDt]  
	,	el.EmpCd[EmpCd]    
	,	e.FName+' '+e.Mname+' '+e.Lname[Emp]    
	,	el.Amount[Amount]
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
	,	el.Typ[Type]
 
		from    
		EmpFund el   
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
	,	el.Amount[Amount]
		   
	,	(select (FName+' '+isnull(Mname,'')+' '+isnull(Lname,'')) from Employee where Cd=el.ApprBy)  [ApprBy]   
	 
	,	case el.ApprDt    
		when  '01/01/1900' then null    
		else el.ApprDt    
		end[ApprDt]    
	,	case el.ApprDt    
		when  '01/01/1900' then null    
		else CONVERT(varchar(20),el.ApprDt ,103)   
		end[FormatedApprDt] 
	,	(select (select des from branch where cd=E.Div) from employee E where cd=el.Empcd)[Div] 
	,	el.Typ[Type]
   
		from    
		EmpFund el   
	,	Employee e    
		where        
		 e.cd=el.EmpCd    
		and el.TransNo=@v_TransNo    
	-- and el.Typ='M'    
	-- and el.LvStatus not in ('C','R')    
		and (@v_Typ='' and el.Status <> 'N' and el.Status <> 'C' and el.Status <> 'F' and el.Status <> 'R'
		or	@v_Typ='D'  and el.Status = 'F')    
End    

 
 
 
 Go 

CREATE OR ALTER       Procedure [dbo].[EmployeeFund_Update_N]	
	@v_TransNo		char(30)
,	@v_TransDt		datetime
,	@v_EmpCd		char(10)
,	@v_Amount		numeric(9,3)
,	@v_Typ			char(10)
,	@v_EntryBy		Char(5)
As  --DROP PROCEDURE [dbo].[EmployeeFund_Update_N] '00028','09/07/2016','MHM/020   ','3800','1200','Admin'
Begin
	IF (Select COUNT(*) From EmpFund Where TransNo=@v_TransNo) = 0
	  Begin
		insert into EmpFund(TransNo,TransDt,EmpCd,
		Amount,Typ,Status,EntryBy,EntryDt)
		Values(
			  @v_TransNo
		,     @v_TransDt
		,     @v_EmpCd
		,     @v_Amount
		,     @v_Typ
		,     'N'
		,     @v_EntryBy
		,     getdate())
		
		if((select COUNT(*) From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPSS4' 
						and CPAD.Div=(select Div from Employee where Cd=@v_EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=@v_EmpCd)
						and CPAD.CoCd=(select CoCd from Employee where Cd=@v_EmpCd))=0)
		BEGIN
				Update EmpFund Set
				Status='Y'
			,	ApprBy=@v_EntryBy
			,	ApprDt=getdate()
			Where
				TransNo=@v_TransNo
		END
	  End
	Else
	  Begin
		Update EmpFund Set
			TransDt=@v_TransDt
		,	EmpCd=@v_EmpCd
		,	Amount=@v_Amount
		,	Typ=@v_Typ
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		Where
			TransNo=@v_TransNo
	  End
End
 
 
 
 Go 


CREATE OR ALTER     procedure [dbo].[EmpTrans_Update_N]
	@v_EmpCd		Char(10)
,	@v_EdCd			Varchar(30)
,	@v_EdTyp		Varchar(30)         
,	@v_DocRef		Char(10)
,	@v_Curr			Varchar(30)
,	@v_ExRate		Numeric(15,10)
,	@v_Amt			Numeric(15,4)
,	@v_Narr			Varchar(100)
,	@v_EntryBy		Char(5)
,	@v_SrNo			Numeric(5,0)
,	@v_FromDt		datetime
,	@v_ToDt			datetime
,	@v_TrnInd		Char(5)
,	@v_EmpDiv		Char(5)=''
As		-- Drop procedure [dbo].[EmpTrans_Update_N]
Begin
	/*
	Declare @v_EdCd 	Char(5)
	Declare @v_EdTyp 	Char(10)
	Declare @v_Curr		Char(5)
	Declare @v_CoCd		Char(5)
	Declare @v_Div		Char(5)
	Declare @v_LocCd	Char(10)
	Declare @v_Cc		Char(10)
	Declare @v_Dept		Char(10)

	Select 	@v_Curr=Cd from Currency where Des=@v_CurrDes
	Select 	@v_EdTyp=cd from SysCodes where SDes=@v_EdTypDes and Typ='HEDT'
	Select 	@v_EdCd=cd from CompanyEarnDed where SDes=@v_EdCdDes and Typ=@v_EdTyp
	
*/
	Declare @v_CoCd		Char(5)
	Declare @v_Div		Char(5)
	Declare @v_LocCd	Char(10)
	Declare @v_Cc		Char(10)
	Declare @v_Dept		Char(10)
	declare @status     char(1)
	if(@v_TrnInd='*S')
	set @status='I'
	Select 	@v_CoCd=CoCd, @v_LocCd=LocCd, 
		@v_Cc=Cc, @v_Dept=Dept from Employee Where Cd=@v_EmpCd

	if @v_EmpDiv in ('','0','All')
		Select @v_Div=Div from Employee Where Cd=@v_EmpCd
	else
		Set @v_Div=@v_EmpDiv

	IF (SELECT COUNT(*) FROM EmpTrans WHERE EmpCd = @v_EmpCd and EdCd=@v_EdCd and EdTyp=@v_EdTyp and TrnInd='M' and SrNo=@v_SrNo) = 0
--	IF (SELECT COUNT(*) FROM EmpTrans WHERE EmpCd = @v_EmpCd and EdCd=@v_EdCd and EdTyp=@v_EdTyp and TrnInd='M') = 0
	  Begin
		Insert into EmpTrans(EmpCd,EdCd,EdTyp,TrnInd,SrNo,DocRef,Curr,ExRate,Amt,
					CoCd,HRDiv,LocCd,HRCc,HRDept,Narr,EntryBy,EntryDt,FromDt,ToDt,[Status])
		Values(
			@v_EmpCd
		,	@v_EdCd
		,	@v_EdTyp
		,	@v_TrnInd
		,	@v_SrNo
		,	@v_DocRef
		,	@v_Curr
		,	@v_ExRate
		,	@v_Amt
		,	@v_CoCd
		,	@v_Div
		,	@v_LocCd
		,	@v_Cc
		,	@v_Dept
		,	@v_Narr
		,	@v_EntryBy
		,	getdate()
		,	@v_FromDt
		,	@v_ToDt
		,   @status
		)
	  End
	Else
	  Begin
		Update EmpTrans
		Set
			DocRef=@v_DocRef
		,	Curr=@v_Curr
		,	ExRate=@v_ExRate	
		,	Amt=@v_Amt
		,	CoCd=@v_CoCd
		,	HRDiv=@v_Div
		,	LocCd=@v_LocCd
		,	HRCc=@v_Cc
		,	HRDept=@v_Dept
		,	Narr=@v_Narr
		,	EditBy=@v_EntryBy
		,	EditDt=Getdate()
		,	FromDt=@v_FromDt
		,	ToDt=@v_ToDt
		,   [Status]=@status
		Where
			EmpCd = @v_EmpCd
		and EdCd=@v_EdCd
		and EdTyp=@v_EdTyp
		and TrnInd=@v_TrnInd
		and	SrNo=@v_SrNo
	  End
End

 
 
 
 Go 

CREATE OR ALTER     Procedure [dbo].[EmpLoan_GetRow_N]
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
,	@v_EmpCd		Char(10)=null
,	@v_EmpUser		Char(1)=null
As		-- Drop Procedure [dbo].[EmpLoan_GetRow_N] ' ','2','100','',''
Begin
	Set @v_Param = ltrim(rtrim(@v_Param))
	If @v_Typ='3'
		set @v_Param = @v_Param +'%'
	Select
		TransNo
	,	TransDt
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmployeeCode]
	,	rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[EmpName]
	,	(select SDes from Branch where Cd=( Select Div From Employee where Cd=EL.EmpCd))[EmpBranch]
	,	c.Des[LoanType]
	,	EL.DocRef
	,	EL.DocDt
	,	CONVERT(varchar(20),EL.DocDt,103)[FormatedDocDt]
	,	EL.Amt
	,	EL.Purpose
	,	EL.Narr
	,	(select (FName+' '+Mname+' '+Lname) from Employee where Cd=EL.LoanApprBy)  [LoanApprBy]
	,	EL.NoInst
	,   EL.LoanApprDt
	,	CONVERT(varchar(20),EL.LoanApprDt,103)[FormatedLoanApprDt]
	,	Case When LoanStatus='A' then 'Approved'
			When LoanStatus='R' then 'Rejected'
			Else 'Not Approved'
		End[ApplicationStatus]
	,	EL.ApprAmt  
	,	EL.RecoMode   
	,	EL.RecoPrd  
	,	EL.NoInstReq
	,	EL.DedStartDt 
	,	CONVERT(varchar(20),EL.DedStartDt,103)[FormatedDedStartDt] 
	,	EL.Guarantor  
	,	(select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  from Employee where cd=EL.Guarantor)[GuarantorName]
	,	EL.LoanStatus  
	,	EL.PayMode  
	--, (select SDes from SysCodes where cd=EL.PayMode)[Pay Mode]  
	,	EL.ChgsTyp  
	,	EL.ChgsPerc 
	,	EL.EntryDt 	
	,	CONVERT(varchar(20),EL.EntryDt,103)[FormatedEntryDt]	
	,	(select CoName from Company where Cd=@v_CoCd) [CoName]
	,	(select Des from Codes where Typ='HLOC ' and  Cd=( Select LocCd From Employee where Cd=EL.EmpCd))[Loaction]
	,	(select Des from Codes where Typ='ESPON' and Cd=( Select Sponsor From Employee where Cd=EL.EmpCd))[Sponsor]
	
	,	case when @v_Typ in ('2')
		then
		(select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS1' 
			and CPAD.ApplTyp=El.LoanTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval_Level]
	,	case when @v_Typ in ('2')
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS1' 
			and CPAD.ApplTyp=El.LoanTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		
		end[Current_Approval]
		
	, (select SDes from SysCodes where cd=EL.RecoMode)[Reco_Mode] 
	, (select SDes from SysCodes where RTRIM(right(Cd,10-len(ltrim(rtrim(typ)))))=EL.RecoPrd and Typ='HLRI')[Reco_Prd] 
	,	(Select CoName from Company where Cd=@v_CoCd)[CompanyName]
	,	(Select Add1+' '+Add2+' '+Add3 from Company where Cd=@v_CoCd)[CompanyAdress]
	,	(Select Fax from Company where Cd=@v_CoCd)[CompanyFax]
	,	(Select Phone from Company where Cd=@v_CoCd)[CompanyPhone]
	,	(Select Email from Company where Cd=@v_CoCd)[CompanyEmail]
	,	(Select Logo from Company where Cd=@v_CoCd)[CompanyLogo]  
	,	EL.LoanTyp[LoanTypeCd]
	--,	ISNULL((Select SUM(ISNULL(ApprAmt,0)) from EmpLoan where EmpCd=(SELECT Empcd FROM dbo.EmpLoan WHERE TransNo=El.TransNo) AND TransNo<>El.TransNo and LoanStatus='D'),0)
	--	-ISNULL((Select SUM(ISNULL(AmtVal,0)) from EmpLoanDetail where EmpCd=(SELECT Empcd FROM dbo.EmpLoan WHERE TransNo=El.TransNo) AND TransNo<>El.TransNo and Typ='D'),0)[Balance]
	,	ISNULL((Select SUM(ISNULL(ApprAmt,0)) from EmpLoan where EmpCd=(SELECT Empcd FROM dbo.EmpLoan WHERE TransNo=El.TransNo)  and LoanStatus='D'),0)
		-ISNULL((Select SUM(ISNULL(AmtVal,0)) from EmpLoanDetail where EmpCd=(SELECT Empcd FROM dbo.EmpLoan WHERE TransNo=El.TransNo)  and Typ='D'),0)[Balance]
	,	isnull((Select Top 1 SrNo from EmpLoanDetail where TransNo=EL.TransNo order by SrNo desc),0)[DetailSrno]  
	,	EL.GuarantorDetails  
	
	,	case when @v_Typ in ('2')
		then
		(Case when((select SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS1' 
			and CPAD.ApplTyp=EL.LoanTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
			=(select Top 1 SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS1' 
			and CPAD.ApplTyp=EL.LoanTyp
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd order by SrNo Desc))
			then 
				(STUFF((SELECT ', ' + CAST((Select Fname From Employee where Cd=EmpCd) AS VARCHAR(10))+' on '+CAST((select Convert(varchar(10),LoanApprDt,103) from EmploanAppr where Transno=EL.Transno and LoanApprBy=EmpCd) AS VARCHAR(10)) [text()]
				FROM CompanyProcessApprovalDetail as CPAD
				WHERE CPAD.ProcessId='HRPSS1' 
				and CPAD.ApplTyp=EL.LoanTyp
				and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
				and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
				and CPAD.CoCd=@v_CoCd
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '))
			End
		)
		end[Approvals]
	,	case when @v_Typ in ('5')
		then (STUFF((SELECT ', ' + CAST((Select Fname From Employee where Cd=ELA.LoanApprBy) AS VARCHAR(10))+' ('+CAST(Convert(varchar(10),ELA.LoanApprDt,103) AS VARCHAR(10))+')' [text()]
				FROM EmploanAppr as ELA
				WHERE ELA.TransNo=EL.TransNo
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '))End[PrintApproval]
	,	(select des from designation where cd=E.Desg)[Desg]
	From
		-- Before It was Default Join(Inner Join).  Inner Join will results 2 records
		EmpLoan EL left outer join
		CompanyLoanTypes C on EL.LoanTyp=C.Cd
	,	Employee E
	Where
		E.Cd=EL.EmpCd and E.CoCd=@v_CoCd
	--and EL.LoanStatus in ('N') -- Commented by Rasheed
	and	(@v_Typ='0' or
		(@v_Typ='1' and ltrim(str(month(EL.TransDt)))=@v_Param) or
		(@v_Typ='2' and EL.TransNo=@v_Param) or
		(@v_Typ='3' and EL.EmpCd like @v_Param) or
		(@v_Typ='4' and c.SDes=@v_Param) or
		(@v_Typ='5' and EL.TransNo=@v_Param) or
		(@v_Typ='6' and EL.EmpCd = @v_Param and EL.RecoMode<>'HLREC03' and EL.LoanStatus='D')  )
	Order by
		EL.TransNo desc
End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpExperience_GetRow_N]
	@v_EmpCd          Char(10)
,	@v_SrNo		Numeric(5,0)
As	-- Drop procedure [dbo].[EmpExperience_GetRow_N]'SA01',0
Begin	
	Select 
		XP.EmpCd
	,	rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmployeeName]
	,	XP.Srno[Srno]
	,	XP.Coname[CompanyName]
	,	XP.CoRef[CompanyReference]
	,	(Select Sdes from Designation Where Cd=XP.Desg)[Designation]
	,	XP.Desg
	,	CONVERT(varchar(20),XP.StDt,101)[StartingDate]
	,	CONVERT(varchar(20),XP.EndDt,101) [EndingDate]
	,	(Select Des from Country Where Cd=XP.Country)[Country]
	,	XP.Country CountryCd
	,	XP.Narr[Narration]
	from    
		EmpExperience XP
	,	Employee Emp
  	where
		Emp.Cd=XP.EmpCd 
	and	(Emp.Cd= @v_EmpCd or @v_EmpCd = '')
	and	(XP.SrNo= @v_SrNo or @v_SrNo = 0)
	order by
		Emp.FName
	,	xp.Srno
end





 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Bank_Delete_N]
	@v_BankCd		Varchar(10)
,	@v_BranchCd		Varchar(10)
As		-- Drop procedure [dbo].[Bank_Delete_N]
Begin
  IF NOT EXISTS (select 1 from EmpBankAc where Bank=@v_BankCd or Branch= @v_BranchCd)
		BEGIN
			Delete from Bank where Branch = @v_BranchCd  and Bank=@v_BankCd
			exec GetMessage 1,'Deleted successfully'
		END
	ELSE
		exec GetMessage 0,'Can not delete'    
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpLoan_Disburse_GetRow_N]
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
As		-- Drop Procedure [dbo].[EmpLoan_Disburse_GetRow_N]
Begin
	Select
		TransNo
	,	TransDt  
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmployeeCode]  
	,	rtrim(e.FName)+' '+rtrim(e.MName)+' '+rtrim(e.LName)[EmployeeName]  
	,	c.SDes[LoanType]  
	,	EL.DocRef  
	,	EL.DocDt  
	,	CONVERT(varchar(20),EL.DocDt ,103)[FormatedDocDt]
	,	EL.Amt  
	,	EL.Purpose  
	,	EL.Narr  
	,	EL.LoanApprBy  
	,	(select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  from Employee where cd=EL.LoanApprBy)[ApproverName]  
	,	EL.LoanApprDt 
	,	CONVERT(varchar(20),EL.LoanApprDt ,103)[FormatedLoanApprDt] 
	,	EL.ApprAmt  
	,	EL.RecoMode   
	--, (select SDes from SysCodes where cd=EL.RecoMode)[Reco Mode]  
	,	EL.RecoPrd  
	--, (select SDes from SysCodes where RTRIM(right(Cd,10-len(ltrim(rtrim(typ)))))=EL.RecoPrd and Typ='HLRI')[Reco Prd]  
	,	EL.NoInst  
	,	EL.DedStartDt 
	,	CONVERT(varchar(20),EL.DedStartDt ,103)[FormatedDedStartDt] 
	,	EL.Guarantor  
	,	(select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  from Employee where cd=EL.Guarantor)[GuarantorName]  
	,	EL.LoanStatus  
	,	EL.PayMode  
	--, (select SDes from SysCodes where cd=EL.PayMode)[Pay Mode]  
	,	EL.ChgsTyp  
	,	EL.ChgsPerc
	,	(select (select des from branch where cd=E.Div) from employee E where cd=el.Empcd)[Div]  
	From
		EmpLoan EL Left Outer Join CompanyLoanTypes C on EL.LoanTyp=C.Cd --Modified by Rasheed
	,	Employee E
 Where
	-- C.Cd=EL.LoanTyp --commented by Rasheed
	--and EL.LoanStatus in ('A','D','C')
		E.CoCd=@v_CoCd and E.Cd=EL.EmpCd and Isnull(EL.LoanApprBy,'') <> '' and EL.LoanStatus in ('A')
	and (@v_Typ='0' or
		@v_Typ='1' and ltrim(str(month(EL.TransDt)))=@v_Param or  
		@v_Typ='2' and EL.TransNo=@v_Param or  
		@v_Typ='3' and EL.EmpCd like @v_Param or  
		@v_Typ='4' and c.SDes=@v_Param)  
	Order by
		TransNo Desc  
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyLeave_Update_N]
	@v_Cd				char(5)
,	@v_SDes				varchar(20)
,	@v_Des				varchar(30)
,	@v_ApprLvl			int--	numeric(1)
,	@v_LvMax 			numeric(5,2)
,	@v_Accrued 			char(1)
,	@v_Encash			char(1)
,	@v_EncashMinLmt 	numeric(5,2)
,	@v_EntryBy 			char(5)
,	@v_PayFact			numeric(5,2)
,	@v_AccrLmt			numeric(5,2)
,	@v_Service			Char(1)
,	@v_CoCd				Char(5)
,	@v_Mode				Char(1)
,	@v_Active				Char(1)
As		-- Drop procedure CompanyLeave_Update_N
Begin	-- Select * from CompanyLeave
	if (Select count(*) from CompanyLeave where rtrim(Cd)=rtrim(@v_Cd))=0
	  Begin
		insert into CompanyLeave(Cd,SDes,Des,ApprLvl,EntryBy,EntryDt,Active) values(
		@v_Cd,
		@v_SDes,
		@v_Des,
		@v_ApprLvl,
		@v_EntryBy,
		Getdate(),
		@v_Active)
		exec GetMessage 1,'Inserted successfully'
	  End
	  Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	  Begin
		Update CompanyLeave Set
			SDes	=@v_SDes,
			Des		=@v_Des,
			ApprLvl	=@v_ApprLvl,
			EditBy	=@v_EntryBy,
			EditDt	=getdate(),
			Active	=@v_Active
		Where
			rtrim(Cd)=rtrim(@v_Cd)
			exec GetMessage 1,'Updated successfully'
	  End
	if (select count(*) from CompanyLeaveDetail where LvCd=@v_Cd and CoCd=@v_CoCd)=0
	  Begin
		Insert into CompanyLeaveDetail(CoCd,LvCd,LvMax,Accrued,EnCash,EncashMinLmt,PayFact,AccrLmt,ServicePrd)
		(select Cd,@v_Cd,@v_LvMax,@v_Accrued,@v_Encash,@v_EncashMinLmt,@v_PayFact,@v_AccrLmt,@v_Service from Company)
		exec GetMessage 1,'Inserted successfully'
	  End
	  Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	  Begin
		Update CompanyLeaveDetail Set
			LvMax			=@v_LvMax,
			Accrued			=@v_Accrued,
			Encash			=@v_Encash,
			EncashMinlmt	=@v_EncashMinlmt,
			PayFact			=@v_PayFact,
			AccrLmt			=@v_AccrLmt,
			ServicePrd		=@v_Service
		Where
			LvCd=@v_Cd and CoCd=@v_CoCd
			exec GetMessage 1,'Updated successfully'
	   End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyLeave_GetRow_N]
	@v_CoCd			Char(5)
,	@v_Cd			Char(5)
As		-- Drop Procedure [dbo].[CompanyLeave_GetRow_N]'100',''
Begin	
	Select
		CL.Cd	
	,	CL.SDes
	,	CL.Des
	,	CL.ApprLvl
	,	CL.EntryBy
	,	CL.EntryDt
	,	CL.EditBy
	,	CL.EditDt
	,	CLD.CoCd
	,	CLD.LvCd
	,	isnull(CLD.LvMax,0)[LvMax]
	,	isnull(CLD.Accrued,0)[Accrued]
	,	isnull(CLD.EnCash,0)[EnCash]
	,	isnull(CLD.EnCashMinLmt,0)[EnCashMinLmt]
	,	isnull(CLD.PayFact,0)[PayFact]
	,	isnull(CLD.AccrLmt,0)[AccrLmt]
	,	isnull(CLD.ServicePrd,0)[ServicePrd]
	,	Active
	From
		CompanyLeave CL LEFT JOIN CompanyLeaveDetail CLD on Cd=LvCd and CoCd='01' 
	Where
		(@v_Cd = '' or Cd=@v_Cd)
	Order by 
		CL.Cd
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyCalendar_Update_N]
@v_CoCd 	varchar(5),
@v_Cd 		varchar(5),
@v_Title 	    varchar(100),
@v_date 	datetime,
@v_Holiday 	bit,
@v_Invite 	bit,
@v_EmailSubject varchar(100),
@v_MessageBody 	varchar(500),
@v_Mode	char(1),
@v_EntryBy varchar(5)
as
	if (select count(*) from CompanyCalendar_N where Cd = @v_Cd and CoCd=@v_CoCd)=0
	Begin
		insert into CompanyCalendar_N(Cd,[Date],[Title],Holiday,Invite,EmailSubject,MessageBody,CoCd,EntryBy,EntryDt) Values(
			@v_Cd
		,	@v_date
		,	@v_Title
		,	@v_Holiday
		,	@v_Invite
		,	@v_EmailSubject
		,	@v_MessageBody
		,	@v_CoCd
		,	@v_EntryBy
		,	GETDATE())
		exec GetMessage 1,'Inserted successfully'
		End
	Else IF (@v_Mode = 'I')
	exec GetMessage 0,'Already exists'
	else
		Update CompanyCalendar_N set
			Holiday=@v_Holiday,
			[Date]=@v_date,
			[Title]=@v_Title,
			EmailSubject=@v_EmailSubject,
			MessageBody=@v_MessageBody,
			CoCd=@v_CoCd,
			EditBy= @v_EntryBy,
			EditDt=GETDATE()
		where 
			Cd =@v_Cd
		and 	CoCd=@v_CoCd
		exec GetMessage 1,'Updated successfully'
 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[CompanyCalendar_Delete_N] 
	-- Add the parameters for the stored procedure here
	@v_Cd varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (select 1 from CalendarEventAttendees where EventCd=@v_Cd)
		BEGIN
			Delete from CompanyCalendar_N where Cd = @v_Cd
		exec GetMessage 1,'Deleted successfully'
		END
	ELSE
		exec GetMessage 0,'Can not delete'
		
	End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpQualification_GetRow_N]
	@v_EmpCd	Char(10)
,	@v_CoCd		Char(5)
,	@v_SrNo		Numeric(5,0)
As		-- DROP PROCEDURE [dbo].[EmpQualification_GetRow_N]'SA01','01',0
Begin	
	Select
		EQ.EmpCd
	,	rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmployeeName]
	,	EQ.Srno[SrNo]
	,	(Select Sdes from Codes where Cd=EQ.QualCd and typ='HQUAL')[Qualification]
	,	EQ.QualCd
	,	EQ.Univ[University]
	,	EQ.Country CountryCd
	,	(Select Des from Country where Cd=EQ.Country)[Country]
	,	EQ.PassYear[PassingYear]
	,	EQ.Marksgrade[MarksGrade]
	,	EQ.EntryBy
	,	EQ.EntryDt
	,	EQ.EditBy
	,	EQ.EditDt
	From
		EmpQualification EQ
	,	Employee Emp
  	Where
		Emp.Cd=EQ.EmpCd
	and	Emp.CoCd=@v_CoCd
	and	(@v_EmpCd='' OR  Eq.EmpCd=@v_EmpCd)
	and	(@v_SrNo=0 OR  EQ.SrNo=@v_SrNo)
	ORDER BY
		EQ.Srno
end


 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpLeaveAppr_Update_N]
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
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyProcessApproval_Detail_GetRow_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_ApplTyp			char(10)
,	@v_Div				char(5)
,	@v_Dept				char(10)
As		-- Drop Procedure [dbo].[CompanyProcessApproval_Detail_GetRow_N]'01','HRPSS2','001','002'
Begin	
	SELECT 
		(select Fname+' '+ISNULL(Lname,'')+' '+Mname from Employee where Cd=CPAD.EmpCd)[EmpName]
	,	EmpCd[EmpCd] 
	FROM CompanyProcessApprovalDetail as CPAD
	where 
		CoCd = @v_CoCd 
		and ProcessId=@v_ProcessId 
		and ApplTyp=@v_ApplTyp 
		and Div=@v_Div 
		and Dept=@v_Dept
End


 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpLeaveSalary_Update_N]	
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
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Codes_Update_N]
	@v_Cd			Char(10)
,	@v_Typ			Char(5)
,	@v_Abbr			Char(5)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(200)
,	@v_EntryBy		Char(5)
,   @v_Mode			Char(1) =null
,	@v_Active		bit
As		-- Drop Procedure dbo.[Codes_Update_N]  -- SP_HELP CODES
Begin
	--declare @NewCd  varchar(10)
	--set @NewCd = exec [Codes_Auto_GetRow] @v_Typ
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Codes WHERE Cd = @v_Cd)
	  Begin
		insert into Codes values(
			@v_Cd
		,	@v_Typ
		,	@v_Abbr
		,	@v_SDes
		,	@v_Des
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		,	@v_Active)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else 
		IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	  Else
		Begin
			Update Codes
				Set
				Typ= @v_Typ
			,	Abbr=@v_Abbr
			,	SDes=@v_SDes
			,	Des=@v_Des
			,	Active=@v_Active
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			Where
				Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
		End
End
 
 
 
 Go 

CREATE OR ALTER     procedure [dbo].[EmpLeave_Update_N]	-- Drop Procedure [dbo].[EmpLeave_Update_N]
	@v_TransNo		char(30)
,	@v_TransDt		datetime
,	@v_EmpCd		char(10)
,	@v_LvTyp		varchar(30)         
,	@v_FromDt		datetime
,	@v_ToDt			datetime
,	@v_LvTaken		char(5)
,	@v_DocRef		char(10)
,	@v_DocDt		datetime --varchar(10)
,	@v_Substitute	char(10)
,	@v_Reason		varchar(50)
,	@v_Narr			varchar(200)
,	@v_EntryBy		Char(5)
,	@v_LvInter		Char(1)

,	@V_LvStatus		Char(1)=null
,	@v_LvApprDays	numeric(5)=null
,	@v_LvApprBy		char(10)=null
,	@v_LvApprDt		datetime=null
,	@v_WP_FromDt	datetime=null
,	@v_WP_ToDt		datetime=null
,	@v_WOP_FromDt	datetime=null
,	@v_WOP_ToDt		datetime=null
As
Begin
	--Declare @v_LvTyp Char(10)
	DEclare @v_Lv_Max numeric(18,4)
	select LvMax from CompanyLeaveDetail where LvCd=@v_LvTyp
	--Select 	@v_LvTyp=cd From CompanyLeave Where SDes=@v_LvTypDes 
	IF (Select COUNT(*) From EmpLeave Where TransNo=@v_TransNo) = 0
	  Begin	
		insert into EmpLeave(TransNo,TransDt,EmpCd,LvTyp,FromDt,ToDt,LvTaken,
					DocRef,DocDt,Substitute,Reason,Narr,EntryBy,EntryDt,LvInter,LvStatus)
		Values(
			  @v_TransNo
		,     @v_TransDt
		,     @v_EmpCd
		,     @v_LvTyp
		,     @v_FromDt
		,     @v_ToDt
		,     @v_LvTaken
		,     @v_DocRef
		,     @v_DocDt
		,     @v_SubStitute
		,     @v_Reason
		,     @v_Narr
		,     @v_EntryBy
		,     getdate()
		,     @v_LvInter
		,     'N')
		 exec GetMessage 1,'Inserted successfully'
	  End
	 
	Else
	  Begin
		Update EmpLeave Set
			TransDt=@v_TransDt
		,	EmpCd=@v_EmpCd
		,	LvTyp=@v_LvTyp
		,	FromDt=@v_FromDt
		,	ToDt=@v_ToDt
		,	LvTaken=@v_LvTaken
		,	DocRef=@v_DocRef
		,	DocDt=@v_DocDt
		,	Substitute=@v_Substitute
		,	Reason=@v_Reason
		,	Narr=@v_Narr
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		,	LvInter=@v_LvInter
		Where
			TransNo=@v_TransNo
		exec GetMessage 1,'Updated successfully'
	  End
End
 
 
 
 Go 

CREATE OR ALTER     Procedure [dbo].[EmpLeave_GetRow_N]  
@v_Param varchar(30),  
@v_Typ  char(1),  
@v_CoCd  Char(5)  ,
 @v_UserCd		char(10)='001'
as  --Drop Procedure [dbo].[EmpLeave_GetRow_N]'90','4','100'  
 select  
  TransNo[TransNo]  
 , TransDt[TransDt]  
 , el.EmpCd[EmployeeCode]  
 , rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[EmployeeName]  
 , c.SDes[LeaveType]  
 , el.FromDt
 , CONVERT(varchar(10), el.FromDt,103) [FormatedFromDt] 
 , el.ToDt  
 , CONVERT(varchar(10), el.ToDt,103) [FormatedToDt] 
 , el.LvTaken   
 , el.DocRef  
 , Case el.DocDt  
   When '01/01/1900' Then ''  
   Else el.DocDt  
  end[docDt]  
 , el.SubStitute[SubtituteCode]  
 , (select  
   rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  
  from  
   Employee Emp  
  where  
   Emp.cd=el.SubStitute  
  )[SubstituteName]  
 , el.Reason  
 , el.Narr  
 , el.LvApprBy  
 , case el.LvStatus  
   when 'Y' then 'Yes'  
   else 'No'  
  end[LvStatus]  
 , el.LvInter [LeaveType]  
 , Typ  
 , DATEDIFF(dd,el.FromDt,GETDATE())[Joiningdays]
 , DATEDIFF(dd,el.ToDt,GETDATE())[Returningdays]
 from  
  EmpLeave el  
 , CompanyLeave  c  
 , Employee e  
 where  
  C.cd=el.LvTyp  
 and e.cd=el.EmpCd  
 and (el.JoinDt is null or Typ='S')  
 and e.CoCd =@v_CoCd  
 and (
  (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='1' and TransNo=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='2' and el.empcd=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='3' and el.FromDt between convert (date,getdate()) and  convert (date,DATEADD(DD,cast(@v_Param as int),getdate())) and el.LvStatus='Y') or
  (@v_Typ='4' and el.ToDt between convert (date,getdate()) and convert (date,DATEADD(DD,cast(@v_Param as int),getdate())) and el.LvStatus='F')
  ) 
 and  (el.HrDiv in (select div from UserBranch where UserCd=@v_UserCd or @v_UserCd='001'))
 --order by 
 
 order by case when @v_Typ='3' then el.FromDt 
			   when @v_Typ='4' then el.ToDt 
			   else TransNo end
  
 -- TransNo  
  
   
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpLoan_Update_N]
	@v_TransNo				char(30)
,	@v_TransDt				datetime
,	@v_EmpCd				char(10)
,	@v_LoanTyp				varchar(30)
,	@v_DocRef				char(10)
,	@v_DocDt				varchar(10)
,	@v_Amt					numeric(15,4)
,	@v_Purpose				varchar(50)
,	@v_Narr					varchar(200)
,	@v_EntryBy				Char(5)
,	@v_NoInstReq			int 
,	@v_Guarantor			char(10)=null
,	@v_GuarantorDetails		varchar(100)=null--Modified  by Rasheed on 11/12/2013
As		-- Drop Procedure [dbo].[EmpLoan_Update_N]
Begin	-- Select * from EmpLoan
	--declare @v_LoanTyp Char(5)
	--Select  @v_LoanTyp=Cd From CompanyLoanTypes Where SDes=@v_LoanTypDes
	IF (Select Count(*) From EmpLoan Where TransNo=@v_TransNo) = 0
	  Begin
		insert into EmpLoan(TransNo,TransDt,EmpCd,LoanTyp,DocRef,DocDt,Amt,
					Purpose,Narr,EntryBy,EntryDt,LoanStatus,NoInstReq,Guarantor,GuarantorDetails)
		Values(
			@v_TransNo    
		,	@v_TransDt    
		,	@v_EmpCd    
		,	@v_LoanTyp    
		,	@v_DocRef    
		,	@v_DocDt    
		,	@v_Amt    
		,	@v_Purpose    
		,	@v_Narr    
		,	@v_EntryBy    
		,	getdate()    
		,	'N'    
		,	@v_NoInstReq
		,	@v_Guarantor
		,	@v_GuarantorDetails)
		exec GetMessage 1,'Loan Request Sent Successfully'
	  End
	Else
	  Begin
		Update EmpLoan Set
			TransDt=@v_TransDt
		,	EmpCd=@v_EmpCd
		,	LoanTyp=@v_LoanTyp
		,	DocRef=@v_DocRef
		,	DocDt=@v_DocDt
		,	Amt=@v_Amt
		,	Purpose=@v_Purpose
		,	Narr=@v_Narr
		,	EditBy=@v_EntryBy
		,	EditDt=getDate()
		,	NoInstReq=@v_NoInstReq
		,	Guarantor=@v_Guarantor
		,	GuarantorDetails=@v_GuarantorDetails
		Where
			TransNo=@v_TransNo
			exec GetMessage 1,'Updated successfully'
	  End
End 
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpCalendar_Delete_N]
@v_srNo	int
As
Delete from 
	empcalendar_N 
where srNo= @v_srNo	
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpAddress_Update_N]  
  @v_EmpCd  Char(10)  
 , @v_AddTyp  VarChar(20)  
 , @v_Contact  VarChar(30)  
 , @v_Add1  VarChar(200)  
 , @v_Add2  VarChar(40)  
 , @v_Add3  VarChar(40)  
 , @v_City  VarChar(30)  
 , @v_Country VarChar(20)
 , @v_Phone  Char(20)  
 , @v_Mobile  Char(20)  
 , @v_Fax  Char(20)  
 , @v_Email  VarChar(40)  
 , @v_EntryBy  Char(5) 
 ,@v_Mode Char(1)
as  
begin  
   
set nocount on  
Declare @err int  
IF (SELECT COUNT(*) FROM EmpAddress WHERE EmpCd =@v_EmpCd and AddTyp=@v_AddTyp) = 0  
 Begin  
 insert into EmpAddress  
 values  
 (  
          @v_EmpCd  
 ,     @v_AddTyp  
 ,     @v_Contact  
 ,     @v_Add1  
 ,     @v_Add2  
 ,     @v_Add3  
 ,     @v_City  
 ,     @v_Country
 ,     @v_Phone  
 ,     @v_Mobile  
 ,     @v_Fax  
 ,     @v_Email  
 ,     @v_EntryBy  
 ,     getdate()  
 ,     null  
 ,     null  
        )  
		exec GetMessage 1,'Inserted successfully'
end  
Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
else
    Begin  
        Update EmpAddress  
          Set  
              Contact=@v_Contact  
 ,            Add1=@v_Add1  
 ,            Add2=@v_Add2  
 ,            Add3=@v_Add3  
 ,            City=@v_City  
 ,            Country=@v_Country  
 ,            Phone=@v_Phone  
 ,            Mobile=@v_Mobile  
 ,            Fax=@v_Fax  
 ,            Email=@v_Email  
 ,            EditBy=@v_EntryBy  
 ,            EditDt=getdate()  
        where        EmpCd=@v_EmpCd and AddTyp=@v_AddTyp  
		exec GetMessage 1,'Updated successfully'
    End  
Select @err = @@error  
 If @err != 0   
  GoTo errorHandler  
  Return  
errorHandler:  
 Return 1  
End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpAddress_GetRow_N]
@v_EmpCd Char(10)
As
Begin
	if @v_EmpCd = ''
		select 
			Ed.EmpCd[EmployeeCode]
		,	rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmployeeName]
		,	Cod.SDes[Address_Type]
		,	Ed.AddTyp
		,	ED.Contact[Contact]
		,	ED.Add1[AddressLine1]
		,	ED.Add2[AddressLine2]
		,	ED.Add3[AddressLine3]
		,	City[City]
		,	Cntry.SDes[Country]
		,	ED.Country[CountryCd]
		,	ED.Phone[Phone]
		,	ED.Mobile[Mobile]
		,	ED.Fax[Fax]
		,	ED.Email[Email]
		,	ED.EntryBy[EntryBy]
		,	ED.EntryDt[EntryDate]
		,	ED.EditBy[EditedBy]
		,	ED.EditDt[EditDate]	
		from 
			Employee Emp
		,	EmpAddress ED
		,	Codes   Cod
		,	Country    Cntry
		where 
			Emp.Cd=Ed.EmpCd
		and	Cod.Cd=Ed.AddTyp
		and	Cntry.Cd=Ed.Country 	
		order by 
			ED.EmpCd
	else 
		select 
			Ed.EmpCd[EmployeeCode]
		,	rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmployeeName]
		,	Cod.SDes[Address_Type]
		,	Ed.AddTyp
		,	ED.Contact[Contact]
		,	ED.Add1[AddressLine1]
		,	ED.Add2[AddressLine2]
		,	ED.Add3[AddressLine3]
		,	City[City]
		,	Cntry.SDes[Country]
		,	ED.Country[CountryCd]
		,	ED.Phone[Phone]
		,	ED.Mobile[Mobile]
		,	ED.Fax[Fax]
		,	ED.Email[Email]
		,	ED.EntryBy[EntryBy]
		,	ED.EntryDt[EntryDate]
		,	ED.EditBy[EditedBy]
		,	ED.EditDt[EditDate]	
		from 
			Employee Emp
		,	EmpAddress ED
		,	Codes   Cod
		,	Country    Cntry
		where 
			Emp.Cd=Ed.EmpCd
		and	Cod.Cd=Ed.AddTyp
		and	Cntry.Cd=Ed.Country 	
		and 	ED.EmpCd=@v_EmpCd
		order by 
			ED.EmpCd
end
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpAddress_Delete_N]
	@v_EmpCd       	Char(10),
	@v_AddTyp	VarChar(20)
As
Begin
	Delete from EmpAddress where EmpCd = @v_EmpCd  and AddTyp=@v_AddTyp 
End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpBankAc_Update_N]  
  @v_EmpCd Char(10)  
 , @v_Bank VarChar(20)  
 , @v_Br Varchar(20)  
 , @v_SrNo numeric(5,2)  
 , @v_AcName Varchar(50)  
 , @v_EmpAc Varchar(30)  
 , @v_Typ Char(10)  
 , @v_Curr Varchar(30)  
 , @v_Amt numeric(15,4)  
 , @v_BkGrp Varchar(20) 
 , @v_RouteCd varchar(100)  
 , @v_EntryBy Char(5)  
as  --drop procedure [dbo].[EmpBankAc_Update_N]  
 --declare @v_Bank Char(10)  
 --declare @v_Br Char(10)  
 --declare @v_Curr Char(5)  
 --declare  @v_BkGrp Char(10)  
 --select  @v_Bank=Cd from Codes  where Typ='BANK' and SDes=@v_BankSDes  
 --select @v_Br=Cd from Codes where Typ='BNKBR' and SDes=@v_BrDes  
 --select @v_Curr=Cd from Currency where Des=@v_CurrDes  
 --select  @v_BkGrp=Cd from Codes where SDes=@v_BkGrDes and Typ='BKGRP'  
  
IF (SELECT COUNT(*) FROM EmpBankAc WHERE EmpCd = @v_EmpCd and Bank=@v_Bank and Branch=@v_Br and SrNo=@v_SrNo) = 0  
 begin  
 set @v_SrNo=(select ISNULL(MAX(SrNo),0)+1 from EmpBankAc where EmpCd=@v_EmpCd and Bank=@v_Bank and Branch=@v_Br)  
 insert into EmpBankAc(EmpCd,Bank,Branch,SrNo,EmpAc,EmpAcName,Typ,CurrCd,Amt,BankGrp,routecd, EntryBy,EntryDt)  
 values  
 (  
          @v_EmpCd  
 ,     @v_Bank  
 ,     @v_Br  
 ,     @v_SrNo   
 ,     @v_EmpAc  
 ,     @v_AcName  
 ,     @v_Typ  
 ,     @v_Curr  
 ,     @v_Amt  
 ,     @v_BkGrp 
 ,	   @v_RouteCd 
 ,     @v_EntryBy  
 ,     getdate() )  
 exec GetMessage 1,'Inserted successfully'
 end  
Else  
Begin  
        Update EmpBankAc  
          Set  
         EmpAc=@v_EmpAc  
 ,       EmpAcName=@v_AcName  
 ,       Typ=@v_Typ  
 ,       Amt=@v_Amt  
 ,       BankGrp=@v_BkGrp  
 ,       CurrCd=@v_Curr  
 ,		 routecd=@v_RouteCd
 ,       EditBy=@v_EntryBy  
 ,       EditDt=getdate()  
        where           
  EmpCd = @v_EmpCd   
 and  Bank=@v_Bank   
 and  Branch=@v_Br  
 and SrNo=@v_SrNo  
 exec GetMessage 1,'Updated successfully'
END
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpEarnDed_Update_N]
		@v_EmpCd		char(10)
	--,	@v_EdCdDes		varchar(30)
	--,	@v_EdTypDes		varchar(30)
	,	@v_EdCd			Char(5)
	--,   @v_CoCd		Char(5)
	,   @v_EdTyp		Char(10)   
	,	@v_SrNo			numeric(5)   
	,	@v_PercAmt		Char(1)
	--,	@v_CurrDes		Varchar(30)
	,	@v_Curr Char(5)
	,	@v_PercVal		Numeric(6,2)
	,	@v_AmtVal		numeric(15,4)
	,	@v_EffDate		datetime
	,	@v_EndDate		datetime
	,	@v_EntryBy		Char(5)
As		 -- Drop Procedure EmpEarnDed_Update_N
Begin
	--declare @v_EdCd Char(5)
	--declare @v_CoCd Char(5)
	--declare @v_EdTyp Char(10)
	--declare @v_Curr Char(5)
	--select @v_CoCd=CoCd from Employee where Cd=@v_EmpCd
	--if @v_PercAmt='P' 
	--	select @v_Curr=CurrCd from Employee where Cd=@v_EmpCd
	--else
	--	select @v_Curr=Cd from Currency where Des=@v_CurrDes

	--select 	@v_EdTyp=cd from SysCodes where SDes=@v_EdTypDes and Typ='HEDT'
	--select @v_EdCd=cd from CompanyEarnDed where SDes=@v_EdCdDes and Typ=@v_EdTyp  
IF (SELECT COUNT(*) FROM EmpEarnDed WHERE EmpCd = @v_EmpCd and EdCd=@v_EdCd and EdTyp=@v_EdTyp and SrNo=@v_SrNo) = 0
	Begin
	insert into EmpEarnDed(EmpCd,EdCd,EdTyp,SrNo,PercAmt,Curr,PercVal,AmtVal,EffDate,EndDate,EntryBy,EntryDt)
	values
	(
          @v_EmpCd
	,     @v_EdCd
	,     @v_EdTyp
	,     @v_SrNo	
	,     @v_PercAmt
	,     @v_Curr
	,     @v_PercVal
	,     @v_AmtVal
	,     @v_EffDate
	,     @v_EndDate
	,     @v_EntryBy
	,     getdate()        )
	exec GetMessage 1,'Inserted successfully'
end
Else
    Begin
        Update EmpEarnDed
          Set

	             	PercAmt=@v_PercAmt
	,            	PercVal=@v_PercVal
	,	Curr	=@v_Curr
	,	AmtVal=@v_AmtVal
	,            	EditBy=@v_EntryBy
	,            	EditDt=getdate()
	,	EffDate=@v_EffDate
	,	EndDate=@v_EndDate
          where 	
		EmpCd = @v_EmpCd 
	and 	EdCd=@v_EdCd 
	and 	EdTyp=@v_EdTyp 
	and 	SrNo=@v_SrNo
	exec GetMessage 1,'Updated successfully'
    End

End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpEarnDed_GetRow_N]
@v_EmpCd char(10)
as
	if @v_EmpCd=''
		select 
			en.EmpCd[EmployeeCode]
		,	rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[EmpName]
		,	sys.SDes[Type]
		,	cen.SDes[Description]
		,	C.Des
		,   en.AmtVal
		,   MAX(en.EffDate)
		from	
			EmpEarnDed en
		,	SysCodes sys
		,	Employee E
		,	Currency C
		,	CompanyEarnDed cen
		group by
			en.EmpCd
		,	E.FName
		,	E.MName
		,	E.LName
		,	Sys.Cd
		,	sys.sdes
		,	cen.sdes
		,	e.cd
		,	sys.typ
		,	en.edtyp
		,	cen.cd
		,	en.edcd
		,	cen.typ
		,	C.Cd
		,	en.Curr
		,	c.Des
		,   en.AmtVal
		,   en.EffDate
		
		
		
		having
			E.cd=en.EmpCd
		and	sys.cd=en.EdTyp
		and 	sys.Typ='HEDT'
		and 	cen.cd=en.EdCd
		and 	cen.Typ=en.EdTyp
		and	en.Curr=C.Cd
		
		
		order by 
--			sys.SDes
			en.EmpCd
	else
select 
			en.EmpCd[Employee Code]
		,	rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[EmpName]
		,	sys.SDes[Type]
		,	cen.SDes[Description]
		,	C.Des
		,   en.AmtVal
		,   MAX(en.EffDate)
		from	
			EmpEarnDed en
		,	SysCodes sys
		,	Employee E
		,	Currency C
		,	CompanyEarnDed cen
		group by
			en.EmpCd
		,	E.FName
		,	E.MName
		,	E.LName
		,	Sys.Cd
		,	sys.sdes
		,	cen.sdes
		,	e.cd
		,	sys.typ
		,	en.edtyp
		,	cen.cd
		,	en.edcd
		,	cen.typ
		,	C.Cd
		,	en.Curr
		,	c.Des
		,   en.AmtVal
		,   en.EffDate
		having
			E.cd=en.EmpCd
		and	sys.cd=en.EdTyp
		and 	sys.Typ='HEDT'
		and 	cen.cd=en.EdCd
		and 	cen.Typ=en.EdTyp
		and	en.Curr=C.Cd
		and	en.EmpCd=@v_EmpCd
		
		order by 
--			sys.SDes
			en.EmpCd
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpDocImages_Delete_N]
	@v_EmpCd		Char(10)
,	@v_DocTyp		Char(20)
,   @v_srNo			int
As		-- Drop Procedure [dbo].[EmpDocImages_Delete_N]
Begin
	--Declare @v_DocTyp Char(10)
	--Select @v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes 
	Delete from EmpDocImages where EmpCd = @v_EmpCd and DocTyp=@v_DocTyp and SlNo = @v_srNo
	exec GetMessage 1,'Deleted successfully'
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpDocImages_GetRow_N]
	@v_EmpCd		Char(10)
,	@v_DocTyp		Varchar(10)=null   
As		-- Drop Procedure [dbo].[EmpDocImages_GetRow_N]
Begin
	Select
		EDI.EmpCd[EmployeeCode]    
	,	rtrim(Emp.FName)+' '+rtrim(Emp.MName)+' '+rtrim(Emp.LName)[EmployeeName]    
	,	EDI.DocTyp[DocumentTypeCd]       
	,	(Select SDes From Codes Where Cd=EDI.DocTyp)[DocumentType]    
	,	EDI.ImageFile[ImageFile]    
	,	EDI.EntryBy[EntryBy]
	,	EDI.EntryDt[EntryDate]
	,	EDI.EditBy[EditedBy]
	,	EDI.EditDt[EditDate]
	,	EDI.SlNo
	,	replace((select ltrim(rtrim(SDes)) from Codes where Codes.Cd=EDI.DocTyp),' ','_') [DocTypSDes_New]	
	From
		Employee Emp    
	,	EmpDocImages EDI    
	Where
		Emp.Cd=EDI.EmpCd
	and (EDI.EmpCd=@v_EmpCd or @v_EmpCd = '')	-- Modified by Rasheed
	and (DocTyp = @v_DocTyp or DocTyp=null)		-- Modified by PK
	Order By
		EDI.EmpCd    
	,	SlNo    
End
  
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpExperience_Update_N]	
	@v_EmpCd	char(10)
,	@v_SrNo		char(5)
,	@v_Stdt		datetime
,	@v_Enddt	datetime
,	@v_Desg		char(10)
,	@v_Coname	varchar(40)
,	@v_Country	char(5)
,	@v_Coref	varchar(50)
,	@v_Narr		varchar(200)
,	@v_EntryBy      Char(5)
As		-- Drop procedure [dbo].[EmpExperience_Update_N]
Begin		
	Set nocount on
	IF (SELECT COUNT(*) FROM EmpExperience WHERE EmpCd = @v_EmpCd  and Srno=@v_srno) = 0
	    Begin
	        insert into EmpExperience values(
			@v_EmpCd
		,	@v_srno
		,	@v_Stdt
		,	@v_Enddt
		,	@v_Desg
		,	@v_Coname
		,	@v_Country
		,	@v_Coref
		,	@v_Narr
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
	        )
			exec GetMessage 1,'Inserted successfully'
	    end
	Else
	
	    Begin
		Update EmpExperience
		Set
			StDt	=@v_Stdt
		,	EndDt	 =@v_Enddt
		,	Desg      = @v_Desg
		,	Coname = @v_Coname
		,	Country  = @v_Country
		,	CoRef    = @v_Coref
		,	Narr       = @v_Narr 
		,	EditBy    = @v_EntryBy
		,	EditDt    = getdate()
		where 
			EmpCd = @v_EmpCd 
		and	Srno=@v_srno
		exec GetMessage 1,'Inserted successfully'
		End
End



 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[EmpQualification_Update_N]
	@v_EmpCd	Char(10)
,	@v_SrNo		Char(5)
,	@v_QualCd char(10)
,	@v_Univ		Varchar(50)
,	@v_Country char(5)
,	@v_PassYr	Char(10)
,	@v_Markgr	CHAR(10)
,	@v_EntryBy	Char(5)
As			-- Drop procedure [dbo].[EmpQualification_Update_N]
Begin			
	Set nocount on
	Declare @err int
	IF (SELECT COUNT(*) FROM EmpQualification WHERE EmpCd = @v_EmpCd  and Srno=@v_srno) = 0
	   Begin
	        Insert into EmpQualification values(
	        @v_EmpCd,
	        @v_SrNo,
	        @v_QualCd,
	        @v_Univ,
	        @v_PassYr,
	        @v_Markgr,
	        @v_Country,
	        @v_EntryBy,
	        getdate(),
		null,
		null)
		exec GetMessage 1,'Inserted successfully'
	   End
	Else
	    Begin
	        Update EmpQualification
		Set
			Univ		= @v_Univ
		,	PassYear	= @v_PassYr
		,	Marksgrade	= @v_Markgr
		,	Country		= @v_Country
		,	EditBy		= @v_EntryBy
		,	EditDt		= getdate()
		Where
			EmpCd = @v_EmpCd and Srno=@v_SrNo
			exec GetMessage 1,'Updated successfully'
	    End
End


 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyProcessApproval_Delete_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_ApplTyp			char(10)
,	@v_Div				Char(5)
,	@v_Dept				char(10)
As		-- Drop Procedure [dbo].[CompanyProcessApproval_Delete_N]
Begin	
	DELETE FROM CompanyProcessApproval 
	WHERE 
		CoCd = @v_CoCd 
		and ProcessId=@v_ProcessId 
		and ApplTyp=@v_ApplTyp 
		and Div=@v_Div
		and Dept=@v_Dept
		exec GetMessage 1,'Deleted successfully'
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Employee_Update_N]
--drop Procedure [dbo].[Employee_Update_N]
	@v_Cd				Char(10)	= null   -- Drop Procedure [dbo].[Employee_Update_N]  
,	@v_Fname			VarChar(40)	= null    
,	@v_Salute			VarChar(10)	= null   
,	@v_Mname			VarChar(40) = null  
,	@v_Lname			VarChar(40) = null    
,	@v_Sex				Char(1)		= null  
,	@v_CoCd				Char(5)		= null   
,	@v_Div				VarChar(5)	= null    
,	@v_CC				Varchar(10)	= null    
,	@v_Dept				VarChar(10)	= null    
,	@v_LocCd			VarChar(10) = null    
,	@v_POB				VarChar(40) = null   
,	@v_Nat				VarChar(5) = null   
,	@v_Relg				VarChar(10) = null   
,	@v_Marital			VarChar(10) = null   
,	@v_Desg				VarChar(5) = null   
,	@v_Dob				datetime  
,	@v_Doj				datetime    
,	@v_EmpCat1			VarChar(10) = null
,	@v_EmpCat2			VarChar(10) = null   
,	@v_EmpCat3			VarChar(10) = null   
,	@v_RepTo			Char(10)	= null  
,	@v_Father			VarChar(40) = null    
,	@v_Mother			VarChar(40) = null    
,	@v_Spouse			VarChar(40) = null    
,	@v_Probation		datetime = null   
,	@v_Confrm			datetime =  null  
,	@v_Leaving			datetime =null  
,	@v_CurrCd			VarChar(5)	= null  
,	@v_Basic			Numeric(9,3)= 0.0    
,	@v_BasicCurr		Varchar(5)	= null  
,	@v_Personal_No		varchar(50) = null
,	@v_FareEligible		Char(1)		= null  
,	@v_NoTickets		Numeric(6,3)= 0.0    
,	@v_TravSect			VarChar(10)	= null  
,	@v_TravClass		VarChar(10)	= null    
,	@v_HomeBase			VarChar(20)	= null    
,	@v_PayMode			VarChar(10)	= null    
,	@v_PayFreq			VarChar(10)	= null   
,	@v_BankCd			VarChar(10)	= null   
,	@v_LvDays			Numeric(5,2)= 0.0  
,	@v_LvSalaryDays			Numeric(5,2)= 0.0    
,	@v_Status			VarChar(10)	= null  
,	@v_Sponsor			VarChar(10) = null  
--, @v_ImageFile		VarChar(500)= null   
--, @v_ImageSign		VarChar(500)= null
,	@v_EntryBy			Char(5)		= null
,	@v_OTEligible		Char(1)		= null
,	@v_LvPrd			Numeric(4,2)= null
,	@v_TradeCd			Varchar(5)	= null
,	@v_EmpTyp			Varchar(10)	= null
,	@v_Pwd				Char(200)	= null
,	@v_ApprCd			Char(10)	= null
,	@v_UserCd			Varchar(10)	= null
,	@v_ShiftCd			Varchar(10)	= null
,	@v_CalcBasis		Char(1)		= null
,	@v_GT				Char(1)		= null
,	@v_LS				Char(1)		= null
,	@v_LT				Char(1)		= null
,	@v_Active			Char(1)		= null
--,	@v_ProvOPAmt		Numeric(15,3)= 0.0   
--,	@v_ProvOPDays		Numeric(15,3)= 0.0    
,	@v_LeaveOB			Numeric(15,3)= 0.0  
,	@v_PassportLocation	varchar(50)=''
,	@v_ImageFile		varchar(100)=''
,	@v_ImageSign		varchar(100)=''
As
Begin  
	Set nocount on  
	declare  @Cd	Char(10) 
	IF (SELECT COUNT(*) FROM Employee WHERE Cd = @v_Cd) = 0    
	  Begin
		Insert into Employee(  
			Cd  
		,	Fname    
		,	Salute    
		,	Mname    
		,	Lname    
		,	Sex    
		,	CoCd    
		,	Div    
		,	CC    
		,	Dept    
		,	LocCd    
		,	POB    
		,	Nat    
		,	Relg    
		,	Marital    
		,	Desg    
		,	Dob    
		,	Doj    
		,	EmpCat1    
		,	EmpCat2    
		,	EmpCat3    
		,	RepTo    
		,	Father    
		,	Mother    
		,	Spouse    
		,	Probation    
		,	Confrm 
		,	Leaving   
		,	BasicCurr    
		,	[Basic]
		,	CurrCd   
		,	Personal_No		-- Newly added field
		,	FareEligible    
		,	NoTickets    
		,	TravSect    
		,	TravClass    
		,	HomeBase    
		,	PayMode    
		,	PayFreq    
		,	BankCd
		,	LvDays
		,	[Status]
		,	Sponsor
		--, ImageFile   //syed on 22/06/2014  
		--, ImageSign    
		,	EntryBy    
		,	EntryDt    
		,	OTEligible    
		,	LvPrd    
		,	TradeCd    
		,	EmpTyp    
		,	ApprCd    
		,	Pwd    
		,	UserCd    
		--, ShiftCd  --Check with PK   
		,	CalcBasis  
		,	GT  
		,	LS  
		,	LT
		,	Active
		,	PassportLocation
		,	Imagefile
		,	ImageSign) 
		Values(  
			@v_Cd    
		,	@v_Fname    
		,	@v_Salute    
		,	@v_Mname    
		,	@v_Lname    
		,	@v_Sex    
		,	@v_CoCd    
		,	@v_Div    
		,	@v_CC    
		,	@v_Dept    
		,	@v_LocCd    
		,	@v_POB    
		,	@v_Nat    
		,	@v_Relg    
		,	@v_Marital    
		,	@v_Desg     
		,	@v_Dob    
		,	@v_Doj    
		,	@v_EmpCat1    
		,	@v_EmpCat2    
		,	@v_EmpCat3    
		,	@v_RepTo    
		,	@v_Father    
		,	@v_Mother    
		,	@v_Spouse    
		,	@v_Probation    
		,	@v_Confrm 
		,	@v_Leaving   
		,	@v_BasicCurr    
		,	@v_Basic    
		,	@v_CurrCd    
		,	@v_Personal_No
		,	@v_FareEligible    
		,	@v_NoTickets    
		,	@v_TravSect    
		,	@v_TravClass    
		,	@v_HomeBase    
		,	@v_PayMode    
		,	@v_PayFreq    
		,	@v_BankCd    
		,	@v_LvSalaryDays    
		,	@v_Status    
		,	@v_Sponsor    
		--, @v_Imagefile   //syed  
		--, @v_ImageSign    
		,	@v_EntryBy    
		,	GetDate()  
		,	@v_OTEligible       
		,	@v_LvPrd    
		,	@v_TradeCd    
		,	@v_EmpTyp    
		,	@v_ApprCd     
		,	@v_Pwd     
		,	@v_UserCd  
		--,	@v_ShiftCd   --Check with PK  
		,	@v_CalcBasis  
		,	@v_GT  
		,	@v_LS  
		,	@v_LT
		,	@v_Active
		,	@v_PassportLocation
		,	@v_ImageFile
		,	@v_ImageSign)
		exec GetMessage 1,'Inserted successfully'
		select @@IDENTITY 
		SET @Cd=@@IDENTITY 
		insert into ErrorLog values(@Cd,GETDATE(),3,'','')		
	  End
	Else    
	  Begin
		Update Employee    
		Set
			Fname		=@v_Fname    
		,	Salute		=@v_Salute    
		,	Mname		=@v_Mname    
		,	Lname		=@v_Lname    
		,	Sex			=@v_Sex    
		,	CoCd		=@v_CoCd    
		,	Div			=@v_Div    
		,	CC			=@v_CC    
		,	Dept		=@v_Dept    
		,	LocCd		=@v_LocCd    
		,	POB			=@v_POB    
		,	Nat			=@v_Nat    
		,	Relg		=@v_Relg    
		,	Marital		=@v_Marital    
		,	Desg		=@v_Desg    
		,	Dob			=@v_Dob    
		,	Doj			=@v_Doj    
		,	EmpCat1		=@v_EmpCat1    
		,	EmpCat2		=@v_EmpCat2    
		,	EmpCat3		=@v_EmpCat3    
		,	RepTo		=@v_RepTo    
		,	Father		=@v_Father    
		,	Mother		=@v_Mother    
		,	Spouse		=@v_Spouse    
		,	Probation	=@v_Probation    
		,	Confrm		=@v_Confrm 
		,	Leaving	=@v_Leaving   
		,	BasicCurr	=@v_BasicCurr    
		,	[Basic]		=@v_Basic
		,	CurrCd		=@v_CurrCd   
		,	Personal_No	=@v_Personal_No 
		,	FareEligible=@v_FareEligible    
		,	NoTickets	=@v_NoTickets    
		,	TravSect	=@v_TravSect    
		,	TravClass	=@v_TravClass    
		,	HomeBase	=@v_HomeBase    
		,	PayMode		=@v_PayMode    
		,	PayFreq		=@v_PayFreq    
		,	BankCd		=@v_BankCd    
		,	LvDays		=@v_LvSalaryDays    
		,	[Status]    =@v_Status    
		,	Sponsor		=@v_Sponsor    
		--,	Imagefile	=@v_Imagefile  //syed  
		--,	ImageSign	=@v_ImageSign    
		,	EditBy		=@v_EntryBy    
		,	EditDt		=GetDate()    
		,	OTEligible	=@v_OTEligible     
		,	LvPrd		=@v_LvPrd     
		,	TradeCd		=@v_TradeCd    
		,	EmpTyp		=@v_EmpTyp    
		,	ApprCd		=@v_ApprCd  
		,	Pwd			=@v_Pwd   
		,	UserCd		=@v_UserCd  
		--,	ShiftCd		=@v_ShiftCd    --Check with PK   
		,	CalcBasis	=@v_CalcBasis  
		,	GT			=@v_GT  
		,	LS			=@v_LS
		,	LT			=@v_LT
		,	Active		=@v_Active
		,	PassportLocation=@v_PassportLocation
		,	Imagefile	=@v_ImageFile
		,	ImageSign	=@v_ImageSign
		Where
			Cd = @v_Cd and CoCd=@v_CoCd 
		exec GetMessage 1,'Updated successfully'
		select @v_Cd 
		SET @Cd=@v_Cd 
		insert into ErrorLog values(@Cd,GETDATE(),4,'','')
		
	  End
		EXEC EmpLeaveMaster_Update @Cd,'AL',@v_LvDays,@v_LeaveOB,0,0,0,0,0,@v_EntryBy,'a'
		
		insert into ErrorLog values(@Cd,GETDATE(),5,'','')
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyCalendar_GetRow_N] --CompanyCalendar_GetRow_N '01','2014'
 @v_CoCd char(5)
,@v_Cd varchar(10) = ''
as
	select 
		*
		,(select STRING_AGG(trim(EmpCd), ',') from CalendarEventAttendees where EventCd = Cd)Attendees
	from 
		CompanyCalendar_N 
	where CoCd=@v_CoCd and Cd =@v_Cd or @v_Cd = ''
	order by 
		[Date]
		
      
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Designation_GetRow_N]
	@v_Cd varChar(10)
As		-- Drop Procedure [dbo].[Designation_GetRow_N] ''
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
CREATE OR ALTER     procedure [dbo].[Designation_Delete_N]
	@v_Cd varChar(10)
As
Begin
	Delete from Designation where Cd = @v_Cd
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Designation_Update_N]
	@v_Cd			varChar(10)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(30)
--,	@v_GradeCd		Char(5) = null
,	@v_EntryBy		Char(5)
,	@v_Mode			char(1)
As		-- Drop Procedure [dbo].[Designation_Update_N]
Begin	-- sp_help Designation
	Set Nocount on
--	Declare @v_GradeCD char(5)
--	Select @v_GradeCd=Cd from Grade where SDes=@v_GradecdDes
	IF (SELECT COUNT(*) FROM Designation WHERE Cd = @v_Cd) = 0
	  Begin
		Insert into Designation Values
		(
			@v_Cd,
			@v_SDes,
			@v_Des,
			null, --@v_GradeCd,	
			@v_EntryBy,
			getdate(),
			null,
			null
		)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else
	 IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	  Begin
		Update Designation
		Set
			SDes		= @v_SDes,
			Des			= @v_Des,
			--GradeCd		= @v_GradeCd,       
			EditBy		= @v_EntryBy,
			EditDt		= getdate()
		Where
			Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
	  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyLoanTypes_Update_N]
	@v_Cd			Char(5)
,	@v_PayTyp		char(10) = 'HEDT03'
,	@v_PayCd		Char(5)		-- Select * from  companyloantypes, sp_help companyloantypes
,	@v_DedTyp		char(10) = 'HEDT02'
,	@v_DedCd		Char(5)		-- Select * from companyearnded, sp_help companyearnded
,	@v_Abbr			char(5)
,	@v_Sdes			varchar(20)
,	@v_Des			varchar(50)
,	@v_EntryBy		char(5)
,	@v_ChgTyp		Char(2)
,	@v_Percval		Numeric(5,2)
,	@v_Active		bit
,	@v_Mode			Char(1)=null
As		-- Drop Procedure [dbo].[CompanyLoantypes_Update]
Begin
	--	declare @v_PayCd	char(5)
	--	declare @v_DedCd	char(5)
	--	select @v_PayCd = Cd from CompanyEarnDed where CompanyEarnDed.Sdes=@v_PayCdDes
	--	select @v_DedCd = Cd from CompanyEarnDed where CompanyEarnDed.Sdes=@v_DedCdDes
	IF (Select Count(1) from CompanyLoanTypes where Cd=@v_Cd)=0
	  Begin
		Insert into CompanyLoanTypes
		Values(
			@v_Cd
		,	@v_PayTyp
		,	@v_PayCd
		,	@v_DedTyp
		,	@v_DedCd
		,	@v_Abbr
		,	@v_Sdes
		,	@v_Des
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		,	@v_ChgTyp
		,	@v_PercVal
		,	@v_Active)
		exec GetMessage 1,'Inserted successfully'
	  end
	else
		IF (@v_Mode = 'I')
			exec GetMessage 0,'Already exists'
		Else
		  Begin
			Update CompanyLoanTypes
			Set
				Abbr=@v_Abbr
			,	Sdes=@v_Sdes
			,	Des=@v_Des
			,	EdTypPay=@v_PayTyp
			,	EdCdPay=@v_PayCd
			,	EdTypDed=@v_DedTyp
			,	EdCdDed=@v_DedCd
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			,	ChgsTyp=@v_ChgTyp
			,	IntPerc=@v_Percval
			,	Active=@v_Active
			Where
				Cd=@v_Cd
				exec GetMessage 1,'Updated successfully'
		  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyLoanTypes_GetRow_N] 
	@v_Cd		Char(10)
,	@v_Typ		Varchar(5)=Null
As		-- Drop Procedure [dbo].[CompanyLoanTypes_GetRow_N] 'JL02      ',''
Begin		
	Select											
		Cd
	,	[Des]
	,	Case @v_Typ
			When 'LA' then
				(Select SDes From CompanyEarnDed Where Cd=EdCdPay and Typ='HEDT03')
			Else
				(Select SDes From SysCodes Where Cd='HEDT03')
		End[PayTyp]
	,	(Select SDes From CompanyEarnDed Where Cd=EdCdPay and Typ='HEDT03')[PayComp]
	,	(Select SDes From SysCodes Where Cd='HEDT02')[DedTyp]
	,	(Select SDes From CompanyEarnDed Where Cd=EdCdDed and Typ='HEDT02')[DedComp]
	,	Abbr
	,	Sdes
	
	,	Case ChgsTyp
			when 'F' then 'Fixed Rate'
			when 'R' then 'Reduced Balance'
			else 'None'
		End	[ChgsTyp]
	,	ChgsTyp[ChgsTypCd]
	,	IntPerc
	,	EdCdPay [PayCd]
	,	EdCdDed [DedCd]
	,	EdTypDed[DedTypCd]
	,	EdTypPay[PayTypCd]
	,	Active
	From
		CompanyLoanTypes
	Where
		@v_cd='' or Cd=@v_Cd 
	Order by
		Cd
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompDocImages_Delete_N]
	@v_CoCd		Char(5)
,	@v_Div		Char(5)
,	@v_DocTyp		Char(10)
,	@v_SlNo		Char(5)
As		-- Drop Procedure [dbo].[CompDocImages_Delete_N]
Begin
	--Declare @v_DocTyp Char(10)
	--Select @v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes 
	Delete from CompDocImages where CompCd = @v_CoCd and Div=@v_Div and DocTyp=@v_DocTyp and SlNo=@v_SlNo
	exec GetMessage 1,'Deleted successfully'
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[VehDocImages_Delete_N]
	@v_VehCd		Char(10)
,	@v_DocTyp		Char(10)
,	@v_SlNo			Char(1) = null
As		-- Drop Procedure [dbo].[VehDocImages_Delete_N]
Begin
	--Declare @v_DocTyp Char(10)
	--Select @v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes 
	Delete from VehDocImages where VehCd = @v_VehCd and DocTyp=@v_DocTyp and SlNo= @v_SlNo
	exec GetMessage 1,'Deleted successfully'
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompDocImages_Update_N]
	@v_CoCd				Char(10)
,	@v_Div				Char(5)
,	@v_DocTyp			Char(10)		-- sp_help EmpDocImages Empdocuments
,	@v_SlNo				int
,	@v_ImageFile		VarChar(200)
,	@v_EntryBy			Char(5)
As		-- Drop Procedure [dbo].[CompDocImages_Update_N]
Begin
	set nocount on
	--declare @v_DocTyp Char(10)
	--select 	@v_DocTyp=Cd from Codes where SDes=@v_DocTypSDes and Typ='HDTYP'
	IF (SELECT COUNT(*) FROM CompDocImages WHERE CompCd =@v_CoCd and Div=@v_Div and DocTyp=@v_DocTyp and SlNo=@v_SlNo) = 0
	  Begin
		insert into CompDocImages
		values
		(
			@v_CoCd
		,	@v_Div
		,	@v_DocTyp
		,	@v_SlNo
		,	@v_ImageFile
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		)
		print 'I'
	  end
	Else
	  Begin
		Update CompDocImages
		  Set
			ImageFile=@v_ImageFile
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		where
			CompCd =@v_CoCd and Div=@v_Div and DocTyp=@v_DocTyp and SlNo=@v_SlNo
			print 'U'
	  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompDocImages_GetRow_N]
	@v_CoCd		Char(5)
,	@v_Div		char(5)=null 
,	@v_DocTyp		char(10)=''   
As		-- Drop Procedure [dbo].[CompDocImages_GetRow_N]'01','002','HCDOC0001'
Begin
	Select
		CDI.CompCd[CompanyCode]    
	,	rtrim(Comp.CoName)[CompanyName]  
	,	CDI.Div[DivCd]       
	,	(Select Des From Branch Where Cd=CDI.Div)[Div]   
	,	CDI.DocTyp[DocumentTypeCd]       
	,	(Select SDes From Codes Where Cd=CDI.DocTyp)[DocumentType]    
	,	CDI.ImageFile[ImageFile]    
	,	CDI.EntryBy[EntryBy]
	,	CDI.EntryDt[EntryDate]
	,	CDI.EditBy[EditedBy]
	,	CDI.EditDt[EditDate]
	,	CDI.SlNo
	From
		Company Comp    
	,	CompDocImages CDI    
	Where
		Comp.Cd=CDI.CompCd
	and (CDI.CompCd=@v_CoCd or @v_CoCd = '')	
	and (Div = @v_Div or Div=null)		
	and (DocTyp = @v_DocTyp or @v_DocTyp='')		
	Order By
		CDI.CompCd    
	,	SlNo    
End
 
 
 
 Go 

CREATE OR ALTER     procedure [dbo].[VehDocuments_Update_N]
		@v_VehCd		Char(10)
	,	@v_DocTyp		VarChar(10)
	,	@v_DocNo		Char(20)
	,	@v_OthRefNo		Char(20)
	,	@v_IssueDt		Datetime
	,	@v_IssuePlace	VarChar(30)
	,	@v_ExpDt		Datetime
	,	@v_EntryBy		Char(5)
	,	@v_SrNo			numeric(5,0)=1
	,	@v_Mode			Char(1)
As		-- Drop Procedure [dbo].[VehDocuments_Update_N]--sp_help VehDocuments
Begin
	Set NoCount on
	IF (SELECT COUNT(1) FROM VehDocuments WHERE VehCd = @v_VehCd and DocTyp=@v_DocTyp) = 0
		Begin
			insert into VehDocuments(VehCd,DocTyp,DocNo,OthRefNo,IssueDt,IssuePlace,ExpDt,EntryBy,EntryDt,SrNo)
			values(
				@v_VehCd
			,	@v_DocTyp
			,	@v_DocNo
			,	@v_OthRefNo
			,	@v_IssueDt
			,	@v_IssuePlace
			,	@v_ExpDt
			,	@v_EntryBy
			,	getdate()
			,	@v_SrNo)
			exec GetMessage 1,'Inserted successfully'
		End
		Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
		Begin
				Update VehDocuments Set
				DocNo=@v_DocNo
			,	IssueDt=@v_IssueDt
			,	IssuePlace=@v_IssuePlace
			,	ExpDt=@v_ExpDt
			,	EditBy=@v_EntryBy
			,	EditDt=Getdate()
			,	OthRefNo=@v_OthRefNo
			Where
				VehCd=@v_VehCd and DocTyp=@v_DocTyp
				exec GetMessage 1,'Updated successfully'
		End
End

 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[VehDocuments_GetSrNo_N]
		@v_VehCd		Char(10)
	,	@v_DocTyp		Char(10)
	,	@v_SrNo			varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

   SELECT isnull(max(SrNo),0)+1 FROM VehDocuments where VehCd = @v_VehCd and DocTyp=@v_DocTyp;
END
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[VehDocImages_GetRow_N]
	@v_VehCd		Char(10)
,	@v_DocTyp		Varchar(10)=''   
As		-- Drop Procedure [dbo].[VehDocImages_GetRow_N]
Begin
	Select
		VEH.Cd[Code]    
	,	rtrim(VEH.Des)[VehicleName]    
	,	VDI.DocTyp[DocumentTypeCd]       
	,	(Select SDes From Codes Where Cd=VDI.DocTyp)[DocumentType]    
	,	VDI.ImageFile[ImageFile]    
	,	VDI.EntryBy[EntryBy]
	,	VDI.EntryDt[EntryDate]
	,	VDI.EditBy[EditedBy]
	,	VDI.EditDt[EditDate]
	,	VDI.SlNo
	From
		CompanyVehicles VEH    
	,	VehDocImages VDI    
	Where
		VEH.Cd=VDI.VehCd
	and (VDI.VehCd=@v_VehCd or @v_VehCd = '')	-- Modified by Rasheed
	and (DocTyp = @v_DocTyp or @v_DocTyp='')		-- Modified by PK
	Order By
		VDI.VehCd    
	,	SlNo    
End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[VehDocuments_GetRow_N]
	@v_VehCd	Char(10)
,	@v_DocTyp	Varchar(30)
As	-- Drop Procedure [dbo].[VehDocuments_GetRow_N]'',''
Begin
	Select
		VD.SrNo
	,	VD.VehCd[VehCd]
	,	Rtrim(Veh.Des) [VehName]
	,	Cod.SDes[DocTypSDes]
	,	VD.DocNo[DocNo]
	,	VD.OthRefNo[OthRefNo]
	,	VD.IssueDt[IssueDt]
	,	VD.ExpDt[ExpDt]
	,	CONVERT(varchar(10), VD.IssueDt,103)[FormatedIssueDt]
	,	CONVERT(varchar(10), VD.ExpDt,103)[FormatedExpDt]
	--,	case when VD.ExpDt>cast (GETDATE() as DATE) then 'Y' else 'N' end[CheckExpiry]
	,	VD.IssuePlace[IssuePlace]
	,	VD.EntryBy[EntryBy]
	,	VD.EntryDt[EntryDt]
	,	CONVERT(varchar(10), VD.EntryDt,103)[FormatedEntryDt]
	,	VD.EditBy[EditBy]
	,	VD.EditDt[EditDt]
	,	CONVERT(varchar(10), VD.EditDt,103)[FormatedEditDt]
	,	Rtrim(VD.VehCd)+Rtrim(Cod.SDes)[Filter]
	, DocTyp [DocTypCd]  
	From
		CompanyVehicles Veh
	,	VehDocuments VD
	,	Codes Cod
	Where
		Veh.Cd=VD.VehCd and Cod.Cd=VD.DocTyp
	and	(VD.VehCd=@v_VehCd and @v_VehCd<>'' or @v_VehCd='')
	and	(VD.VehCd=@v_VehCd and @v_VehCd<>'' or @v_VehCd='')
	and	(VD.DocTyp=@v_DocTyp and @v_DocTyp<>'' or @v_DocTyp='')
	Order by
		EntryDt desc
End

 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[VehDocuments_Delete_N]
		@v_VehCd		Char(10)
	,	@v_DocTyp		Char(10)
	,	@v_SrNo		varchar(5)
As		-- Drop procedure [dbo].[VehDocuments_Delete_N] '', ''
Begin	
	Delete from VehDocuments where VehCd = @v_VehCd and DocTyp=@v_DocTyp and SrNo=@v_SrNo
	exec GetMessage 1,'Deleted successfully'
End

 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[CompanyVehicle_Delete_N]
@v_Cd Char(10)
As
Begin
	IF NOT EXISTS (select 1 from VehDocImages where VehCd =@v_Cd)
		BEGIN
		Delete from CompanyVehicles where Cd = @v_Cd
		exec GetMessage 1,'Deleted successfully'
		END
	ELSE
		exec GetMessage 0,'Can not delete'    
End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[CompanyVehicle_Update_N]
--DROp procedure [dbo].[CompanyVehicle_Update_N]
@v_Cd               Char(10),
@v_SDes             Varchar(20),
@v_Des              Varchar(50),
@v_Div              char(20),
@v_Loc              char(20),
@v_Brand            char(10),
@v_Model            Varchar(20),
@v_PurDt			Datetime,
@v_OrgPrice			Numeric(12,4),
@v_Owner            char(10),
@v_Driver           Char(10),
@v_EngineNo			Varchar(20),
@v_ChassisNo		Varchar(20),
@v_PlateColor		char(20),
@v_RegnNo			Varchar(20),
@v_RegnFrmDt		Datetime,
@v_RegnExpDt		Datetime,
@v_State			char(20),
@v_PetrolCard		Varchar(50),
@v_PetrolCardAmt	Numeric(18,0),
@v_InsCo			Varchar(30),
@v_InsPolicyNo		Varchar(30),
@v_InsAmt           Numeric(12,4),
@v_InsPrem          Numeric(9,4),
@v_InsFrmDt			Datetime,
@v_InsExpDt			Datetime,
@v_Narr	           	Varchar(500),
@v_EntryBy          Char(5),
@v_Mode		        Char(1)
as

Begin
	IF (SELECT COUNT(*) FROM CompanyVehicles WHERE Cd = @v_Cd) = 0
	  Begin
	        insert into CompanyVehicles 
		Values(
	       	@v_Cd              
	,	@v_SDes         
	,	@v_Des           
	,	@v_Div
	,	@v_Loc               
	,	@v_Brand            
	,	@v_Model         
	,	@v_PurDt		
	,	@v_OrgPrice		
	,	@v_Owner              	
	,	@v_Driver             	
	,	@v_EngineNo	
	,	@v_ChassisNo		
	,	@v_PlateColor
	,	@v_RegnNo		
	,	@v_RegnFrmDt		
	,	@v_RegnExpDt		
	,	@v_State		
	,	@v_PetrolCard	
	,	@v_PetrolCardAmt
	,	@v_InsCo		
	,	@v_InsPolicyNo		
	,	@v_InsAmt           	
	,	@v_InsPrem          	
	,	@v_InsFrmDt		
	,	@v_InsExpDt		
	,	@v_Narr	           	
	,	@v_EntryBy             	
	,	getdate()
	,	null
	,	null)	
	exec GetMessage 1,'Inserted successfully'
	 End 
	 Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
Else
	   Begin
	        Update CompanyVehicles
	          Set
			Cd		=	@v_Cd,
			SDes		=	@v_SDes,
			Des		=	@v_Des,
			Div		=	@v_Div, 
			Loc		=	@v_Loc, 
			Brand		=	@v_Brand  ,
			Model		=	@v_Model,
			PurDt		=	@v_PurDt,	
			OrgPrice	=	@v_OrgPrice,	
			Owner		=	@v_Owner,
			Driver		=	@v_Driver,   
			EngineNo	=	@v_EngineNo,	
			ChassisNo	=	@v_ChassisNo,	
			PlateColor	=	@v_PlateColor,	
			RegnNo	=	@v_RegnNo,
			RegnFrmDt	=	@v_RegnFrmDt,
			RegnExpDt	=	@v_RegnExpDt,
			State		=	@v_State,	
			PetrolCard	=	@v_PetrolCard,
			PetrolCardAmt=	@v_PetrolCardAmt,
			InsCo		=	@v_InsCo,	
			InsPolicyNo	=	@v_InsPolicyNo,		
			InsAmt		=	@v_InsAmt, 
			InsPrem	=	@v_InsPrem, 
			InsFrmDt	=	@v_InsFrmDt,	
			InsExpDt	=	@v_InsExpDt,	
			Narr		=	@v_Narr,	
			EditBy		=	@v_EntryBy, 
			EditDt		=	getdate()
	where Cd = @v_Cd
	exec GetMessage 1,'Updated successfully'
	End
End

 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyProcessApproval_GetRowSingle_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_ApplTyp			char(10)
,	@v_Div				char(5)
,	@v_Dept				char(10)
,	@v_typ				Char(1)
As		-- Drop Procedure [dbo].[CompanyProcessApproval_GetRow]'01','0','02','jl','','0'
Begin	
	SELECT top 1
		(select CoName from Company where Cd=CPA.CoCd)[CoCd]
	,	CoCd[CoCdCd]
	,	(select Caption from MenuCtrl where ProcessId=CPA.ProcessId)[ProcessId]
	,	ProcessId[ProcessIdCd]
	,	(Case when ProcessId='HRPSS2' then (select Des from CompanyLeave where Cd=CPA.ApplTyp)
						when ProcessId='HRPSS1' then (select Des from CompanyLoanTypes where Cd=CPA.ApplTyp)
						when ProcessId='HRPT8' then (select Des from Codes where Typ='HDTYP' and Cd=CPA.ApplTyp)
						when ProcessId='HRPT6' then (select Des from SysCodes where Typ='HREP' and Cd=CPA.ApplTyp)
						when ProcessId='HRPSS3' then (select Des from CompanyLeave where Cd=CPA.ApplTyp)
						when ProcessId='HRPT14' then (select Des from CompanyProvisions where Cd=CPA.ApplTyp) end)[ApplTyp]
	,	ApplTyp[ApplTypCd]
	,	(select Des from Branch where Cd=CPA.Div)[Branch]
	,	Div[BranchCd]
	,	(select Des from Dept where Cd=CPA.Dept)[Dept]
	,	Dept[DeptCd]
	FROM CompanyProcessApproval  as CPA
	WHERE  @v_typ='0'
	 or(@v_typ='1' 
		and CoCd = @v_CoCd 
		and (ProcessId=@v_ProcessId)
		and (@v_ApplTyp='0' or ApplTyp=@v_ApplTyp )
		and (@v_Div='0' or Div=@v_Div )
		and (@v_Dept='0' or Dept=@v_Dept))
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyOverTimeRates_Update_N]
	@v_CoCd		varchar(50)
,	@v_Typ		varchar(50)
,	@v_HolTyp	varchar(10)
,	@v_PayCd	varchar(5)
,	@v_SrNo		numeric(3,0)
,	@v_Rate		numeric(5,3)
,	@v_HrsApply	numeric(5,2)
,	@v_Sdes		varchar(20)
,	@v_Narr		varchar(50)
,	@v_EntryBy	varchar(10)
,	@v_Mode			char(1)
As			-- Drop procedure CompanyOverTimeRates_Update_N
--Declare @v_Typ		char(10)
--Declare @v_HolTyp	char(10)
--Declare @v_PayCd	char(5)
--Select @v_Typ=Cd From SysCodes where Sdes = @v_TypDes and Typ='HCOTT'
--Select @v_HolTyp=Cd From SysCodes where Sdes = @v_HolTypDes and Typ='HOTC2'
--Select @v_PayCd=Cd From CompanyEarnDed where Sdes = @v_PaySDes and Typ='HEDT01'
Begin
If (Select Count(*) from CompanyOverTimeRates where CoCd=@v_CoCd and Typ=@v_Typ and HolTyp=@v_HolTyp and Srno=@v_SrNo)=0
	Begin
		insert into CompanyOverTimeRates(CoCd,Typ,HolTyp,SrNo,Rate,PayCd,HrsApply,SDes,Narr,EntryBy,EntryDt)
		Values(
			@v_CoCd
		,	@v_Typ
		,	@v_HolTyp
		,	@v_SrNo
		,	@v_Rate
		,	@v_PayCd
		,	@v_HrsApply
		,	@v_Sdes
		,	@v_Narr
		,	@v_EntryBy
		,	getdate()
		)
		exec GetMessage 1,'Inserted successfully'
	End
	Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
Else
	Begin
		Update CompanyOverTimeRates
		Set
			Rate=@v_Rate
		,	PayCd=@v_PayCd
		,	HrsApply=@v_HrsApply	
		,	Narr=@v_Narr
		,	Sdes=@v_Sdes
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		where 
			CoCd=@v_CoCd 
		and 	Typ=@v_Typ
		and 	HolTyp=@v_HolTyp
		and 	Srno=@v_SrNo
		exec GetMessage 1,'Updated successfully'
	End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Airfare_Update_N]
	@v_SectCd		char(10)
,	@v_Class		char(10)
,	@v_SrNo			Numeric(5)
,	@v_FromDt		datetime
,	@v_ToDt			datetime
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(30)
,	@v_Fare			Numeric(15,4)
,	@v_EntryBy		Char(5)
,	@v_Mode			char(1)
As		-- Drop Procedure [dbo].[Airfare_Update_N]
Begin
	--declare @v_SectCd char(10)
	--declare @v_Class char(10)
	--select  @v_SectCd=cd from Codes where SDes=@v_SectCdDes and Typ='TSECT'
	--select  @v_Class=cd from Codes where SDes=@v_ClassDes  and Typ='TCLAS'
	set nocount on
	if (select  count(*) from AirFare where SectCd=@v_SectCd and Class=@v_Class and SrNo=@v_SrNo)=0
	begin
		Insert into Airfare values
	(
		@v_SectCd
	,	@v_Class
	,	@v_Srno
	,	@v_FromDt
	,	@v_Todt
	,	@v_SDes
	,	@v_Des
	,	@v_Fare
	,	@v_EntryBy
	,	getDate()
	,	null
	,	null)
	exec GetMessage 1,'Inserted successfully'
	end
	Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	else
	    Begin
	        Update Airfare
		Set
			FromDt	= @v_FromDt,
			ToDt	= @v_ToDt,	
			SDes   	= @v_SDes,
			Des     = @v_Des,
			Fare    = @v_Fare,
			EditBy  = @v_EntryBy,
			EditDt	= getdate()
		where
			SrNo	= @v_SrNo
		and	SectCd	= @v_SectCd
		and Class	= @v_Class
		exec GetMessage 1,'Updated successfully'
		End
End
 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[CompanyLeavePay_Update_N]
	@v_CoCd		Char(5)
--,	@v_PayTypDes	varchar(20)
--,	@v_PayCdDes		varchar(20) 
--,	@v_LvDes		varchar(20) 
,	@v_PayTyp		char(10)
,	@v_PayCd		Char(5)
,   @v_LvCd			char(5)    
,	@v_EntryBy		char(5)
,	@v_Mode			Char(1)
As		-- Drop PROCEDURE [dbo].[CompanyLeavePay_Update_N]
Begin
		--declare @v_PayTyp	char(10)
		--declare @v_PayCd	char(5)
		--declare @v_LvCd	Char(5)
		--select @v_PayTyp = Cd from SysCodes where SysCodes.Sdes=@v_PayTypDes and SysCodes.Typ='HEDT'
		--select @v_PayCd = Cd from CompanyEarnDed where CompanyEarnDed.Sdes=@v_PayCdDes
		--select @v_LvCd=Cd from CompanyLeave where SDes=@v_LvDes
	IF (Select Count(*) from CompanyLeavePay Where CoCd=@v_CoCd and LvCd=@v_LvCd and PayTyp=@v_PayTyp and Paycd=@v_PayCd)=0
	  Begin
		Insert into CompanyLeavePay(CoCd,PayTyp,PayCd,LvCd,EntryBy,EntryDt)
		Values
		(
			@v_CoCd
		,	@v_PayTyp
		,	@v_PayCd
		,	@v_LvCd
		,	@v_EntryBy
		,	Getdate())
		exec GetMessage 1,'Inserted successfully'
	  End
	  Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	  Begin
		Update CompanyLeavePay
		Set
			LvCd = @v_LvCd
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		Where
			CoCd=@v_CoCd
		and LvCd=@v_LvCd 
		and PayTyp=@v_PayTyp 
		and Paycd=@v_PayCd
		exec GetMessage 1,'Updated successfully'
	  End
End
 
 
 
 Go 


CREATE OR ALTER     Procedure [dbo].[CompanyDocuments_Update_N]
	@v_CoCd				Char(5)
,	@v_DivCd  			Char(5)
,	@v_DocTypCd   		Char(10)
,	@v_DocNo			Char(20)
,	@v_IssueDt			Datetime
,	@v_IssuePlace		Varchar(30)
,	@v_ExpDt			Datetime
,	@v_RefNo			Varchar(30)
,	@v_RefDt			datetime
,	@v_Narr				Varchar(500)
,	@v_EntryBy			Char(5)
,	@v_Mode				Char(1) =null
,	@v_Partners			Varchar(500)=null
--,	@v_EjariExpDt		Datetime
As		-- Drop Procedure CompanyDocuments_Update_N
Begin	-- Sp_Help CompanyDocuments
	IF (SELECT COUNT(*) FROM CompanyDocuments WHERE CoCd = @v_CoCd and Div = @v_DivCd and DocTyp=@v_DocTypCd) = 0
	  Begin
		Insert into CompanyDocuments
		Values(
			@v_CoCd	
		,	@v_DivCd
		,	@v_DocTypCd
		,	@v_DocNo
		,	@v_IssueDt
		,	@v_IssuePlace
		,	@v_ExpDt
		,	@v_RefNo
		,	@v_RefDt
		,	@v_Narr	
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		,	@v_Partners
		,	null
		)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else
	IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	  Begin
		Update CompanyDocuments
			Set
			DocNo=@v_DocNo
		,	IssueDt=@v_IssueDt
		,	IssuePlace=@v_IssuePlace
		,	ExpDt=@v_ExpDt
		,	RefNo=@v_RefNo
		,	RefDt=@v_RefDt	
		,	Narr=@v_Narr	
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		,	Partners=@v_Partners
		--,	EjariExpDt=@v_EjariExpDt
		Where
			CoCd=@v_CoCd
		and	Div=@v_DivCd
		and	DocTyp=@v_DocTypCd
		exec GetMessage 1,'Updated successfully'
	  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Bank_Update_N]
		@v_BankCd		varchar(10)
	,	@v_BranchCd		varchar(10)	
	,	@v_Bank			Varchar(20)
	,	@v_Swift		Varchar(20)
	,	@v_Add1			Varchar(40)
	,	@v_Add2			VarChar(40)
	,	@v_Add3			Varchar(40)
	,	@v_Contact		Varchar(40)
	,	@v_Phone		VarChar(20)
	,	@v_Fax			Varchar(20)
	,	@v_Email		Varchar(40)
	,	@v_URL			Varchar(40)
	,	@v_EntryBy		Char(5)
	,	@v_Mode			char(1)
As		-- Drop Procedure [dbo].[Bank_Update_N]
Begin
	--declare @v_Bank Char(10)
	--declare @v_Br Char(10)
	Declare @v_BkGr Char(20)
	--select 	@v_Bank=Cd from Codes where SDes=@v_BankDes and Typ='BANK'
	--select 	@v_Br=Cd from Codes where SDes=@v_BrDes and Typ='BNKBR'
	IF (SELECT COUNT(*) FROM Bank WHERE Branch = @v_BranchCd and Bank=@v_BankCd) = 0
	  Begin
		insert into Bank(Bank,Branch,Swift,Add1,Add2,Add3,Contact,Phone,Fax,Email,URL,EntryBy,EntryDt)
		values
		(
			@v_BankCd
		,	@v_BranchCd	
		,	@v_Swift 	
		,	@v_Add1 	
		,	@v_Add2 	
		,	@v_Add3		
		,	@v_Contact 	
		,	@v_Phone 	
		,	@v_Fax		
		,	@v_Email 	
		,	@v_URL	 	
		,	@v_EntryBy
		,	getdate()
		)
		exec GetMessage 1,'Inserted successfully'
	  End
	  Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	  Begin
        Update Bank
		Set
			Add1=@v_Add1
		,	Add2=@v_Add2
		,	Add3=@v_Add3
		,	Contact=@v_Contact
		,	Phone=@v_Phone
		,	Fax=@v_Fax
		,	Email=@v_Email
		,	URL=@v_URL
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		,	Swift=@v_Swift
		Where 
			Branch = @v_BranchCd and Bank = @v_BankCd
			exec GetMessage 1,'Updated successfully'
    End
End
 
 
 
 Go 


CREATE OR ALTER     Procedure [dbo].[Airfare_GetRow_N]
	@v_SectCd		Char(10) = null
,	@v_Class		Char(10) = null
,	@v_SrNo			int = 0
As		-- Drop Procedure [dbo].[Airfare_GetRow_N]
Begin
	Select
		C.SDes[Sector]
	,	C1.SDes[TravelClass]
	,	A.SrNo
	,	case A.FromDt
		when '1/1/1900' then null
		else  CONVERT(varchar(20), A.FromDt,103)
		end [FormattedFromDate]
	,	case A.ToDt
		when '1/1/1900' then null
		else CONVERT(varchar(20),A.ToDt,103)
		end [FormattedToDate]
		
	,	case A.FromDt
		when '1/1/1900' then null
		else  A.FromDt
		end [FromDate]
	,	case A.ToDt
		when '1/1/1900' then null
		else A.ToDt
		end [ToDate]
		
	,	A.SDes
	,	A.Des
	,	A.Fare
	,	A.Entryby
	,	A.EntryDt
	,	A.EditBy
	,	A.EditDt
	,	A.SectCd
	,	A.Class[ClassCd]
	From 	
		Codes C
	,	Codes C1
	,	Airfare A
	Where
		C.Cd=A.SectCd and (C.Cd = @v_SectCd or @v_SectCd='')
	and	C1.Cd=A.Class and (C1.Cd = @v_Class or @v_Class='')
	and	(@v_SrNo = 0 or A.SrNo = @v_SrNo)
	Order By
		SrNo
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Notification_GetSrNo_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_Typ				Char(1)
,	@v_DocTyp			Char(10)
As		-- Drop Procedure [dbo].[Notification_GetSrNo_N]'03','HRPE2'
--select * from NotificationMaster
Begin	
	SELECT 
		isnull(max(SrNo),0)+1
	FROM NotificationMaster  
	WHERE	CoCd=@v_CoCd
	and		Processid=@v_ProcessId
	and		@v_Typ=0 or (@v_Typ=1 and DocTyp=@v_DocTyp)
End
 
 
 
 Go 

CREATE OR ALTER     PROCEDURE GetEmployees_N
	@v_CoCd varchar(5)
AS
BEGIN
	
	SET NOCOUNT ON;
	select * from Employee where CoCd= @v_CoCd
END
 
 
 
 Go 

CREATE OR ALTER     PROCEDURE GetEmployee_N
	@v_CoCd varchar(5)
AS
BEGIN
	
	SET NOCOUNT ON;
	select * from Employee where CoCd= @v_CoCd
END
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyWHrs_Update_N]
		@v_Cd			Char(5)
	,	@v_Narr			Varchar(100)
	,	@v_FromDt		Datetime
	,	@v_ToDt			Datetime
	,	@v_CoCd			Char(5)
	,	@v_DutyHrs		Numeric(5,2)
	--,	@v_HolTypDes		Char(20)
	--,	@v_RelgTypDes		Char(20)
	,	@v_RelgTyp		char(10)
	,	@v_HolTyp		Char(10)
	,	@v_EntryBy		Char(10)
	,	@v_Mode			Char(1)=null
As			-- Drop procedure CompanyWHrs_Update_N
Begin
	--Declare @v_RelgTyp	char(10)
	--Declare @v_HolTyp	Char(10)
	--select @v_RelgTyp=Cd from SysCodes where SDes=@v_RelgTypDes and Typ='HOTC1'
	--select @v_HolTyp=Cd from Syscodes where Sdes=@v_HolTypDes and Typ='HOTC2'
	set nocount on
	IF (SELECT COUNT(*) FROM CompanyWHrs WHERE Cd = @v_Cd) = 0
	    Begin
	        insert into CompanyWHrs (Cd, Narr, FromDt, ToDt, CoCd, DutyHrs, HolTyp, RelgTyp, EntryBy)
		values(
	        	@v_Cd
		,	@v_Narr
		,	@v_FromDt
		,	@v_ToDt
		,	@v_CoCd
		,	@v_DutyHrs
		,	@v_HolTyp
		,	@v_RelgTyp
		,	@v_EntryBy)
		exec GetMessage 1,'Inserted successfully'
	    End
	IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	    Begin
	        Update CompanyWHrs
	          Set		       	
			Narr = @v_Narr             	
		,	FromDt =@v_FromDt               	
		,	ToDt = @v_ToDt              	               
		,	DutyHrs=@v_DutyHrs              	
		,	HolTyp=@v_HolTyp               
		,	RelgTyp=@v_RelgTyp          	
		,	EntryBy = @v_EntryBy  
		where Cd = @v_Cd
		exec GetMessage 1,'Updated successfully'
	    End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyEarnDed_Update_N]
	@v_Cd			Char(5)
,	@v_Typ			Char(10)
,	@v_Abbr			Char(10)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(30)
,	@v_PercAmt		Char(1)
,	@v_PercVal		Numeric(5,2)
,	@v_EntryBy		Char(5)
,	@v_TrnTyp		Char(1)
,	@v_LoanTyp		Char(1)
,	@v_JobFlag		Char(1)
,	@v_Ot			Char(1)
,	@v_OtCd			Char(1)
,	@v_Mode			Char(1)=Null
As		-- Drop Procedure [dbo].[CompanyEarnDed_Update_N]
Begin
	--	declare @v_Typ Char(10)
	--	select 	@v_Typ=cd from SysCodes where SDes=@v_TypDes and Typ='HEDT'
	set nocount on
	IF (SELECT COUNT(*) FROM CompanyEarnDed WHERE Cd = @v_Cd and Typ=@v_Typ) = 0
	  Begin
		Insert into CompanyEarnDed
		Values(
			@v_Cd
		,	@v_Typ
		,	@v_Abbr
		,	@v_SDes
		,	@v_Des
		,	@v_PercAmt
		,	@v_PercVal
		,	@v_EntryBy
		,	getdate()
		,	null
		,	null
		,	@v_TrnTyp
		,	@v_LoanTyp
		,	@v_JobFlag
		,	@v_Ot
		,	@v_OtCd)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else
		IF (@v_Mode = 'I')
			exec GetMessage 0,'Already exists'
		Else
		  Begin
			Update CompanyEarnDed
			Set
     			SDes=@v_SDes
			,	Abbr=@v_Abbr
			,	Des=@v_Des
			,	PercAmt=@v_PercAmt
			,	PercVal=@v_PercVal
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			,	TrnTyp=@v_TrnTyp
			,	LoanTyp=@v_LoanTyp
			,	JobFlag=@v_JobFlag
			,	OverTime=@v_Ot
			,	OtCd=@v_OtCd
         	Where
				Cd = @v_Cd 
			and Typ=@v_Typ
			exec GetMessage 1,'Updated successfully'
		  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Country_Update_N]
	@v_Cd			Char(5)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(40) 
,	@v_Nat			Varchar(20)
,	@v_Region		Varchar(20)
,	@v_Provisions	Numeric(18,0)
,	@v_EntryBy		Char(5)
,	@v_Mode			Char(1) = null
As
Begin		-- Drop procedure [dbo].[Country_Update_N]
	set nocount on
	IF NOT EXISTS (SELECT 1 FROM Country WHERE Cd = @v_Cd)
		Begin
			insert into Country values(
			@v_Cd,
			@v_SDes,
			@v_Des,
			@v_Nat,
			@v_Region,			
			@v_EntryBy,
			getdate(),
			null,
			null,
			@v_Provisions)
			exec GetMessage 1,'Inserted successfully'
		End
	Else
		IF (@v_Mode= 'I')
			exec GetMessage 0,'Already exists'
		Else
		  Begin
			Update Country
			  Set
			  SDes                = 	@v_SDes,
			  Des                 = 	@v_Des,
			  Nat                 =		@v_Nat,
			  Region              = 	@v_Region,
			  Provisions		  =		@v_Provisions,
			  EditBy              = 	@v_EntryBy,
			  EditDt              = 	getdate()
			  where Cd = @v_Cd
			  exec GetMessage 1,'Updated successfully'
		  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Currency_Update_N]
	@v_Cd			Char(5)
,	@v_Des			Varchar(30)
,	@v_MainCurr		Char(15)
,	@v_SubCurr		Char(10)
,	@v_NoDecs		Numeric(1)
,	@v_Rate			Numeric(15,10)
,	@v_Symbol		Char(5)
,	@v_Abbr			Char(5)
,	@v_EntryBy		Char(5)
,	@v_CoCd			Char(5)
,	@v_Mode			Char(1) = null
As		-- Drop procedure Currency_Update_N
Begin
If (SELECT COUNT(*) FROM Currency WHERE Cd = @v_Cd) = 0
  Begin
	insert into Currency (Cd,[Des],MainCurr,SubCurr,NoDecs,Rate,
				Symbol,Abbr,EntryBy,EntryDt,HrCurr)
	Values(@v_Cd, @v_Des, @v_MainCurr, @v_SubCurr, @v_NoDecs,
		@v_Rate, @v_Symbol, @v_Abbr, @v_EntryBy, getdate(),'Y')
--	Update CurrencyRates Set Rate=@v_Rate Where CurrCd=@v_Cd and
--		CoCd in (Select Cd from Company Where BaseCurr=(Select Min(BaseCurr) From Company))
	insert into CurrencyRates Values(@v_CoCd,@v_Cd,@v_Rate)
	exec GetMessage 1,'Inserted successfully'
  End
Else
  IF (@v_Mode = 'I')
	exec GetMessage 0,'Already exists'
  Else
	Begin
		Update Currency
		Set
			Cd			= @v_Cd,
			Des			= @v_Des,
			MainCurr	= @v_MainCurr,
			SubCurr		= @v_SubCurr,
			NoDecs		= @v_NoDecs,
			Rate		= @v_Rate,
			Symbol		= @v_Symbol,
			Abbr		= @v_Abbr,
			EditBy		= @v_EntryBy,
			EditDt		= getdate()
		Where
			Cd = @v_Cd
		Update CurrencyRates Set Rate=@v_Rate Where CurrCd =@v_Cd and CoCd =@v_CoCd
		exec GetMessage 1,'Updated successfully'
	  End
End
 
 
 
 Go 
CREATE OR ALTER     procedure [dbo].[Country_Delete_N]
@v_Cd Char(5)
As
Begin
	IF NOT EXISTS (select 1 from Employee where Nat=@v_Cd)
		BEGIN
			Delete from Country where Cd = @v_Cd
			exec GetMessage 1,'Deleted successfully'
		END
	ELSE
		exec GetMessage 0,'Can not delete'
End 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Dept_Update_N]
	@v_Cd			Char(10)
,	@v_SDes			Varchar(20)
,	@v_Des			Varchar(30)
,	@v_EntryBy		Char(5)
,	@v_Mode			Char(1) = null
As
Begin
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Dept WHERE Cd = @v_Cd)
	  Begin
		Insert into Dept Values
		(
			@v_Cd,
			@v_SDes,
			@v_Des,
			@v_EntryBy,
			getdate(),
			null,
			null
		)
		exec GetMessage 1,'Inserted successfully'
	  End
	Else
		IF (@v_Mode = 'I')
			exec GetMessage 0,'Already exists'
		Else
		  Begin
			Update Dept
			Set
				SDes			= @v_SDes,
				Des				= @v_Des,
				EditBy			= @v_EntryBy,
				EditDt			= getdate()
			Where
				Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
		  End
			
End
 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[Branch_Update_N]
    @v_Cd VARCHAR(50),
    @v_CoCd VARCHAR(50),
    @v_SDes VARCHAR(20),
    @v_Des VARCHAR(30),
    @v_EntryBy VARCHAR(50),
    @v_BU_Cd VARCHAR(50),
    @v_Image VARCHAR(200),
	@v_Mode Char(1)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Branch] WHERE Cd = @v_Cd)
    BEGIN
		 INSERT INTO [dbo].[Branch] (Cd, CoCd, SDes, [Des], EntryBy, EntryDt, BU_Cd, [Image])
        VALUES (@v_Cd, @v_CoCd, @v_SDes, @v_Des, @v_EntryBy, GETDATE(), @v_BU_Cd, @v_Image);
		exec GetMessage 1,'Inserted successfully'
    END
	Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
    ELSE
    BEGIN
        UPDATE [dbo].[Branch]
        SET CoCd = @v_CoCd,
            SDes = @v_SDes,
            [Des] = @v_Des,
            EditBy = @v_EntryBy,
            EditDt = GETDATE(),
            BU_Cd = @v_BU_Cd,
            [Image] = @v_Image
        WHERE Cd = @v_Cd;
		exec GetMessage 1,'Updated successfully'
    END
END



 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Users_Update_N]
		@v_Cd			varchar(10)=null
	,	@v_LoginId		varchar(15)=null
	,	@v_Abbr			varchar(5)=null
	,	@v_UPWD			varchar(200)=null
	,	@v_UName		varchar(30)=null
	,	@v_ExpiryDt		varchar(10)=null
	,	@v_EntryBy		varchar(5)=null
	,   @v_Mode			char(1) = null
As	
Begin	
	Set nocount on
	IF NOT EXISTS (SELECT 1 FROM Users WHERE Cd = @v_Cd)
		Begin
			Insert into Users (Cd, LoginId, Abbr, UPwd, UName, ExpiryDt, EntryBy, EntryDt)
			Values (@v_Cd, @v_LoginId, @v_Abbr, @v_UPWD, @v_UName, @v_ExpiryDt, @v_EntryBy, Getdate())
			exec GetMessage 1,'Inserted successfully'
		End
	Else
		IF (@v_Mode = 'I')
			exec GetMessage 0,'Already Exists'
		Else
		  Begin
			Update Users
			Set
				LoginId = @v_LoginId
			,	Abbr=@v_abbr
			,	Uname=@v_UName
			,   UPWD=@v_UPWD
			,	expirydt=@v_ExpiryDt
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
  			Where
				Cd = @v_Cd
			exec GetMessage 1,'Updated successfully'
		  End
End
 
 
 
 Go 
-- =============================================
-- Author:		<Author,,Name>
-- CREATE OR ALTER OR ALTER OR ALTER date: <CREATE OR ALTER OR ALTER OR ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER     PROCEDURE GetMessage_N
	@success bit,
	@message VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select @success success,@message [message]
END
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Codes_Auto_GetRow_N]
	@v_Typ	char(5)      
As		-- Drop Procedure dbo.Codes_Auto_GetRow_N 'BANK'
Begin
	Declare @Len int
	Declare @LenCodes int
	Select @LenCodes=Val From Parameters where Cd='LEN_CODES'
	set @Len=Len(Ltrim(Rtrim(@v_Typ)))
	if (Select Count(1) From CodeGroups where Cd=@v_Typ) <> 0
		Select 
			Right('0000000000'+ Isnull(Rtrim(Max(Right(Ltrim(Rtrim(Cd)),Len(Ltrim(Rtrim(Cd)))-@Len))+1),1), @LenCodes)[NewCode]
		From
			Codes
		Where
			Typ=@v_Typ
	else
		Select Cd From Codes where 1=2
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[CompanyOvertimeRates_GetRow_N]
	@v_CoCd	Char(5) = null,
	@v_Typ Char(10) = null,
	@v_SrNo		numeric(3,0) = 0
As	-- Drop procedure CompanyOvertimeRates_GetRow_N
Begin
	Select
		(Select SDes from Syscodes where Cd=OTR.Typ)[Type]
	,	SrNo
	,	HrsApply
	,	Rate
	,	Sdes
	,	Narr
	,	CoCd
	,	(Select SDes from Syscodes where Cd=OTR.HolTyp)[HolTyp]
	,	(Select SDes from CompanyEarnDed where Cd=OTR.PayCd and Typ='HEDT01')[PayCd]
	,	EntryBy					
	,	EntryDt
	,	EditBy
	,	EditDt
	,	Typ[TypCd]
	,	HolTyp[HolTypCd]
	,	PayCd[PayCode]
	From
		CompanyOvertimeRates OTR
	Where
		(@v_Typ= '' or Typ=@v_Typ) and (@v_CoCd = '' or CoCd=@v_CoCd) and (@v_SrNo= 0 or Srno=@v_SrNo)
	Order by
		Typ
	,	HrsApply
End
 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[CompanyOvertime_GetRow_N]
	@v_CoCd	Char(5)
As	-- Drop procedure CompanyOvertime_GetRow_N
	Select
		Cd
	,	Sdes
	,	Des
	,	Week_OTRate
	,	Off_OTRate
	,	Hol_OTRate
	,	DutyHrs
	,	CoCd
	,	EntryBy					
	,	EntryDt
	,	EditBy
	,	EditDt
	From
		CompanyOvertime
	Where	
		CoCd=@v_CoCd
	Order by
		Cd
 
 
 
 Go 
-- select * from users userbranch sp_help users
CREATE OR ALTER     Procedure [dbo].[Users_Delete_N]
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
 
 
 
 Go 

CREATE OR ALTER     procedure [dbo].[CompanyWHrs_GetRow_N]
	@v_Cd		Char(5)
,	@v_CoCd		Char(5)
As		-- Drop Procedure [CompanyWHrs_GetRow_N]
   Begin
	Select
		CWH.Cd[Code]
	,	CWH.Narr[Narr]
	,	case CWH.FromDt
		when '01/01/1900' then null
		else CWH.FromDt
		end [FromDt]
	,	case CWH.ToDt
		when '01/01/1900' then null
		else CWH.ToDt
		end [ToDt]
		
		,	case CWH.FromDt
		when '1/1/1900' then null
		else  CONVERT(varchar(20), CWH.FromDt,103)
		end [FormattedFromDate]
	,	case CWH.ToDt
		when '1/1/1900' then null
		else CONVERT(varchar(20),CWH.ToDt,103)
		end [FormattedToDate]
		
	,	CWH.DutyHrs[DutyHrs]
	,	(select SDes FROM SysCodes where cd=CWH.RelgTyp)[Religion]
	,	(Select sdes from Syscodes where Cd=CWH.HolTyp)[HolTypDesc]
	,	RelgTyp[RelgTypCd]
	,	HolTyp[HolTypCd]
	From
		CompanyWHrs CWH
	Where
		(@v_Cd = '' or @v_Cd <> '' and Cd=@v_Cd)
	and 	(@v_CoCd = '' or @v_CoCd <> '' and CoCd=@v_CoCd)
   End

 
 
 
 Go 

CREATE OR ALTER     Procedure [dbo].[Users_GetRow_N]
	@v_Cd		Varchar(10)
As		-- Drop Procedure [dbo].[Users_GetRow_N] ''
Begin	-- Select * from sp_help users
	Select
		U.Cd[Code]
	,	U.Abbr[Abbr]
	,	U.LoginId[LoginId]
	,	U.UPwd
	,	U.UName[UserName]
	,	U.Expirydt[ExpiryDt]
	,	U.EntryBy
	,	U.EntryDt
	,	U.EditBy
	,	U.EditDt
	From
		Users U
	Where
		(@v_Cd='' or U.Cd=@v_Cd)
	Order by
		U.Cd
End
 
 
 
 Go 
CREATE OR ALTER     PROCEDURE [dbo].[Validate_Employee_N]
	@v_EMPID varchar(30)
,	@v_PWD varchar(200) 
As	-- Drop PROCEDURE [dbo].[Validate_Employee_N] 'admin','MTIzNDU2'
--select * from Employees
Begin
	-- SET NOCOUNT ON added to prevent extra result sets 
	-- from interfering with SELECT statements.
	SET NOCOUNT ON
	Select * from Employee where Cd = @v_EMPID and Pwd = @v_PWD
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[GetRepo_EmpTransactionDetail_1_N]    
	@v_CoCd   Char(5)   
,	@v_EmpCd char(10)   
,	@v_RFrmPrd  Char(6)   
,	@v_RToPrd  Char(6)   
As    -- Drop Procedure [GetRepo_EmpTransactionDetail] '01','dtd00595','202110','202203'  
Begin     

/*
declare @v_CoCd   Char(5)   
declare @v_EmpCd char(10)   
declare @v_RFrmPrd  Char(6)   
declare @v_RToPrd  Char(6)
Select @v_CoCd   ='01' 
Select @v_EmpCd ='001' 
Select @v_RFrmPrd  ='201001'   
Select @v_RToPrd  ='201506'
*/

Declare @Prd int   
Declare @Year int   
Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd='01'   
Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd='01'         
	Select Cd[Cd]     
	, rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	, (select SDes from Branch where Cd=Employee.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period]  
	from Employee    
	where Cd=@v_EmpCd               
	
If @Year *100 +@Prd between @v_RFrmPrd and @v_RToPrd        
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,@Prd), 0 ) - 1 ))[Month]    
	, @Year[Yr]    
	, convert(char(4),@Year)+ +right ('00'+ltrim(str( @Prd)),2 )[Prd]
	, Isnull(Emp.Basic,0)+ IsNull((Select sum(Amt) from EmpTrans where EdCd<>'001' and EdTyp='HEDT01' and EmpCd=emp.Cd),0)[Eligible]    
	, Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd),0)[LOP]  
	, IsNull((select Amt from EmpTrans where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd),0)[LS]   
	, IsNull((select Amt from EmpTrans where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd),0)[LT] 
	, IsNull((select sum(Amt) from EmpTrans where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd),0)[Recovery]    
	, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=@Year *100 +@Prd and EmpCd=@v_EmpCd),0)[Advance]    
	From     EmpTrans EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd     
	group by emt.EmpCd,emp.Basic,emp.Cd  
	
	
union       
	

Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	, left(Prd,4)[Yr] 
	, EmT.Prd  [Prd] 
	, Isnull(Emp.Basic,0)+ IsNull((Select sum(Amt) from EmpTransYtd where EdCd<>'001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[Eligible]    
	, Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LOP]
	, IsNull((select Amt from EmpTransYtd where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LS]   
	, IsNull((select Amt from EmpTransYtd where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LT]     
	, IsNull((select sum(Amt) from EmpTransYtd where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd and Prd=EmT.Prd),0)[Recovery]    
	, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=EmT.Prd and EmpCd=@v_EmpCd),0)[Advance]    
	From     EmpTransYtd EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by EmT.EmpCd,Prd,emp.Basic,emp.Cd  
	order by  Prd asc
	
else       

Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	, left(Prd,4)[Yr] 
	, emt.Prd    [Prd]
	,format( Isnull(Emp.Basic,0)+ IsNull((Select sum(Amt) from EmpTransYtd where EdCd<>'001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=emt.Prd),0),'###,###,###.###')[Eligible]    
	, format(Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=emt.Prd),0),'###,###,###.###')[LOP]  
	, format(IsNull((select Amt from EmpTransYtd where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0),'###,###,###.###')[LS]   
	, format(IsNull((select Amt from EmpTransYtd where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0),'###,###,###.###')[LT]   
	, format(IsNull((select sum(Amt) from EmpTransYtd where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd and Prd=emt.Prd),0),'###,###,###.###')[Recovery]    
	, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=EmT.Prd and EmpCd=@v_EmpCd),0)[Advance]    
	From     EmpTransYtd EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and emt.Prd between @v_RFrmPrd and @v_RToPrd     
	group by emt.EmpCd,Prd,emp.Basic,emp.Cd     
	order by Prd asc      
	
	--EdCd ='004' and
End 
 
 
 Go 
CREATE OR ALTER       Procedure [dbo].[GetRepo_EmpTransactionDetail_New]    
	@v_CoCd   Char(5)   
,	@v_EmpCd char(10)   
,	@v_RFrmPrd  Char(6)   
,	@v_RToPrd  Char(6)   
As    -- Drop Procedure [GetRepo_EmpTransactionDetail_New] '01','101','202110','202310'  
Begin     

/*
declare @v_CoCd   Char(5)   
declare @v_EmpCd char(10)   
declare @v_RFrmPrd  Char(6)   
declare @v_RToPrd  Char(6)
Select @v_CoCd   ='01' 
Select @v_EmpCd ='001' 
Select @v_RFrmPrd  ='201001'   
Select @v_RToPrd  ='201506'
*/

Declare @Prd int   
Declare @Year int   
Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd='01'   
Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd='01'         
	--Select Cd[Cd]     
	--, rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	--, (select SDes from Branch where Cd=Employee.Div) [Branch]
	--, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	--  +left(@v_RFrmPrd,4)     
	--  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	--  +left(@v_RToPrd,4)[Period]  
	--from Employee    
	--where Cd=@v_EmpCd               
	
If @Year *100 +@Prd between @v_RFrmPrd and @v_RToPrd        
Begin
Select      
	 
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	,	left(Prd,4)[Yr] 
	,	 EmT.Prd  [Prd] 
	,	emt.EdTyp
	,	sum(amt)[Amt]
	,	emt.EdCd
	,	(select upper(trim(SDes)) from CompanyEarnDed where cd=edcd and typ=EdTyp)[Component]	
	,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName) +' '+rtrim(Emp.Lname)[EmpName]    
	,	(select SDes from Branch where Cd=Emp.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period]  
	into	#EmpTransYtd
	From     EmpTransYtd EmT  , Employee Emp    
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by Prd,edcd,edtyp	,Fname,Mname,Lname,Div
	
union       

Select   
	(Select DateName( month , DateAdd( month ,convert (numeric,@Prd), 0 ) - 1 ))[Month]    
	, @Year[Yr]    
	, convert(char(4),@Year)+ +right ('00'+ltrim(str( @Prd)),2 )[Prd]
	,	emt.EdTyp
	,	sum(amt)[Amt]
	,	emt.EdCd
	,	(select upper(trim(SDes)) from CompanyEarnDed where cd=edcd and typ=EdTyp)[Component]
	,	rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	,	(select SDes from Branch where Cd=Emp.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	
	From	EmpTrans EmT     , Employee Emp     
	where	emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd     
	group by emt.EmpCd,edcd,EdTyp,Fname,Mname,Lname,Div
	order by  Prd asc

	select * from #EmpTransYtd  order by  Month asc
	drop table #EmpTransYtd
End
else       
Begin
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	,	left(Prd,4)[Yr] 
	,	 EmT.Prd  [Prd] 
	,	emt.EdTyp
	,	sum(amt)[Amt]
	,	emt.EdCd
	,	(select upper(trim(SDes)) from CompanyEarnDed where cd=edcd and typ=EdTyp)[Component]	
	,	rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	,	(select SDes from Branch where Cd=Emp.Div) [Branch]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	into	#EmpTransYtd1
	From     EmpTransYtd EmT     , Employee Emp    
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by emt.EmpCd,edcd,EdTyp,Prd,Fname,Mname,Lname,Div
	order by  Prd asc
	select * from #EmpTransYtd1 order by  Month asc
	drop table #EmpTransYtd1
	--EdCd ='004' and
	End
End 
 
 
 Go 


CREATE OR ALTER     procedure  [dbo].[EmpAttendance_Getrow_N]
	@v_EmpCd		Char(10)
--,	@v_DivCd		Char(10)
,	@v_DivCd		Char(5)
,	@v_DeptCd		Char(10)
,	@v_Prd			Char(6)
,	@v_CoCd			char(5) --select div from employee where cd='MHM/1008'
 as
-- Drop Procedure [dbo].[EmpAttendance_Getrow_N] '101','15','','202303','01' 
Begin  
/*	declare @v_EmpCd  char(10)  
	declare @v_DivCd  Char(5)  
	declare @v_DeptCd  Char(10)  
	declare @v_Prd   char(6)  

	set @v_EmpCd = ''  
	set @v_DivCd = ''  
	set @v_DeptCd = ''  
	set @v_Prd  = '201503'
*/
	Declare @LoanDedDiv			Char(1)
	Select @LoanDedDiv=Val  From Parameters Where Cd='LOAN_DED_DIV' and CoCd=@v_CoCd
	if (Select Count(1) from EmpAttendance where Prd=@v_Prd and Div=@v_DivCd And (EmpCd=@v_EmpCd or @v_EmpCd='') and TrnInd='S')<>0  
	  Begin
		Select  
			Emp.Cd  
		,	Emp.Fname +' '+Emp.Mname+' '+Emp.Lname[EmpName]  
		,	@v_Prd[Period]  
		,	EmpAtt.W_days  
		,	EmpAtt.P_HDays  
		,	EmpAtt.Up_HDays  
		,	EmpAtt.NHrs  
		,	EmpAtt.CHrs  
		,	EmpAtt.W_OT  
		,	EmpAtt.O_OT  
		,	EmpAtt.H_OT  
		,	EmpAtt.C_OT  
		,	(EmpAtt.W_days - (EmpAtt.Up_HDays+EmpAtt.P_HDays))[Payable] 
		,	isnull((select sum(AmtVal) from EmpLoanDetail 
			where EmpCd=Emp.Cd and Typ='D'
			and (select LoanStatus from EmpLoan where TransNo=EmpLoanDetail.TransNo)='D'
			and (select RecoMode from EmpLoan where TransNo=EmpLoanDetail.TransNo)='HLREC03'
			and CAST(DATEPART(YYYY, EffDate)*100+ DATEPART(mm, EffDate) AS varchar(6))=@v_prd
			and CAST(DATEPART(YYYY, EndDate)*100+ DATEPART(mm, EndDate) AS varchar(6))=@v_prd
			and		((@LoanDedDiv='O' and Transno in (select EL.TransNo from EmpLoan EL where EL.HrDiv=@v_DivCd))
					or (@LoanDedDiv='N' and EmpCd in (select E.Cd from Employee E where E.Div=@v_DivCd)))
						),0)[LoanDed]
		From
			Employee Emp Left Join EmpAttendance EmpAtt on Emp.Cd=EmpAtt.EmpCd And EmpAtt.Prd=@v_Prd
		Where
			(Emp.Cd=@v_EmpCd or @v_EmpCd='') 
		and (@v_DivCd='' or @v_DivCd<>'' and EmpAtt.Div=@v_DivCd)
		and (@v_DeptCd='' or @v_DeptCd<>'' and EmpAtt.Dept=@v_DeptCd) 
		and Emp.CalcBasis <> 'H'  
		and Emp.Active='Y'
		and Emp.Status not in ('HSTATNP','HSTATSR','HSTATST','HSTATES')
		and Emp.Cd not in (select Empcd from empattendance where TrnInd='*S')
		Order by  
		Emp.Cd 
	  end
	Else
	  Begin
		declare @month char(2)
		declare @year char(4)
		set @month=(select right( @v_prd,2))
		set @year=(select left( @v_prd,4))
		declare @W_days numeric(2,0)
		declare @ActualW_days numeric(2,0)
		exec @ActualW_days = Get_Eday @month,@year
		--------------  changed to aljessour only,bcoz they need 30 as no of days in a month always-----------------------------
		--if(@v_CoCd='01' and (select CoName from Company where Cd=@v_CoCd)='Al Jessour Bldg. Materials trading LLC')
		if((select val from Parameters where Cd='MNTHDAYS2')='30')
		set @W_days=30
		else exec @W_days = Get_Eday @month,@year
		

		
		 
		----------------------------------------------------------------------------Emp transfer at middle of month		
		CREATE table dbo.#WorkingDaysTemp
		(	EmpCd char(10)  ,
			NoOfDays  numeric(18,0),
			DivCd  Char(10) 
		)

		CREATE table dbo.#WorkingDays
		(	EmpCd char(10) collate Latin1_General_CI_AS,
			NoOfDays  numeric(18,0),
			DivCd  Char(10) 
		)

		CREATE table dbo.#EmpEmpTransfer
		(	EmpCd char(10)  collate SQL_Latin1_General_CP1_CI_AS,
			SlNo numeric(18,0)   identity  
		)
  
		insert into dbo.#EmpEmpTransfer select distinct EmpCd from EmpTransfers where EmpCd in (select Cd from Employee where Doj<=cast( @month+'/'+ cast(@ActualW_days as char(2))+'/'+@year as datetime) and div=@v_DivCd)

		Declare @Start numeric(18,0)
		set @Start =1
		while(@Start<=(select COUNT(1) from dbo.#EmpEmpTransfer))
		Begin
			declare @count numeric(18,0)
			set @count=(select COUNT(*) from EmpTransfers where EmpCd=(select EmpCd from #EmpEmpTransfer where SlNo=@Start)
					 and EmpCd in (select Cd from Employee where Doj<=cast( @month+'/'+ cast(@ActualW_days as char(2))+'/'+@year as datetime))
					 and DATEPART(MM,TransferDt)=(select right( @v_prd,2))
					 and DATEPART(YYYY,TransferDt)=(select left( @v_prd,4)))
			declare @Previouscount numeric(18,0)
			set @Previouscount=(select COUNT(*) from EmpTransfers where EmpCd=(select EmpCd from #EmpEmpTransfer where SlNo=@Start)
					 and EmpCd in (select Cd from Employee where Doj<=cast( @month+'/'+ cast(@ActualW_days as char(2))+'/'+@year as datetime))
					 and ((DATEPART(YYYY,TransferDt)*100)+DATEPART(MM,TransferDt))< @v_prd)
			 if(@count>0)
			 BEGIN
			declare @StartSrNo numeric(18,0)
			set @StartSrNo =1
			while(@StartSrNo<=@count)
			Begin
				if( @StartSrNo+@Previouscount=1+@Previouscount)
		
				begin
					if((select CONVERT(varchar(20),TransferDt,103) from EmpTransfers where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start) and SrNo=@StartSrNo+@Previouscount)<>'01' +'/'+SUBSTRING(@v_Prd,5,2)+'/'+SUBSTRING(@v_Prd,1,4) )
					Begin
						insert into dbo.#WorkingDaysTemp
						select EmpT.EmpCd
						,(select case when (EmpT.TransferDt>=(select Doj from employee where Cd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start))
										and DATEPART(MM,EmpT.TransferDt)=(select DATEPART(MM,Doj) from employee where Cd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start))
										and DATEPART(YYYY,EmpT.TransferDt)=(select DATEPART(YYYY,Doj) from employee where Cd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)))
						then (datepart(DD,EmpT.TransferDt)-1-(select datepart(dd,Doj)-1 from employee where Cd=EmpT.EmpCd))
						else (datepart(DD,EmpT.TransferDt)-1) end)[NoOfDays]
						--,datepart(DD,TransferDt)-1[NoOfDays]
						,BrFrom [Branch] 
						from EmpTransfers as EmpT
						where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)
						and SrNo=@StartSrNo+@Previouscount
				
						insert into dbo.#WorkingDaysTemp
						select EmpT.EmpCd
						,(select datepart(DD,TransferDt) from EmpTransfers where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)and SrNo=@StartSrNo+@Previouscount+1)-datepart(DD,TransferDt)[NoOfDays]
						,BrTo [Branch] 
						from EmpTransfers as EmpT
						where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)
						and SrNo=@StartSrNo+@Previouscount
					end
					else
					begin
						insert into dbo.#WorkingDaysTemp
						select EmpT.EmpCd
						,(select datepart(DD,TransferDt) from EmpTransfers where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)and SrNo=@StartSrNo+@Previouscount+1)-datepart(DD,TransferDt)[NoOfDays]
						,BrTo [Branch] 
						from EmpTransfers as EmpT
						where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)
						and SrNo=@StartSrNo+@Previouscount
					end
				end
				if( @StartSrNo+@Previouscount=@count+@Previouscount)
		
				begin
					if((select CONVERT(varchar(20),TransferDt,103) from EmpTransfers where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start) and SrNo=@StartSrNo+@Previouscount)<>CONVERT(varchar(10),@ActualW_days ) +'/'+SUBSTRING(@v_Prd,5,2)+'/'+SUBSTRING(@v_Prd,1,4) )
					Begin
						insert into dbo.#WorkingDaysTemp
						select EmpT.EmpCd
						,(@W_days-datepart(DD,TransferDt))+1[NoOfDays]
						,BrTo [Branch] 
						from EmpTransfers as EmpT
						where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)
						and SrNo=@StartSrNo+@Previouscount
					end
					else
					Begin
						insert into dbo.#WorkingDaysTemp
						select EmpT.EmpCd
						,1[NoOfDays]
						,BrTo [Branch] 
						from EmpTransfers as EmpT
						where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)
						and SrNo=@StartSrNo+@Previouscount
					end
				end
				if( @StartSrNo+@Previouscount<>@count+@Previouscount and @StartSrNo+@Previouscount<>1+@Previouscount)
				begin
					insert into dbo.#WorkingDaysTemp
					select EmpT.EmpCd
					,(select datepart(DD,TransferDt) from EmpTransfers where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)and SrNo=@StartSrNo+@Previouscount+1)-datepart(DD,TransferDt)[NoOfDays]
					,BrTo [Branch] 
					from EmpTransfers as EmpT
					where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)
					and SrNo=@StartSrNo+@Previouscount
				end
				set @StartSrNo=@StartSrNo+1
			end
			END
			else if(@Previouscount>0)
			BEGIN
					insert into dbo.#WorkingDaysTemp
					select (select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start)[EmpCd]
					--,(select case when (EmpT.TransferDt>=(select Doj from employee where Cd=EmpT.EmpCd))
					--then (@W_days-(select datepart(dd,Doj)-1 from employee where Cd=EmpT.EmpCd))
					--else (@W_days) end)[NoOfDays]
					,@W_days[NoOfDays]
					,(select TOP 1 BrTo from EmpTransfers where EmpCd=(select EmpCd from dbo.#EmpEmpTransfer where SlNo=@Start) and ((DATEPART(YYYY,TransferDt)*100)+DATEPART(MM,TransferDt))< @v_prd order by TransferDt DESC) [Branch] 
			END
			set @Start=@Start+1
		end

		insert into dbo.#WorkingDays
			Select EmpCd, Sum(NoOfDays), DivCd From dbo.#WorkingDaysTemp Group By EmpCd, DivCd 
			
		----------------------------------------------------------------------------Emp transfer at middle of month
		CREATE table dbo.#TempTable
		(	Cd char(10) collate Latin1_General_CI_AS,
			EmpName varchar(100),
			Period char(6),
			W_days numeric(5,0),
			P_HDays numeric(5,0),
			Up_HDays numeric(5,0),
			NHrs numeric(5,0),
			CHrs numeric(5,0),
			W_OT numeric(5,0),
			O_OT numeric(5,0),
			H_OT numeric(5,0),
			C_OT numeric(5,0),
			Payable numeric(5,0)
		)
		


		insert into dbo.#TempTable
		Select  
			Emp.Cd  
		,	Emp.Fname +' '+Emp.Mname+' '+Emp.Lname[EmpName]
		,	@v_Prd[Period]
		,	isnull((select NoOfDays from dbo.#WorkingDays where DivCd=@v_DivCd 
				and ((@v_EmpCd='' and EmpCd=Emp.Cd collate SQL_Latin1_General_CP1_CI_AS) or (@v_EmpCd<>'' and EmpCd=@v_EmpCd))),
				(case when (DATEPART(MM,Emp.Doj)=@month and DATEPART(YYYY,Emp.Doj)=@year) then (@W_days-DATEPART(DD,Emp.Doj)+1) else @W_days end)) [W_days]  
		,	isnull((case when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))=@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
					then DATEDIFF(dd,EmpL.WP_FromDt,EmpL.WP_ToDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))<>@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))<>@v_prd
					then 
						(case when cast(@v_prd as int) between DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt)
							and DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt)
							then @W_days
							else 0 end)
				when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))=@v_prd
				   or CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
					then case when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))=@v_prd
								then @W_days-DATEPART(dd, EmpL.WP_FromDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
							  when CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
								then DATEPART(dd, EmpL.WP_ToDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
					end
			end),0) [P_HDays]
		,	isnull((case when isnull(EmpL.JoinDt,'')=''
				then 
				(case when convert(varchar(20),EmpL.WOP_FromDt,103)='01/01/1900'
					then (case when CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
					then (@W_days-DATEPART(dd,EmpL.WP_ToDt))+(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))<@v_prd
					then @W_days end)
					when convert(varchar(20),EmpL.WP_FromDt,103)='01/01/1900'
					then (case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
					then (@W_days-DATEPART(dd,EmpL.WOP_FromDt))-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))<@v_prd
					then @W_days end)
					when (convert(varchar(20),EmpL.WP_FromDt,103)='01/01/1900' and convert(varchar(20),EmpL.WOP_FromDt,103)='01/01/1900')
					then @W_days
				else (case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
					then DATEDIFF(dd,EmpL.WOP_FromDt,EmpL.WOP_ToDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))<>@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))<>@v_prd
					then (case when cast(@v_prd as int) between DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt)
							and DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt)
							then @W_days
							else 0 end)
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
				   or CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
					then case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
								then @W_days-DATEPART(dd, EmpL.WOP_FromDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)+1  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
							  when CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
								then DATEPART(dd, EmpL.WOP_ToDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
						end
				end) 
				end) 
			else
			(case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
					then DATEDIFF(dd,EmpL.WOP_FromDt,EmpL.WOP_ToDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))<>@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))<>@v_prd
					then (case when cast(@v_prd as int) between DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt)
							and DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt)
							then @W_days
							else 0 end)
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
				   or CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
					then case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
								then @W_days-DATEPART(dd, EmpL.WOP_FromDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
							  when CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
								then DATEPART(dd, EmpL.WOP_ToDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
						end
				end) 
				end),0)as [Up_HDays] 
		,	((@W_days-
				isnull((case when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))=@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
					then DATEDIFF(dd,EmpL.WP_FromDt,EmpL.WP_ToDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))<>@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))<>@v_prd
					then 
						(case when cast(@v_prd as int) between DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt)
							and DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt)
							then @W_days
							else 0 end)
				when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))=@v_prd
				   or CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
					then case when CAST(DATEPART(YYYY, EmpL.WP_FromDt)*100+ DATEPART(mm, EmpL.WP_FromDt) AS varchar(6))=@v_prd
								then @W_days-DATEPART(dd, EmpL.WP_FromDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
							  when CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
								then DATEPART(dd, EmpL.WP_ToDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
					end
			end),0)-
				isnull((case when isnull(EmpL.JoinDt,'')=''
				then 
				(case when convert(varchar(20),EmpL.WOP_FromDt,103)='01/01/1900'
					then (case when CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))=@v_prd
					then (@W_days-DATEPART(dd,EmpL.WP_ToDt))-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WP_ToDt)*100+ DATEPART(mm, EmpL.WP_ToDt) AS varchar(6))<@v_prd
					then @W_days end)
					when convert(varchar(20),EmpL.WP_FromDt,103)='01/01/1900'
					then (case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
					then (@W_days-DATEPART(dd,EmpL.WOP_FromDt))-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))<@v_prd
					then @W_days end)
					when (convert(varchar(20),EmpL.WP_FromDt,103)='01/01/1900' and convert(varchar(20),EmpL.WOP_FromDt,103)='01/01/1900')
					then @W_days
				end) 
			else
			(case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
					then DATEDIFF(dd,EmpL.WOP_FromDt,EmpL.WOP_ToDt)+1-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))<>@v_prd
				   and CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))<>@v_prd
					then (case when cast(@v_prd as int) between DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt)
							and DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt)
							then @W_days
							else 0 end)
				when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
				   or CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
					then case when CAST(DATEPART(YYYY, EmpL.WOP_FromDt)*100+ DATEPART(mm, EmpL.WOP_FromDt) AS varchar(6))=@v_prd
								then @W_days-DATEPART(dd, EmpL.WOP_FromDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
							  when CAST(DATEPART(YYYY, EmpL.WOP_ToDt)*100+ DATEPART(mm, EmpL.WOP_ToDt) AS varchar(6))=@v_prd
								then DATEPART(dd, EmpL.WOP_ToDt)-(case when (EmpL.LvTyp='AL' and @ActualW_days=31 and (select val from Parameters where Cd='MNTHDAYS2')='30') then 1 else 0 end)  --changed to aljessour only,bcoz they need 30 as no of days in a month always--
						end
				end) 
				end),0)
				) * (select val from parameters where cd='WORKHRS' and CoCd=@v_CoCd))[NHrs]  
		--,	0 [W_days]
		--,	0 [P_HDays]
		--,	0 [Up_HDays]
		--,	0 [NHrs]
		,	0[CHrs]
		,	0[W_OT]  
		,	0[O_OT]  
		,	0[H_OT]  
		,	0[C_OT]  
		,	0[Payable]  
		From  
			Employee Emp 
			Left join EmpLeave as EmpL on EmpL.EmpCd=Emp.Cd 
				and ((EmpL.LvStatus ='J' and CAST(@v_Prd as int) between datepart(yyyy,EmpL.FromDt)*100+datepart(MM,EmpL.FromDt) and datepart(yyyy,EmpL.ToDt)*100+datepart(MM,EmpL.ToDt))
				or (EmpL.LvStatus ='F' and datepart(yyyy,EmpL.FromDt)*100+datepart(MM,EmpL.FromDt)<=CAST(@v_Prd as int) )) and EmpL.HrDiv=@v_DivCd  --- only to take the leave which are confirmed
			left join dbo.#WorkingDays as WD on WD.EmpCd=Emp.Cd collate SQL_Latin1_General_CP1_CI_AS and WD.NoOfDays<>0
					
		Where
			(Emp.Cd=@v_EmpCd or @v_EmpCd='')
		and	(@v_DivCd='' 
				or (@v_DivCd<>'' and WD.DivCd=@v_DivCd)
				or (@v_DivCd<>'' and Emp.Div=@v_DivCd))
		--		or (@v_DivCd<>'' and EmpT.BrFrom=@v_DivCd and DATEPART(DD,EmpT.TransferDt)<>'1')
		--		or (@v_DivCd<>'' and EmpT.BrTo=@v_DivCd and DATEPART(DD,EMPt.TransferDt)<>@ActualW_days)
		--		or (@v_DivCd<>'' and EmpL.HrDiv=@v_DivCd))
		and (@v_DeptCd='' or @v_DeptCd<>'' and Emp.Dept=@v_DeptCd) 
		and Emp.CalcBasis <> 'H'  
		and Emp.Active='Y'
		and Emp.Status not in ('HSTATNP','HSTATSR','HSTATST','HSTATES')
		and Emp.Doj<=cast( @month+'/'+ cast(@ActualW_days as char(2))+'/'+@year as datetime)
		and Emp.Cd not in (select Empcd from empattendance where TrnInd='*S')
							
		union
		
		Select  
			Emp.Cd  
		,	Emp.Fname +' '+Emp.Mname+' '+Emp.Lname[EmpName]
		,	@v_Prd[Period]
		,	@W_days-((select top 1 datepart(dd,JoinDt) from EmpLeave where EmpCd=Emp.Cd and datepart(yyyy,joindt)*100+datepart(MM,joindt)=@v_Prd order by joindt desc)-1)[W_days]  
		,	0[P_HDays]
		,	0[Up_HDays] 
		,	(@W_days-((select top 1 datepart(dd,JoinDt) from EmpLeave where EmpCd=Emp.Cd and datepart(yyyy,joindt)*100+datepart(MM,joindt)=@v_Prd order by joindt desc)-1))
				 * (select val from parameters where cd='WORKHRS' and CoCd=@v_CoCd)[NHrs]  
		,	0[CHrs]
		,	0[W_OT]  
		,	0[O_OT]  
		,	0[H_OT]  
		,	0[C_OT]  
		,	0[Payable]  
		From  
			Employee Emp 
			Left join EmpLeave as EmpL on EmpL.EmpCd=Emp.Cd 
				and ((EmpL.LvStatus ='J' and CAST(@v_Prd as int) between datepart(yyyy,EmpL.FromDt)*100+datepart(MM,EmpL.FromDt) and datepart(yyyy,EmpL.ToDt)*100+datepart(MM,EmpL.ToDt))
				or (EmpL.LvStatus ='F' and datepart(yyyy,EmpL.FromDt)*100+datepart(MM,EmpL.FromDt)<=CAST(@v_Prd as int) )) 
				and EmpL.HrDiv=@v_DivCd  --- only to take the leave which are confirmed
			left join dbo.#WorkingDays as WD on WD.EmpCd=Emp.Cd collate SQL_Latin1_General_CP1_CI_AS and WD.NoOfDays<>0
					
		Where
			(Emp.Cd=@v_EmpCd or @v_EmpCd='')
		and	(@v_DivCd='' 
				or (@v_DivCd<>'' and WD.DivCd=@v_DivCd)
				or (@v_DivCd<>'' and Emp.Div=@v_DivCd))
		and (@v_DeptCd='' or @v_DeptCd<>'' and Emp.Dept=@v_DeptCd) 
		and Emp.CalcBasis <> 'H'  
		and Emp.Active='Y'
		and Emp.Status not in ('HSTATNP','HSTATSR','HSTATST','HSTATES')
		and Emp.Doj<=cast( @month+'/'+ cast(@ActualW_days as char(2))+'/'+@year as datetime)
		and Emp.Cd in (select Empcd from empattendance where TrnInd='*S'
							and Empcd in (select Empcd from empleave where datepart(yyyy,joindt)*100+datepart(MM,joindt)=@v_Prd))
							
		Order by
			Emp.Cd 


--select * from dbo.#TempTable


		Select
			Cd
		,	EmpName
		,	Period
		--,	isnull(W_days,@W_days)[W_days]
		,	@W_days[W_days]
		,	sum(isnull(P_HDays,0))[P_HDays] 
		,	sum(isnull(Up_HDays,0))[Up_HDays]  
		,	sum(isnull(NHrs,0))[NHrs]
		,	CHrs
		,	W_OT
		,	O_OT
		,	H_OT
		,	C_OT
		,	(isnull(W_days,@W_days))-(sum(isnull(Up_HDays,0))+sum(isnull(P_HDays,0)))[Payable] 
		,	isnull((select sum(AmtVal) from EmpLoanDetail 
			where EmpCd=dbo.#TempTable.Cd collate SQL_Latin1_General_CP1_CI_AS and Typ='D'
			and (select LoanStatus from EmpLoan where TransNo=EmpLoanDetail.TransNo)='D'
			and (select RecoMode from EmpLoan where TransNo=EmpLoanDetail.TransNo)='HLREC03'
			and CAST(DATEPART(YYYY, EffDate)*100+ DATEPART(mm, EffDate) AS varchar(6))=@v_prd
			and CAST(DATEPART(YYYY, EndDate)*100+ DATEPART(mm, EndDate) AS varchar(6))=@v_prd
			--and (case when @LoanDedDiv='O' then Transno in (select EL.TransNo from EmpLoan EL where EL.HrDiv=@v_DivCd) 
			and		((@LoanDedDiv='O' and Transno in (select EL.TransNo from EmpLoan EL where EL.HrDiv=@v_DivCd))
					or (@LoanDedDiv='N' and EmpCd in (select E.Cd from Employee E where E.Div=@v_DivCd)))
						),0)[LoanDed]
		from
			dbo.#TempTable
		Group by
			Cd
		,	EmpName
		,	Period
		,	W_days
		--,	NHrs
		,	CHrs
		,	W_OT
		,	O_OT
		,	H_OT
		,	C_OT
		--order by cast(SUBSTRING(Cd,5,len(cd)-4) as int) asc
		--order by cast(SUBSTRING(Cd,5,len(cd)-4) as int) asc
		drop table dbo.#WorkingDaysTemp
		drop table dbo.#WorkingDays
		drop table  dbo.#EmpEmpTransfer
		drop table dbo.#TempTable

	  End
End  
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Notification_GetRow_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10) = ''
,	@v_SrNo				Numeric(3,0) = 0
,	@v_Doctyp			Char(10) = 0
,	@v_typ				Char(1) = 0
As		-- Drop Procedure [dbo].[Notification_GetRow_N]'01','HRPE2','1','1'
Begin	
	SELECT 
		CoCd
	,	ProcessId
	,	DocTyp
	,	(Select Des from Codes where Cd=DocTyp)[DocTypDes]
	,	SrNo
	,	(select Caption from MenuCtrl where ProcessId=NM.ProcessId)[NotificationType]
	,	NoOfDays
	,	EmailSubject
	,	case when BeforeOrAfter='B' then 'Before'
				else 'After' end[BeforeOrAfter]
	,	MessageBody
	,	(select STRING_AGG(trim(EmpCd), ',') from NotificationDetail where ProcessId = NM.ProcessId and DocTyp=NM.DocTyp)Attendees
	FROM NotificationMaster as NM
	WHERE  @v_typ='0'
	 or(CoCd = @v_CoCd and ProcessId= @v_ProcessId and SrNo=@v_SrNo and DocTyp=@v_Doctyp)
End 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Notification_Update_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_SrNo				Numeric(3,0)
,	@v_NoOfDays			Numeric(3,0)
,	@v_BeforeOrAfter	Char(1)
,	@v_EmailSubject		Varchar(100)
,	@v_MessageBody		Varchar(1000)
,	@v_DocTyp			Char(10)
,	@v_Mode			char(1)
As		-- Drop Procedure [dbo].[Notification_Update_N]'01','HRPE2','1','10','B','HDTYP0001','Passport first'
Begin	
	IF (SELECT COUNT(*) FROM NotificationMaster WHERE CoCd = @v_CoCd and ProcessId=@v_ProcessId and SrNo=@v_SrNo and DocTyp= @v_DocTyp) = 0
	  Begin
		Insert into NotificationMaster
		values(
			@v_CoCd
		,	@v_ProcessId
		,	@v_DocTyp
		,	@v_SrNo
		,	@v_NoOfDays
		,	@v_BeforeOrAfter
		,	@v_MessageBody
		,	@v_EmailSubject)
		exec GetMessage 1,'Inserted successfully'
	  End
	  Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
	Else
	  Begin
			Update NotificationMaster
			Set
			
		    NoOfDays		= @v_NoOfDays
		,   BeforeOrAfter	= @v_BeforeOrAfter
		,   MessageBody		= @v_MessageBody
		,	EmailSubject	= @v_EmailSubject
		Where
				CoCd			= @v_CoCd
		and		ProcessId		= @v_ProcessId
		and		SrNo			= @v_SrNo
		and		DocTyp		    = @v_DocTyp
		exec GetMessage 1,'Updated successfully'
	  End
End
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[Notification_Detail_Insert_N]
	@v_CoCd				Char(5)
,	@v_ProcessId		Varchar(10)
,	@v_DocTyp		char(10)
,	@v_SrNo				Numeric(3,0)
,	@v_EmpCd		Varchar(100)
As		-- Drop Procedure [dbo].[Notification_Detail_Insert_N]
Begin	
		Insert into NotificationDetail
		values(
			@v_CoCd
		,	@v_ProcessId
		,	@v_DocTyp
		,	@v_SrNo
		,	null
		,	@v_EmpCd)
End 
 
 
 Go 
CREATE OR ALTER    
 Procedure [dbo].[EmpCalendar_Update_N]
	@v_SrNo			int
,	@v_Empcd		varchar(10)
,	@v_Date			datetime
,	@v_Title		varchar(20)
,	@v_Holiday		bit
,	@v_Narr		varchar(50)
,	@v_EntryBy		varchar(5)
As			-- Drop Procedure EmpCalendar_Update
 Begin
	If (select count(*) from EmpCalendar_N where Empcd=@v_Empcd and SrNo = @v_SrNo)=0
	Begin
		insert into EmpCalendar_N(SrNo,Empcd,[Date],Holiday,Title,Narr,EntryBy,EntryDt) 
		Values(@v_SrNo,@v_Empcd,@v_Date,@v_Holiday,@v_Title,@v_Narr,@v_EntryBy,Getdate())
		exec GetMessage 1,'Inserted successfully'
		End
	Else
		Update EmpCalendar_N set
			Holiday=@v_Holiday,
			Title=@v_Title,
			[Date]=@v_Date,
			Narr=@v_Narr

		where 
			SrNo = @v_SrNo
			exec GetMessage 1,'Updated successfully'
   End 
 
 Go 
CREATE OR ALTER   Procedure [dbo].[Employee_LeaveHistory_N]
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
	   
	CREATE table #tempLvSalary
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
		
	CREATE table dbo.#Temp
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

 

		 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpFund_Approval_GetRow]
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
As		-- Drop Procedure [dbo].[EmpFund_Approval_GetRow] '','3','01','001','U'  
Begin	
	Declare @FinalAuth Char(10)	
	Select
		TransNo[TransNo]
	,	TransDt[TransDt] 
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmpCd]  
	,	Rtrim(FName)+' '+Rtrim(MName)+' '+Rtrim(LName) [Emp]
	,	Amount
	,	case when @v_Typ in ('1','4','3')
		then
		(select  SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval_Level]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(Case when((select  SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
			=(select Top 1 SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd order by SrNo Desc))
			then 
				(STUFF((SELECT ', ' + CAST((Select Fname From Employee where Cd=EmpCd) AS VARCHAR(10)) [text()]
				FROM CompanyProcessApprovalDetail as CPAD
				WHERE CPAD.ProcessId='HRPSS4' 
				and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
				and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
				and CPAD.CoCd=@v_CoCd
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '))
			End
		)
		end[Approvals]
	,Typ
	
		
	From	-- Modified by Rasheed( otherwise list all employees)
		EmpFund EL left outer join Employee Emp on EL.empcd=Emp.Cd
	Where	-- Modified by Rasheed (Need to show only new applications for approval)
		Emp.Cd=EL.EmpCd and Emp.CoCd=@v_CoCd
	
	and (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and EL.Status = 'N'  or
		@v_Typ='1' and TransNo=@v_Param and EL.Status = 'N'  or
		@v_Typ='2' and EL.empcd=@v_Param and EL.Status = 'N'  or
		@v_Typ='4' and TransNo=@v_Param and EL.Status = 'F'  or
		@v_Typ='3' and EL.Status = 'N' and TransNo in( select TransNo as LeaveApproval  from EmpFund
				inner join Employee as emp on emp.Cd=EmpFund.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS4' and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				EmpFund.Status='N' 
				and emp.CoCd=@v_CoCd
				and emp.Status='HSTATPM'
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select top 1 SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS4' and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select top 1 Cd from Employee where UserCd=@v_EmpCd))) )))
			
	)
	Order By
		TransNo
End
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[GetRepo_EmpTransactionDetail_N]    
	@v_CoCd   Char(5)   
,	@v_EmpCd char(10)   
,	@v_RFrmPrd  Char(6)   
,	@v_RToPrd  Char(6)   
As    -- Drop Procedure [GetRepo_EmpTransactionDetail_N] '01','523','202110','202310'  
Begin     

/*
declare @v_CoCd   Char(5)   
declare @v_EmpCd char(10)   
declare @v_RFrmPrd  Char(6)   
declare @v_RToPrd  Char(6)
Select @v_CoCd   ='01' 
Select @v_EmpCd ='001' 
Select @v_RFrmPrd  ='201001'   
Select @v_RToPrd  ='201506'
*/

Declare @Prd int   
Declare @Year int   
Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd='01'   
Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd='01'         
	--Select Cd[Cd]     
	--, rtrim(Fname) +' '+rtrim(MName) +' '+rtrim(Lname)[EmpName]    
	--, (select SDes from Branch where Cd=Employee.Div) [Branch]
	--, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	--  +left(@v_RFrmPrd,4)     
	--  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	--  +left(@v_RToPrd,4)[Period]  
	--from Employee    
	--where Cd=@v_EmpCd               
	
If @Year *100 +@Prd between @v_RFrmPrd and @v_RToPrd    
Begin
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,@Prd), 0 ) - 1 ))[Month]    
	, @Year[Yr]    
	, convert(char(4),@Year)+ +right ('00'+ltrim(str( @Prd)),2 )[Prd]
		, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	,Emp.Cd[Cd]     
		,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
		, (select SDes from Branch where Cd=emp.Div) [Branch]
	,	round((select isnull(sum(amt),0) from emptrans where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd ),2)[BasicSalaray]
	--,	round(IsNull((Select isnull(sum(Amt),0) from EmpTrans where EdTyp in('HEDT01 ','HEDT03') and edcd<>'STFFP' and TrnInd='M' and EmpCd=EmT.Empcd ),0),2)[ExtraMnthly]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where edcd not in('TMF1','TMF2','TMF3','004','PENSI','211','203','201  ') and EdTyp='HEDT02' and EmpCd=EmT.Empcd ),0),2)[Deductions]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='004' and EdTyp='HEDT02' and EmpCd=EmT.Empcd ),0),2)[Recovery]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('TMF1','TMF2','TMF3') and EdTyp='HEDT02' and EmpCd=EmT.Empcd  ),0),2)[TMF]

	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd ),0),2)[FOTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('052','051','004','FOTA')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[Allowance]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[LivingAllowance]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[OverTime]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in ('MGRIN','207' )  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[Incentives]

	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='053'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[LastSalary]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[StaffAdvGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('211','004','203','201  ')  and EdTyp='HEDT02' and EmpCd=EmT.Empcd  ),0),2)[StaffAdvCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('FUNDW','STFFP')  and EdTyp in('HEDT01','HEDT03') and EmpCd=EmT.Empcd  ),0),2)[StaffFundGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd  ),0),2)[StaffFundCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  ),0),2)[TMFPay]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd  ),0),2)[LSA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd in('LTA','008  ')   and EdTyp='HEDT03' and EmpCd=EmT.Empcd  ),0),2)[LTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTrans where EdCd='PENSI'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd  ),0),2)[Pension]
	into #EmpTrans
	From     EmpTrans EmT, Employee Emp     
	where	emp.Cd=@v_EmpCd 
			and emt.EmpCd=@v_EmpCd     
	group by emt.EmpCd,emp.Basic,emp.Cd  ,emp.Fname,emp.Mname,emp.Lname,emp.Div 
	
	
union       
	

Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	, left(Prd,4)[Yr] 
	, EmT.Prd  [Prd] 
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	,Emp.Cd[Cd]     
		,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
		, (select SDes from Branch where Cd=emp.Div) [Branch]
	--, Isnull(Emp.Basic,0)+ IsNull((Select sum(Amt) from EmpTransYtd where EdCd<>'001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[Eligible]    
	--, Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LOP]
	--, IsNull((select Amt from EmpTransYtd where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LS]   
	--, IsNull((select Amt from EmpTransYtd where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0)[LT]     
	--, IsNull((select sum(Amt) from EmpTransYtd where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd and Prd=EmT.Prd),0)[Recovery]    
	--, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=EmT.Prd and EmpCd=@v_EmpCd),0)[Advance]    
	,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and Prd=EmT.Prd),2)[BasicSalaray]

	--,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdTyp in('HEDT01 ','HEDT03') and edcd<>'STFFP'   and TrnInd='M' and EmpCd=EmT.Empcd ),0),2)[ExtraMnthly]
	,	round(IsNull((select sum(Amt) from EmpTransYtd where edcd not in('TMF1','TMF2','TMF3','004','PENSI','211','203','201  ') and EdTyp='HEDT02'  and EmpCd=EmT.Empcd and Prd=EmT.Prd),0),2)[Deductions]
	--,	round(IsNull((select sum(Amt) from EmpTransYtd where EdCd='004' and EdTyp='HEDT02'  and EmpCd=EmT.Empcd    and Prd=EmT.Prd),0),2)[Recovery]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('TMF1','TMF2','TMF3') and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and prd=EmT.Prd),0),2)[TMF]

	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[FOTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('052','051','004','FOTA')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Allowance]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LivingAllowance]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[OverTime]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('207  ','MGRIN')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Incentives]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='053  '  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[LastSalary]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('211','004','203','201  ')  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('FUNDW','STFFP')  and EdTyp in('HEDT01','HEDT03') and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffFundGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[StaffFundCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[TMFPay]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LSA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('LTA','008  ')  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='PENSI'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Pension]
	From     EmpTransYtd EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and EmT.Prd between @v_RFrmPrd and @v_RToPrd     
	group by EmT.EmpCd,Prd,emp.Basic,emp.Cd  ,emp.Fname,emp.Mname,emp.Lname,emp.Div 
	order by  Prd asc
	select *,[Month]+' '+cast(Yr as char(4))[Decsription] from  #EmpTrans
	drop table #EmpTrans
	End
else       
Begin
Select      
	(Select DateName( month , DateAdd( month ,convert (numeric,right(Prd,2)), 0 ) - 1 ))[Month]    
	, left(Prd,4)[Yr] 
	, emt.Prd    [Prd]
	, (Select DateName( month , DateAdd( month , CONVERT(numeric, right(@v_RFrmPrd,2)) , 0 ) - 1 ))  
	  +left(@v_RFrmPrd,4)     
	  +' to '+(Select DateName( month , DateAdd( month , CONVERT(numeric,right(@v_RToPrd,2)) , 0 ) - 1 ))    
	  +left(@v_RToPrd,4)[Period] 
	,Emp.Cd[Cd]     
		,	rtrim(Emp.Fname) +' '+rtrim(Emp.MName)+' '+rtrim(Lname)   [EmpName] 
		, (select SDes from Branch where Cd=emp.Div) [Branch]
	--,format( Isnull(Emp.Basic,0),'###,###,###.###')[Eligible]    
	--, format(Isnull(emp.Basic,0) - IsNull((select sum(Amt) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=emp.Cd and Prd=emt.Prd),0),'###,###,###.###')[LOP]  
	--, format(IsNull((select Amt from EmpTransYtd where EdCd='LSA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0),'###,###,###.###')[LS]   
	--, format(IsNull((select Amt from EmpTransYtd where EdCd='LTA' and EdTyp='HEDT03' and EmpCd=emp.Cd and Prd=EmT.Prd),0),'###,###,###.###')[LT]   
	--, format(IsNull((select sum(Amt) from EmpTransYtd where  EdTyp='HEDT02' and edcd in ('004','205','209','204') and EmpCd=@v_EmpCd and Prd=emt.Prd),0),'###,###,###.###')[Recovery]    
	--, IsNull((select sum(Amt) from EmpLoan where datepart(YYYY,LoanApprDt)*100+datepart(MM,LoanApprDt)=EmT.Prd and EmpCd=@v_EmpCd),0)[Advance]    
	,	round((select isnull(sum(amt),0) from EmpTransYtd where EdCd='001' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and Prd=EmT.Prd),2)[BasicSalaray]
	--,	round(IsNull((Select sum(Amt) from EmpTransYtd where EdTyp in('HEDT01 ','HEDT03') and edcd not in('STFFP','MGRIN','208') and TrnInd='M' and EmpCd=EmT.Empcd and  Prd=EmT.Prd),0),2)[ExtraMnthly]
	,	round(IsNull((select sum(Amt) from EmpTransYtd where edcd not in('TMF1','TMF2','TMF3','004','PENSI','211','203','201  ')and EdTyp='HEDT02'  and EmpCd=EmT.Empcd and Prd=EmT.Prd),0),2)[Deductions]
	--,	round(IsNull((select sum(Amt) from EmpTransYtd where EdCd='004' and EdTyp='HEDT02'   and EmpCd=EmT.Empcd    and Prd=EmT.Prd),0),2)[Recovery]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('TMF1','TMF2','TMF3') and EdTyp='HEDT02' and EmpCd=EmT.Empcd  and prd=EmT.Prd ),0),2)[TMF]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='FOTA' and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[FOTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('052','051','004','FOTA')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Allowance]
	--,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='051'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LivingAllowance]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='OT'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[OverTime]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('207  ','MGRIN')  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Incentives]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='053  '  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[LastSalary]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='208'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('211','004','203','201  ')  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffAdvCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('FUNDW','STFFP')  and EdTyp in('HEDT01','HEDT03') and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[StaffFundGiven]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='STFFP'  and EdTyp='HEDT01' and EmpCd=EmT.Empcd and prd=EmT.Prd  ),0),2)[StaffFundCollected]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='TMFPA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[TMFPay]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='LSA'  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LSA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd in('LTA','008  ')  and EdTyp='HEDT03' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[LTA]
	,	round(IsNull((select isnull(sum(Amt),0) from EmpTransYtd where EdCd='PENSI'  and EdTyp='HEDT02' and EmpCd=EmT.Empcd and prd=EmT.Prd ),0),2)[Pension]
	into #EmpTransYtd
	From     EmpTransYtd EmT     , Employee Emp     
	where emp.Cd=@v_EmpCd and emt.EmpCd=@v_EmpCd and emt.Prd between @v_RFrmPrd and @v_RToPrd     
	group by emt.EmpCd,Prd,emp.Basic,emp.Cd   ,emp.Fname,emp.Mname,emp.Lname ,emp.Div 
	order by Prd asc 
	select *,[Month]+' '+cast(Yr as char(4))[Decsription] from #EmpTransYtd
	drop table #EmpTransYtd
	--EdCd ='004' and
ENd
End 
 
 
 Go 


CREATE OR ALTER     Procedure [dbo].[EmpLoan_Approval_GetRow_N]  
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
As		-- Drop Procedure [EmpLoan_Approval_GetRow_N]'','0','100','','U'
Begin	
	Set @v_Param = ltrim(rtrim(@v_Param))  
	If @v_Typ='3' set @v_Param = @v_Param +'%'  
	Select
		TransNo  
	,	TransDt  
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmployeeCode]  
	,	rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[EmpName]
	,	(select Imagefile from Employee where cd= E.Cd) [ImagePath]
	,	(select des from designation where cd=E.Desg)[Desg]
	,	C.SDes[LoanType]  
	,	EL.DocRef  
	,	EL.DocDt  
	,	CONVERT(varchar(20),EL.DocDt ,103)[FormatedDocDt]
	,	EL.Amt  
	,	EL.NoInstReq
	,	EL.Purpose  
	,	EL.Narr  
	,	EL.LoanApprBy  
	--, (select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName) from Employee where cd=EL.LoanApprBy and EL.LoanApprBy<>null)[Approval's Name]  
	,	case isnull(EL.LoanApprBy,'N')  
			when 'N' then ('')  
			else (select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName) from Employee where cd=EL.LoanApprBy)  
			end [ApprovalName]  
	,	EL.LoanApprDt
	,	CONVERT(varchar(20),EL.LoanApprDt ,103)[FormatedLoanApprDt]
	,	EL.ApprAmt  
	,	EL.RecoMode --, (select SDes from SysCodes where cd=EL.RecoMode)[Reco Mode]  
	-- , (select SDes from SysCodes where RTRIM(right(Cd,10-len(ltrim(rtrim(typ)))))=EL.RecoPrd and Typ='HLRI')[Reco Prd]  
	,	EL.RecoPrd -- (select SDes from SysCodes where RTRIM(right(Cd,6))=EL.RecoPrd and Typ='HLRI')[Reco Prd]  
	,	EL.NoInst  
	,	EL.DedStartDt  
	,	CONVERT(varchar(20),EL.DedStartDt ,103)[FormatedDedStartDtDt]
	,	EL.Guarantor  
	,	(select rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  from Employee where cd=EL.Guarantor)[GuarantorName]  
	,	EL.GuarantorDetails  
	,	EL.LoanStatus  
	,	EL.PayMode --, (select SDes from SysCodes where cd=EL.PayMode)[Pay Mode]  
	,	case isnull(EL.LoanApprBy,'N')  
			when 'N' then (select ChgsTyp from CompanyLoanTypes where Cd=EL.LoanTyp)  
			else EL.ChgsTyp   
		end [ChgsTyp]  
	,	case isnull(EL.LoanApprBy,'N')  
			when 'N' then (select IntPerc from CompanyLoanTypes where Cd=EL.LoanTyp)  
			else EL.ChgsPerc  
		end [ChgsPerc]  
		
		
	From
		EmpLoan EL left outer join CompanyLoanTypes C on EL.LoanTyp=C.Cd -- Modified by Rasheed. Inner Join will return 2 records for matching records.
	,	Employee E
	Where
		E.cd=EL.EmpCd and E.CoCd=@v_CoCd
	--C.cd=EL.LoanTyp and (NOTE:commented by rasheed for temporary)
	--and EL.LoanStatus in ('A','N','R')  
	and LoanStatus='N'  --by rasheed
	and (  
		@v_Typ='1' and ltrim(str(month(EL.TransDt)))=@v_Param or  
		@v_Typ='2' and EL.TransNo=@v_Param or  
		@v_Typ='3' and EL.EmpCd like @v_Param or   
		@v_Typ='4' and c.SDes=@v_Param or
		@v_Typ='0' and TransNo in( select TransNo as LoanApproval  from EmpLoan
				inner join Employee as emp on emp.Cd=EmpLoan.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS1' and CPA.ApplTyp=EL.LoanTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				LoanStatus='N' 
				and emp.CoCd=@v_CoCd
				and trim(emp.Status)='HSTATPM'
				and ((LoanApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (LoanApprBy is not null
						and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS1' and ApplTyp=EL.LoanTyp and Div=emp.Div and Dept=emp.Dept and EmpCd=LoanApprBy ) +1
					and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) 
			)
			)
			)
			)  
	Order By  
		TransNo Desc  
End  
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpLeaveSalaryTicket_Approval_GetRow_N]
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
	,	(select Imagefile from Employee where cd= EL.EmpCd) [ImagePath]
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
 
 
 
 Go 
CREATE OR ALTER     Procedure [dbo].[EmpFund_Approval_GetRow_N]
	@v_Param		Varchar(30)
,	@v_Typ			Char(1)
,	@v_CoCd			Char(5)
,	@v_EmpCd		Char(10)
,	@v_EmpUser		Char(1)
As		-- Drop Procedure [dbo].[EmpFund_Approval_GetRow] '','3','01','001','U'  
Begin	
	Declare @FinalAuth Char(10)	
	Select
		TransNo[TransNo]
	,	TransDt[TransDt] 
	,	CONVERT(varchar(20),TransDt,103)[FormatedTransDt]
	,	EL.EmpCd[EmpCd]  
	,	Rtrim(FName)+' '+Rtrim(MName)+' '+Rtrim(LName) [Emp]
	,	(select Imagefile from Employee where cd= EL.EmpCd) [ImagePath]
	,	Amount
	,	case when @v_Typ in ('1','4','3')
		then
		(select  SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval_Level]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
		end[Current_Approval]
		
	,	case when @v_Typ in ('1','4','3')
		then
		(Case when((select  SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd
			and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))))
			=(select Top 1 SrNo From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPSS4' 
			and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
			and CPAD.CoCd=@v_CoCd order by SrNo Desc))
			then 
				(STUFF((SELECT ', ' + CAST((Select Fname From Employee where Cd=EmpCd) AS VARCHAR(10)) [text()]
				FROM CompanyProcessApprovalDetail as CPAD
				WHERE CPAD.ProcessId='HRPSS4' 
				and CPAD.Div=(select Div from Employee where Cd=EL.EmpCd)
				and CPAD.Dept=(select Dept from Employee where Cd=EL.EmpCd)
				and CPAD.CoCd=@v_CoCd
				FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' '))
			End
		)
		end[Approvals]
	,Typ
	
		
	From	-- Modified by Rasheed( otherwise list all employees)
		EmpFund EL left outer join Employee Emp on EL.empcd=Emp.Cd
	Where	-- Modified by Rasheed (Need to show only new applications for approval)
		Emp.Cd=EL.EmpCd and Emp.CoCd=@v_CoCd
	
	and (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and EL.Status = 'N'  or
		@v_Typ='1' and TransNo=@v_Param and EL.Status = 'N'  or
		@v_Typ='2' and EL.empcd=@v_Param and EL.Status = 'N'  or
		@v_Typ='4' and TransNo=@v_Param and EL.Status = 'F'  or
		@v_Typ='3' and EL.Status = 'N' and TransNo in( select TransNo as LeaveApproval  from EmpFund
				inner join Employee as emp on emp.Cd=EmpFund.EmpCd
				inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS4' and CPA.Div=emp.Div and CPA.Dept=emp.Dept
				inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
				where 
				EmpFund.Status='N' 
				and emp.CoCd=@v_CoCd
				and emp.Status='HSTATPM'
				and ((ApprBy is null and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))  and cpad.SrNo='1')
					or (ApprBy is not null
						and CPAD.SrNo=(select top 1 SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS4' and Div=emp.Div and Dept=emp.Dept and EmpCd=ApprBy ) +1
						and ((@v_EmpUser='E' and CPAD.EmpCd=@v_EmpCd) or (@v_EmpUser='U' and cpad.EmpCd in (Select top 1 Cd from Employee where UserCd=@v_EmpCd))) )))
			
	)
	Order By
		TransNo
End
 
 
 Go 


CREATE OR ALTER   Procedure [dbo].[Employee_LeaveHistory_GetRow_N]
	@v_CoCd		Char(10)
,	@v_EmpCd	Char(10)
,	@v_ToDt		Datetime

As	-- Drop Procedure [dbo].[Employee_LeaveHistory_GetRow] '100','MHM/005','04/07/2020'
/*
-- sp_help EmpProvisionsAdj
Declare @v_CoCd		Char(10)='01'
	,	@v_EmpCd	Char(10)='MHM/575'
	,	@v_ToDt		Datetime='09/30/2017'
			-- Drop Procedure [dbo].[Employee_LeaveHistory_GetRow]'100','MHM/575','09/30/2017'
*/
Begin

	Declare @Prd			int
	Declare @Year			int
	Declare @StrtPrdPrd		int
	Declare @StrtPrdYear	int
	Declare @AnnualLv		Char(10)
	Declare	@StrtPrd		Char(6)
	Declare @AmtDecs		int
	Declare @BasicCd		Char(15)
	Declare @EDay			int
	
	select @BasicCd='HEDT01'+rtrim(Val) From Parameters Where Cd='BASIC' and CoCd='#'
	select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
	Select @StrtPrd=Val from Parameters where Cd='HR_ST_PRD' and CoCd=@v_CoCd
	Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_CoCd
	Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_CoCd
	select @AmtDecs=AmtDecs From Company Where Cd=@v_CoCd
	Select @StrtPrdPrd=substring(@StrtPrd,5,2)
	Select @StrtPrdYear=substring(@StrtPrd,1,4)
	Exec @EDay=Get_EDay @Prd,@Year
	
	CREATE table #temp
	(
			LvSalary	Numeric(9,4) 
		,	EmpCd		Char(10) collate SQL_Latin1_General_CP1_CI_AS
	)
	insert into #temp
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
		and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd=@AnnualLv and CoCd=@v_CoCd)
		and	EffDate<=(case when @v_ToDt='' then (rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)) else @v_ToDt end) 
		and	(EndDate>=(case when @v_ToDt='' then (rtrim(@Prd) + '/' + rtrim(@EDay)+'/'+rtrim(@Year)) else @v_ToDt end)  or EndDate='1/1/1900')
		group by EmpCd 
		
	select 
		Emp.Cd[Code]  
	,	Emp.Fname+' '+Emp.Mname+' '+Emp.Lname [Name]
	,	(Select LvSalary from #temp where EmpCd=Emp.Cd)[LvSalYr]
	,	(Select isnull(Provisions,0) from Country where Cd=Emp.Nat)[LvTicYr]
	,	isnull((select ISNULL(ELM.LvOpBal,0) from EmpLeaveMaster ELM where ELM.EmpCd=Emp.Cd and ELM.LvTyp=@AnnualLv),0)[LeaveOp]	
	
	,	isnull((select ISNULL(ELM.LvMax,0) from EmpLeaveMaster ELM where ELM.EmpCd=Emp.Cd and ELM.LvTyp=@AnnualLv),0)
		*((case Leaving
		when '1/1/1900' then DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) then Emp.Doj else CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) end,
                    case @v_ToDt when '' then CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@EDay AS VARCHAR(2))) else @v_ToDt end )+1
		else DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) then Emp.Doj else CONVERT(DATE,CAST(@StrtPrdYear AS VARCHAR(4))+'-'+
                    CAST(@StrtPrdPrd AS VARCHAR(2))+'-'+
                    CAST(1 AS VARCHAR(2))) end,Leaving)+1
		end)/365.0)[Leave]
		
	,	isnull(round((select ISNULL(ELM.LvUsed,0) from EmpLeaveMaster ELM where ELM.EmpCd=Emp.Cd and ELM.LvTyp=@AnnualLv),0),0)
		[LeaveTaken]
		
	,	isnull((select ISNULL(EPO.OpDays,0) from EmpProvisionsOpening EPO where EPO.EmpCd=Emp.Cd and EPO.Typ='LS'),0)[LvSalDaysOp]	
	
	,	isnull((Select isnull(sum(provdays),0) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0)
			+isnull((Select isnull(sum(days),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='LS' and Status='A' and TransDt<=@v_ToDt),0)
					+Isnull((select ISNULL(ELM.lvdays,0) from Employee ELM where ELM.Cd=Emp.Cd)
					*((DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) end,
                    case @v_ToDt when '' then CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@EDay AS VARCHAR(2))) else @v_ToDt end)+1
					)/365.0),0)
					
					[LvSalDays]
		
	,	round(isnull((select sum(ISNULL(EP.ActDays,0)) from EmpProvisions EP where EP.EmpCd=Emp.Cd and EP.Typ='LS' and EP.Yr*100+EP.Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0),0)
		[LvSalDaysTaken]
		
     ,	isnull((Select isnull(sum(provamt),0) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0)
			+isnull((Select isnull(sum(amt),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='LS' and Status='A' and transdt<=@v_ToDt),0)
					+Isnull((((datediff(DD,
					case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2)))end,case @v_ToDt when '' then 
                    CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@Eday AS VARCHAR(2))) else @v_ToDt end)+1)*(Select LvDays from employee where Cd=Emp.Cd)/365)
                    *((Select LvSalary from #temp where EmpCd=Emp.Cd)*12/365)),0)
                    [LvSalary]
                    
	,	round(isnull((Select isnull(OpAmt,0) from empprovisionsopening where empcd=Emp.Cd and typ='LS'),0),@AmtDecs)[LvSalaryOp]
	,	round(isnull((Select isnull(sum(actamt),0) from empprovisions where empcd=Emp.Cd and typ='LS' and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0),@AmtDecs)[LvSalaryTaken]
	
	,	round(isnull((Select isnull(sum(provamt),0) from empprovisions where empcd=Emp.Cd and typ='LT' and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0)
			+isnull((Select isnull(sum(amt),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='LT' and Status='A' and transdt<=@v_ToDt),0)
					+Isnull(((((Select NoTickets from employee where Cd=Emp.Cd)
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
                    AS VARCHAR(2)))end,case @v_ToDt when '' then 
                    CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@Eday AS VARCHAR(2))) else @v_ToDt end)+1)/365),0)
					,@AmtDecs)
					[LvTicket]
					
	,	round(isnull((Select isnull(OpAmt,0) from empprovisionsopening where empcd=Emp.Cd and typ='LT'),0),@AmtDecs)[LvTicketOp]
	,	round(isnull((Select isnull(sum(actamt),0) from empprovisions where empcd=Emp.Cd and typ='LT'  and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0),@AmtDecs)[LvTicketTaken]
	,	CONVERT(varchar(10), @v_ToDt,103)[FormatedFromDt]
	,	isnull((select Cumlvnopay from EmpLeaveMaster where EmpCd=Emp.Cd),0)[Cumlvnopay]
	
	,	isnull((select ISNULL(EPO.OpDays,0) from EmpProvisionsOpening EPO where EPO.EmpCd=Emp.Cd and EPO.Typ='GT'),0)[GratDaysOp]	
	
	,	isnull((Select isnull(sum(provdays),0) from empprovisions where empcd=Emp.Cd and typ='GT' and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0)
			+isnull((Select isnull(sum(days),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='GT' and Status='A' and TransDt<=@v_ToDt),0)
					+Isnull((select ISNULL(ELM.lvdays,0) from Employee ELM where ELM.Cd=Emp.Cd)
					*((DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='GT' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='GT' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) end,
                    case @v_ToDt when '' then CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@EDay AS VARCHAR(2))) else @v_ToDt end)+1
					)/365.0),0)
					[GratDays]
		
	,	round(isnull((select sum(ISNULL(EP.ActDays,0)) from EmpProvisions EP where EP.EmpCd=Emp.Cd and EP.Typ='GT' and EP.Yr*100+EP.Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0),0)
		[GratDaysTaken]
		
	,	isnull((select ISNULL(EPO.OpAmt,0) from EmpProvisionsOpening EPO where EPO.EmpCd=Emp.Cd and EPO.Typ='GT'),0)[GratAmtOp]	
	
	,	isnull((Select isnull(sum(provAmt),0) from empprovisions where empcd=Emp.Cd and typ='GT' and Yr*100+Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0)
			+isnull((Select isnull(sum(Amt),0) from EmpProvisionsAdj where empcd=Emp.Cd and ProvTyp='GT' and Status='A' and transdt<=@v_ToDt),0)
					+Isnull((select ISNULL(ELM.lvdays,0) from Employee ELM where ELM.Cd=Emp.Cd)
					*((DateDiff(DD,case when Emp.Doj>CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='GT' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) 
                    then Emp.Doj else CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST((case when (Select Count(1) from empprovisions where empcd=Emp.Cd and typ='GT' and Yr*100+Prd=@Year*100+@Prd)>0 then @Eday else 1 end)
                    AS VARCHAR(2))) end,
                    case @v_ToDt when '' then CONVERT(DATE,CAST(@Year AS VARCHAR(4))+'-'+
                    CAST(@Prd AS VARCHAR(2))+'-'+
                    CAST(@EDay AS VARCHAR(2))) else @v_ToDt end)+1
					)/365.0),0)
					[GratAmt]
		
	,	round(isnull((select sum(ISNULL(EP.ActAmt,0)) from EmpProvisions EP where EP.EmpCd=Emp.Cd and EP.Typ='GT' and EP.Yr*100+EP.Prd<=datepart(YYYY,@v_ToDt)*100+datepart(MM,@v_ToDt)),0),0)
		[GratAmtTaken]
	
	,(select sum(amt) from EmpTrans where edcd in('TMFPA') and empcd=@v_EmpCd)[TmfAmount]
	
	from 
	Employee as Emp 
	where 
	(@v_EmpCd='All' or Cd=@v_EmpCd)
	and Status not in ('HSTATNP','HSTATSR','HSTATST','HSTATES') 

drop table #temp
	
END 
 
 Go 
CREATE OR ALTER   Procedure [dbo].[GetRepo_Provisions_N]
	@v_CoCd			Char(5)
,	@v_DivCd		Char(5)
,	@v_ProvTyp		Varchar(5)
,	@v_Prd			Char(2)
,	@v_Year			Char(4)
As   --DROP Procedure [dbo].[GetRepo_Provisions]'100','All','gt','01','2017'
Begin
	Declare @AmtDecs int
	Declare @BasicCd Char(15)
	Declare @EndDt datetime
	Declare @BeginDt datetime
	Declare @Prd int
	Declare @Year int
	Declare @EDay int
	Declare @AnnualLv		Char(10)	
	Select @Prd=val from Parameters where Cd='CUR_MONTH' and CoCd=@v_CoCd
	Select @Year=Val from Parameters where Cd='CUR_YEAR' and CoCd=@v_CoCd
	Select @AmtDecs=AmtDecs from Company where Cd=@v_CoCd
	Select @BasicCd='HEDT01'+rtrim(Val) from Parameters where Cd='BASIC' and CoCd='#'
	select @AnnualLv=Val From Parameters Where Cd='CD_PREVILEGE_LV_1' and CoCd='#'
	Exec @EDay=Get_EDay @v_Prd,@v_Year
	Set @EndDt=rtrim(@v_Prd)+'/'+rtrim(@EDay)+'/'+rtrim(@v_Year)
	--set @v_Prd=RIGHT('0' + RTRIM(@v_Prd), 2)
	
	Select 
		Emp.Cd
	,	Emp.FName+' '+Emp.MName[Name]
	,	DOJ
	,	(Select SDes from Designation where Cd=Emp.Desg)[Designation]
	,	case Leaving
		when '1/1/1900' then DateDiff(D,DOJ,@EndDt)+1
		else DateDiff(D,DOJ,Leaving)+1
		end[DaysWorked]
	,	case @v_ProvTyp when 'GT' then
		round(Basic*CR.Rate*(select isnull(PayFactor,1) from CompanyEOSPay where CoCd=@v_CoCd and Typ='HCPAYGT   ' and rtrim(PayTyp)+rtrim(PayCd)=@BasicCd),@AmtDecs)
		+Isnull(dbo.GetFunc_ESBPay(@v_CoCd,Emp.Cd,@Prd,@Year,@EDay,round(Basic*CR.Rate,@AmtDecs),@AmtDecs,@BasicCd,'HCPAYGT'),0)
		when 'LS' then
		round(Basic*CR.Rate,@AmtDecs)
		+(Select isnull(sum(AmtVal),0)From EmpEarnDed Ed Where Ed.EmpCd=Emp.Cd and rtrim(EdTyp)+rtrim(EdCd) <> @BasicCd
			and	rtrim(EdTyp)+rtrim(EdCd) in (select rtrim(PayTyp)+rtrim(PayCd) From CompanyLeavePay Where LvCd=@AnnualLv and CoCd=@v_CoCd)
			and srno=(select top 1 srno from empearnded ED1 where ED1.EmpCd=ED.EmpCd and ED1.EdTyp=ED.EdTyp and ED1.EdCd=ED.EdCd
			order by srno desc))
		--2*(round(Basic*CR.Rate*(select isnull(PayFactor,1) from CompanyEOSPay where CoCd=@v_CoCd and Typ='HCPAYGT   ' and rtrim(PayTyp)+rtrim(PayCd)=@BasicCd),@AmtDecs)
		--+Isnull(dbo.GetFunc_ESBPay(@v_CoCd,Emp.Cd,@Prd,@Year,@EDay,round(Basic*CR.Rate,@AmtDecs),@AmtDecs,@BasicCd,'HCPAYGT'),0))
		when 'LT' then
	 	Isnull((select Provisions from Country where Cd=(select Nat from Employee where Cd=Emp.Cd)),0)end[PrRate]
	,	(Select Des from DEPT where cd=Dept)[Department]
	,	(Select Des from CC where cd=Emp.CC)[CC]
	,	(Select Des from Codes where Cd=LocCd)[Loc]
	,	(Select Des from Company where Cd=@v_CoCd)[CoName]
	,	Br.SDes[Branch]
	,	isnull((Select Isnull(OpDays,0) from EmpProvisionsOpening where EmpCd=Emp.Cd and Typ=@v_ProvTyp),0)[OpDays]
	,	isnull((Select Isnull(OpAmt,0) from EmpProvisionsOpening where EmpCd=Emp.Cd and Typ=@v_ProvTyp),0)[OpAmt]
	,	isnull((Select Sum(Isnull(ProvAmt,0)) from EmpProvisions where (@v_Year*100)+@v_Prd=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTMAmt]
	,	isnull((Select Sum(Isnull(ActAmt,0)) from EmpProvisions where (@v_Year*100)+@v_Prd=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTMPay]
	,	isnull((Select Sum(Isnull(Amt,0)) from EmpProvisionsAdj where (@v_Year*100)+@v_Prd= (datepart(YYYY,TransDt)*100)+datepart(MM,TransDt) and EmpCd=Emp.Cd and ProvTyp=@v_ProvTyp),0)[GTMAdj]
	,	isnull((Select Sum(Isnull(ProvAmt,0)) from EmpProvisions where (@v_Year*100)+@v_Prd>=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTCAmt]
	,	isnull((Select Sum(Isnull(ActAmt,0)) from EmpProvisions where (@v_Year*100)+@v_Prd>=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTCPay]
	,	isnull((Select Sum(Isnull(Amt,0)) from EmpProvisionsAdj where (@v_Year*100)+@v_Prd>=  (datepart(YYYY,TransDt)*100)+datepart(MM,TransDt) and EmpCd=Emp.Cd and ProvTyp=@v_ProvTyp),0)[GTCAdj]
	
	
	,	isnull((Select Sum(Isnull(ProvDays,0)) from EmpProvisions where (@v_Year*100)+@v_Prd=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTMDays]
	,	isnull((Select Sum(Isnull(ActDays,0)) from EmpProvisions where (@v_Year*100)+@v_Prd=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTMDaysPay]
	,	isnull((Select Sum(Isnull(Days,0)) from EmpProvisionsAdj where (@v_Year*100)+@v_Prd=  (datepart(YYYY,TransDt)*100)+datepart(MM,TransDt) and EmpCd=Emp.Cd and ProvTyp=@v_ProvTyp),0)[GTMDaysAdj]
	,	isnull((Select Sum(Isnull(ProvDays,0)) from EmpProvisions where (@v_Year*100)+@v_Prd>=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTCDays]
	,	isnull((Select Sum(Isnull(ActDays,0)) from EmpProvisions where (@v_Year*100)+@v_Prd>=(Yr*100)+Prd and EmpCd=Emp.Cd and (@v_DivCd='All' or HrDiv=@v_DivCd) and Typ=@v_ProvTyp),0)[GTCDaysPay]
	,	isnull((Select Sum(Isnull(Days,0)) from EmpProvisionsAdj where (@v_Year*100)+@v_Prd>=  (datepart(YYYY,TransDt)*100)+datepart(MM,TransDt) and EmpCd=Emp.Cd and ProvTyp=@v_ProvTyp),0)[GTCDaysAdj]
	
	,	@AmtDecs[AmtDecs]
	,	@v_Prd[Prd]
	,	LTrim(Str(@v_Year))[Year]
	,	(Select Des from CompanyProvisions where Cd=@v_ProvTyp)[ProvisionType]
	from
		Employee Emp
	,	Branch Br
	,	CurrencyRates CR
	where
		Emp.CoCd=@v_CoCd and Br.Cd=Emp.Div
	and	CR.CurrCd=Emp.BasicCurr and CR.CoCd=@v_CoCd
	and	(Emp.Cd in (Select EmpCd from EmpProvisions Where Typ=@v_ProvTyp) or Emp.Cd in (Select EmpCd from EmpProvisionsadj Where ProvTyp=@v_ProvTyp))
	and (@v_DivCd='All' or Emp.Div=@v_DivCd)
	and	Emp.Status not in ('HSTATNP','HSTATTP','HSTATSR','HSTATST')
	Order by
		Emp.Cd
End
 
 
 Go 
CREATE OR ALTER   Procedure [dbo].[EmpLeaveMaster_GetRow_N]
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

CREATE OR ALTER   Procedure [dbo].[Getrepo_Emptransfers_N]
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
CREATE OR ALTER   procedure [dbo].[GetRepo_EmpLoanDueList_N]
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

CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpLoan_Analysis_N]
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

CREATE OR ALTER   Procedure [dbo].[GetRepo_EmpLeave_N]
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


CREATE OR ALTER   Procedure [dbo].[GetRepo_ExpiredDocument]
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

CREATE OR ALTER     Procedure [dbo].[CompanyDocuments_GetRow_N]
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


CREATE OR ALTER   Procedure [dbo].[EmpFund_Confirm_Revise_Cancel_Update]
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
CREATE OR ALTER   Procedure [dbo].[Designation_GetRow]
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

CREATE OR ALTER     PROCEDURE [dbo].[Employee_GetRowItems_N] 
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
CREATE OR ALTER   procedure [dbo].[Empprovisionsadj_Update]
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
CREATE OR ALTER   procedure [dbo].[Empprovisionsadj_GetRow]
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
CREATE OR ALTER   procedure [dbo].[Empprovisionsadj_GetRow_N]
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
CREATE OR ALTER   procedure [dbo].[Empprovisionsadj_Update_N]
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
CREATE OR ALTER   procedure [dbo].[EmpprovisionsadjAppr_Update_N]
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

CREATE OR ALTER   Procedure [dbo].[GetRepo_FixedEarnDed]
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
CREATE OR ALTER       Procedure [dbo].[GetRepo_EmpShortList_N]
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

CREATE OR ALTER   Procedure [dbo].[GetRepo_FixedPayrollCom]
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
CREATE OR ALTER     procedure [dbo].[EmpTrans_Incentives_GetRow_N]
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





CREATE OR ALTER   Procedure [dbo].[Employee_GetRow]    
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
CREATE OR ALTER     procedure [dbo].[Employee_Find_N]
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
CREATE OR ALTER   Trigger [dbo].[Trigger_Emp_ProgressionHead] on [dbo].[EmpProgressionHead] for insert,update
as --drop  Trigger [dbo].[Trigger_Emp_ProgressionHead]
begin 
	
			
declare @ApprBy		char(10)
declare @Stat		char(1)
declare @TransNo	char(10)
declare @Typ		char(10)

declare @Flag int 

declare @recipients varchar(MAX) 
declare @body varchar(MAX) 
declare @ProfileName varchar(100)  
 
		CREATE table #Temp(
		 EmailId varchar(40) ,
		 Body varchar(500) ,
		 SNo int )
		 
---Assigning Values--------------
select @Flag=1
select @ApprBy=ApprBy from inserted
select @Stat=Status from inserted
select @TransNo=TransNo from inserted 
select @Typ=Typ from inserted
set @ProfileName = ( select Val from Parameters where Cd='EMAIL_PROFILE       ' and AppCd='HR' and CoCd='#')
-------Updating------------------


if @Stat='A'
	BEGIN
			insert into #Temp
			select distinct EmpA.Email,
				('The application for '
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is approved.'),
					@Flag
			from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END

	
else if @Stat='R'
	BEGIN
			insert into #Temp
			select distinct EmpA.Email,
				('The application for '
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is rejected.'),
					@Flag
			from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END		

			
else if @Stat='E' and @ApprBy is null
	BEGIN
			insert into #Temp
			select (select Email from EmpAddress where EmpCd=(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT8' 
			and CPAD.ApplTyp=@Typ
			and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
			and SrNo='1') and AddTyp='HADD0001')
			,((select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=Empl.EmpCd)
				+ ' applied to ' +
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is waiting for an approval from you.'),
					@Flag
				from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd	
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
			
			
			insert into #Temp
			select EmpA.Email,
					('Your application to '
					+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' wants to be approved by '
					+ (select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=
						(select CPAD.EmpCd From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT8'  
						and CPAD.ApplTyp=@Typ
						and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
						and CPAD.SrNo='1'))),
					@Flag
				from EmpProgressionHead as Empl 
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd	
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END		
			
else if @Stat='E' and @ApprBy is not null	
	BEGIN
			insert into #Temp
			select (select Email from EmpAddress where EmpCd=(select EmpCd From CompanyProcessApprovalDetail as CPAD
			where CPAD.ProcessId='HRPT8'  
			and CPAD.ApplTyp=@Typ
			and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
			and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
			and SrNo=((select Top 1 ApprLvl from EmpProgressionAppr where TransNo=Empl.TransNo order by ApprLvl Desc)+1) 
				and AddTyp='HADD0001'))
			,((select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=Empl.EmpCd)
				+ ' applied to ' +
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' is waiting for an approval from you.'),
					@Flag
				from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd	
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
			
			insert into #Temp
			select EmpA.Email,
					('Your application to '
				+ (select Des from SysCodes where Typ='HREP' and Cd=Empl.Typ)
				+ ' with changing ' 
				+(select Des from CompanyEarnDed where Cd=EmpD.EdCd and Typ=EmpD.EdTyp)
				+' from '+ CAST(val AS VARCHAR(100))+' to '+ CAST(ApprVal AS VARCHAR(100))
					+' wants to be approved by '
					+ (select Emp.Fname+Emp.Mname+Emp.Lname from Employee as Emp where Emp.Cd=
						(select CPAD.EmpCd From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT8'  
						and CPAD.ApplTyp=@Typ
						and CPAD.Div=(select Div from Employee where Cd=Empl.EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=Empl.EmpCd)
						and CPAD.SrNo=((select Top 1 ApprLvl from EmpProgressionAppr where TransNo=Empl.TransNo order by ApprLvl Desc)+1 )))),
					@Flag
				from EmpProgressionHead as Empl
			inner join EmpProgressionDetail as EmpD on EmpD.TransNo=Empl.TransNo
			inner join EmpAddress as EmpA on Empl.EmpCd=EmpA.EmpCd and EmpA.AddTyp='HADD0001'
			inner join Employee as Emp on Emp.Cd=Empl.EmpCd		
			where Empl.TransNo=@TransNo
			set @Flag=@Flag+1
	END		

		--declare @Count numeric(3,0)
		--declare @RowNo numeric(3,0)
		--set @RowNo=1
		--set @Count=(select COUNT(EmailId) from #Temp)
		--while(@RowNo<=@Count)
		--begin
		
		--	set @recipients=(select EmailId from #Temp where SNo=@RowNo)
		--	set @body=(select Body from #Temp where SNo=@RowNo )
		--	if @recipients !=''
		--		BEGIN
		--			EXEC msdb.dbo.sp_send_dbmail 
		--			@profile_name =@ProfileName,
		--			@recipients = @recipients,
		--			@subject ='HRMS Employee Progression',
		--			@body = @body, 
		--			@body_format = 'TEXT';
		--		END
		--	set @RowNo=@RowNo+1
		--end
		Drop table #Temp
	end


 
 
 Go 
CREATE OR ALTER       Procedure [dbo].[CompanyProcessApproval_Update_N]
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
CREATE OR ALTER   Procedure [dbo].[EmpProgressionHead_GetRow]
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

 CREATE OR ALTER   PROCEDURE [dbo].[EmpProgressionDetail_GetRow_N]  
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

 CREATE OR ALTER   PROCEDURE [dbo].[EmpProgressionDetail_GetRow]  
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
CREATE OR ALTER   Procedure [dbo].[CodeGroups_GetRow]
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
CREATE OR ALTER       Procedure [dbo].[Codes_GetRow_N]
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



CREATE OR ALTER     Procedure [dbo].[EmpLeave_Approval_GetRow_N]
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



CREATE OR ALTER     procedure [dbo].[Empleave_View_Getrow_N]    
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
CREATE OR ALTER   procedure [dbo].[VehDocIssueRcpt_Update]
	@v_SrNo			char(5)
,	@v_VehCd		Char(10)
,	@v_DocTyp		Char(10)
,	@v_DocNo		Char(20)
,	@v_IssueDt		Datetime
,	@v_IssuePlace	VarChar(30)
,	@v_ExpDt		Datetime
,	@v_TrnDt		datetime
,	@v_TransTyp  	char(1)
,	@v_DocStatus	char(10)
,	@v_Narr			varchar(100)
,	@v_EntryBy		Char(5)
,	@v_Status		Char(1)
--,	@v_ApprBy		Char(10)
as  --drop procedure [dbo].[VehDocIssueRcpt_Update]
begin
set nocount on
Declare @err int
IF (SELECT COUNT(*) FROM VehDocIssueRcpt WHERE VehCd = @v_VehCd and DocTyp=@v_DocTyp and SrNo=@v_SrNo) = 0
	Begin
	insert into VehDocIssueRcpt(VehCd, DocTyp,DocNo,IssueDt,IssuePlace,ExpDt, SrNo, TrnTyp, Narr, TrnDt, DocStat, EntryBy, EntryDt,Stat)
	values
	(
          @v_VehCd
	,     @v_DocTyp
	,	  @v_DocNo
	,	  @v_IssueDt
	,	  @v_IssuePlace
	,	  @v_ExpDt
	,     @v_SrNo
	,     @v_TransTyp
	,     @v_Narr
	,     @v_TrnDt
	,     @v_DocStatus
	,     @v_EntryBy
	,     getdate()
	,	  @v_Status
        )
        
	If @@error != 0
	Print 'error'
	GoTo errorHandler
end
Else
    Begin
        Update VehDocIssueRcpt
          Set
	 TrnTyp=@v_TransTyp
	,Narr=	@v_Narr
	,DocStat=@v_DocStatus
	,EditBy=@v_EntryBy
	,EditDt=getdate()
	,Stat=@v_Status

        WHERE VehCd = @v_VehCd and DocTyp=@v_DocTyp and SrNo=@v_SrNo
    End
Select @err = @@error
	If @err != 0 
		GoTo errorHandler
		Return
errorHandler:
	Return 1
End

 
 
 Go 

CREATE OR ALTER   Procedure [dbo].[EmpLeave_GetRow]  
@v_Param varchar(30),  
@v_Typ  char(1),  
@v_CoCd  Char(5)  
as  --Drop Procedure [dbo].[EmpLeave_GetRow]'90','4','100'  
 select  
  TransNo[TransNo]  
 , TransDt[Trans Dt.]  
 , el.EmpCd[Employee Code]  
 , rtrim(E.FName)+' '+rtrim(E.MName)+' '+rtrim(E.LName)[Employee Name]  
 , c.SDes[Leave Type]  
 , el.FromDt
 , CONVERT(varchar(10), el.FromDt,103) [FormatedFromDt] 
 , el.ToDt  
 , CONVERT(varchar(10), el.ToDt,103) [FormatedToDt] 
 , el.LvTaken   
 , el.DocRef  
 , Case el.DocDt  
   When '01/01/1900' Then ''  
   Else el.DocDt  
  end[docDt]  
 , el.SubStitute[Subtitute Code]  
 , (select  
   rtrim(FName)+' '+rtrim(MName)+' '+rtrim(LName)  
  from  
   Employee Emp  
  where  
   Emp.cd=el.SubStitute  
  )[Substitute Name]  
 , el.Reason  
 , el.Narr  
 , el.LvApprBy  
 , case el.LvStatus  
   when 'Y' then 'Yes'  
   else 'No'  
  end[LvStatus]  
 , el.LvInter [Leave.Type]  
 , Typ  
 , DATEDIFF(dd,el.FromDt,GETDATE())[Joining days]
 , DATEDIFF(dd,el.ToDt,GETDATE())[Returning days]
 from  
  EmpLeave el  
 , CompanyLeave  c  
 , Employee e  
 where  
  C.cd=el.LvTyp  
 and e.cd=el.EmpCd  
 and (el.JoinDt is null or Typ='S')  
 and e.CoCd =@v_CoCd  
 and (
  (@v_Typ='0' and ltrim(str(month(TransDt)))=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='1' and TransNo=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='2' and el.empcd=@v_Param and LvStatus <> 'C' ) or  
  (@v_Typ='3' and el.FromDt between convert (date,getdate()) and  convert (date,DATEADD(DD,cast(@v_Param as int),getdate())) and el.LvStatus='Y') or
  (@v_Typ='4' and el.ToDt between convert (date,getdate()) and convert (date,DATEADD(DD,cast(@v_Param as int),getdate())) and el.LvStatus='F')
  ) 
 --order by 
 
 order by case when @v_Typ='3' then el.FromDt 
			   when @v_Typ='4' then el.ToDt 
			   else TransNo end
  
 -- TransNo  
  
   
 
 Go 

CREATE OR ALTER   PROCEDURE [dbo].[EmployeeWiseForChart_N]
--drop PROCEDURE [dbo].[EmployeeWiseForChart]'Branch'
@v_Typ Varchar(30)
AS
if @v_Typ='Dept' 
begin
select dept.Des[Des],COUNT(Emp.Cd)[Count] from Employee as Emp 
inner join  Dept on Emp.Dept=dept.Cd
group by  dept.Des
end
else if @v_Typ='Branch'
begin
select Branch.SDes[Des],COUNT(Emp.Cd)[Count] from Employee as Emp --select * from Employee where cd='PH   '
inner join Branch on Emp.Div=Branch.Cd
group by  Branch.sdes
end
else if @v_Typ='Nationality'
begin
select Country.Nat[Des],COUNT(Emp.Cd)[Count] from Employee as Emp 
inner join Country  on Emp.Nat=Country.Cd
group by  Country.Nat
end
else if @v_Typ='Location'
begin
select Codes.SDes[Des],COUNT(Emp.Cd)[Count] from Employee as Emp 
inner join Codes on Emp.LocCd=Codes.Cd and typ='HLOC '
group by  Codes.SDes
end
else if @v_Typ='Status'
begin
select SysCodes.SDes[Des],COUNT(Emp.Cd)[Count] from Employee as Emp 
inner join SysCodes on Emp.Status=SysCodes.Cd and typ='HSTAT '
group by  SysCodes.SDes
end
 
 
 Go 
CREATE OR ALTER   Trigger [dbo].[Trigger_Veh_DocIssueRcpt] on [dbo].[VehDocIssueRcpt] for insert,update
as --drop  Trigger [dbo].[Trigger_Veh_DocIssueRcpt]
begin 

	
			
declare @ApprBy	char(10)
declare @Stat	char(1)
--declare @VehCd	char(10)
--declare @DocTyp	Char(10)
--declare @SrNo	numeric(5,0)

--declare @Flag int 

--declare @recipients varchar(MAX) 
--declare @body varchar(MAX) 
--declare @ProfileName varchar(100)  
 
--		CREATE table #Temp(
--		 EmailId varchar(40) ,
--		 Body varchar(500) ,
--		 SNo int )
		 
-----Assigning Values--------------
--select @Flag=1
--select @ApprBy=ApprBy from inserted
--select @Stat=Stat from inserted
--select @VehCd=VehCd from inserted
--select @DocTyp=DocTyp from inserted
--select @SrNo=SrNo from inserted

--set @ProfileName = ( select Val from Parameters where Cd='EMAIL_PROFILE       ' and AppCd='HR' and CoCd='#')
---------Updating------------------


--if @Stat='A'
--	BEGIN
	 
--			if((select Top 1 Docstat from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo) ='HDS0003')
--			begin
--				insert into VehDocuments(VehCd,DocTyp,SrNo,DocNo,OthRefNo,IssueDt,IssuePlace,ExpDt,EntryBy,EntryDt)
--					values(
--						@VehCd
--					,	@DocTyp
--					,	(select Top 1 SrNo+1 from VehDocuments where VehCd=@VehCd and DocTyp=@DocTyp order by SrNo desc) 
--					,	(select Top 1 DocNo from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	(select Top 1 OthRefNo from VehDocuments where VehCd=@VehCd and DocTyp=@DocTyp order by SrNo desc) 
--					,	(select Top 1 IssueDt from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	(select Top 1 IssuePlace from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	(select Top 1 ExpDt from VehDocIssueRcpt where VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo)
--					,	@ApprBy
--					,	getdate())
--			End
	
--			insert into #Temp
--			select distinct VehA.Email,
--				('The '+ C.Des +' which you '
--				+ case when Vehl.DocStat='HDS0002' then 'issue from 'else ' return to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is approved.'),
--					@Flag
--			from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			--inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			--inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
			
			
--	END

	
--else if @Stat='R'
--	BEGIN
--			insert into #Temp
--			select distinct VehA.Email,
--				('The '+ C.Des +' which you '
--				+ case when Vehl.DocStat='HDS0002' then 'issue from 'else ' return to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is rejected.'),
--					@Flag
--			from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
--	END		

			
--else if @Stat='N' and @ApprBy is null
--	BEGIN
--			insert into #Temp
--			select (select Email from VehAddress where VehCd=(select VehCd From CompanyProcessApprovalDetail as CPAD
--			where CPAD.ProcessId='HRPT8' 
--			and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--			and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--			and SrNo='1') and AddTyp='HADD0001')
--			,((select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=Vehl.VehCd)
--				+ ' applied to ' +
--				+ case when Vehl.DocStat='HDS0002' then ' issue 'else ' return ' end
--				+ case when (select Veh.Sex from Vehloyee where Cd=Vehl.VehCd)='M' then ' his 'else ' her ' end 
--				+ C.Des 
--				+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is waiting for an approval from you.'),
--					@Flag
--				from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
			
			
--			insert into #Temp
--			select VehA.Email,
--					('The application to '
--					+ case when Vehl.DocStat='HDS0002' then 'issue 'else ' return ' end
--					+ ' your ' + C.Des 
--					+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--					+'company wants to be approved by '
--					+ (select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=
--						(select CPAD.VehCd From CompanyProcessApprovalDetail as CPAD
--						where CPAD.ProcessId='HRPT8' 
--						and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.SrNo='1'))),
--					@Flag
--				from VehDocIssueRcpt as Vehl 
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
--	END		
			
--else if @Stat='N' and @ApprBy is not null	
--	BEGIN
--			insert into #Temp
--			select (select Email from VehAddress where VehCd=(select VehCd From CompanyProcessApprovalDetail as CPAD
--			where CPAD.ProcessId='HRPT8' 
--			and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--			and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--			and SrNo=((select ApprLvl from VehDocIssueRcptAppr where VehCd=Vehl.VehCd and DocTyp=Vehl.DocTyp and SrNo=Vehl.SrNo )+1) 
--				and AddTyp='HADD0001'))
--			,((select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=Vehl.VehCd)
--				+ ' applied to ' +
--				+ case when Vehl.DocStat='HDS0002' then ' issue 'else ' return ' end
--				+ case when (select Veh.Sex from Vehloyee where Cd=Vehl.VehCd)='M' then ' his 'else ' her ' end 
--				+ C.Des 
--				+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--				+ 'company for ' +Vehl.Narr
--					+' on '+ CONVERT(varchar(20),Vehl.TrnDt,103)
--					+' is waiting for an approval from you.'),
--					@Flag
--				from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo
--			set @Flag=@Flag+1
			
--			insert into #Temp
--			select VehA.Email,
--					('The application to '
--					+ case when Vehl.DocStat='HDS0002' then 'issue 'else ' return ' end
--					+ ' your ' + C.Des 
--					+ case when Vehl.DocStat='HDS0002' then ' from 'else ' to ' end
--					+'company wants to be approved by '
--					+ (select Veh.Fname+Veh.Mname+Veh.Lname from Vehloyee as Veh where Veh.Cd=
--						(select CPAD.VehCd From CompanyProcessApprovalDetail as CPAD
--						where CPAD.ProcessId='HRPT8' 
--						and CPAD.Div=(select Div from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.Dept=(select Dept from Vehloyee where Cd=Vehl.VehCd)
--						and CPAD.SrNo=(select ApprLvl+1 from VehDocIssueRcptAppr where VehCd=Vehl.VehCd and DocTyp=Vehl.DocTyp and SrNo=Vehl.SrNo )))),
--					@Flag
--				from VehDocIssueRcpt as Vehl
--			inner join Codes as c on C.Cd=Vehl.DocTyp and C.Typ='HDTYP'
--			inner join VehAddress as VehA on Vehl.VehCd=VehA.VehCd and VehA.AddTyp='HADD0001'
--			inner join Vehloyee as Veh on Veh.Cd=Vehl.VehCd	
--			where Vehl.VehCd=@VehCd and DocTyp=@DocTyp and SrNo=@SrNo	
--			set @Flag=@Flag+1
--	END		

--		declare @Count numeric(3,0)
--		declare @RowNo numeric(3,0)
--		set @RowNo=1
--		set @Count=(select COUNT(EmailId) from #Temp)
--		while(@RowNo<=@Count)
--		begin
		
--			set @recipients=(select EmailId from #Temp where SNo=@RowNo)
--			set @body=(select Body from #Temp where SNo=@RowNo )
--			if @recipients !=''
--				BEGIN
--					EXEC msdb.dbo.sp_send_dbmail 
--					@profile_name =@ProfileName,
--					@recipients = @recipients,
--					@subject ='HRMS Document Issue',
--					@body = @body, 
--					@body_format = 'TEXT';
--				END
--			set @RowNo=@RowNo+1
--		end
--		Drop table #Temp
		
	

	end
 
 
 Go 
CREATE OR ALTER   Procedure [dbo].[EmpEarnDed2_GetRow_N]
	@v_EmpCd			Char(10)
,	@v_EdTyp		Varchar(20)
,	@v_EdCd			Varchar(20)
As	    -- Drop Procedure EmpEarnDed2_GetRow 'MHM/005','Allowances/Earnings','OTHER ALLOWANCE' -- 'BASIC' 
Begin	-- EmpEarnDed2_GetRow 'MHM/005','Allowances/Earnings','BASIC'
	Declare @v_CoCd			Char(5)
	--Declare @v_EdTyp		Char(10)	-- sp_help CompanyEarnDed Syscodes select * from Syscodes Where typ='HEDT'
	--Declare @v_EdCd			Char(5)
	Declare @v_BasicCd		Char(5)
	Declare @v_St_Prd		Char(10)
	Declare @v_St_Dt		Char(10)
	Declare @v_CUR_MONTH	Numeric(2)
	Declare @v_CUR_YEAR		Numeric(4)
	Declare @v_SrNo			Numeric(5,0)		-- select * from EmpEarnDed			select * from CompanyEarnDed

	Select @v_CoCd	= CoCd From Employee Where Cd=@v_EmpCd
	--Select @v_EdTyp	= Cd From SysCodes Where Typ='HEDT' and SDes=@v_EdTypSDes
	--Select @v_EdCd	= Cd From CompanyEarnDed Where Typ=@v_EdTyp and SDes=@v_EdCdSDes
	Select @v_BasicCd=RTrim(Isnull(Val,'')) From Parameters Where CoCd='#' and Cd='BASIC'
	Select @v_St_Prd=RTrim(Isnull(Val,'')) From Parameters Where CoCd=@v_CoCd and Cd='HR_ST_PRD'
	Set @v_St_Dt=Left(@v_St_Prd,4)+'/'+Substring(@v_St_Prd,5,2)+'/01'
	Select @v_CUR_MONTH=Cast(RTrim(Val) as Int) From Parameters Where CoCd=@v_CoCd and Cd='CUR_MONTH'
	Select @v_CUR_YEAR=Cast(RTrim(Val) as Int) From Parameters Where CoCd=@v_CoCd and Cd='CUR_YEAR'
	Select @v_SrNo=Count(1) From EmpEarnDed Where EmpCd=@v_EmpCd and EdTyp=@v_EdTyp and EdCd=@v_EdCd
	Select @v_SrNo=SrNo From EmpEarnDed Where EmpCd=@v_EmpCd and EdTyp=@v_EdTyp and EdCd=@v_EdCd and SrNo>=@v_SrNo
	Select
--	,	Max(PercAmt)[PercAmt]
--	,	Max(EffDate)[Eff.Date]
--	,	Isnull(Max(PercVal),0)[Percent]
--	,	Isnull(Max(AmtVal),0)[Amount]
		PercAmt
	,	EffDate
	,	Isnull(PercVal,0)[Percent]
	,	Isnull(AmtVal,0)[Amount]
	From
		EmpEarnDed
	Where
		EmpCd=@v_EmpCd and EdTyp=@v_EdTyp and EdCd=@v_EdCd and SrNo=@v_SrNo
--	Group By
--		EmpCd
--	,	EdTyp
--	,	EdCd
--	Having
--		(EmpCd +EdTyp +EdCd) in (Select (EmpCd +EdTyp +EdCd) From EmpEarnDed Where EffDate=Max(EffDate))
--	and (select Count(1) from EmpEarnDed where EmpCd=@v_EmpCd and EdTyp=@v_EdTyp and EdCd=@v_EdCd)<>0
	Union
	Select
--		Cd[EmpCd]
--	,	''[EdTyp]
--	,	''[EdCd]
		'A'[PercAmt]
	,	@v_St_Dt[EffDate]
	,	0[Percent]
	,	[Basic][Amount]
	From
		Employee
	Where
		Cd=@v_EmpCd and @v_EdCd=@v_BasicCd
	and	(Select Count(1) From EmpEarnDed Where EmpCd=@v_EmpCd and EdTyp=@v_EdTyp and EdCd=@v_BasicCd) =0
	Order By
		EffDate
End 
 
 Go 
--Drop Procedure EmpProgressionDetail_Update
CREATE OR ALTER   procedure [dbo].[EmpProgressionDetail_Update_N]
		@v_TransNo      char(10)  
	,	@v_SrNo        	numeric(5)   
	--,	@v_EdCdDes      varchar(20)
	,	@v_EdCd			Char(5)
	--,	@v_EdTypDes	varchar(20)
	,	@v_EdTyp		Char(10)	
	,	@v_EffDate	datetime     
	,	@v_PercAmt	Char(1)
	,	@v_Val		numeric(15,4)
	,	@v_ApprVal	numeric(15,4)
	,	@v_Narr		Varchar(50)
	,	@v_EntryBy	Char(5)
as
begin
	--declare @v_EdCd Char(5)
	--declare @v_EdTyp Char(10)
	--select 	@v_EdTyp=cd from  Syscodes where SDes=@v_EdTypDes and Typ='HEDT'
	--select  @v_EdCd=cd from CompanyEarnDed  where SDes=@v_EdCdDes and Typ=@v_EdTyp 

	
IF (SELECT COUNT(*) FROM EmpProgressionDetail WHERE  SrNo=@v_SrNo and TransNo=@v_TransNo) = 0
	Begin
	insert into EmpProgressionDetail
	values
	(
		@v_TransNo     
	,	@v_SrNo        
	,	@v_EdCd
	,	@v_EdTyp
	,	@v_EffDate	
	,	@v_PercAmt	
	,	@v_Val	
	,	@v_ApprVal	
	,	@v_Narr		
	,	@v_EntryBy	
	,     getdate()
	,     null
	,     null

        )
end
Else
    Begin
        Update EmpProgressionDetail
          Set
		EdCd=@v_EdCd
	,	EdTyp=@v_EdTyp
	,	EffDt=@v_EffDate	
	,	PercAmt=@v_PercAmt
	,       Val=@v_Val
	,	ApprVal=@v_ApprVal
	,	Narr=@v_Narr
	where   SrNo=@v_SrNo and TransNo=@v_TransNo
    End
End
 
 
 Go 
CREATE OR ALTER   procedure [dbo].[EmpProgressionHead_Update_N]
	@v_TransNo		Char(10)
,	@v_TransDt		Datetime
,	@v_EmpCd		Char(10)=''
--,	@v_DesigFrDes	VarChar(20) --comment by Syed
--,	@v_DesigToDes	VarChar(20)
,	@v_DesigFr	Char(5)=''
,	@v_DesigTo	Char(5)=''
,	@v_ApprBy		Char(10) = ''
,	@v_ApprDt		Char(10) = ''
,	@v_Remarks		Varchar(50)=''
,	@v_EntryBy		Char(5) = ''
,	@v_Status       Char(1) = ''
--,	@v_TypDes		Char(20) --comment by Syed
,	@v_Typ		Char(10)=''

As		-- Drop Procedure [dbo].[EmpProgressionHead_Update]
Begin
	IF (SELECT COUNT(*) FROM EmpProgressionHead WHERE TransNo=@v_TransNo ) = 0
	  Begin
		insert into EmpProgressionHead(TransNo,TransDt,EmpCd,FromDesg,ToDesg,Remarks,EntryBy,EntryDt,Status,Typ) 
		values (
			@v_TransNo
		,	@v_TransDt	
		,	@v_EmpCd	
		,	@v_DesigFr	
		,	@v_DesigTo	
		,	@v_Remarks	
		,	@v_EntryBy
		,	getdate()
		,	@v_Status
		,	@v_Typ)
		if((select COUNT(*) From CompanyProcessApprovalDetail as CPAD
						where CPAD.ProcessId='HRPT6' 
						and CPAD.ApplTyp=(select Typ from EmpProgressionHead where TransNo=@v_TransNo)
						and CPAD.Div=(select Div from Employee where Cd=@v_EmpCd)
						and CPAD.Dept=(select Dept from Employee where Cd=@v_EmpCd)
						and CPAD.CoCd=(select CoCd from Employee where Cd=@v_EmpCd))=0)
		BEGIN
				Update EmpProgressionHead Set
				TransNo=@v_TransNo
			,	TransDt=@v_TransDt
			,	EmpCd=@v_EmpCd	
			,	ToDesg=@v_DesigTo
			,	ApprBy=@v_EntryBy	
			,	ApprDt=getdate()
			,	Remarks=@v_Remarks	
			,	EditBy=@v_EntryBy
			,	EditDt=getdate()
			,	Status='A'
			,	Typ=@v_Typ
			where	TransNo=@v_TransNo
		END
						
	  End
	Else
	  Begin
		Update EmpProgressionHead Set
			TransNo=@v_TransNo
		,	TransDt=@v_TransDt
		,	EmpCd=@v_EmpCd	
		,	ToDesg=@v_DesigTo
		,	ApprBy=@v_ApprBy	
		,	ApprDt=@v_ApprDt
		,	Remarks=@v_Remarks	
		,	EditBy=@v_EntryBy
		,	EditDt=getdate()
		,	Status=@v_Status
		,	Typ=@v_Typ
		where	TransNo=@v_TransNo
		
	  End
	
End
 
 
 Go 

CREATE OR ALTER     PROCEDURE [dbo].[EmpDocIssueRcpt_GetRow_N]
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
	,	(select Imagefile from Employee where cd= Emp.Cd) [ImagePath]
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

 
 
 
 Go 
CREATE OR ALTER   Procedure [dbo].[EmpProgressionHead_GetRow_N]
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
	,	(select Imagefile from Employee where cd= Emp.Cd) [ImagePath]
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
CREATE OR ALTER   Trigger [dbo].[Trigger_Delete_AirFare] on [dbo].[AirFare] for delete
as
declare @SectCd Char(10)
declare @Class 	Char(10)
declare	@SrNo	numeric(5)

select @SectCd=SectCd from deleted
select @Class=Class from deleted
select @SrNo=SrNo from deleted

declare @row int
declare @rowc int
set @rowc=@SrNo+1
	select @row=max(SrNo) from AirFare where SectCd=@SectCd and @Class=Class
		while @rowc <=@row
			begin
				update AirFare set Srno=@Srno-1 where Srno=@rowc and SectCd=@SectCd and @Class=Class
				set @rowc=@rowc+1
			end
 
 
 Go 


CREATE OR ALTER   Procedure [dbo].[EmplLoanAndLeaveApproval]
	@v_CoCd		char(5)
,	@v_EmpCd	Char(10)
,	@v_Typ		Char(1)
AS
--Drop Procedure [dbo].[EmplLoanAndLeaveApproval]'01','HR','U'

select COUNT(TransNo) as OnLeave from EmpLeave
inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
where GETDATE() between FromDt and ToDt and LvStatus='F' and emp.CoCd=@v_CoCd and emp.Status='HSTATPM   '

select COUNT(TransNo) as LeaveApproval  from EmpLeave
inner join Employee as emp on emp.Cd=EmpLeave.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS2' and CPA.ApplTyp=EmpLeave.LvTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	LvStatus='N' 
	and emp.CoCd=@v_CoCd
	and emp.Status='HSTATPM   '
	and ((LvApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (LvApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS2' and ApplTyp=EmpLeave.LvTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=LvApprBy or (select UserCd from Employee where Cd=EmpCd)=LvApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))

select COUNT(TransNo) as LeaveSalaryTicketApproval  from EmpLeaveSalaryTicket ELST
inner join Employee as emp on emp.Cd=ELST.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS3' and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	ELST.Status='N' 
	and emp.CoCd=@v_CoCd
	and emp.Status='HSTATPM   '
	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (ApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS3' and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))

select COUNT(TransNo) as LoanApproval  from EmpLoan
inner join Employee as emp on emp.Cd=EmpLoan.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS1' and CPA.ApplTyp=EmpLoan.LoanTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	LoanStatus='N' 
	and emp.CoCd=@v_CoCd
	and emp.Status='HSTATPM   '
	and ((LoanApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (LoanApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS1' and ApplTyp=EmpLoan.LoanTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=LoanApprBy or (select UserCd from Employee where Cd=EmpCd)=LoanApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))

		
select COUNT(EDI.EmpCd) as  DocumentIssue from EmpDocIssueRcpt as EDI
inner join  Employee as emp on emp.Cd=EDI.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT8' and CPA.ApplTyp=EDI.DocTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	EDI.Stat='N' 
	and emp.CoCd=@v_CoCd 
	and emp.Status='HSTATPM   '   
	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (ApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT8' and ApplTyp=EDI.DocTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))



select COUNT(EmpProgressionHead.EmpCd) as EmpProgression  from EmpProgressionHead
inner join Employee as emp on emp.Cd=EmpProgressionHead.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT6' and CPA.ApplTyp=EmpProgressionHead.Typ and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	EmpProgressionHead.Status='E' 
	and emp.CoCd=@v_CoCd
	and emp.Status='HSTATPM   '
	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (ApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT6' and ApplTyp=EmpProgressionHead.Typ and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))
	
select COUNT(empprovisionsadj.EmpCd) as ProvAdj  from empprovisionsadj
inner join Employee as emp on emp.Cd=empprovisionsadj.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPT14' and CPA.ApplTyp=empprovisionsadj.ProvTyp and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	empprovisionsadj.Status='E' 
	and emp.CoCd=@v_CoCd
	and emp.Status='HSTATPM   '
	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (ApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPT14' and ApplTyp=empprovisionsadj.ProvTyp and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))
			 
	
select SysCodes.Cd[Cd],SysCodes.Des,COUNT(Emp.Cd) as HeadCount from Employee as Emp 
right   join SysCodes on Emp.Status=SysCodes.Cd  
group by  SysCodes.Des,typ,emp.CoCd,SysCodes.Cd 
having  typ='HSTAT ' or emp.CoCd=@v_CoCd


declare @CurMonth int
set @CurMonth=(select Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_MONTH           ')


--order by Abbr
--or Prd=
--(select (CONVERT(varchar(10),(select Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            ')))+
--(CONVERT(varchar(10),(select right ('00'+ltrim(str( (@CurMonth-1) )),2 ))))) 

--select * from syscodes where typ='HEDT ' and cd<>'HEDT04    '
declare @monthname as varchar(50)
set @monthname=
 case @CurMonth
when 1 then 'January'  
when 2 then 'February' 
when 3 then 'March' 
when 4 then 'April' 
when 5 then 'May' 
when 6 then 'June' 
when 7 then 'July' 
when 8 then 'August' 
when 9 then 'September' 
when 10 then 'October' 
when 11 then 'November' 
when 12 then 'December' 
end 
select @monthname +' '+Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            '

declare @monthnameminusone as varchar(50)
set @monthnameminusone=
case @CurMonth-1
when 0 then 'December' 
when 1 then 'January'  
when 2 then 'February' 
when 3 then 'March' 
when 4 then 'April' 
when 5 then 'May' 
when 6 then 'June' 
when 7 then 'July' 
when 8 then 'August' 
when 9 then 'September' 
when 10 then 'October' 
when 11 then 'November' 
when 12 then 'December' 
end 
if( @monthnameminusone = 'December' )
begin
select @monthnameminusone +' '+
(select CONVERT(varchar, CONVERT(int, Val)-1) from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            ')
end
else
begin
select @monthnameminusone +' '+Val from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR            '
end

select SysCodes.Des,isnull(CONVERT(decimal(18,2), SUM(Amt)),0) as  PayElementDetailsCount  
from EmpTransDetailYtd
right  join SysCodes on EmpTransDetailYtd.EdTyp=SysCodes.Cd  
where Prd=(select Val*100+(@CurMonth-1) from  Parameters where CoCd=@v_CoCd and Cd='CUR_YEAR')
group by  SysCodes.Des,typ,cd,Abbr--,Prd
having typ='HEDT ' and cd<>'HEDT04    '
--and Prd=(select Val++convert(varchar(10),RIGHT('00' + CONVERT(VARCHAR,@CurMonth-1), 2)) from  Parameters where CoCd='03' and Cd='CUR_YEAR')


select COUNT(TransNo) as FundApproval  from EmpFund
inner join Employee as emp on emp.Cd=EmpFund.EmpCd
inner join CompanyProcessApproval as CPA on CPA.ProcessId='HRPSS4' and CPA.ApplTyp=EmpFund.Typ and CPA.Div=emp.Div and CPA.Dept=emp.Dept
inner join CompanyProcessApprovalDetail as CPAD on CPAD.CoCd=CPA.CoCd and CPAD.ProcessId=CPA.ProcessId and CPAD.ApplTyp=CPA.ApplTyp and CPAD.Div=CPA.Div and CPAD.Dept=CPA.Dept
where 
	EmpFund.[Status]='N' 
	and emp.CoCd=@v_CoCd
	and emp.Status='HSTATPM'
	and ((ApprBy is null and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd))) and cpad.SrNo='1')
		or (ApprBy is not null
			and CPAD.SrNo=(select SrNo from CompanyProcessApprovalDetail where ProcessId='HRPSS4' and ApplTyp=EmpFund.typ and Div=emp.Div and Dept=emp.Dept and (EmpCd=ApprBy or (select UserCd from Employee where Cd=EmpCd)=ApprBy)) +1
			and ((@v_Typ='E' and CPAD.EmpCd=@v_EmpCd) or (@v_Typ='U' and cpad.EmpCd in (Select Cd from Employee where UserCd=@v_EmpCd)))))






 
 
 Go 

CREATE OR ALTER   PROCEDURE [dbo].[GetDashboardCalendarEvents]
	@v_Usercd			varchar(10)	
AS
BEGIN
	SET NOCOUNT ON;

	select ROW_NUMBER() OVER (ORDER BY [Date] desc) AS SrNo,* from 
		(select 
			 Fname+' '+isnull(Mname,'')+' '+isnull(Lname,'') [Name],Dob[Date],Div,'Birthday'[Type]
		from Employee
		union all
		 select 
			 Fname+' '+isnull(Mname,'')+' '+isnull(Lname,'') [Name],Doj[Date],Div,'Work Anniversary'[Type]
		from Employee) Emp
		where 
		Emp.Div in(select div from UserBranch where (UserCd=@v_Usercd or @v_Usercd=''))
END
 
 
 Go 
