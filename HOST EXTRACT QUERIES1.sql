
/*
use BOS_CanadianTire_100202
HOST EXTRACT QUERIES

*/
--PosLblCategories
--categories
/*
SELECT ih.item_hierarchy_id, ih.name, ih.expanded_name, ih.parent_item_hierarchy_id, ih.hierarchy_level, ih.non_taxable_flag, ih.external_number
               ,ih.credit_category, eps.category_code, ih.description, ih.merchandise_code 
        FROM Item_Hierarchy ih
        LEFT JOIN Retail_EPS_Category eps
        ON   eps.retail_eps_category_id = ih.retail_eps_category_id      
        order by external_number
*/        

--LHWEB_LOYALTY
--EntLoyaltyProgram
/*
--EntLoyaltyProgram
--Probably indicates whether they are in the loyalty program or not
SELECT  *
          FROM  loy_program AS lp
          WHERE  lp.status_code = 'y'
          AND  ((lp.effective_start_date >= %BULocalTime )
          OR  (lp.effective_end_date >= %BULocalTime ) )
          ORDER BY lp.effective_start_date DESC, lp.loy_program_id

--EntLoyaltyBusinessUnit
SELECT  lp.loy_program_id, lp.status_code, bu.POS_Site_UUID, 
          bu.business_unit_id, rsda.name, rsda.long_name
          FROM  Loy_Program AS lp
          CROSS JOIN  Business_Unit AS bu
          JOIN  Rad_Sys_Data_Accessor AS rsda
            ON  rsda.data_accessor_id = bu.business_unit_id
          WHERE  bu.business_unit_id =  %BUID
          AND  lp.status_code = 'y'
          AND (lp.effective_start_date >= %BULocalTime 
          OR  lp.effective_end_date >= %BULocalTime )
          ORDER BY lp.effective_start_date DESC, lp.loy_program_id

*/

      
SELECT count(ih.expanded_name) as loyalty, ih.expanded_name 
        FROM Item_Hierarchy ih
        LEFT JOIN Retail_EPS_Category eps
        ON   eps.retail_eps_category_id = ih.retail_eps_category_id      
        group by ih.expanded_name 
       
--select distinct cdm_owner_id from item

--PoslblRetailItems
--RetailItems

--sp_help item
/*
1000331
1000415
1000416
*/
declare @clientid int
set @clientid = 1000101

declare @buid int 
set @buid = 1000115

-- for CT, i.item_hierarchy_id, will need to be changed
/*
SELECT ri.retail_item_id, i.name, i.item_hierarchy_id, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,
ri.device_group_id, ri.discount_group_code, ri.receipt_text, ri.condiment_group_id,
ri.entree_flag, ri.beverage_flag, ri.global_condiment_flag, ri.remote_device_highlight_flag,
ri.prompt_for_quantity_flag as quantity_prompt_flag, ri.meter_payment_type_code, ri.terminal_sales_flag,
*/

SELECT ri.retail_item_id, i.name, ih.description, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,
ri.device_group_id, ri.discount_group_code, ri.receipt_text, ri.condiment_group_id,
ri.entree_flag, ri.beverage_flag, ri.global_condiment_flag, ri.remote_device_highlight_flag,
ri.prompt_for_quantity_flag as quantity_prompt_flag, ri.meter_payment_type_code, ri.terminal_sales_flag,
CASE 
WHEN ri.taxability_flag = 's' AND ih.non_taxable_flag = 'n' THEN 'y' 
WHEN ri.taxability_flag = 's' and ih.non_taxable_flag = 'y' THEN 'n'
WHEN ri.taxability_flag = 'y' THEN 'y' 
WHEN ri.taxability_flag = 'n' THEN 'n'
ELSE 'y'
END AS taxability_flag,   
ri.disallow_cancel_flag,
ri.car_wash_type_code,
ri.car_wash_token_value,               
ri.price_override_device_feature_id, gl.frame_id, CASE WHEN i.cdm_owner_id = @buid THEN ri.tender_rank END AS tender_rank,
rmi.retail_modified_item_id, rmi.name as modifiername, rmi.retail_combo_item_group_id, ri.price_prompt_flag, rmi.pos_nav_frame_id,
/* Next line is for future change to include costs - spoke with cblevins it */
/* will probably be on merch_bu_rmi_retail_list */
/* COALESCE(price.unit_cost, 0.0) as unit_cost, 
COALESCE(0.0, 0.0) as unit_cost,  */
'n' as locked_flag,
rmi.xref_code AS external_id,
rmi.xref_code,
rmi.print_priority as print_priority, rth.default_retail_tax_type_id, COALESCE(rth.single_tier_flag, 'n') as single_tier_flag
,rmi.container_deposit_flag
,ri.swipe_flag, ri.card_fee_amount, ri.card_fee_retail_item_id
FROM retail_item ri             
JOIN item i          
ON   ri.retail_item_id = i.item_id
AND  i.purge_flag = 'n'
AND  ( i.cdm_owner_id = @clientid OR i.cdm_owner_id = @buid ) 
AND (ri.retail_item_type_code NOT IN ('f','t','x', 'w' ) OR (ri.retail_item_type_code='f' AND ri.pos_code='p'))
JOIN retail_modified_item rmi   
ON ri.retail_item_id = rmi.retail_item_id
LEFT OUTER JOIN pos_menu_frame_group_list gl 
ON ri.receipt_frame_group_id = gl.pos_frame_group_id
AND gl.menu_id = (SELECT COALESCE(fs_menu_id, pcs_menu_id) FROM business_unit_settings   
WHERE business_unit_id = @buid)
LEFT OUTER JOIN retail_modified_item_bu_list lf     
ON lf.retail_modified_item_id = rmi.retail_modified_item_id
AND lf.business_unit_id = @buid
JOIN merch_bu_rmi_retail_list price 
ON rmi.retail_modified_item_id = price.retail_modified_item_id
AND price.business_unit_id = @buid
LEFT OUTER JOIN retail_modified_item_dimension_list rmidl1   
ON rmi.retail_modified_item_id = rmidl1.retail_modified_item_id
AND rmidl1.dimension_level = 1
LEFT OUTER JOIN retail_modified_item_dimension_list rmidl2    
ON rmi.retail_modified_item_id = rmidl2.retail_modified_item_id
AND rmidl2.dimension_level = 2
LEFT OUTER JOIN retail_modified_item_dimension_list rmidl3    
ON rmi.retail_modified_item_id = rmidl3.retail_modified_item_id
AND rmidl3.dimension_level = 3
JOIN Item_Hierarchy ih   
ON   ih.item_hierarchy_id = i.item_hierarchy_id 
JOIN Business_Unit_Settings bus   
ON  bus.business_unit_id = @buid
JOIN Retail_Tax_Hierarchy rth     
ON  rth.retail_tax_hierarchy_id = bus.retail_tax_hierarchy_id
/*
WHERE rmi.client_id IN @clientid
AND (ri.retail_item_type_code NOT IN ('f','t','x', 'w' ) OR (ri.retail_item_type_code='f' AND ri.pos_code='p'))
ABOVE lines are redundant due to the initial join to the item table*/

UNION ALL

/*
SELECT ri.retail_item_id, i.name, i.item_hierarchy_id, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,
ri.device_group_id, ri.discount_group_code, ri.receipt_text, ri.condiment_group_id,
ri.entree_flag, ri.beverage_flag, ri.global_condiment_flag, ri.remote_device_highlight_flag,
ri.prompt_for_quantity_flag as quantity_prompt_flag, ri.meter_payment_type_code, ri.terminal_sales_flag,
*/
SELECT ri.retail_item_id, i.name, ih.description, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,
ri.device_group_id, ri.discount_group_code, ri.receipt_text, ri.condiment_group_id,
ri.entree_flag, ri.beverage_flag, ri.global_condiment_flag, ri.remote_device_highlight_flag,
ri.prompt_for_quantity_flag as quantity_prompt_flag, ri.meter_payment_type_code, ri.terminal_sales_flag,
CASE 
WHEN ri.taxability_flag = 's' AND ih.non_taxable_flag = 'n' THEN 'y' 
WHEN ri.taxability_flag = 's' and ih.non_taxable_flag = 'y' THEN 'n'
WHEN ri.taxability_flag = 'y' THEN 'y' 
WHEN ri.taxability_flag = 'n' THEN 'n'
ELSE 'y'
END AS taxability_flag,   
ri.disallow_cancel_flag,
ri.car_wash_type_code,
ri.car_wash_token_value,               
ri.price_override_device_feature_id, gl.frame_id, CASE WHEN i.cdm_owner_id = @buid THEN ri.tender_rank END AS tender_rank,
rmi.retail_modified_item_id, rmi.name as modifiername, rmi.retail_combo_item_group_id, ri.price_prompt_flag, rmi.pos_nav_frame_id,
/* Next line is for future change to include costs - spoke with cblevins it */
/* will probably be on merch_bu_rmi_retail_list */
/* COALESCE(price.unit_cost, 0.0) as unit_cost, 
COALESCE(0.0, 0.0) as unit_cost,  */
'n' as locked_flag,
rmi.xref_code AS external_id,
rmi.xref_code,
rmi.print_priority as print_priority, rth.default_retail_tax_type_id, COALESCE(rth.single_tier_flag, 'n') as single_tier_flag
,rmi.container_deposit_flag
,ri.swipe_flag, ri.card_fee_amount, ri.card_fee_retail_item_id
FROM retail_item ri             
JOIN item i          
ON   ri.retail_item_id = i.item_id
AND  i.purge_flag = 'n'
AND  ( i.cdm_owner_id = @clientid OR i.cdm_owner_id = @buid ) 
AND ri.retail_item_type_code = 'o' 
JOIN retail_modified_item rmi   
ON ri.retail_item_id = rmi.retail_item_id
LEFT OUTER JOIN pos_menu_frame_group_list gl 
ON ri.receipt_frame_group_id = gl.pos_frame_group_id
AND gl.menu_id = (SELECT COALESCE(fs_menu_id, pcs_menu_id) FROM business_unit_settings   
WHERE business_unit_id = @buid)
JOIN Item_Hierarchy ih   
ON   ih.item_hierarchy_id = i.item_hierarchy_id 
JOIN Business_Unit_Settings bus   
ON  bus.business_unit_id = @buid
JOIN Retail_Tax_Hierarchy rth     
ON  rth.retail_tax_hierarchy_id = bus.retail_tax_hierarchy_id
ORDER BY ri.retail_item_id












