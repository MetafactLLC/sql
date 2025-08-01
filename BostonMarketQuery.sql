
/*
select db_name()
-- BOS_bostonmarket_090302
-- BOS_bostonmarket_090302_wh

declare @startdate datetime 
declare @rundate datetime 

--set @startdate = dateadd(ww,-6,'9/30/2008')
set @startdate = '9/30/2008'
set @startdate = dateadd(dd,-1,@startdate)

--set @rundate = dateadd(dd,1,@startdate)
set @rundate = '9/30/2008'

-- Find BUs with no sales_usage aggregated data on a particular day
select distinct rsda.data_accessor_id, rsda.name, a.start_business_date
from rad_sys_data_accessor rsda (nolock)
join org_hierarchy oh (nolock)
on rsda.data_accessor_id = oh.org_hierarchy_id
join business_unit bu (nolock)
on rsda.data_accessor_id = bu.business_unit_id
left outer join (select bu_id, start_business_date
                 from   BOS_bostonmarket_090302_wh..f_gen_inv_item_activity_bu_day fg (nolock)
                 where  month(fg.start_business_date) = month(@rundate)
					and year(fg.start_business_date) = year(@rundate)
					and day(fg.start_business_date) = day(@rundate)
                 group by bu_id, start_business_date) a
on rsda.data_accessor_id = a.bu_id
where oh.org_hierarchy_level_id = 2
  and bu.status_code in ('o')
  and a.start_business_date is null
order by rsda.name
*/



--use BOS_bostonmarket_090302


declare @var_date datetime
declare @min_date datetime
declare @bu_dates table(eye_d int identity(1,1),bu int, business_date datetime, valid varchar(1) default('y'))
declare @last int
declare @place int
declare @datefinder datetime
declare @datefinder2 datetime
declare @monthbeginning datetime
declare @monthend datetime
declare @bu int
declare @bu_date as datetime
declare @non_existant_dates table(eye_d int identity(1,1), bu int, business_date datetime)
declare @place2 int

declare @l1 int
declare @loop_bu int
declare @limit int 

set @var_date = '3/22/2010'

--populate temp table w/ available dates
insert into @bu_dates 
select distinct bu.business_unit_id, a.start_business_date, 'y' 
from business_unit bu (nolock)
left join BOS_bostonmarket_090302_wh..f_gen_inv_item_activity_bu_day a -- warehouse data
on bu.business_unit_id = a.bu_id
where bu.status_code in ('o')
and a.start_business_date is not null

set @min_date = (select top 1 business_date from @bu_dates order by business_date)
set @limit = (select top 1 eye_d from @bu_dates order by eye_d desc)

set @l1 = 1
while @l1 < @limit
begin
	set @loop_bu = (select distinct bu from @bu_dates where eye_d = @l1)
	-- loop thru bu's to ensure dates 
	while @min_date < @var_date
	begin
		if not exists(select 1 from @bu_dates where month(business_date) = @min_date and year(business_date) = @min_date and bu = @loop_bu)
		begin
			insert into @bu_dates
			select @loop_bu, @min_date, 'n' 
		end
		set @min_date = dateadd(m,1,@min_date)
	end
	set @l1 = @l1 + 1
end

select * from @bu_dates order by bu

set @last = (select top 1 eye_d from @bu_dates order by eye_d desc)
set @place = 1
set @place2 = 1
set @datefinder = (select top 1 business_date from @bu_dates order by business_date)

while @place < @last  
begin 

	--loop through the month
	set @bu = (select bu from @bu_dates where eye_d = @place)
	set @bu_date = (select business_date from @bu_dates where eye_d = @place)
	set @monthbeginning = cast(cast(month(@bu_date) as varchar) + '/1/' + cast(year(@bu_date) as varchar) as datetime) 
	set @monthend = dateadd(d,-1,dateadd(m,1,cast(month(@bu_date) as varchar) + '/1/' + cast(year(@bu_date) as varchar))) 

	set @place2 = 1
		
	while @place2 <= day(@monthend)
	begin
		-- if the does not exist for that bu in the temp table let it be known	
		if not exists(select 1 from @bu_dates where business_date = @monthbeginning and bu = @bu and valid='y')
		begin 
			insert into @non_existant_dates values(@bu, @monthbeginning)
		end	
		set @monthbeginning = dateadd(d,1,@monthbeginning)
		set @place2 = @place2 + 1	
	end
	
	-- reset the date (add 1 day)
	--set @datefinder = dateadd(d,1,@datefinder)
	set @place2 = 1
	
	-- proceed to the next 
	set @place = @place + 1
end 

select * from @non_existant_dates order by business_date






/*
-- Find BUs with no gross_sold_qty aggregated data on a particular day
select distinct rsda.data_accessor_id, rsda.name, a.start_time
from bostonmarket..rad_sys_data_accessor rsda (nolock)
join bostonmarket..org_hierarchy oh (nolock)
on rsda.data_accessor_id = oh.org_hierarchy_id
join bostonmarket..business_unit bu (nolock)
on rsda.data_accessor_id = bu.business_unit_id
left outer join (select bu_id, start_time
                 from   bostonmarket_wh..f_gen_sales_dest_min_bu_day fg (nolock)
                 where  fg.start_time between '3/8/2010' and '3/9/2010'
                 group by bu_id, start_time) a
on rsda.data_accessor_id = a.bu_id
where oh.org_hierarchy_level_id = 2
  and bu.status_code in ('o')
  and a.start_time is null
order by rsda.name
*/
