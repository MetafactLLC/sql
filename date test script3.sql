
-- Select  *  from    dbo.STG_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER  with (nolock)
-- Select  *  from    dbo.STG_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER  with (nolock)

-- Select distinct DEPT  from STG_RPT_EMER_SCHN_VSBL_IPR_NEW_ORDER  with(nolock) order by DEPT 

select * from [dbo].[STG_RPT_EMER_SCHN_VSBL_PULLREPORT] where po = '15978637'

-- select [dbo].[UDF_GET_WORK_DAYS]('2013-11-20 10:00:00.000', '2013-11-22 11:22:00.000')

declare @date1 datetime, @date2 datetime
set @date1 = '11/18/13 21:04'
set @date2 = '11/21/13 9:18'
	

declare @sob1 datetime, @sob2 datetime, @eob1 datetime, @eob2 datetime
declare @useweekends bit
declare @starthour int, @endhour int
declare @firstdayminutesworked int, @lastdayminutesworked int, @middledayminutesworked int, @totalminutesworked int
declare @grandtotal numeric(10,3)
declare @businessdaytimespanminutes int

set @useweekends = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 502)
set @starthour = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 504) -- 8
set @endhour = (select PARM_INTG_VAL from EMER_SCHN_VSBL_EVNT_PARM with (nolock) where EMER_SCHNV_PARM_TYP_CD = 505) -- 17
set @businessdaytimespanminutes = ((@endhour - @starthour) * 60)

set @sob1 = (select cast(DATEPART(m,@date1) as varchar) + '/' + cast(DATEPART(d,@date1) as varchar) + '/' + cast(DATEPART(yyyy,@date1) as varchar) + ' ' + cast(@starthour as varchar) + ':00:00')
set @eob1 = (select cast(DATEPART(m,@date1) as varchar) + '/' + cast(DATEPART(d,@date1) as varchar) + '/' + cast(DATEPART(yyyy,@date1) as varchar) + ' ' + cast(@endhour as varchar) + ':00:00')

set @sob2 = (select cast(DATEPART(m,@date2) as varchar) + '/' + cast(DATEPART(d,@date2) as varchar) + '/' + cast(DATEPART(yyyy,@date2) as varchar) + ' ' + cast(@starthour as varchar) + ':00:00')
set @eob2 = (select cast(DATEPART(m,@date2) as varchar) + '/' + cast(DATEPART(d,@date2) as varchar) + '/' + cast(DATEPART(yyyy,@date2) as varchar) + ' ' + cast(@endhour as varchar) + ':00:00')


if datediff(d,@date1,@date2) > 0
-- multiple days
begin

-- have to account for start time > end of business on the first day of business
set @firstdayminutesworked = (select case when datediff(n,@sob1,@date1) <= 0 then datediff(n,@sob1,@eob1) when datediff(n,@date1,@eob1) <= 0 then 0 else datediff(n,@date1,@eob1) end)
-- have to account for start time < start of business on the last day of business
set @lastdayminutesworked = (select case when datediff(n,@date2,@eob2) <= 0 then datediff(n,@sob2,@eob2) when datediff(n,@sob2, @date2) <= 0 then 0 else datediff(n,@sob2,@date2) end)

    if datediff(d,@date1,@date2) > 1
    -- more than a 2 day span
    begin

	 declare @loopdate1 datetime, @loopdate2 datetime
	 declare @satcount int, @suncount int, @loopcounter int
	 set @loopdate1 = @date1 
	 set @loopdate2 = @date2 
	 set @satcount = 0
	 set @suncount = 0
	 set @loopcounter = 0
	     
	 -- will weekends be calculated? if not, get the number of saturdays & sundays & subtract those minutes
	 if (@useweekends = 0) 
	 begin

	     while @loopdate1 < @loopdate2 
	     begin
		  		  
		  if @loopcounter = 0 
		  begin 
		      -- calculate for the first day if the first day is on the weekend
		      set @satcount = @satcount + (select case when datename(dw,@loopdate1) = 'Saturday' then datediff(n,@loopdate1,@eob1) else 0 end)		  
		      set @suncount = @suncount + (select case when datename(dw,@loopdate1) = 'Sunday' then datediff(n,@loopdate1,@eob1) else 0 end)		  
		  end 
		  else 
		  begin
		      -- calculate if the full work day is on the weekend
		      set @satcount = @satcount + (select case when datename(dw,@loopdate1) = 'Saturday' then @businessdaytimespanminutes else 0 end)		  
		      set @suncount = @suncount + (select case when datename(dw,@loopdate1) = 'Sunday' then @businessdaytimespanminutes else 0 end)		  
		  end 
		  set @loopdate1 = dateadd(d,1,@loopdate1)
		  set @loopcounter = @loopcounter + 1
	     end
	     set @loopdate1 = dateadd(d,-1,@loopdate1)

	     -- calculate for the last day
	     set @satcount = @satcount + (select case when datename(dw,@loopdate1) = 'Saturday' then datediff(n,@sob2,@loopdate2) else 0 end)		  
	     set @suncount = @suncount + (select case when datename(dw,@loopdate1) = 'Sunday' then datediff(n,@sob2,@loopdate2) else 0 end)		  

	 end 
	 -- 1. get number of days
	 -- 2. subtract 2
	 -- 3. get the working hours
	 set @middledayminutesworked = (datediff(d,@date1,@date2) - 1) * @businessdaytimespanminutes  
	 set @totalminutesworked = @firstdayminutesworked + @middledayminutesworked + @lastdayminutesworked 
	 set @totalminutesworked = @totalminutesworked - (@satcount + @suncount)
	 select @middledayminutesworked, @firstdayminutesworked, @totalminutesworked , @totalminutesworked/60.00 

    end
    else
    -- only 2 day span i.e., friday & thursday
    begin

	 -- will weekends be calculated? if not, see which day was the weekend day and set value to 0 (it may be both)
	 if (@useweekends = 0) 
	 begin
	     set @firstdayminutesworked = (select case when datename(dw,@date1) in('Saturday','Sunday') then 0 else @firstdayminutesworked end )
	     set @lastdayminutesworked = (select case when datename(dw,@date2) in('Saturday','Sunday') then 0 else @lastdayminutesworked end )
	 end 

	 set @totalminutesworked = @firstdayminutesworked + @lastdayminutesworked
    end

end 
else
-- single day
begin 
    set @date1 = (select case when datediff(n,@sob1,@date1) <= 0 then @sob1 else @date1 end)
    set @date2 = (select case when datediff(n,@date2,@eob2) <= 0 then @eob2 else @date2 end)

    set @totalminutesworked =  (select case when @date1 > @date2 then 0.00 else (select datediff(n,@date1,@date2)) end)

    -- will weekends be calculated?  if not, check to see if this is a weekend; if so, set to zero
    if (@useweekends = 0) and (datename(dw,@date1) = 'Saturday') or (datename(dw,@date1) = 'Sunday')
    begin
	 set @totalminutesworked = 0.00
    end 
end

set @grandtotal = (select case when @totalminutesworked is null then 0.00 when @totalminutesworked < 0.00 then 0.00 else @totalminutesworked/60.00 end)

select @grandtotal











