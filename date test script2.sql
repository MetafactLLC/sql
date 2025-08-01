declare @date1 datetime, @date2 datetime 

set @date1 = '2013-11-16 20:03:00.000'
set @date2 = '2013-11-22 08:50:00.000'

declare @sob1 datetime, @sob2 datetime, @eob1 datetime, @eob2 datetime
declare @useweekends bit
declare @starthour int, @endhour int
declare @firstdayminutesworked int, @lastdayminutesworked int, @middledayminutesworked int, @totalminutesworked int

set @useweekends = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 502)
set @starthour = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 504) -- 8
set @endhour = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 505) -- 17

set @sob1 = (select cast(DATEPART(m,@date1) as varchar) + '/' + cast(DATEPART(d,@date1) as varchar) + '/' + cast(DATEPART(yyyy,@date1) as varchar) + ' ' + cast(@starthour as varchar) + ':00:00')
set @eob1 = (select cast(DATEPART(m,@date1) as varchar) + '/' + cast(DATEPART(d,@date1) as varchar) + '/' + cast(DATEPART(yyyy,@date1) as varchar) + ' ' + cast(@endhour as varchar) + ':00:00')

set @sob2 = (select cast(DATEPART(m,@date2) as varchar) + '/' + cast(DATEPART(d,@date2) as varchar) + '/' + cast(DATEPART(yyyy,@date2) as varchar) + ' ' + cast(@starthour as varchar) + ':00:00')
set @eob2 = (select cast(DATEPART(m,@date2) as varchar) + '/' + cast(DATEPART(d,@date2) as varchar) + '/' + cast(DATEPART(yyyy,@date2) as varchar) + ' ' + cast(@endhour as varchar) + ':00:00')


SELECT * FROM STG_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER

-- select dbo.UDF_GET_WORK_DAYS('2013-11-19 01:33:00.000', '2013-11-19 22:33:00.000')
-- select dbo.UDF_GET_WORK_DAYS('2013-11-21 17:33:00.000', '2013-11-21 22:47:00.000')
-- select dbo.UDF_GET_WORK_DAYS('2013-11-07 23:42:00.000', '2013-11-13 01:52:00.000')
-- select dbo.UDF_GET_WORK_DAYS('2013-11-20 20:59:00.000', '2013-11-21 06:46:00.000')
-- select dbo.UDF_GET_WORK_DAYS('2013-11-20 10:00:00.000', '2013-11-22 10:26:00.000')
select dbo.UDF_GET_WORK_DAYS('2013-11-16 20:03:00.000', '2013-11-22 08:50:00.000')

	

set @firstdayminutesworked = (select case when datediff(n,@sob1,@date1) <= 0 then datediff(n,@sob1,@eob1) else datediff(n,@date1,@eob1) end)
set @lastdayminutesworked = (select case when datediff(n,@date2,@eob2) <= 0 then datediff(n,@sob2,@eob2) else datediff(n,@sob2,@date2) end)

    set @date1 = (select case when datediff(n,@sob1,@date1) <= 0 then @sob1 else @date1 end)
    set @date2 = (select case when datediff(n,@date2,@eob2) <= 0 then @eob2 else @date2 end)

select @date1 , @date2






