






--	select count(1) from dbo.Employee

/*
select * from dbo.Employee
where employee_id = 1002456

select b.business_unit_id, b.status_code, e.* 
from dbo.Employee e
inner join business_unit b on e.home_business_unit_id = b.business_unit_id
where employee_id = 1002456

select top 1000 * from Employee where manager_level_flag = 'y'

--MANAGEMENT LEVEL EMPLOYEES - CURRENTLY EMPLOYED
select les.*, b.business_unit_id, e.* 
from dbo.Employee e
inner join lab_employee_status les on e.employee_id = les.employee_id 
inner join lab_employee_business_unit_list b on e.employee_id = b.employee_id
--a manager
where e.manager_level_flag = 'y'
--activly employed
and les.work_status_code = 'a' and les.end_date is null



*/


select les.*, b.business_unit_id, e.* 
from dbo.Employee e
inner join lab_employee_status les on e.employee_id = les.employee_id 
inner join lab_employee_business_unit_list b on e.employee_id = b.employee_id
--a manager
where e.manager_level_flag = 'y'
--activly employed
and les.work_status_code = 'a' and les.end_date is null
/*
-- did not check employee status_type code, please see the following:
select employee_status_type_code, employee_status_type, count(employee_status_type_code)
 from dbo.Lab_Employee_Status_Request_Audit
group by employee_status_type, employee_status_type_code
*/


select column_name from information_schema.columns where table_name = 'lab_employee_status'
order by column_name

select employee_status_type_code, employee_status_type, count(employee_status_type_code)
 from dbo.Lab_Employee_Status_Request_Audit
group by employee_status_type, employee_status_type_code

sp_help Employee
sp_help business_unit 

select top 1000 * from dbo.lab_Employee_business_unit_list

select top 1000 * from business_unit

select top 1000 * from dbo.Business_Unit_Group

select top 1000 * from dbo.Business_Unit_Group_List

select top 1000 * from Employee where manager_level_flag = 'y'

select top 1000 * from lab_employee_status 

select top 1000 * from employee_status_type

select top 1000 * from dbo.Lab_Employee_Status_Request

select top 1000 * from dbo.Lab_Employee_Status_Request_Audit

select top 1000 * from dbo.Lab_Employee_Status_Request_Comment

select top 1000 * from 

select top 1000 * from 

select top 1000 * from 

select top 1000 * from 

select top 1000 * from 

select top 1000 * from 

select top 1000 * from 

select top 1000 * from 