
CREATE PROCEDURE GetEmployee_N
	@v_CoCd varchar(5)
AS
BEGIN
	
	SET NOCOUNT ON;
	select * from Employee where CoCd= @v_CoCd
END
