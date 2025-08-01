



declare @s varchar(255)
declare @days varchar(10)
declare @hours varchar(10)

set @s = '1 Days 2.65 Hours'
select len(@s)
/*
set @days = ( select left(@s,charindex(' ',@s,1)) )

set @s = ( select ltrim(replace(@s,@days+'Days','')) )

set @hours = ( select left(@s,charindex(' ',@s,1)) )

select @days
select @hours

select (cast(@days as numeric(9,2))*24) + cast(@hours as numeric(4,2))
*/

/*
select ( left(@s,charindex(' ',@s,1)) ), 

( left((ltrim(replace(@s,left(@s,charindex(' ',@s,1))+'Days',''))), charindex(' ',(ltrim(replace(@s,left(@s,charindex(' ',@s,1))+'Days',''))),1))  )
*/

select ( cast(left(@s,charindex(' ',@s,1)) as numeric(5,2))*24 ) + 

( cast(left((ltrim(replace(@s,left(@s,charindex(' ',@s,1))+'Days',''))), charindex(' ',(ltrim(replace(@s,left(@s,charindex(' ',@s,1))+'Days',''))),1)) as numeric(5,2))  )
