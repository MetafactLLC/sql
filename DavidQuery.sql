EXEC PARCEL.DBO.DROP_IF_EXISTS '#TEMP' 
SELECT * INTO #TEMP FROM OPENQUERY(IBM_PR1,'
                        SELECT A.DC_BU_ID
                                    ,  A.DC_NBR AS LOC_NBR, 
                   ''DC'' AS LOC_TYPE , 
                   D.LNG_NBR,  
                   D.LAT_NBR,  
                   D.ADDR_LINE1_TXT,
                   D.CITY_NM,
                   D.ST_CD,
                   D.PSTL_CD
                   FROM PR1.PRTHD.EPR_DC A,  
                   PR1.PRTHD.PRTY_CMECH_ROLE B,  
                   PR1.PRTHD.EPR_CMECH C,  
                   PR1.PRTHD.EPR_ADDR D   
                    WHERE A.DC_BU_ID = B.PRTY_ID  
                   AND B.CMECH_ID = C.CMECH_ID  
                   AND B.CMECH_ID = D.ADDR_ID  
                   AND D.LNG_NBR IS NOT NULL  
                   AND D.LAT_NBR IS NOT NULL
                   AND B.CMECH_ROLE_CD = 52
                        UNION ALL
                        
                        SELECT A.STR_BU_ID,  
                   A.STR_NBR AS LOC_NBR,
                   ''STR'' AS LOC_TYPE ,  
                   D.LNG_NBR,  
                   D.LAT_NBR,  
                   D.ADDR_LINE1_TXT,
                   D.CITY_NM,
                   D.ST_CD,
                   D.PSTL_CD
                   FROM PR1.PRTHD.EPR_STR A,  
                   PR1.PRTHD.PRTY_CMECH_ROLE B,  
                   PR1.PRTHD.EPR_CMECH C,  
                   PR1.PRTHD.EPR_ADDR D   
                    WHERE A.STR_BU_ID = B.PRTY_ID  
                   AND B.CMECH_ID = C.CMECH_ID  
                   AND B.CMECH_ID = D.ADDR_ID  
                   AND D.LNG_NBR IS NOT NULL  
                   AND D.LAT_NBR IS NOT NULL
                   AND B.CMECH_ROLE_CD = 52
WITH UR
')


EXEC PARCEL.DBO.DROP_IF_EXISTS '#EMER_SCHN_VSBL_TMS_FAC'
CREATE TABLE #EMER_SCHN_VSBL_TMS_FAC (
SFLOC_ALIAS_ID varchar(16) NOT NULL
,LAST_UPD_SYSUSR_ID char(24) NOT NULL
,LAST_UPD_TS datetime NOT NULL
,LAT_NBR decimal(11,7) NOT NULL
,LNG_NBR decimal(11,7) NOT NULL
,TM_ZONE_ID smallint NULL
,GMT_ADJ_HRS decimal(4,2) NULL
,TM_ZONE_DESC varchar(150) NULL
)
INSERT INTO #EMER_SCHN_VSBL_TMS_FAC (
            SFLOC_ALIAS_ID, LAST_UPD_SYSUSR_ID, LAST_UPD_TS, LAT_NBR, LNG_NBR
            , TM_ZONE_ID, GMT_ADJ_HRS, TM_ZONE_DESC
)
SELECT * FROM OPENQUERY(IBM_PR6,'

SELECT DISTINCT 
            FA.FACILITY_ALIAS_ID AS SFLOC_ALIAS_ID 
            , CAST(''EVIS_FAC'' AS CHAR(24)) AS LAST_UPD_SYSUSR_ID
            , CURRENT_TIMESTAMP AS LAST_UPD_TS
            , LATITUDE as LAT_NBR
            , LONGITUDE AS LNG_NBR
            , TIME_ZONE_ID AS TM_ZONE_ID
            , GMT_OFFSET AS GMT_ADJ_HRS 
            , TZ.TIME_ZONE_NAME AS TM_ZONE_DESC 

FROM
            PRHDW.TMS_FACILITY F,
            PRHDW.TMS_FACILITY_ALIAS FA, 
            PRHDW.TMS_TIME_ZONE TZ
            
WHERE
            F.FACILITY_ID = FA.FACILITY_ID
            AND F.FACILITY_TZ = TZ.TIME_ZONE_ID
            AND LATITUDE IS NOT NULL    
			AND FA.MARK_FOR_DELETION = 0
')
--LATITUDE, LONGITUTE

select * from #EMER_SCHN_VSBL_TMS_FAC
select * from #TEMP





