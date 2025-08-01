




-- alter view VW_RPT_EMER_SCHN_VSBL_COMPANYTRANSIT
-- as
select distinct t.class_contents as [CLASS], t.subdept as [DEPT], t.str_dc_count as [# STRS/DCs], 
		-- TOTALS COLUMNS
		t.po_count as [# POs], t.ord_qty as [# UNITS], t.sku_retl_amt as [RETL $], 


		-- ETA TBD
		tbd.po_count as [# POs5], tbd.ord_qty as [# UNITS5],

		t.*
		
		   
/*
		-- NEW ORDER COLUMNS
		po_counts.[New Order] as [# POs1], units.[New Order] as [# UNITS1], (1) as [UNIT % TTL], 

		-- PENIDNG PICKUP 
		po_counts.[Pend Pickup] as [# POs2], t.aged_days as [AGE DAYS 1], units.[Pend Pickup] as [# UNITS2], amounts.[Pend Pickup] as [RETL $2], 
		-- IN TRANSIT
		po_counts.[In Transit] as [# POs3], units.[In Transit] as [# UNITS3], amounts.[In Transit] as [RETL $3], 
		-- DELIVERED
		po_counts.[Delivered] as [# POs4], units.[Delivered] as [# UNITS4], amounts.[Delivered] as [RETL $4],  
		-- VENDOR MANAGED
		po_counts.[Vnd Mgd Frt] as [# POs5], units.[Vnd Mgd Frt] as [# UNITS5], amounts.[Vnd Mgd Frt] as [RETL $5], 
		(case when t.FLOW_TYPE = 'OUTBOUND STORE SHIPMENTS' then 'OUTBOUND' when t.FLOW_TYPE = 'INBOUND STORE SHIPMENTS' then 'INBOUND' END) as [OUT_IN]
		--select * 
*/
from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY t

/*
-- TODAY
left join (
	select distinct * from (
		select stp_status, po_count, class_contents, subdept, FLOW_TYPE, max(isnull(aged_days,0)) as max_aged_days
		from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY group by stp_status, po_count, class_contents, subdept, FLOW_TYPE
	) as source
	pivot (
		sum(po_count) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) po_counts on po_counts.class_contents = t.class_contents and po_counts.subdept = t.subdept and isnull(po_counts.FLOW_TYPE,'n/a') = isnull(t.FLOW_TYPE,'n/a')
-- TOMORROW
left join ( 
	select distinct * from (
		select stp_status, ord_qty, class_contents, subdept, FLOW_TYPE, max(isnull(aged_days,0)) as max_aged_days
		from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY group by stp_status, ord_qty, class_contents, subdept, FLOW_TYPE
	) as source
	pivot (
		sum(ord_qty) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) units on t.class_contents = units.class_contents and t.subdept = units.subdept and isnull(units.FLOW_TYPE,'n/a') = isnull(t.FLOW_TYPE,'n/a')
-- TWO DAYS OUT
left join ( 
	select distinct * from (
		select stp_status, sku_retl_amt, class_contents, subdept, FLOW_TYPE, max(isnull(aged_days,0)) as max_aged_days
		from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY group by stp_status, sku_retl_amt, class_contents, subdept, FLOW_TYPE
	) as source
	pivot (
		sum(sku_retl_amt) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) amounts on t.class_contents = amounts.class_contents and t.subdept = amounts.subdept and isnull(amounts.FLOW_TYPE,'n/a') = isnull(t.FLOW_TYPE,'n/a')
*/
-- ETA TBD
left join ( 
	select distinct * from (
		select sku_retl_amt, class_contents, subdept, FLOW_TYPE, max(est_dl_days_out) as max_aged_days
		from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY where est_dl_days_out is null and stp_status = 'In Transit'
		group by stp_status, sku_retl_amt, class_contents, subdept, FLOW_TYPE
	) as source
	pivot (
		sum(sku_retl_amt) for stp_status in([New Order],[Pend Pickup],[In Transit],[Delivered],[Vnd Mgd Frt])
	) as pvt 
) tbd on t.class_contents = tbd.class_contents and t.subdept = tbd.subdept and isnull(tbd.FLOW_TYPE,'n/a') = isnull(t.FLOW_TYPE,'n/a')

where t.stp_status = 'In Transit'


select * from (
	select po_count, class_contents, subdept, str_dc_count, FLOW_TYPE, 
		(case when isnull(est_dl_days_out,9000) <= 0 then 'Today' 
				when isnull(est_dl_days_out, 9000) = 1 then 'Tomorrow' 
				when isnull(est_dl_days_out, 9000) = 2 then 'Next2Days'
				when isnull(est_dl_days_out, 9000) = 9000 then 'ETATBD'
				else 'Over2Days' end) as datecategory
	from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY where stp_status = 'In Transit'
) as source
pivot (
	sum(po_count) for datecategory in(Today, Tomorrow, Next2Days, Over2Days, ETATBD)
) as pvt 







select sku_retl_amt, class_contents, subdept, FLOW_TYPE, 
	(case when est_dl_days_out <= 0 then 'Today' 
			when est_dl_days_out = 1 then 'Tomorrow' 
			when est_dl_days_out = 2 then 'Next2Days'
			else 'Over2Days' end) as datecategory,
	*
from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY where stp_status = 'In Transit'
group by stp_status, sku_retl_amt, class_contents, subdept, FLOW_TYPE








