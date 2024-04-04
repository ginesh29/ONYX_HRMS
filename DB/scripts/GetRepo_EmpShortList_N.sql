


CREATE Procedure [dbo].[GetRepo_EmpShortList_N]
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



As		-- Drop Procedure [dbo].[GetRepo_EmpShortList_N] '01','All ','All ','All ','All ','All ','All','0','HQUAL0001 ','','2'
Begin
	Select
		distinct Emp.Cd [Code]
	,	rtrim(Emp.Fname)+' '+rtrim(Emp.Mname)+' '+rtrim(Emp.Lname) [EmpName]
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
	,	(select rtrim(FName)+' '+rtrim(MName)+rtrim(LName) from Employee where Cd=(select RepTo from Employee where Employee.cd=Emp.Cd))[ReportingTo]
	,	(Select Des from Currency where Cd= Emp.BasicCurr) [BasicCurr]
	,	Emp.Basic [Basic]
	,	Emp.Basic+(select Sum(isnull(AmtVal,0)) from empearnded where EmpCd=Emp.Cd and (Rtrim(EdCd)+RTrim(EdTyp))<>'001HEDT01' and CONVERT(varchar(10), EndDate,103)='01/01/1900') [Total]
	,	Emp.FareEligible [FareEligiblity]
	,	(select Des from codes where Typ='ESPON' and Cd=emp.Sponsor)[Sponsor]
	,	(select Des from Syscodes where cd=Emp.PayMode) [PayMode]
	,	(select Des from Syscodes where cd=Emp.PayFreq) [PayFrequency]
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




