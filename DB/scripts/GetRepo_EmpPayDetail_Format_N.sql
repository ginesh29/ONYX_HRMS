
CREATE Procedure [dbo].[GetRepo_EmpPayDetail_Format_N]
 	@v_CoCd			Char(5)		
,	@v_RPrd			Char(2)	
,	@v_RYear		Char(4)
,   @v_Employee     Char(10)	
,   @v_Branch       char(5)	
,   @v_Location     char(10)
,   @v_Department   Char(10)
,   @v_Sponsor      Char(10)
As				-- Drop Procedure [GetRepo_EmpPayDetail_Format_N]'01','09','2023','1131       ','All','All ','All','All'
				
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
			Search,Desg,Doj,dept,Sponsor,secttion,Paymode,TMF1,TMF2,TMF3,TMFPay,ManagerIncentives,Incentives,StaffAdvCollected,StaffAdvGiven,StaffFundCollected,StaffFundGiven,FOTA,
			TransportAllowance,LivingAllowance,OverTime,LastSalary,LSA,LTA,Pension
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

