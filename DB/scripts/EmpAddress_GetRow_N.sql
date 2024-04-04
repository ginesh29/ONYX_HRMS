CREATE procedure [dbo].[EmpAddress_GetRow_N]
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
