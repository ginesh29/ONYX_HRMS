CREATE Procedure [dbo].[Employee_Update_N]
--drop Procedure [dbo].[Employee_Update_N]
	@v_Cd				Char(10)	= null   -- Drop Procedure [dbo].[Employee_Update_N]  
,	@v_Fname			VarChar(40)	= null    
,	@v_Salute			VarChar(10)	= null   
,	@v_Mname			VarChar(40) = null  
,	@v_Lname			VarChar(40) = null    
,	@v_Sex				Char(1)		= null  
,	@v_CoCd				Char(5)		= null   
,	@v_Div				VarChar(5)	= null    
,	@v_CC				Varchar(10)	= null    
,	@v_Dept				VarChar(10)	= null    
,	@v_LocCd			VarChar(10) = null    
,	@v_POB				VarChar(40) = null   
,	@v_Nat				VarChar(5) = null   
,	@v_Relg				VarChar(10) = null   
,	@v_Marital			VarChar(10) = null   
,	@v_Desg				VarChar(5) = null   
,	@v_Dob				datetime  
,	@v_Doj				datetime    
,	@v_EmpCat1			VarChar(10) = null
,	@v_EmpCat2			VarChar(10) = null   
,	@v_EmpCat3			VarChar(10) = null   
,	@v_RepTo			Char(10)	= null  
,	@v_Father			VarChar(40) = null    
,	@v_Mother			VarChar(40) = null    
,	@v_Spouse			VarChar(40) = null    
,	@v_Probation		datetime = null   
,	@v_Confrm			datetime =  null  
,	@v_Leaving			datetime =null  
,	@v_CurrCd			VarChar(5)	= null  
,	@v_Basic			Numeric(9,3)= 0.0    
,	@v_BasicCurr		Varchar(5)	= null  
,	@v_Personal_No		varchar(50) = null
,	@v_FareEligible		Char(1)		= null  
,	@v_NoTickets		Numeric(6,3)= 0.0    
,	@v_TravSect			VarChar(10)	= null  
,	@v_TravClass		VarChar(10)	= null    
,	@v_HomeBase			VarChar(20)	= null    
,	@v_PayMode			VarChar(10)	= null    
,	@v_PayFreq			VarChar(10)	= null   
,	@v_BankCd			VarChar(10)	= null   
,	@v_LvDays			Numeric(5,2)= 0.0  
,	@v_LvSalaryDays			Numeric(5,2)= 0.0    
,	@v_Status			VarChar(10)	= null  
,	@v_Sponsor			VarChar(10) = null  
--, @v_ImageFile		VarChar(500)= null   
--, @v_ImageSign		VarChar(500)= null
,	@v_EntryBy			Char(5)		= null
,	@v_OTEligible		Char(1)		= null
,	@v_LvPrd			Numeric(4,2)= null
,	@v_TradeCd			Varchar(5)	= null
,	@v_EmpTyp			Varchar(10)	= null
,	@v_Pwd				Char(200)	= null
,	@v_ApprCd			Char(10)	= null
,	@v_UserCd			Varchar(10)	= null
,	@v_ShiftCd			Varchar(10)	= null
,	@v_CalcBasis		Char(1)		= null
,	@v_GT				Char(1)		= null
,	@v_LS				Char(1)		= null
,	@v_LT				Char(1)		= null
,	@v_Active			Char(1)		= null
--,	@v_ProvOPAmt		Numeric(15,3)= 0.0   
--,	@v_ProvOPDays		Numeric(15,3)= 0.0    
,	@v_LeaveOB			Numeric(15,3)= 0.0  
,	@v_PassportLocation	varchar(50)=''
,	@v_ImageFile		varchar(100)=''
,	@v_ImageSign		varchar(100)=''
As
Begin  
	Set nocount on  
	declare  @Cd	Char(10) 
	IF (SELECT COUNT(*) FROM Employee WHERE Cd = @v_Cd) = 0    
	  Begin
		Insert into Employee(  
			Cd  
		,	Fname    
		,	Salute    
		,	Mname    
		,	Lname    
		,	Sex    
		,	CoCd    
		,	Div    
		,	CC    
		,	Dept    
		,	LocCd    
		,	POB    
		,	Nat    
		,	Relg    
		,	Marital    
		,	Desg    
		,	Dob    
		,	Doj    
		,	EmpCat1    
		,	EmpCat2    
		,	EmpCat3    
		,	RepTo    
		,	Father    
		,	Mother    
		,	Spouse    
		,	Probation    
		,	Confrm 
		,	Leaving   
		,	BasicCurr    
		,	[Basic]
		,	CurrCd   
		,	Personal_No		-- Newly added field
		,	FareEligible    
		,	NoTickets    
		,	TravSect    
		,	TravClass    
		,	HomeBase    
		,	PayMode    
		,	PayFreq    
		,	BankCd
		,	LvDays
		,	[Status]
		,	Sponsor
		--, ImageFile   //syed on 22/06/2014  
		--, ImageSign    
		,	EntryBy    
		,	EntryDt    
		,	OTEligible    
		,	LvPrd    
		,	TradeCd    
		,	EmpTyp    
		,	ApprCd    
		,	Pwd    
		,	UserCd    
		--, ShiftCd  --Check with PK   
		,	CalcBasis  
		,	GT  
		,	LS  
		,	LT
		,	Active
		,	PassportLocation
		,	Imagefile
		,	ImageSign) 
		Values(  
			@v_Cd    
		,	@v_Fname    
		,	@v_Salute    
		,	@v_Mname    
		,	@v_Lname    
		,	@v_Sex    
		,	@v_CoCd    
		,	@v_Div    
		,	@v_CC    
		,	@v_Dept    
		,	@v_LocCd    
		,	@v_POB    
		,	@v_Nat    
		,	@v_Relg    
		,	@v_Marital    
		,	@v_Desg     
		,	@v_Dob    
		,	@v_Doj    
		,	@v_EmpCat1    
		,	@v_EmpCat2    
		,	@v_EmpCat3    
		,	@v_RepTo    
		,	@v_Father    
		,	@v_Mother    
		,	@v_Spouse    
		,	@v_Probation    
		,	@v_Confrm 
		,	@v_Leaving   
		,	@v_BasicCurr    
		,	@v_Basic    
		,	@v_CurrCd    
		,	@v_Personal_No
		,	@v_FareEligible    
		,	@v_NoTickets    
		,	@v_TravSect    
		,	@v_TravClass    
		,	@v_HomeBase    
		,	@v_PayMode    
		,	@v_PayFreq    
		,	@v_BankCd    
		,	@v_LvSalaryDays    
		,	@v_Status    
		,	@v_Sponsor    
		--, @v_Imagefile   //syed  
		--, @v_ImageSign    
		,	@v_EntryBy    
		,	GetDate()  
		,	@v_OTEligible       
		,	@v_LvPrd    
		,	@v_TradeCd    
		,	@v_EmpTyp    
		,	@v_ApprCd     
		,	@v_Pwd     
		,	@v_UserCd  
		--,	@v_ShiftCd   --Check with PK  
		,	@v_CalcBasis  
		,	@v_GT  
		,	@v_LS  
		,	@v_LT
		,	@v_Active
		,	@v_PassportLocation
		,	@v_ImageFile
		,	@v_ImageSign)
		exec GetMessage 1,'Inserted successfully'
		select @@IDENTITY 
		SET @Cd=@@IDENTITY 
		insert into ErrorLog values(@Cd,GETDATE(),3,'','')		
	  End
	Else    
	  Begin
		Update Employee    
		Set
			Fname		=@v_Fname    
		,	Salute		=@v_Salute    
		,	Mname		=@v_Mname    
		,	Lname		=@v_Lname    
		,	Sex			=@v_Sex    
		,	CoCd		=@v_CoCd    
		,	Div			=@v_Div    
		,	CC			=@v_CC    
		,	Dept		=@v_Dept    
		,	LocCd		=@v_LocCd    
		,	POB			=@v_POB    
		,	Nat			=@v_Nat    
		,	Relg		=@v_Relg    
		,	Marital		=@v_Marital    
		,	Desg		=@v_Desg    
		,	Dob			=@v_Dob    
		,	Doj			=@v_Doj    
		,	EmpCat1		=@v_EmpCat1    
		,	EmpCat2		=@v_EmpCat2    
		,	EmpCat3		=@v_EmpCat3    
		,	RepTo		=@v_RepTo    
		,	Father		=@v_Father    
		,	Mother		=@v_Mother    
		,	Spouse		=@v_Spouse    
		,	Probation	=@v_Probation    
		,	Confrm		=@v_Confrm 
		,	Leaving	=@v_Leaving   
		,	BasicCurr	=@v_BasicCurr    
		,	[Basic]		=@v_Basic
		,	CurrCd		=@v_CurrCd   
		,	Personal_No	=@v_Personal_No 
		,	FareEligible=@v_FareEligible    
		,	NoTickets	=@v_NoTickets    
		,	TravSect	=@v_TravSect    
		,	TravClass	=@v_TravClass    
		,	HomeBase	=@v_HomeBase    
		,	PayMode		=@v_PayMode    
		,	PayFreq		=@v_PayFreq    
		,	BankCd		=@v_BankCd    
		,	LvDays		=@v_LvSalaryDays    
		,	[Status]    =@v_Status    
		,	Sponsor		=@v_Sponsor    
		--,	Imagefile	=@v_Imagefile  //syed  
		--,	ImageSign	=@v_ImageSign    
		,	EditBy		=@v_EntryBy    
		,	EditDt		=GetDate()    
		,	OTEligible	=@v_OTEligible     
		,	LvPrd		=@v_LvPrd     
		,	TradeCd		=@v_TradeCd    
		,	EmpTyp		=@v_EmpTyp    
		,	ApprCd		=@v_ApprCd  
		,	Pwd			=@v_Pwd   
		,	UserCd		=@v_UserCd  
		--,	ShiftCd		=@v_ShiftCd    --Check with PK   
		,	CalcBasis	=@v_CalcBasis  
		,	GT			=@v_GT  
		,	LS			=@v_LS
		,	LT			=@v_LT
		,	Active		=@v_Active
		,	PassportLocation=@v_PassportLocation
		,	Imagefile	=@v_ImageFile
		,	ImageSign	=@v_ImageSign
		Where
			Cd = @v_Cd and CoCd=@v_CoCd 
		exec GetMessage 1,'Updated successfully'
		select @v_Cd 
		SET @Cd=@v_Cd 
		insert into ErrorLog values(@Cd,GETDATE(),4,'','')
		
	  End
		EXEC EmpLeaveMaster_Update @Cd,'AL',@v_LvDays,@v_LeaveOB,0,0,0,0,0,@v_EntryBy,'a'
		
		insert into ErrorLog values(@Cd,GETDATE(),5,'','')
End
