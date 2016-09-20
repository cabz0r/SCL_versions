

/****** Object:  StoredProcedure [dbo].[sp_CalculateVersionValue]    Script Date: 06/27/2016 15:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CalculateVersionValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_CalculateVersionValue]
GO



/****** Object:  StoredProcedure [dbo].[sp_CalculateVersionValue]    Script Date: 06/27/2016 15:29:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CalculateVersionValue] 
	-- Add the parameters for the stored procedure here
	@PXVal NVARCHAR(20),
	@Result NVARCHAR(20) OUTPUT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CurrentClientVer NVARCHAR(20), 
			--@DispatchVer NVARCHAR (20),
			@clientRevision NVARCHAR (20),
			--@dispatchRevision NVARCHAR (20),
			@clientVersion NVARCHAR (3),
			--@dispatchVersion NVARCHAR (3),
			@clientValue NVARCHAR(20),
			--@dispatchValue NVARCHAR (20),
			@start INT,
			@stop INT
			
	
	SET @CurrentClientVer = @PXVal --'PX V9R7.3.10'

	SET @start = CHARINDEX('V',@CurrentClientVer)
	SET @stop = CHARINDEX('R',@CurrentClientVer)
	SET @clientVersion = SUBSTRING(@CurrentClientVer,@start+1,@stop-@start-1) --GET VERSION NUMBER
	SET @CurrentClientVer =  REPLACE(@CurrentClientVer,'.','')  --REMOVE DECIMAL POINTS FROM REVISION NUMBER
	SET @clientRevision = SUBSTRING(@CurrentClientVer,@stop+1,LEN(@CurrentClientVer)) --GET REVISION NUMBER
	SET @clientValue = @clientVersion + '.' + @clientRevision
	
	SET @Result = @clientValue
	--SELECT @clientValue

END
GO


