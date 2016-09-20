

 Object  StoredProcedure [dbo].[sp_displayVersions]    Script Date 06272016 152833 
IF  EXISTS (SELECT  FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_displayVersions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_displayVersions]
GO



 Object  StoredProcedure [dbo].[sp_displayVersions]    Script Date 06272016 152833 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_displayVersions]
	-- Add the parameters for the stored procedure here
@selectedVersion NVARCHAR(20), @selectedDispatch NVARCHAR(20)
AS
BEGIN
--DECLARE @selectedVersion NVARCHAR(20), @selectedDispatch NVARCHAR(20)
--SET @selectedVersion = 'PX V9R7.2.1.2'
--SET @selectedDispatch = 'PX V9R7.2.2.10'
--SET @selectedVersion = 'PX V9R7.2.1.2'
--SET @selectedDispatch = 'PX V9R7.2.2.10'

IF  object_id('tempdb..#tmpCTE') is not null
DROP TABLE #tmpCTE

CREATE TABLE #tmpCTE (Ver NVARCHAR(20),BuiltFrom NVARCHAR(20),VerValue NVARCHAR(20), builtFromValue NVARCHAR(20))

INSERT INTO #tmpCTE
exec [sp_getBuildVersionParents] @selectedVersion, @selectedDispatch

DECLARE csrValue CURSOR FOR
SELECT  from #tmpCTE

DECLARE 
@Version NVARCHAR(20),
@builtFrom NVARCHAR(20),
@versionValue NVARCHAR(20),
@builtFromValue NVARCHAR(20),
@val1 NVARCHAR(20),
@val2 NVARCHAR(20)

OPEN csrValue
FETCH NEXT FROM csrValue into @version,@builtFrom,@val1,@val2

WHILE @@FETCH_STATUS = 0
	BEGIN 
		
		exec sp_CalculateVersionValue @Version, @Result = @versionValue OUTPUT
		exec sp_CalculateVersionValue @builtFrom, @Result = @builtFromValue OUTPUT
		
		UPDATE #tmpCTE
		SET VerValue = @versionValue
		WHERE ver = @Version
		
		UPDATE #tmpCTE
		SET builtFromValue = @builtFromValue
		where ver = @Version
		
		FETCH NEXT FROM csrValue into @version,@builtFrom,@val1,@val2;
	END;
CLOSE csrValue
DEALLOCATE csrValue

--SELECT ,
--SUBSTRING(verValue,0,CHARINDEX('.',verValue)) 'cv', 
--SUBSTRING(verValue,CHARINDEX('.',verValue)+1,LEN(verValue)) 'cv_rev',
--SUBSTRING(builtFromValue,0,CHARINDEX('.',builtFromValue)) 'bfv',
--SUBSTRING(builtFromValue,CHARINDEX('.',builtFromValue)+1,LEN(builtFromValue)) 'bfv_rev'
--from #tmpCTE

DECLARE @tmpVal NVARCHAR(20) --HOLD RETURNED VALUE FOR COMPARISON
exec sp_CalculateVersionValue @selectedVersion, @Result = @tmpVal OUTPUT

IF  object_id('tempdb..#tmpVer') is not null
DROP TABLE #tmpVer

CREATE TABLE #tmpVer (cv NVARCHAR(20), cv_rev NVARCHAR(20), bfv NVARCHAR(20), bfv_rev NVARCHAR(20), selectedVal NVARCHAR(20), selectedRev NVARCHAR(20))
INSERT INTO #tmpVer
SELECT
SUBSTRING(verValue,0,CHARINDEX('.',verValue)) 'cv', 
SUBSTRING(verValue,CHARINDEX('.',verValue)+1,LEN(verValue)) 'cv_rev',
SUBSTRING(builtFromValue,0,CHARINDEX('.',builtFromValue)) 'bfv',
SUBSTRING(builtFromValue,CHARINDEX('.',builtFromValue)+1,LEN(builtFromValue)) 'bfv_rev',
SUBSTRING(@tmpVal,0,CHARINDEX('.',@tmpVal)) 'selVer', 
SUBSTRING(@tmpVal,CHARINDEX('.',@tmpVal)+1,LEN(@tmpVal)) 'selRev'
from #tmpCTE


SELECT --[cv]+[cv_rev] 'Version',[bfv]+[bfv_rev] 'Built_From',
#tmpCTE.Ver, #tmpCTE.BuiltFrom
FROM #tmpver
INNER JOIN #tmpCTE on #tmpCTE.VerValue = [cv]+[cv_rev] and #tmpCTE.builtFromValue = [bfv]+[bfv_rev]
WHERE CONVERT(float,[bfv]+[bfv_rev]) = CONVERT(FLOAT,[selectedVal]+[selectedRev])


IF  object_id('tempdb..#tmpVer') is not null
DROP TABLE #tmpVer
IF  object_id('tempdb..#tmpCTE') is not null
DROP TABLE #tmpCTE


END

GO


