


/*


DECLARE @Time_Fact TABLE (time_key int , time_stamp datetime, 
							year_key int, month_key int, 
							month_name varchar(50), date_key int, 
							day_number int, day_name varchar(50)) 

declare @workingdate datetime = '1/1/1975' 

while @workingdate < '1/1/2200'
begin
--insert into Time_Fact(time_key, time_stamp, year_key, month_key, month_name, date_key, day_number, day_name)
insert into @Time_Fact(time_key, time_stamp, year_key, month_key, month_name, date_key, day_number, day_name)
select 
	(year(@workingdate)*10000)+(month(@workingdate)*100)+(day(@workingdate) ) as time_key
	,convert(date, @workingdate) as time_stamp
	,year(@workingdate) as year_key 
	,month(@workingdate) as month_Key
	,datename(m,@workingdate) as month_name
	,day(@workingdate) as date_key
	,datepart(dw,@workingdate) as day_number
	,datename(DW,@workingdate) as day_name

set @workingdate = dateadd(d,1,@workingdate)
end 

SELECT * FROM @Time_Fact



*/











