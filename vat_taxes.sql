




-- select distinct cdm_owner_id from item
declare @clientid int
set @clientid = 1000237

-- select distinct business_unit_id from business_unit_settings 
declare @buid int 
set @buid = 1000237

-- VAT_CATEGORY_TAXES
SELECT ihl.item_hierarchy_id, ihl.retail_tax_type_id, ihl.merch_retail_type_id
FROM   business_unit_settings bus
JOIN   retail_tax_hierarchy rth
ON     bus.business_unit_id = @buid
AND    rth.retail_tax_hierarchy_id = bus.retail_tax_hierarchy_id
AND    rth.single_tier_flag = 'y'
JOIN   retail_tax_type_item_hierarchy_list ihl
ON     ihl.retail_tax_hierarchy_id = rth.retail_tax_hierarchy_id

-- VAT_RMI_TAXES
SELECT rmil.retail_modified_item_id, rmil.retail_tax_type_id, rmil.merch_retail_type_id
        FROM   business_unit_settings bus
        JOIN   retail_tax_hierarchy rth
        ON     bus.business_unit_id = @buid
        AND    rth.retail_tax_hierarchy_id = bus.retail_tax_hierarchy_id
        AND    rth.single_tier_flag = 'y'
        JOIN   retail_tax_type_retail_modified_item_list rmil
        ON     rmil.retail_tax_hierarchy_id = rth.retail_tax_hierarchy_id

--  VAT_OWNERS
SELECT vat.retail_vat_owner_id, vat.name, vat.fiscal_code, addr.address_line_1
,addr.address_line_2, addr.city, addr.state_code, addr.country_code, addr.postal_code
FROM   retail_vat_owner vat
JOIN   business_unit_settings bus
ON     bus.business_unit_id = @buid
JOIN   Address addr ON addr.address_id = vat.address_id
WHERE EXISTS (   SELECT 1
FROM   Retail_VAT_Configuration_RMI_Override rmi
WHERE  vat.retail_vat_owner_id = rmi.retail_vat_owner_id
AND    rmi.retail_vat_configuration_id = bus.retail_Vat_configuration_id )
OR    EXISTS (   SELECT 1
FROM   Retail_VAT_Configuration_ih_Override ih
WHERE  vat.retail_vat_owner_id = ih.retail_vat_owner_id
AND    ih.retail_vat_configuration_id = bus.retail_Vat_configuration_id )
OR    EXISTS (   SELECT 1
FROM   Retail_VAT_Configuration c
WHERE  vat.retail_vat_owner_id = c.default_retail_vat_owner_id
AND    c.retail_vat_configuration_id = bus.retail_Vat_configuration_id  )        

-- VAT_ITEMS
SELECT bus.business_unit_id, rmi.retail_modified_item_id
,COALESCE ( rvo3.retail_vat_owner_id, rvo2.retail_vat_owner_id, rvo1.retail_vat_owner_id ) AS retail_vat_owner_id
FROM business_unit_settings AS bus
JOIN item AS i
ON ( i.cdm_owner_id = @clientid OR i.cdm_owner_id = @buid )
AND bus.business_unit_id = @buid
JOIN retail_modified_item AS rmi
ON rmi.retail_item_id = i.item_id
JOIN retail_vat_configuration AS rvc
ON rvc.retail_vat_configuration_id = bus.retail_vat_configuration_id
JOIN retail_vat_owner AS rvo1
ON rvc.default_retail_vat_owner_id = rvo1.retail_vat_owner_id
LEFT OUTER JOIN retail_vat_configuration_ih_override AS rvciho
ON rvciho.retail_vat_configuration_id = bus.retail_vat_configuration_id
AND rvciho.item_hierarchy_id = i.item_hierarchy_id
LEFT OUTER JOIN retail_vat_owner AS rvo2
ON rvciho.retail_vat_owner_id = rvo2.retail_vat_owner_id
LEFT OUTER JOIN retail_vat_configuration_rmi_override AS rvcrmio
ON rvcrmio.retail_vat_configuration_id = bus.retail_vat_configuration_id
AND rmi.retail_modified_item_id = rvcrmio.retail_modified_item_id
LEFT JOIN retail_vat_owner AS rvo3
ON rvcrmio.retail_vat_owner_id = rvo3.retail_vat_owner_id  
























