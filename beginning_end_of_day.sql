
select getdate(), dateadd(s,-(datepart(s,getdate())),dateadd(n,-(datepart(n,getdate())),dateadd(hh,-(datepart(hh,getdate())),getdate())))

select getdate(), dateadd(s,59,dateadd(n,59,dateadd(hh,23,dateadd(s,-(datepart(s,getdate())),dateadd(n,-(datepart(n,getdate())),dateadd(hh,-(datepart(hh,getdate())),getdate()))))))
