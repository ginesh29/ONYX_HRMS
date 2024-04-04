CREATE PROCEDURE [dbo].[Validate_Employee_N]
	@v_EMPID varchar(30)
,	@v_PWD varchar(200) 
As	-- Drop PROCEDURE [dbo].[Validate_Employee_N] 'admin','MTIzNDU2'
--select * from Employees
Begin
	-- SET NOCOUNT ON added to prevent extra result sets 
	-- from interfering with SELECT statements.
	SET NOCOUNT ON
	Select * from Employee where Cd = @v_EMPID and Pwd = @v_PWD
End
