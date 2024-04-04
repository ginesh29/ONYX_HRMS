CREATE Procedure [dbo].[CompDocImages_GetRow_N]
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
