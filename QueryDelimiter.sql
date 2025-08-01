

create procedure USP_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER_DEPT (@showoriginalstring bit=0)
as

declare @t table(eyed int identity(1,1), dept varchar(50))
declare @depts table(dept varchar(10), originalstring varchar(50))
declare @counter int, @end int
declare @deptstring varchar(50)

insert into @t (dept) select distinct dept from STG_RPT_EMER_SCHN_VSBL_PULLREPORT
set @counter = 1
set @end = (select top 1 eyed from @t order by eyed desc)

while @counter < @end 
begin
    set @deptstring = (select dept from @t where eyed = @counter)
    insert into @depts(dept, originalstring) select dept, originalstring from dbo.UDF_PARSE_DEPT_STRING(@deptstring)
    set @counter = @counter + 1
end

if @showoriginalstring = 0 
begin
    select * from @depts
end 
else
begin
    select distinct dept from @depts where dept is not null
end


/*
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
    and ltrim(rtrim(DEPT)) in('21')
--    and ltrim(rtrim(DEPT)) in(isnull(ltrim(rtrim(@dept)), ltrim(rtrim(DEPT))) )
order by DEPT, MERCHANT, ORIGIN, PO_CREATE desc
*/

--exec USP_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER @calculateWeekends=0,@dept='21,21, 28I'

-- exec USP_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER @calculateWeekends=0,@dept='21'


-- exec USP_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER @calculateWeekends=0,@dept=N' 21, 21, 28I, 22, 22, 23F, 22, 24, 22, 25H, 22, 25T, 22, 26B, 22, 28I, 23F, 23F, 25H, 23F, 25T, 23F, 26P, 23F, 27L, 23F, 28I, 23F, 28O, 24, 24, 25T, 24, 26P, 24, 27E, 24, 28I, 24, 28O, 24, 59S, 25H, 25H, 25T, 25H, 25T, 26P, 25H, 25T, 59S, 25H, 26P, 25H, 59S, 25T, 25T, 26P, 25T, 27E, 25T, 28I, 25T, 28O, 26B, 26B, 26P, 26B, 28O, 26P, 26P, 27E, 26P, 27L, 26P, 28I, 26P, 28O, 26P, 30, 26P, 59S, 27E, 27E, 28I, 27E, 59S, 27L, 28I, 28I, 28O, 28I, 30, 28O, 28O, 30, 28O, 59S, 29K, 29K, 30, 30, 59S'

-- exec USP_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER @calculateWeekends=0,@dept=' 21, 21, 28I, 22, 22, 23F, 22, 24, 22, 25H, 22, 25T, 22, 26B, 22, 28I, 23F, 23F, 25H, 23F, 25T, 23F, 26P, 23F, 27L, 23F, 28I, 23F, 28O, 24, 24, 25T, 24, 26P, 24, 27E, 24, 28I, 24, 28O, 24, 59S, 25H, 25H, 25T, 25H, 25T, 26P, 25H, 25T, 59S, 25H, 26P, 25H, 59S, 25T, 25T, 26P, 25T, 27E, 25T, 28I, 25T, 28O, 26B, 26B, 26P, 26B, 28O, 26P, 26P, 27E, 26P, 27L, 26P, 28I, 26P, 28O, 26P, 30, 26P, 59S, 27E, 27E, 28I, 27E, 59S, 27L, 28I, 28I, 28O, 28I, 30, 28O, 28O, 30, 28O, 59S, 29K, 29K, 30, 30, 59S'













