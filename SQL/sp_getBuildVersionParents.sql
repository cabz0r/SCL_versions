

/****** Object:  StoredProcedure [dbo].[sp_getBuildVersionParents]    Script Date: 06/27/2016 15:27:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_getBuildVersionParents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_getBuildVersionParents]
GO



/****** Object:  StoredProcedure [dbo].[sp_getBuildVersionParents]    Script Date: 06/27/2016 15:27:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_getBuildVersionParents] @CurrentVer NVARCHAR(20),@Dispatch NVARCHAR (20)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE 
	--@CurrentVer NVARCHAR(20), 
	--@Dispatch NVARCHAR (20)
	--SET @CurrentVer = 'PX V9R7.2'  
	--SET @Dispatch = 'PX V9R7.2.2.10'

	
WITH CTE as (

--GET BASE RECORDS
select [1] 'Version',
CASE WHEN (SUBSTRING(PRODCAT.[10],0,3) LIKE 'PX') THEN [10] ELSE 'PX '+[10] END 'Built From', NULL 'VerValue', NULL 'builtFromValue'
from PRODCAT
where [1] = @Dispatch 

UNION ALL

--GET ASSOCIATED VERSION RECORDS FROM ABOVE DATASET
select pc.[1] 'Version',
CASE WHEN (SUBSTRING(pc.[10],0,3) LIKE 'PX') THEN [10] ELSE 'PX '+[10] END 'Built From', NULL 'VerValue', NULL 'builtFromValue'
from PRODCAT as pc
inner join CTE on pc.[1] = cte.[Built From]
WHERE pc.[10] <> @CurrentVer --DOES NOT INCLUDE RECORD SET FOR @CurrentVer

)

SELECT * FROM CTE

UNION ALL

SELECT  pc.[1] 'Version',
CASE WHEN (SUBSTRING(pc.[10],0,3) LIKE 'PX') THEN [10] ELSE 'PX '+[10] END 'Built From', NULL 'VerValue', NULL 'builtFromValue'
from PRODCAT as pc
inner join CTE on pc.[1] = cte.[Built From]
WHERE pc.[10] = @CurrentVer --INCLUDES RECORD SET FOR @CurrentVer

END

GO


