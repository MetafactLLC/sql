






CREATE VIEW [VW_RPT_EMER_SCHN_VSBL_PULLREPORT] 

AS   

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME  LIKE '%STATUS%'

SELECT TOP 100 a.STP_STATUS AS [STATUS], a.TC_SHP_ID AS [SHP ID], a.CARR_CD AS CARRIER, 
		'X' AS [DIV_SHP], b.PO_NBR as PO, a.FLOW_PATH, 
		a.STP_SFLOC_ALIAS_NM as ORIGIN, a.STP_SEQ_NBR as STOP_NBR, a.STP_SFLOC_ALIAS_ID as DEST, 
		'IL' as ST, b.PO_CRT_DT, SUBSTRING(a.CARR_CD,0,3) as DEPT, 
		a.ORIG_SFLOC_ALIAS_NM as CONTENTS, a.EST_PU as [ESTIMATED_PICKUP], '(A)' as F15,
		a.EST_DL AS [ESTIMATED_DELIVERY (ETA)], '(a)' AS F17, '*' AS F18,
		a.MILES_OUT as [MILES_OUT (GPS)], LAST_KNOWN_LOC AS [LAST KNOWN_LOCATION],
		a.LAST_KNOWN_LOC_DTTM as [LAST KNOWN_LOCATION (DT/TM)], a.COMMENTS_STR AS [ _COMMENTS],
		b.CRT_TS as [KEYREC_DATE], b.CRT_TS as [SHIP_CREATE], 'XXX.X' as [CUBE], 
		'XXX.X' as [WEIGHT], b.STP_ACTN_TYP_IND as [TRANS_MODE], a.STP_SFLOC_ALIAS_ID as [TRAILER],
		a.ORIG_SFLOC_ALIAS_NM as [MERCHANT], a.COMMENTS_SHP as [PO_COMMENTS], 'NORTHERN' as [DIVISION], 
		'CENTRAL' as [REGION], b.LAST_UPD_SYSUSR_ID as [DISTRICT (DM)], b.CRT_SYSUSR_ID as [MARKET], 
		'PREPAID, ETA NOT AVAILABLE' as [ALERT(S)], (case a.STP_STATUS ) as status_sort_order 
FROM VW_EMER_SCHN_VSBL_MAIN_LNDG a
INNER JOIN EMER_SCHN_VSBL_STP_PO b ON a.TC_SHP_ID = b.TC_SHP_ID


SELECT TOP 100 * FROM EMER_SCHN_VSBL_STP_PO
SELECT TOP 100 * FROM VW_EMER_SCHN_VSBL_MAIN_LNDG
SELECT TOP 100 * FROM [dbo].[VW_EMER_SCHN_VSBL_GPS]







  
SELECT DISTINCT  rtrim(ltrim([STATUS])) as [STATUS], rtrim(ltrim([SHIP ID])) as [SHIP ID], rtrim(ltrim([CARRIER])) as [CARRIER], 
		rtrim(ltrim([DIV_SHP])) as [DIV_SHP], rtrim(ltrim([PO])) as [PO], rtrim(ltrim([FLOW_PATH])) as [FLOW_PATH], 
		rtrim(ltrim([ORIGIN])) as [ORIGIN], rtrim(ltrim([STOP_NBR])) as [STOP_NBR], rtrim(ltrim([DEST])) as [DEST], 
		rtrim(ltrim([ST])) as [ST], [PO_CREATE], rtrim(ltrim([DEPT])) as [DEPT], 
		rtrim(ltrim([CONTENTS])) as [CONTENTS], [ESTIMATED_PICKUP], rtrim(ltrim([F15])) as [F15], 
		[ESTIMATED_DELIVERY (ETA)], rtrim(ltrim([F17])) as [F17], rtrim(ltrim([F18])) as [F18], 
		rtrim(ltrim([MILES_OUT (GPS)])) as [MILES_OUT (GPS)], rtrim(ltrim([LAST KNOWN_LOCATION])) as [LAST KNOWN_LOCATION], 
		[LAST KNOWN_LOCATION (DT/TM)], rtrim(ltrim([ _COMMENTS])) as [ _COMMENTS], 
		[KEYREC_DATE], [SHIP_CREATE], rtrim(ltrim([CUBE])) as [CUBE], 
		rtrim(ltrim([WEIGHT])) as [WEIGHT], rtrim(ltrim([TRANS_MODE])) as [TRANS_MODE], rtrim(ltrim([TRAILER])) as [TRAILER], 
		rtrim(ltrim([MERCHANT])) as [MERCHANT], rtrim(ltrim([PO_COMMENTS])) as [PO_COMMENTS], rtrim(ltrim([DIVISION])) as [DIVISION], 
		rtrim(ltrim([REGION])) as [REGION], rtrim(ltrim([DISTRICT (DM)])) as [DISTRICT (DM)], rtrim(ltrim([MARKET])) as [MARKET], 
		rtrim(ltrim([ALERT(S)])) as [ALERT(S)], 
		status_sort_order 
from carrier_shipments
  







