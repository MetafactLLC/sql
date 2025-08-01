
select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 502 -- 1
select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 504 -- 8
select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 505 -- 



declare @StartDateTime datetime = getdate() - (365*.05)
declare @EndDateTime datetime = getdate() 
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
SELECT top 100 
  DATEADD(
    MINUTE,
    ABS(CHECKSUM(NEWID())) % DATEDIFF(MINUTE, @StartDateTime, @EndDateTime) + DATEDIFF(MINUTE, 0, @StartDateTime),
    0
  ) AS RandomStartDateTime
       , cast(null as datetime) as RandomEndDatetime
       , cast(null as float) as getworkdays

into #temp
FROM EMER_SCHN_VSBL_BYO_PO

update #temp
set RandomEndDatetime = 
  DATEADD(
    MINUTE,
    ABS(CHECKSUM(NEWID())) % DATEDIFF(MINUTE, RandomStartDateTime, getdate()) + DATEDIFF(MINUTE, 0, RandomStartDateTime),
    0
  ) 


update #temp
set getworkdays = dbo.UDF_GET_WORK_DAYS(RandomStartDateTime,RandomEndDatetime)




select * from #temp

