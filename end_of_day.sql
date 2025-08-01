
select dateadd(s,59,dateadd(n,59,dateadd(hh,23,getdate())))

select dateadd(s,-(datepart(s,getdate())),getdate())

select dateadd(n,-(datepart(n,getdate())),getdate())

select dateadd(hh,-(datepart(hh,getdate())),getdate())


select dateadd(hh,-(datepart(hh,getdate())),dateadd(n,-(datepart(n,getdate())),dateadd(s,-(datepart(s,getdate())),getdate())))

select dateadd(s,59,dateadd(n,59,dateadd(hh,23,dateadd(hh,-(datepart(hh,getdate())),dateadd(n,-(datepart(n,getdate())),dateadd(s,-(datepart(s,getdate())),getdate()))))))

