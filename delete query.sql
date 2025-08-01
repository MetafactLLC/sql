

users

user_levels

schedule

menu_item_prices

menus

select * from restaurants
where restaurant_id between 5 and 150


select * from users 
where user_id in(select user_id from user_levels where restaurant_id between 5 and 150)

select user_id from user_levels where restaurant_id between 5 and 150

select * from restaurant_schedules where restaurant_id between 5 and 150

select * from menu_item_prices where item_id in(select item_id from menus where restaurant_id between 5 and 150)

select * from menus where restaurant_id between 5 and 150

select * from restaurants
where restaurant_id between 5 and 150

/*

delete from user_levels where restaurant_id in(1,2,3,453)

delete from users 
where user_id in(select user_id from user_levels where restaurant_id in(1,2,3,453))

delete from restaurant_schedules where restaurant_id in(1,2,3,453)

delete from orders where item_id in(select item_id from menu_item_prices where item_id in(select item_id from menus where restaurant_id in(1,2,3,453)))

delete from invoices where invoice_id in(select invoice_id from orders where item_id in(select item_id from menus where restaurant_id in(1,2,3,453)))

delete from menu_item_prices where item_id in(select item_id from menus where restaurant_id in(1,2,3,453))

delete from menus where restaurant_id in(1,2,3,453)

delete from fees where restaurant_id in(1,2,3,453)

delete from restaurants
where restaurant_id in(1,2,3,453)


*/



