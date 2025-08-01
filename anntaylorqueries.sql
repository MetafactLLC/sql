

/*
Ann Taylor Queries

*/

-- server: WFM_2005
-- database: WFMR_AT_080415
-- use WFMR_AT_080415 
-- use WFMR_AT_080415_wh 
 

SELECT *
FROM Metric m
  
SELECT *
FROM Metric_Report

select top 100 * from dbo.fv_gen_labor_cost_prod_bu_day

select top 100 * from f_gen_labor_cost_bu_day



select * from Rad_Sys_Feature_Lang

-----------------------------------------------------------------------------------------------------
select lbuday.labor_cost_hours_qty, lbuday.labor_cost_amt, lbuday.labor_cost_charged_hours_qty,
	lbuday.home_bu_id, lbuday.bu_id, lbuday.business_date, * -- 
from f_gen_labor_cost_bu_day lbuday
where lbuday.overtime_flag <> 'o' and lbuday.pay_class_code <> 2  


-----------------------------------------------------------------------------------------------------

--create view dbo.fv_gen_labor_cost_bu  
--as  
select minbuday.home_bu_id,   
 minbuday.bu_id,   
 sum(minbuday.labor_cost_hours_qty + minbuday.labor_cost_charged_hours_qty) as labor_cost_hours,   
 minbuday.labor_cost_amt,    
 minbuday.business_date  
from f_gen_labor_cost_min_bu_day minbuday  
where minbuday.overtime_flag <> 'o' and minbuday.pay_class_code <> 2    
group by minbuday.home_bu_id,   
 minbuday.bu_id, minbuday.labor_cost_amt,    
 minbuday.business_date  
union all 
select lbuday.home_bu_id,   
 lbuday.bu_id,   
 sum(lbuday.labor_cost_hours_qty + lbuday.labor_cost_charged_hours_qty) as labor_cost_hours,   
 lbuday.labor_cost_amt,    
 lbuday.business_date  
from f_gen_labor_cost_bu_day lbuday  
where lbuday.overtime_flag <> 'o' and lbuday.pay_class_code <> 2  
and not exists(select 1 from f_gen_labor_cost_min_bu_day minbuday  
where  minbuday.home_bu_id = lbuday.home_bu_id
and minbuday.bu_id = lbuday.bu_id
and minbuday.business_date  = lbuday.business_date)
group by lbuday.home_bu_id,   
 lbuday.bu_id, lbuday.labor_cost_amt,    
 lbuday.business_date  
----union   
----select dest.home_bu_id,   
---- dest.bu_id,   
---- sum(dest.labor_cost_hours_qty + dest.labor_cost_charged_hours_qty) as labor_cost_hours,   
---- dest.labor_cost_amt,    
---- dest.business_date  
----from f_gen_labor_cost_sales_dest_bu_day dest  
----group by dest.home_bu_id,   
---- dest.bu_id, dest.labor_cost_amt,    
---- dest.business_date  
  


-- INSERT INTO THE RAD_SYS_TABLE....
/*
declare @ticket int exec @ticket = sp_get_next_ticket 1, 'y', 1 
insert into rad_sys_table( table_id, name, global_flag, alter_pk_flag ) 
                                
select @ticket, 'fv_gen_labor_cost_bu', 'N', 'Y'
exec update_metadata 'fv_gen_labor_cost_bu' 

update rad_sys_table 
set freq_code = 'D', table_type_code = 'f', data_guid = newid()
where name = 'fv_gen_labor_cost_bu' 


*/


SELECT * FROM rad_sys_table 
where charindex('_',name,0) > 0
	and table_type_code = 'f'
order by name

union 
SELECT * FROM rad_sys_table where name = 'fv_gen_labor_cost_bu' 

SELECT * FROM rad_sys_table where name = 'fv_gen_labor_ot_cost_bu_day' 

-- look for the data_guid column
sp_help rad_sys_table 




/*
select labor_cost_hours_qty from f_gen_labor_cost_bu_day
select labor_cost_hours_qty from f_gen_labor_cost_min_bu_day
select labor_cost_hours_qty from f_gen_labor_cost_sales_dest_bu_day



select * from employee
*/






























