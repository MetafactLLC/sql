--select * into #VW_RPT_EMER_SCHN_VSBL_COMP_SMRY from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY
--[VW_RPT_EMER_SCHN_VSBL_COMPANYSUMMARY]
select 
	class_contents as CLASS, subdept as DEPT, sum(total_str_dc_count) as [# STRS/DCs], 
	sum(total_po_count) as [# POs], [# UNITS] , [RETL $] ,
	new_order_po_count as [# POs1], new_order_aged_days as [AGE DAYS ], new_order_str_dc_count as [# UNITS1], new_order_str_sku_retl_amt as [RETL $1], 
	pend_pickup_po_count as [# POs2], pend_pickup_aged_days as [AGE DAYS 1], 

	FLOW_TYPE, FLOW_TYPE_SRTR
	, sum(new_order_po_count) as new_order_po_count
	, sum(pend_pickup_po_count) as pend_pickup_po_count
from (
select 
	FLOW_TYPE, FLOW_TYPE_SRTR, class_contents, subdept, stp_status

	, sum(ord_qty) as [# UNITS]
	, sum(sku_retl_amt) as [RETL $]
	, case when stp_status = 'New Order' then aged_days end as new_order_aged_days
	, case when stp_status = 'Pend Pickup' then aged_days end as pend_pickup_aged_days

	, sum(po_count) as total_po_count
	, sum(case when stp_status = 'New Order' then po_count end) as new_order_po_count
	, sum(case when stp_status = 'Pend Pickup' then po_count end) as pend_pickup_po_count
	, sum(case when stp_status = 'In Transit' then po_count end) as in_transit_po_count
	, sum(case when stp_status = 'Delivered' then po_count end) as delivered_po_count
	, sum(case when stp_status = 'Vnd Mgd Frt' then po_count end) as vnd_mgd_frt_po_count

	, sum(str_dc_count) as total_str_dc_count
	, sum(case when stp_status = 'New Order' then str_dc_count end) as new_order_str_dc_count
	, sum(case when stp_status = 'Pend Pickup' then str_dc_count end) as pend_pickup_str_dc_count
	, sum(case when stp_status = 'In Transit' then str_dc_count end) as in_transit_str_dc_count
	, sum(case when stp_status = 'Delivered' then str_dc_count end) as delivered_str_dc_count
	, sum(case when stp_status = 'Vnd Mgd Frt' then str_dc_count end) as vnd_mgd_frt_str_dc_count

	, sum(sku_retl_amt) as total_sku_retl_amt
	, sum(case when stp_status = 'New Order' then sku_retl_amt end) as new_order_str_sku_retl_amt
	, sum(case when stp_status = 'Pend Pickup' then sku_retl_amt end) as pend_pickup_sku_retl_amt
	, sum(case when stp_status = 'In Transit' then sku_retl_amt end) as in_transit_sku_retl_amt
	, sum(case when stp_status = 'Delivered' then sku_retl_amt end) as delivered_sku_retl_amt
	, sum(case when stp_status = 'Vnd Mgd Frt' then sku_retl_amt end) as vnd_mgd_frt_sku_retl_amt

from VW_RPT_EMER_SCHN_VSBL_COMP_SMRY where class_contents = '08 - FENCING' and subdept = '21'
group by FLOW_TYPE, FLOW_TYPE_SRTR, class_contents, subdept, stp_status
	, case when stp_status = 'New Order' then aged_days end 
	, case when stp_status = 'Pend Pickup' then aged_days end 
) a 
group by FLOW_TYPE, FLOW_TYPE_SRTR, class_contents, subdept, 
	new_order_aged_days, pend_pickup_aged_days, [# UNITS], [RETL $], 
	new_order_po_count, new_order_aged_days, new_order_str_dc_count, new_order_str_sku_retl_amt 	 






