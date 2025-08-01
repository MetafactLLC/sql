
select '@' + column_name + ' ' + data_type + 
	(
		case data_type
			when 'varchar' then '(' + cast(character_maximum_length as varchar) + ')'
			when 'char' then '(' + cast(character_maximum_length as varchar) + ')'
			when 'nvarchar' then '(' + cast(character_maximum_length as varchar) + ')'
			when 'numeric' then '(' + cast(numeric_precision as varchar) + ',' + cast(numeric_scale as varchar) + ')'
			else ''
		end
	) 
from information_schema.columns 
where table_name = 'users'