

CREATE Procedure [dbo].[Airfare_GetRow_N]
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
