



DECLARE @t TABLE(eye_d INT IDENTITY(1,1), ItemID UNIQUEIDENTIFIER, Name VARCHAR(500), Type INT, typedescription VARCHAR(100), content IMAGE, varchar_content VARCHAR(MAX), xml_content XML) 
DECLARE @i INT, @c INT 
SET @i = 1; 

/*
SELECT TOP 100 CONVERT(VARBINARY(MAX), content), * 
FROM dbo.Catalog 
WHERE content IS NOT null
---------------------------------------------------------------------------------------------------
SELECT ItemID, Name, Type, Content
FROM dbo.Catalog 
WHERE content IS NOT null
---------------------------------------------------------------------------------------------------
*/
;WITH MyBinaries AS (
	SELECT ItemID, Name, Type, 
	CAST(Content AS VARBINARY(MAX)) AS content, 
	CASE Type	
		WHEN 2 THEN 'Report'
		WHEN 5 THEN 'Data Source'
		WHEN 7 THEN 'Report part'
		WHEN 8 THEN 'Shared dataset'
		ELSE 'other'
	END AS TypeDescription
	FROM dbo.Catalog 
	WHERE type IN (2,5,7,8)
), ItemContent AS (
	SELECT ItemID, Name, Type, TypeDescription, 
		CASE 
			WHEN LEFT(content,3) = 0xEFBBBF THEN CAST(SUBSTRING(content,4,LEN(content)) AS VARBINARY(MAX))
			ELSE content
		END AS content 		
	FROM MyBinaries
)

INSERT INTO @t(ItemID, Name, Type, typedescription, content, varchar_content)
SELECT ItemID, Name, Type, TypeDescription, 
	content, 
	CAST(content AS VARCHAR(MAX)) AS varchar_content  
FROM ItemContent

SET @c = @@ROWCOUNT

WHILE @i < @c+1
BEGIN 
	BEGIN TRY
		UPDATE @t
			SET xml_content = CAST(varchar_content AS XML)	
		 WHERE eye_d = @i  
	END TRY 
	BEGIN CATCH 
	END CATCH 
	SET @i = @i + 1 
END 

SELECT ItemID, name, type,  
	Query.value('(./*:CommandText/text())[1]','nvarchar(max)') AS commandtext 	
FROM @t t
	CROSS APPLY t.xml_content.nodes('//*:Query') Queries(Query)




