


declare @buid int 
set @buid = 1000115

select i.name as item_name, rmia.name as attribute_name, rmiavl.value, rmial.retail_modified_item_id,
		rmial.retail_modified_item_attribute_id,
		rmial.value_id, rmial.client_id from Retail_Modified_Item_Attribute_RMI_List rmial 
inner join Retail_Modified_Item_Attribute rmia 
      on rmial.retail_modified_item_attribute_id = rmia.retail_modified_item_attribute_id
inner join Retail_Modified_Item_Attribute_Value_List rmiavl
      on rmia.retail_modified_item_attribute_id = rmiavl.retail_modified_item_attribute_id 
      and rmial.value_id = rmiavl.value_id
inner join Retail_Modified_Item i on i.retail_modified_item_id = rmial.retail_modified_item_id
left join retail_modified_item_bu_list lf     
on lf.retail_modified_item_id = i.retail_modified_item_id
and lf.business_unit_id = @buid


 SELECT retail_modified_item_id, locked_flag, print_priority
            FROM   retail_modified_item_bu_list
            WHERE  business_unit_id = @BUID
            AND   ( locked_flag = 'y' OR print_priority IS NOT NULL )


