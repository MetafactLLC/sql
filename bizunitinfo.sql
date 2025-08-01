



/*
use BOS_CanadianTire_100202

SELECT srs.sales_restriction_id AS item_restriction_group_id, srs.day_of_week_id AS item_restriction_id,srs.day_of_week_id AS restriction_day, srs.all_day_flag, srs.start_time AS begin_time, srs.end_time FROM sales_restriction_setting srs

SELECT   sr.sales_restriction_id AS item_restriction_group_id, COALESCE(sr.description, sr.name) AS description FROM sales_restriction sr

SELECT b.primitive_complete_code AS pos_code, COALESCE( rmidl.dimension_member_id, 0) AS barcode_unit_packing_id, rmibl.retail_modified_item_id AS object_id, 1 AS pos_code_type, b.client_id FROM barcode b JOIN retail_modified_item_barcode_list rmibl ON b.barcode_id = rmibl.barcode_id AND b.primitive_complete_code is not null JOIN retail_modified_item rmi ON rmi.retail_modified_item_id = rmibl.retail_modified_item_id JOIN retail_item ri ON rmi.retail_item_id = ri.retail_item_id AND ri.retail_item_type_code NOT IN ('t','x') JOIN Merch_BU_RMI_Retail_List mburl WITH (NOLOCK) ON   mburl.retail_modified_item_id = rmi.retail_modified_item_id AND  mburl.business_unit_id = %BUID LEFT JOIN retail_modified_item_dimension_list rmidl ON rmibl.retail_modified_item_id = rmidl.retail_modified_item_id LEFT JOIN Retail_Item_Dimension_Member ridm ON ridm.dimension_member_id = rmidl.dimension_member_id LEFT JOIN Retail_Item_Dimensions rid ON      rid.dimension_id = ridm.dimension_id WHERE NOT (rmidl.retail_modified_item_id IS NOT NULL AND ridm.unit_of_measure_id IS NULL AND rid.unit_of_measure_class_id IS NULL AND rid.dimension_level > 1 ) ORDER BY b.primitive_complete_code, rmibl.retail_modified_item_id
*/

/*

select distinct cast(business_unit_id as varchar) 
from merch_bu_rmi_retail_list 

*/

declare @business_unit int
set @business_unit = 1000201--1000117--1000113--1000327

SELECT ri.retail_item_id, i.name, i.item_hierarchy_id, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,  ri.device_group_id, ri.discount_group_code, ri.receipt_text, ri.condiment_group_id,
ri.entree_flag, ri.beverage_flag, ri.global_condiment_flag, ri.remote_device_highlight_flag, ri.prompt_for_quantity_flag as quantity_prompt_flag, ri.meter_payment_type_code, ri.terminal_sales_flag, CASE WHEN ri.taxability_flag = 's' AND ih.non_taxable_flag = 'n' THEN 'y' WHEN ri.taxability_flag = 's' and ih.non_taxable_flag = 'y' THEN 'n' WHEN ri.taxability_flag = 'y' THEN 'y' WHEN ri.taxability_flag = 'n' THEN 'n' ELSE 'y' END AS taxability_flag, ri.disallow_cancel_flag, ri.car_wash_type_code, ri.car_wash_token_value, ri.price_override_device_feature_id, gl.frame_id, CASE WHEN i.cdm_owner_id = @business_unit THEN ri.tender_rank END AS tender_rank, rmi.retail_modified_item_id, rmi.name as modifiername, rmi.retail_combo_item_group_id, ri.price_prompt_flag, rmi.pos_nav_frame_id,
'n' as locked_flag, rmi.xref_code AS external_id, rmi.xref_code, rmi.print_priority as print_priority, rth.default_retail_tax_type_id, COALESCE(rth.single_tier_flag, 'n') as single_tier_flag ,rmi.container_deposit_flag ,ri.swipe_flag, ri.card_fee_amount, ri.card_fee_retail_item_id FROM retail_item ri with (NOLOCK) JOIN item i with (NOLOCK) ON   ri.retail_item_id = i.item_id AND  i.purge_flag = 'n' AND  ( i.cdm_owner_id = @business_unit ) AND (ri.retail_item_type_code NOT IN ('f','t','x', 'w' ) OR (ri.retail_item_type_code='f' AND ri.pos_code='p')) JOIN retail_modified_item rmi   with (NOLOCK) ON ri.retail_item_id = rmi.retail_item_id LEFT OUTER JOIN pos_menu_frame_group_list gl with (NOLOCK) ON ri.receipt_frame_group_id = gl.pos_frame_group_id AND gl.menu_id = (SELECT COALESCE(fs_menu_id, pcs_menu_id) FROM business_unit_settings  with (NOLOCK) WHERE business_unit_id = @business_unit) LEFT OUTER JOIN retail_modified_item_bu_list lf    ON lf.retail_modified_item_id = rmi.retail_modified_item_id
              AND lf.business_unit_id = @business_unit
              JOIN merch_bu_rmi_retail_list price 
              ON rmi.retail_modified_item_id = price.retail_modified_item_id
              AND price.business_unit_id = @business_unit
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
              ON  bus.business_unit_id = @business_unit
              JOIN Retail_Tax_Hierarchy rth    
              ON  rth.retail_tax_hierarchy_id = bus.retail_tax_hierarchy_id

          UNION ALL
          
          SELECT ri.retail_item_id, i.name, i.item_hierarchy_id, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,
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
              ri.price_override_device_feature_id, gl.frame_id, CASE WHEN i.cdm_owner_id = @business_unit THEN ri.tender_rank END AS tender_rank,
              rmi.retail_modified_item_id, rmi.name as modifiername, rmi.retail_combo_item_group_id, ri.price_prompt_flag, rmi.pos_nav_frame_id,
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
              AND  ( i.cdm_owner_id = @business_unit ) 
              AND ri.retail_item_type_code = 'o' 
              JOIN retail_modified_item rmi   
              ON ri.retail_item_id = rmi.retail_item_id
              LEFT OUTER JOIN pos_menu_frame_group_list gl 
              ON ri.receipt_frame_group_id = gl.pos_frame_group_id
              AND gl.menu_id = (SELECT COALESCE(fs_menu_id, pcs_menu_id) FROM business_unit_settings  
              WHERE business_unit_id = @business_unit)
              JOIN Item_Hierarchy ih   
              ON   ih.item_hierarchy_id = i.item_hierarchy_id 
              JOIN Business_Unit_Settings bus  
              ON  bus.business_unit_id = @business_unit
              JOIN Retail_Tax_Hierarchy rth   
              ON  rth.retail_tax_hierarchy_id = bus.retail_tax_hierarchy_id
              ORDER BY ri.retail_item_id






