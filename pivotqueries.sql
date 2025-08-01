
/*
CREATE view [VW_RPT_EMER_SCHN_VSBL_COMP_SMRY] as (
select 
	right('00' + cast(main.mer_class_nbr as varchar(2)),2) + ' - ' + main.contents as class_contents
	,main.subdept
	, main.stp_status
	, DATEADD(dd, 0, DATEDIFF(dd, 0, est_dl)) as est_deliv_dt
	, count(distinct stp_sfloc_alias_id) as str_dc_count
	, count(distinct main.po_nbr) as po_count
	, sum(retl.ord_qty) as ord_qty
	, sum(retl.sku_retl_amt) as sku_retl_amt
from VW_EMER_SCHN_VSBL_MAIN_LNDG main
		left outer join VW_RPT_EMER_SCHN_VSBL_ORD_QTY_RETL retl with (nolock) on 
			retl.po_nbr = main.po_nbr and main.crt_dt = retl.crt_dt and main.stp_sfloc_alias_id = retl.loc_nbr 
			and main.subdept = retl.subdept and main.mer_class_nbr = retl.mer_class_nbr
			and main.mer_sub_class_nbr = retl.mer_sub_class_nbr and main.po_stat_cd = retl.po_stat_cd
where stp_status in ('New Order','Pend Pickup','In Transit','Delivered','Vnd Mgd Frt')
	and main.subdept is not null
group by main.subdept
	, main.stp_status	 
	, DATEADD(dd, 0, DATEDIFF(dd, 0, est_dl)) 
	, right('00' + cast(main.mer_class_nbr as varchar(2)),2) + ' - ' + main.contents )

GO
*/

declare @t as table(eye_d int identity(1,1), class_contents varchar(100),
					subdept varchar(10), stp_status varchar(30), est_deliv_dt datetime,
					str_dc_count int, po_count int, ord_qty numeric(15,6), 
					sku_retl_amt numeric(15,4) )

insert into @t(class_contents, subdept, stp_status, est_deliv_dt, str_dc_count, po_count, ord_qty, sku_retl_amt)
select 
	right('00' + cast(main.mer_class_nbr as varchar(2)),2) + ' - ' + main.contents as class_contents
	,main.subdept
	, main.stp_status
	, DATEADD(dd, 0, DATEDIFF(dd, 0, est_dl)) as est_deliv_dt
	, count(distinct stp_sfloc_alias_id) as str_dc_count
	, count(distinct main.po_nbr) as po_count
	, sum(retl.ord_qty) as ord_qty
	, sum(retl.sku_retl_amt) as sku_retl_amt
from VW_EMER_SCHN_VSBL_MAIN_LNDG main
		left outer join VW_RPT_EMER_SCHN_VSBL_ORD_QTY_RETL retl with (nolock) on 
			retl.po_nbr = main.po_nbr and main.crt_dt = retl.crt_dt and main.stp_sfloc_alias_id = retl.loc_nbr 
			and main.subdept = retl.subdept and main.mer_class_nbr = retl.mer_class_nbr
			and main.mer_sub_class_nbr = retl.mer_sub_class_nbr and main.po_stat_cd = retl.po_stat_cd
where stp_status in ('New Order','Pend Pickup','In Transit','Delivered','Vnd Mgd Frt')
	and main.subdept is not null
group by main.subdept
	, main.stp_status	 
	, DATEADD(dd, 0, DATEDIFF(dd, 0, est_dl)) 
	, right('00' + cast(main.mer_class_nbr as varchar(2)),2) + ' - ' + main.contents 


-- select * from @t where stp_status = 'New Order'
-- select * from summary_cte
-- select class_contents, subdept, stp_status, est_deliv_dt, str_dc_count, po_count, ord_qty, sku_retl_amt from summary_cte 

-- neworder table
--select class_contents, subdept, stp_status, est_deliv_dt, str_dc_count, po_count, ord_qty, sku_retl_amt from summary_cte 

-- emergency_visibility@homedepot.com

-- NT AUTHORITY\SYSTEM
-- AMER\MEM8593

-- PO's [#POs]

select distinct * from @t where est_deliv_dt is not null order by class_contents, subdept 

/*
select distinct t.class_contents, t.subdept,  
	sum(t.str_dc_count) as total_dc_count, sum(po_count) as total_po_count, sum(ord_qty) as total_units, sum(sku_retl_amt) as total_amounts, 
	(select sum(po_count) from @t t1 where t1.class_contents = t.class_contents and t1.subdept = t.subdept and t1.stp_status = 'New Order') as PONewOrders,	
--	(select datediff(dd,t2.est_deliv_dt,getdate()) from @t t2 where t2.class_contents = t.class_contents and t2.subdept = t.subdept and t2.est_deliv_dt is not null) as AgeDaysNewOrders,
	(select sum(ord_qty) from @t t3 where t3.class_contents = t.class_contents and t3.subdept = t.subdept and t3.stp_status = 'New Order') as UnitsNewOrders,	
	(select sum(sku_retl_amt) from @t t4 where t4.class_contents = t.class_contents and t4.subdept = t.subdept and t4.stp_status = 'New Order') as AmountNewOrders,	


	(select sum(po_count) from @t t5 where t5.class_contents = t.class_contents and t5.subdept = t.subdept and t5.stp_status = 'Pend Pickup') as POPendingPickup,	
--	(select datediff(dd,t6.est_deliv_dt,getdate()) from @t t6 where t6.class_contents = t.class_contents and t6.subdept = t.subdept ) as AgeDaysPendingPickup,
	(select sum(ord_qty) from @t t7 where t7.class_contents = t.class_contents and t7.subdept = t.subdept and t7.stp_status = 'Pend Pickup') as UnitsPendingPickup,	
	(select sum(sku_retl_amt) from @t t8 where t8.class_contents = t.class_contents and t8.subdept = t.subdept and t8.stp_status = 'Pend Pickup') as AmountPendingPickup,	
		
	(select sum(po_count) from @t t9 where t9.class_contents = t.class_contents and t9.subdept = t.subdept and t9.stp_status = 'In Transit') as POInTransit,	
	(select sum(ord_qty) from @t t10 where t10.class_contents = t.class_contents and t10.subdept = t.subdept and t10.stp_status = 'In Transit') as UnitsInTransit,	
	(select sum(sku_retl_amt) from @t t11 where t11.class_contents = t.class_contents and t11.subdept = t.subdept and t11.stp_status = 'In Transit') as AmountInTransit,	

	(select sum(po_count) from @t t12 where t12.class_contents = t.class_contents and t12.subdept = t.subdept and t12.stp_status = 'Delivered') as PODelivered,
	(select sum(ord_qty) from @t t13 where t13.class_contents = t.class_contents and t13.subdept = t.subdept and t13.stp_status = 'Delivered') as UnitsDelivered,	
	(select sum(sku_retl_amt) from @t t14 where t14.class_contents = t.class_contents and t14.subdept = t.subdept and t14.stp_status = 'Delivered') as AmountDelivered,
		
	(select sum(po_count) from @t t15 where t15.class_contents = t.class_contents and t15.subdept = t.subdept and t15.stp_status = 'Vnd Mgd Frt') as POVndMgdFrt,
	(select sum(ord_qty) from @t t16 where t16.class_contents = t.class_contents and t16.subdept = t.subdept and t16.stp_status = 'Vnd Mgd Frt') as UnitsVndMgdFrt,	
	(select sum(sku_retl_amt) from @t t17 where t17.class_contents = t.class_contents and t17.subdept = t.subdept and t17.stp_status = 'Vnd Mgd Frt') as AmountVndMgdFrt

from @t t
group by t.class_contents, t.subdept 
*/

/*
left join (
	select distinct * from (
		select stp_status, po_count, class_contents, subdept, str_dc_count  
		from @t
	) as source
	pivot (
		sum(po_count) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) po_counts on po_counts.class_contents = t.class_contents and po_counts.subdept = t.subdept and po_counts.str_dc_count = t.str_dc_count
-- ORDER QUANTITY [#UNITS]
left join ( 
	select distinct * from (
		select stp_status, ord_qty, class_contents, subdept, str_dc_count  
		from @t
	) as source
	pivot (
		sum(ord_qty) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) units on t.class_contents = units.class_contents and t.subdept = units.subdept and units.str_dc_count = t.str_dc_count
-- AMOUNTS [RETL $]
left join ( 
	select distinct * from (
		select stp_status, sku_retl_amt, class_contents, subdept, str_dc_count  
		from @t
	) as source
	pivot (
		sum(sku_retl_amt) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) amounts on t.class_contents = amounts.class_contents and t.subdept = amounts.subdept and units.str_dc_count = t.str_dc_count

*/





















/*
-- PO's [#POs]
select * from (
	select stp_status, po_count, class_contents, subdept  
	from @t
) as source
pivot (
	sum(po_count) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
) as pvt 

-- ORDER QUANTITY [#UNITS]
select * from (
	select stp_status, ord_qty, class_contents, subdept  
	from @t
) as source
pivot (
	sum(ord_qty) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
) as pvt 

-- AMOUNTS [RETL $]
select * from (
	select stp_status, sku_retl_amt, class_contents, subdept  
	from @t
) as source
pivot (
	sum(sku_retl_amt) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
) as pvt 
*/



