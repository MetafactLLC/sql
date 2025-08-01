
-- select dbo.recursive_stack(22)



-- recursive_stack 20
alter procedure dbo.recursive_stack (@i INT) 
as
begin
if @i < 31
	begin
		print @i;
		set @i = @i + 1;
		execute dbo.recursive_stack @i 
	end
else 
	select @i 
	print @i
end 

