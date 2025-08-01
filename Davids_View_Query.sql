
--ALTER VIEW [dbo].[VW_EMER_SCHN_VSBL_PO_TAB_FOR_PROC] AS (        
      
        
SELECT   
 cast(po.tc_shp_id as varchar(50)) as TC_SHP_ID,   
 cast(po.STP_SFLOC_ALIAS_ID as varchar(16)) as STP_SFLOC_ALIAS_ID,   
 byo.PO_NBR  
 , byo.LOC_NBR  
 , byo.CRT_DT --DO NOT PUT THIS FIELD ON UI  
 , byo.MERC_CTGRY_ID AS SUBDEPT  
 , RIGHT('0' + CAST(byo.MER_CLASS_NBR AS VARCHAR(4)),2)   
 + ' - ' +   
 byo.SHRT_CLASS_DESC  
 AS CLASS  
 , RIGHT('0' + CAST(byo.MER_SUB_CLASS_NBR AS VARCHAR(4)),2)   
 + ' - ' +   
 byo.SHRT_SUBCLASS_DESC  
 AS SUBCLASS  
 , byo.PO_STAT_CD   
 , byo.SKU_NBR  
 , byo.SKU_DESC  
 , cast(byo.ORD_QTY as int) as ORD_QTY  
 , (case
	 when (byo.PO_STAT_CD = 4) then 'Cancelled'
	 when ((byo.PO_STAT_CD = 2) and (byo.ORD_QTY > 0)) then 'Open'
	 when ((byo.PO_STAT_CD = 3) and (byo.ORD_QTY > 0)) then 'Closed'
	 when ((byo.ORD_QTY = 0) and (byo.PO_STAT_CD in(2,3)) ) then 'Cancelled'
    end) as EVIS_PO_STATUS_DESC
from VW_EMER_SCHN_VSBL_MAIN_LNDG PO with (nolock) 
	inner join EMER_SCHN_VSBL_BYO_PO BYO with (nolock) on 
            PO.PO_NBR = BYO.PO_NBR          
              AND PO.CRT_DT = BYO.CRT_DT
              AND PO.STP_SFLOC_ALIAS_ID       = BYO.LOC_NBR    

--	 left outer VW_EMER_SCHN_VSBL_BYO_PO_CANC
--	 all_skus_cancelled_flg = 'Y'


/*
The VW_EMER_SCHN_VSBL_BYO_PO_CANC table has summary level info - filter on all skus cancelled flg
*/


--select * from VW_EMER_SCHN_VSBL_BYO_PO_CANC where all_skus_cancelled_flg = 'Y'

--select @@servername

--select * from VW_EMER_SCHN_VSBL_BYO_PO_CANC where all_skus_cancelled_flg = '0' 


--)      
--GO


