




select * from orders

sp_help orders 


alter table orders 
drop constraint FK_Order_Menu

alter table orders
add constraint FK_Order_Menu_Item_Price foreign key (item_id) references Menu_Item_Prices(menu_item_id)

alter table orders
add constraint FK_Order_Invoice foreign key (invoice_id) references Invoices(invoice_id)



/*
alter orders 
drop foreign key FK_Order_Menu

alter orders
add constraint FK_Order_Menu_Item_Price foreign key (item_id) references Menu_Item_Prices(menu_item_id)

*/












