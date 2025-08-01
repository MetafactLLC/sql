


declare @s varchar(6)
set @s = '433'

select 5-len(@s)

select replicate('0',5-len(@s)) + @s
----------------------------------------------------------------------
--	PAD 5 SPACES WITH 0'S, THIS IS FOR THE FIRST CHECKED OUT FILE
----------------------------------------------------------------------








