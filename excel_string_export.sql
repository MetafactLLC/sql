




declare @rtnperiod varchar(5)
declare @datadate int
declare @datevar varchar(10)

set @datadate = 200706
set @rtnperiod = 'Jan04'


select cast(@datadate as datetime)


set @datevar = right(cast(@datadate as varchar(6)),2) + '/01/' + left(cast(@datadate as varchar(6)),4) 
select @datevar 

select left(datename(mm, @datevar),3) + substring(left(cast(@datadate as varchar(6)),4), 3, 2)

select '="' +left(datename(mm, @datevar),3) + '"&TEXT("' + substring(left(cast(@datadate as varchar(6)),4), 3, 2) + '","00")'


--	="Nov"&TEXT("04","00")







