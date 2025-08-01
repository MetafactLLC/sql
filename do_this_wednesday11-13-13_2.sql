

Select distinct DEPT, MERCHANT, ORIGIN, 
    dbo.UDF_GET_WORK_DAYS(PO_CREATE, GETDATE(),0) as BUSINESSHOURS, 
    PO, CONTENTS, PO_CREATE, DEST + ' - ' + STP_SFLOC_ALIAS_NM as DEST, 
    ST, '1' as TIMESONREPORT, 
    GETDATE() as RUNTIME
    --select * 
from  STG_RPT_EMER_SCHN_VSBL_PULLREPORT
where PO_CREATE is not null
    and ORIGIN is not null
    and FLOW_PATH = 'VND-STR'
    and dbo.UDF_GET_WORK_DAYS(PO_CREATE, GETDATE(),0) > 6
order by DEPT, MERCHANT, ORIGIN, PO_CREATE desc

Select distinct DEPT, MERCHANT, ORIGIN, 
    dbo.UDF_GET_WORK_DAYS(PO_CREATE, GETDATE(),0) as BUSINESSHOURS, 
    PO, CONTENTS, PO_CREATE, DEST + ' - ' + STP_SFLOC_ALIAS_NM as DEST, 
    ST, '1' as TIMESONREPORT, 
    GETDATE() as RUNTIME, 
    ipr_category_owners,
    ipr_category_owners_email,
    ipr_category_owners_mgr,
    ipr_category_owners_mgr_email,
    ipr_category_owners_sr_mgr,
    ipr_category_owners_sr_mgr_email
from  STG_RPT_EMER_SCHN_VSBL_PULLREPORT
where PO_CREATE is not null
    and ORIGIN is not null
    and FLOW_PATH = 'VND-STR'
    and dbo.UDF_GET_WORK_DAYS(PO_CREATE, GETDATE(),0) > 6
order by DEPT, MERCHANT, ORIGIN, PO_CREATE desc

select distinct DEPT  from STG_RPT_EMER_SCHN_VSBL_PULLREPORT where DEPT is not null order by DEPT

-- select * from STG_RPT_EMER_SCHN_VSBL_PULLREPORT where PO_CREATE is not null and ORIGIN is not null

select * from INFORMATION_SCHEMA.columns where table_name = 'STG_RPT_EMER_SCHN_VSBL_PULLREPORT'




/*
Select  DEPT, MERCHANT, ORIGIN, 
    dbo.UDF_GET_WORK_DAYS(PO_CREATE, GETDATE(),0) as BUSINESSHOURS, 
    PO, CONTENTS, PO_CREATE, DEST, ST, '1' as TIMESONREPORT, 
    GETDATE() as RUNTIME  
from  STG_RPT_EMER_SCHN_VSBL_PULLREPORT
where PO_CREATE is not null
*/

-- select @@servername





