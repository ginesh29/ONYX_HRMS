CREATE Procedure [dbo].[Codes_Auto_GetRow_N]
	@v_Typ	char(5)      
As		-- Drop Procedure dbo.Codes_Auto_GetRow_N 'BANK'
Begin
	Declare @Len int
	Declare @LenCodes int
	Select @LenCodes=Val From Parameters where Cd='LEN_CODES'
	set @Len=Len(Ltrim(Rtrim(@v_Typ)))
	if (Select Count(1) From CodeGroups where Cd=@v_Typ) <> 0
		Select 
			Right('0000000000'+ Isnull(Rtrim(Max(Right(Ltrim(Rtrim(Cd)),Len(Ltrim(Rtrim(Cd)))-@Len))+1),1), @LenCodes)[NewCode]
		From
			Codes
		Where
			Typ=@v_Typ
	else
		Select Cd From Codes where 1=2
End
