CREATE Procedure [dbo].[EmpDocImages_GetRow_N]
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
 