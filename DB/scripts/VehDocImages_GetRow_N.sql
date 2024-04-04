CREATE Procedure [dbo].[VehDocImages_GetRow_N]
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
