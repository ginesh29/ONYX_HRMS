
CREATE procedure [dbo].[EmpLeave_Update_N]	-- Drop Procedure [dbo].[EmpLeave_Update_N]
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
