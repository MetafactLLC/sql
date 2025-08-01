



;WITH cte_columns AS (
	SELECT c.TABLE_CATALOG, c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME, c.ORDINAL_POSITION, c.DATA_TYPE, 
		c.NUMERIC_PRECISION, c.CHARACTER_MAXIMUM_LENGTH, t.TABLE_TYPE, s.crdate, 
		((SUM(i.reserved)*8.00)/1000.00) AS size_MB, ((SUM(i.dpages)*8.00)/1000.00) AS data_mb, ((SUM(i.used)*8.00)/1000.00) AS used 	
	FROM INFORMATION_SCHEMA.columns c
		INNER JOIN INFORMATION_SCHEMA.TABLES t ON t.TABLE_NAME = c.TABLE_NAME
												AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
												AND t.TABLE_CATALOG = c.TABLE_CATALOG
		INNER JOIN sysobjects s ON s.name = t.TABLE_NAME AND s.xtype = 'u'
		INNER JOIN sysindexes i ON i.id = s.id
	GROUP BY c.TABLE_CATALOG, c.TABLE_SCHEMA, c.TABLE_NAME, c.COLUMN_NAME, c.ORDINAL_POSITION, c.DATA_TYPE, 
		c.NUMERIC_PRECISION, c.CHARACTER_MAXIMUM_LENGTH, t.TABLE_TYPE, s.crdate
)

SELECT DISTINCT table_name, cte.crdate , cte.size_mB, cte.data_mb, cte.used
FROM cte_columns cte 
	WHERE table_name LIKE '%_[0-9]'
ORDER BY 1

/*
SELECT * FROM sysobjects WHERE xtype = 'u'

SELECT * FROM sys.sysallocunits

SELECT * FROM sys.partitions
*/

/*
SELECT DISTINCT table_name, cte_columns.crdate 
FROM cte_columns
WHERE cte_columns.TABLE_SCHEMA = 'dbo'
ORDER BY 1
*/

