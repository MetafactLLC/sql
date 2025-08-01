
select cast(cast(month(getdate()) as varchar) + '/1/' + cast(year(getdate()) as varchar) as datetime) as [month], 
		dateadd(d,-1,dateadd(m,1,cast(month(getdate()) as varchar) + '/1/' + cast(year(getdate()) as varchar))) as [endofmonth]

		
select  dateadd(m,-1,(cast(cast(month(getdate()) as varchar) + '/1/' + cast(year(getdate()) as varchar) as datetime)) ) as [firstoflastmonth],
		dateadd(d,-1,dateadd(m,1, dateadd(m,-1,(cast(cast(month(getdate()) as varchar) + '/1/' + cast(year(getdate()) as varchar) as datetime)) ) )) as [endoflastmonth]

