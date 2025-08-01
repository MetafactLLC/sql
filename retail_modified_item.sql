










--  select * from retail_modified_item

select * from retail_modified_item_attribute

select * from retail_modified_item_attribute_rmi_list

select * from retail_modified_item_attribute_value_list

select * from retail_modified_item_bu_list

select * from retail_modified_item


select r.name, rmia.name ,rmiavl.value 
from retail_modified_item_attribute_rmi_list rmi
inner join retail_modified_item_attribute_value_list rmiavl on rmiavl.value_id =  rmi.value_id
inner join retail_modified_item_attribute rmia on rmia.retail_modified_item_attribute_id = rmi.retail_modified_item_attribute_id
inner join retail_modified_item r on r.retail_modified_item_id = rmi.retail_modified_item_id

--------------------------------------------------------------------
-- CTP_Item_Is_CTM_Awardable retail_modified_item_attribute_id = 1000102
select r.name, rmia.name ,rmiavl.value 
from retail_modified_item_attribute_rmi_list rmi_list
inner join retail_modified_item_attribute_value_list rmiavl on rmiavl.value_id =  rmi_list.value_id
inner join retail_modified_item_attribute rmia on rmia.retail_modified_item_attribute_id = rmi_list.retail_modified_item_attribute_id
inner join retail_modified_item r on r.retail_modified_item_id = rmi_list.retail_modified_item_id
where rmia.retail_modified_item_attribute_id = 1000102

-- CTP_Override_Department
select r.name, rmia.name ,rmiavl.value 
from retail_modified_item_attribute_rmi_list rmi_list
inner join retail_modified_item_attribute_value_list rmiavl on rmiavl.value_id =  rmi_list.value_id
inner join retail_modified_item_attribute rmia on rmia.retail_modified_item_attribute_id = rmi_list.retail_modified_item_attribute_id
inner join retail_modified_item r on r.retail_modified_item_id = rmi_list.retail_modified_item_id
where rmia.retail_modified_item_attribute_id = 1000103

-- CTP_Bonus_CTM_Method
select r.name, rmia.name ,rmiavl.value 
from retail_modified_item_attribute_rmi_list rmi_list
inner join retail_modified_item_attribute_value_list rmiavl on rmiavl.value_id =  rmi_list.value_id
inner join retail_modified_item_attribute rmia on rmia.retail_modified_item_attribute_id = rmi_list.retail_modified_item_attribute_id
inner join retail_modified_item r on r.retail_modified_item_id = rmi_list.retail_modified_item_id
where rmia.retail_modified_item_attribute_id = 1000104

-- CTP_CTM_Bonus_Amount
select r.name, rmia.name ,rmiavl.value 
from retail_modified_item_attribute_rmi_list rmi_list
inner join retail_modified_item_attribute_value_list rmiavl on rmiavl.value_id =  rmi_list.value_id
inner join retail_modified_item_attribute rmia on rmia.retail_modified_item_attribute_id = rmi_list.retail_modified_item_attribute_id
inner join retail_modified_item r on r.retail_modified_item_id = rmi_list.retail_modified_item_id
where rmia.retail_modified_item_attribute_id = 1000105




