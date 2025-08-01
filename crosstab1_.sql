
declare @t table(nom varchar(2000))
declare @m varchar(2000)

insert into @t
select top 10 name from tracs.dbo.entity

set @m = ''
select @m = @m + nom + ', ' from @t

select @m







