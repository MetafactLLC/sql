

/*
-- multiple days
1. get the minutes worked for the first day for working hours
2. get the minutes worked for the last day for working hours
3. get minutes in for days in the middle for working hours

-- single day
1. if the start time is before the sob, use the sob time
2. if the end time is after eob use the eob time
3. find the difference between 1 and 2 - this is the hours worked
*/


declare @date1 datetime, @date2 datetime
set @date1 = '11/20/2013 9:00:00'
set @date2 = '11/20/2013 15:00:00'


declare @sob1 datetime, @sob2 datetime, @eob1 datetime, @eob2 datetime
declare @useweekends bit
declare @starthour int, @endhour int
declare @firstdayminutesworked int, @lastdayminutesworked int, @middledayminutesworked int, @totalminutesworked int

set @useweekends = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM where EMER_SCHNV_PARM_TYP_CD = 502)
set @starthour = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM where EMER_SCHNV_PARM_TYP_CD = 504) -- 8
set @endhour = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM where EMER_SCHNV_PARM_TYP_CD = 505) -- 17

set @sob1 = (select cast(DATEPART(m,@date1) as varchar) + '/' + cast(DATEPART(d,@date1) as varchar) + '/' + cast(DATEPART(yyyy,@date1) as varchar) + ' ' + cast(@starthour as varchar) + ':00:00')
set @eob1 = (select cast(DATEPART(m,@date1) as varchar) + '/' + cast(DATEPART(d,@date1) as varchar) + '/' + cast(DATEPART(yyyy,@date1) as varchar) + ' ' + cast(@endhour as varchar) + ':00:00')

set @sob2 = (select cast(DATEPART(m,@date2) as varchar) + '/' + cast(DATEPART(d,@date2) as varchar) + '/' + cast(DATEPART(yyyy,@date2) as varchar) + ' ' + cast(@starthour as varchar) + ':00:00')
set @eob2 = (select cast(DATEPART(m,@date2) as varchar) + '/' + cast(DATEPART(d,@date2) as varchar) + '/' + cast(DATEPART(yyyy,@date2) as varchar) + ' ' + cast(@endhour as varchar) + ':00:00')


if datediff(d,@date1,@date2) > 0
-- multiple days
begin
set @firstdayminutesworked = (select case when datediff(n,@sob1,@date1) <= 0 then datediff(n,@sob1,@eob1) else datediff(n,@date1,@eob1) end)
set @lastdayminutesworked = (select case when datediff(n,@date2,@eob2) <= 0 then datediff(n,@sob2,@eob2) else datediff(n,@sob2,@date2) end)

    if datediff(d,@date1,@date2) > 1
    -- more than a 2 day span
    begin
	 -- 1. get number of days
	 -- 2. subtract 2
	 -- 3. get the working hours
	 set @middledayminutesworked = (datediff(d,@date1,@date2) - 1) * 540 
	 set @totalminutesworked = @firstdayminutesworked + @middledayminutesworked + @lastdayminutesworked 
    
	 -- will weekends be calculated? if not, get the number of saturdays & sundays & subtract those minutes

    end
    else
    -- only 2 day span i.e., friday & thursday
    begin

	 -- will weekends be calculated? if not, see which day was the weekend day and set value to 0 (it may be both)
	 if (@useweekends = 0) 
	 begin
	     set @firstdayminutesworked = (select case when datename(dw,@date1) in('Saturday','Sunday') then 0 end )
	     set @lastdayminutesworked = (select case when datename(dw,@date2) in('Saturday','Sunday') then 0 end )
	 end 

	 set @totalminutesworked = (select @firstdayminutesworked + @lastdayminutesworked)
    end
end 
else
-- single day
begin 
    set @totalminutesworked = (select datediff(n,@date1,@date2))

    -- will weekends be calculated?  if not, check to see if this is a weekend; if so, set to zero
    if (@useweekends = 0) and (datename(dw,@date1) = 'Saturday') or (datename(dw,@date1) = 'Sunday')
    begin
	 set @totalminutesworked = 0
    end 
end

select @totalminutesworked / 60.00







