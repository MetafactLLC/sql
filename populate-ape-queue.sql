

/*
1000257
1000282
1000283
1000284
1000285
*/



-- use bos_CanadianTire_100427

/*
select * from business_unit_group
select * from rad_sys_data_accessor
select * from business_unit_group_list
select * from dbo.Business_Unit_Group_List_Audit
select * from dbo.Business_Unit_Operator
select * from dbo.Business_Unit_Settings
select * from 
select * from 
select * from 
select * from 


select distinct business_unit_id from business_unit_group_list


sp_helptext ape_insert_execution_object 

select * from APE_Execution_Queue_Segment
select * from APE_Execution_Document
select * from APE_Execution_Queue



select distinct bugl.business_unit_id, 
	'extensions.workflows.CanadianTire.CanadianTire_EOD',
	'd',
	'q',
	null,
	null,
	null,
	bu.client_id,-- org hierarchy id,
	bu.client_id,
	null,
	null,
	1
from business_unit_group_list bugl
inner join business_unit bu on bu.business_unit_id = bugl.business_unit_id
--inner join rad_sys_data_accessor rda on rda.data_accessor_id = bu.business_unit_id
--where rda.[name] = 'HiSpeed' 
where bugl.business_unit_group_id = 

--             exec ape_insert_execution_object 
	@moniker=N'Platform.Export.ExportTask',
	@exec_type=N'd',
	@exec_status=N'q',
	@job_exec_guid='69DC0085-5E07-4B8A-838F-D3FDF6557325',
	@task_sequence=NULL,
	@exec_doc=N'<ExecutionDocument><ParameterValue name="export_id">203</ParameterValue><ParameterValue name="transform_id">186</ParameterValue><ParameterValue name="new_version"/><Context current_client_id="1000001" export_iddisplay="Sales Transactions" transform_iddisplay="Sales Transactions XML" business_unit_id=" + @bu_id + " business_date=" + @conv_bu_date + " current_hier_id="1000001" current_hier_level="1" __current_job_execution_guid="{69DC0085-5E07-4B8A-838F-D3FDF6557325}" __current_job_moniker="Platform.Export.ExportJob"/></ExecutionDocument>',
	@org_hierarchy_id=1000001,
	@client_id=1000001,
	@named_lock=NULL,
	@dev_mode_segment=NULL,
	@parent_child_incr=1
*/
----------------------------------------------------------------------------------------------------

--create procedure dbo.ape_export_by_bu_group (@bu_group_id int)
declare @bu_group_id int
set @bu_group_id = 1000283
--as
declare @tbl table(eye_d int identity, buid int, moniker varchar(255), exec_type varchar(1),
	exec_status varchar(1), job_exec_guid uniqueidentifier, task_sequence int, exec_doc ntext,
	org_hierarchy_id int, client_id int, named_lock varchar(50), dev_mode_segment varchar(64),
	parent_child_incr int) 

declare @b int
set @b = 1
declare @e int
declare @s varchar(4000)
declare @str varchar(255)
-------------------------
declare @buid int
declare @moniker varchar(255)
declare @exec_type varchar(1)
declare	@exec_status varchar(1)
declare @job_exec_guid uniqueidentifier
declare @task_sequence int
declare @exec_doc varchar(5000)
declare @org_hierarchy_id int
declare @client_id int
declare @named_lock varchar(50)
declare @dev_mode_segment varchar(64)
declare @parent_child_incr int


insert into @tbl
select distinct bugl.business_unit_id, 
	'extensions.workflows.CanadianTire.CanadianTire_EOD',
	'd',
	'q',
	null,
	0, -- @task_sequence
	null,
	bu.client_id,-- org hierarchy id,
	bu.client_id,
	'',
	'',
	1
from business_unit_group_list bugl
inner join business_unit bu on bu.business_unit_id = bugl.business_unit_id
where bugl.business_unit_group_id = @bu_group_id 


set @e = (select top 1 eye_d from @tbl order by eye_d desc)

while @b < @e
begin
	
	select @buid = buid, @moniker = moniker, @exec_type = exec_type, @exec_status = exec_status, 
		@job_exec_guid = coalesce(job_exec_guid,'00000000-0000-0000-0000-000000000006')/*newid()*/, @task_sequence = task_sequence, @exec_doc = exec_doc,
		@org_hierarchy_id = org_hierarchy_id, @client_id = client_id, @named_lock = named_lock, 
		@dev_mode_segment = dev_mode_segment, @parent_child_incr = parent_child_incr
	from @tbl where eye_d = @b
	
	set @s = '@moniker=''' + @moniker + ''',@exec_type=''' + @exec_type + ''',@exec_status=''' + @exec_status + '''' 
	set @s = @s + ',@job_exec_guid=''' + cast(@job_exec_guid as varchar(255)) + ''',@task_sequence=' + cast(@task_sequence as varchar(2)) 
	set @s = @s + ',@exec_doc=<exec_doc>,@org_hierarchy_id=' + cast(@buid as varchar(10)) + ',@client_id=' + cast(@client_id as varchar(10)) 
	set @s = @s + ',@named_lock=''' + @named_lock + ''',@dev_mode_segment=''' + @dev_mode_segment + ''',@parent_child_incr=' + cast(@parent_child_incr as varchar(10)) 
		
	set @s = replace(@s,'<exec_doc>','''''')
	--exec ('ape_insert_execution_object ' + @s)
	print @s 
	
	set @b = @b + 1
end 



/*
select newid()

2FD5E409-8A17-4214-9B08-CCAAF96B0E2B

00000000-0000-0000-0000-000000000006
*/

select * from ape_execution_queue

select * from ape_execution_segment





