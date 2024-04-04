



CREATE Procedure [dbo].[Employee_GetRow_N]    
	@v_Param		varchar(40)    
,	@v_Typ			Char(2)    
,	@v_Cocd			Char(5)    
,	@v_RowsCnt		int 
,	@v_Div			varchar(40)		='0'
,	@v_Dept			varchar(40)		='0'
,	@v_Sponsor		varchar(40)		='0'
,	@v_Designation	varchar(40)		='0'
,	@v_Status		varchar(40)		='0'
,	@v_Usercd		varchar(10)
As  -- Drop Procedure [dbo].[Employee_GetRow_N] '','99','01','2','0','0','0','0','PW'
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
--  and ( Emp.cd in (select distinct empcd from EmpLeave where ((@v_Status='OL' and LvStatus='F') or (@v_Status='PW' and LvStatus not in ('Y','F')) 
--or  (@v_Status='LR' and LvStatus  in ('N')) or (@v_Status='LA' and LvStatus not in ('Y')) )) or @v_Status='0')
--  and
--  (	
--	 (@v_Status='OL' and  emp.cd in  (select  distinct empcd from EmpLeave where LvStatus ='F' and cast(FromDt as date)<=cast(GETDATE() as date) and (
--	(cast(ToDt as date)>=cast(getdate() as date)
--	or (cast(ToDt as date)<=cast(getdate() as date) and isnull(JoinDt,'01/01/1900')='01/01/1900')
	
--	)
--	)))
--  or (@v_Status='PW' and emp.cd  in  (select distinct empcd from EmpLeave where LvStatus not in ('F') and cast(FromDt as date)<=cast(GETDATE() as date) and cast(ToDt as date)>=cast(getdate() as date)  union
--	select cd from Employee))  
--or (@v_Status='LR' and emp.cd in  (select  distinct empcd from EmpLeave where LvStatus  in ('N') and cast(FromDt as date)<=cast(GETDATE() as date) and cast(ToDt as date)>=cast(getdate() as date) ))
--  or (@v_Status='LA' and emp.cd in  (select distinct  empcd from EmpLeave where LvStatus  in ('Y') and cast(FromDt as date)>=cast(GETDATE() as date) and cast(ToDt as date)>=cast(getdate() as date) and a ))
--  or (@v_Status='0')
--  )
--and ( 
--(@v_Status='OL' and emp.cd in (select distinct empcd from empleave where LvStatus='F' and isnull(joindt,'01/01/1900')='01/01/1900' and cast(FromDt as date) <= cast(getdate() as date)  ) )
--or 
--(@v_Status='LA' and emp.cd in (select distinct empcd from empleave where LvStatus='Y' and isnull(ConfirmDt,'01/01/1900')='01/01/1900' and isnull(LvApprDt,'01/01/1900')<>'01/01/1900' and isnull(joindt,'01/01/1900')='01/01/1900' and cast(FromDt as date) <= cast(getdate() as date)  ))
--or
--(@v_Status='LR' and emp.cd in (select distinct empcd from empleave where LvStatus='N' and isnull(ConfirmDt,'01/01/1900')='01/01/1900' and isnull(LvApprDt,'01/01/1900')='01/01/1900' and isnull(joindt,'01/01/1900')='01/01/1900' and cast(FromDt as date) <= cast(getdate() as date)  ))
--or
--(@v_Status='PW' and emp.cd in (select distinct empcd from empleave where LvStatus not in ('F','Y') union select cd from employee ))
--or 
--(@v_Status='0')
--)
 
 Order By    
  EntryDt desc  
 , EditDt desc  
 , Emp.Cd  
 
End  

