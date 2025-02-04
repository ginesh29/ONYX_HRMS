USE [LSHRMS_Telal_LIVE_NEW]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 28/04/2024 12:26:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER   FUNCTION [dbo].[SplitString]
(
    @String NVARCHAR(MAX),
    @Delimiter NVARCHAR(10)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Value = LTRIM(RTRIM(SUBSTRING(@String, Number, CHARINDEX(@Delimiter, @String + @Delimiter, Number) - Number)))
    FROM 
        (SELECT TOP (LEN(@String) + 1) Number = ROW_NUMBER() OVER (ORDER BY a.object_id)
         FROM sys.all_objects a
         CROSS JOIN sys.all_objects b) AS n
    WHERE 
        Number <= LEN(@String) + 1
        AND SUBSTRING(@Delimiter + @String, Number, LEN(@Delimiter)) = @Delimiter
);