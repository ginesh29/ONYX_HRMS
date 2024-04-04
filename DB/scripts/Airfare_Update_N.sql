CREATE Procedure [dbo].[Airfare_Update_N]
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
