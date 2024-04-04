CREATE procedure [dbo].[EmpAddress_Update_N]  
  @v_EmpCd  Char(10)  
 , @v_AddTyp  VarChar(20)  
 , @v_Contact  VarChar(30)  
 , @v_Add1  VarChar(200)  
 , @v_Add2  VarChar(40)  
 , @v_Add3  VarChar(40)  
 , @v_City  VarChar(30)  
 , @v_Country VarChar(20)
 , @v_Phone  Char(20)  
 , @v_Mobile  Char(20)  
 , @v_Fax  Char(20)  
 , @v_Email  VarChar(40)  
 , @v_EntryBy  Char(5) 
 ,@v_Mode Char(1)
as  
begin  
   
set nocount on  
Declare @err int  
IF (SELECT COUNT(*) FROM EmpAddress WHERE EmpCd =@v_EmpCd and AddTyp=@v_AddTyp) = 0  
 Begin  
 insert into EmpAddress  
 values  
 (  
          @v_EmpCd  
 ,     @v_AddTyp  
 ,     @v_Contact  
 ,     @v_Add1  
 ,     @v_Add2  
 ,     @v_Add3  
 ,     @v_City  
 ,     @v_Country
 ,     @v_Phone  
 ,     @v_Mobile  
 ,     @v_Fax  
 ,     @v_Email  
 ,     @v_EntryBy  
 ,     getdate()  
 ,     null  
 ,     null  
        )  
		exec GetMessage 1,'Inserted successfully'
end  
Else IF (@v_Mode = 'I')
		exec GetMessage 0,'Already exists'
else
    Begin  
        Update EmpAddress  
          Set  
              Contact=@v_Contact  
 ,            Add1=@v_Add1  
 ,            Add2=@v_Add2  
 ,            Add3=@v_Add3  
 ,            City=@v_City  
 ,            Country=@v_Country  
 ,            Phone=@v_Phone  
 ,            Mobile=@v_Mobile  
 ,            Fax=@v_Fax  
 ,            Email=@v_Email  
 ,            EditBy=@v_EntryBy  
 ,            EditDt=getdate()  
        where        EmpCd=@v_EmpCd and AddTyp=@v_AddTyp  
		exec GetMessage 1,'Updated successfully'
    End  
Select @err = @@error  
 If @err != 0   
  GoTo errorHandler  
  Return  
errorHandler:  
 Return 1  
End
