


/*
select db_name()
-- SSA_SSA_mini_080321

select * from sysobjects 
where xtype='u'
and name like '%Retail%'


select * from information_schema.columns 
where column_name like '%Retail%'
order by column_name

select top 100 * from retail_item
where retail_item_id = 1024492

*/

/*
use BOS_CanadianTire_100202
HOST EXTRACT QUERIES

*/

declare @clientid int
set @clientid = 1000101

declare @buid int 
set @buid = 1000115

declare @TemplateClientID int
set @TemplateClientID = 1000101



SELECT ri.retail_item_id, i.name, ih.description as item_hierarchy_id, ri.security_action_code, ri.retail_item_type_code, ri.pos_code,
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
                 ri.price_override_device_feature_id, 
                 gl.frame_id, 
                 CASE WHEN i.cdm_owner_id = @BUID THEN ri.tender_rank END AS tender_rank,
                 ri.price_prompt_flag, 
                 ri.swipe_flag, ri.card_fee_amount, ri.card_fee_retail_item_id, ri.kitchen_display_text,
                 ri.upsell_flag, CASE WHEN ri.card_fee_retail_item_id = ri.retail_item_id THEN 'y' ELSE 'n' END as card_fee_flag,
                 rmi.retail_modified_item_id, rmi.name as modifiername, rmi.retail_combo_item_group_id, rmi.pos_nav_frame_id,
                 'n' as locked_flag,
                        rmi.xref_code AS external_id,
                        rmi.xref_code,
                 rmi.print_priority as print_priority, 
                 rmi.container_deposit_flag, 
				 coalesce(ii.sku_number,'') as sku_number, ii.set_variance_to_zero_flag, coalesce(i.shelf_label_quantity,0) as shelf_label_quantity, 
				 coalesce(i.description,'0') as description
          FROM retail_item ri with (NOLOCK)
          JOIN item i with (NOLOCK)
            ON ri.retail_item_id = i.item_id 
          JOIN Item_Hierarchy ih  with (NOLOCK) 
            ON ih.item_hierarchy_id = i.item_hierarchy_id 
          join retail_modified_item rmi with(nolock)
            ON ri.retail_item_id=rmi.retail_item_id
		  join inventory_item ii with(nolock)
			on ii.inventory_item_id = ri.retail_item_id
          LEFT OUTER JOIN pos_menu_frame_group_list gl with (NOLOCK)
            ON ri.receipt_frame_group_id = gl.pos_frame_group_id and exists (
                SELECT 1 FROM business_unit_settings  with (NOLOCK) 
                WHERE gl.menu_id = COALESCE(fs_menu_id, pcs_menu_id) and business_unit_id = @BUID)
          where  i.purge_flag = 'n'
                 AND  ( i.cdm_owner_id IN (0,@TemplateClientID,@ClientID) OR i.cdm_owner_id = @BUID ) 
                 AND (
                       (ri.retail_item_type_code NOT IN ('f','t','x', 'w','o' ) OR (ri.retail_item_type_code='f' AND ri.pos_code='p'))
                       and exists (select 1 from merch_bu_rmi_retail_list price with (NOLOCK)
                                   where rmi.retail_modified_item_id = price.retail_modified_item_id
                                   AND price.business_unit_id = @BUID)
                       OR 
                       ri.retail_item_type_code = 'o'
                      )
          order by rmi.retail_item_id





