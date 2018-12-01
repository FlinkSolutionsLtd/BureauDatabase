
CREATE procedure [bureau].[sp_get_daily]
	 @startdate as varchar(10) 
	,@enddate as varchar(10)
	,@lid as varchar(10)
as
--declare
--@startdate as varchar(10) 
--	,@enddate as varchar(10)
--	,@lid as varchar(10) 
--select
--	 @startdate = '26/04/2016'
--	,@enddate = '28/04/2016'
--	,@lid = '1'

declare 
	 @sdate as datetime
	,@edate as datetime
select
	 @sdate = convert(datetime,@startdate,103)
	,@edate = convert(datetime,@enddate,103)

;with dates as
(
	 select @sdate as shift_date, 1 as x
	 union all select dateadd(day,1,shift_date), x + 1 from dates where x <= datediff(day,@sdate,@edate)
)

select
	 ds_id
	,l.loc_id
	,dates.shift_date
	,ct.shift_code
	,Coord
	,Orientee
	,RN
	,EN
	,HCA
	,CNM
	,Coord_Name
	,comments
	,r.create_dttm
	,r.create_user
	,r.modif_dttm
	,r.modif_user
	,r.is_deleted
	,'<b>' + left(datename(weekday,dates.shift_date),3) + '</b><br>'
		+ convert(varchar(6),dates.shift_date,6) + '<br>'
		+ case when ct.shift_code = 'D' then 'Day' when ct.shift_code='E' then 'Evening' when ct.shift_code='N' then 'Night' end as shift_display
	,row_number() over (partition by '' order by dates.shift_date, ct.shift_code) as seq_number
from
	 bureau.TLocation as l with (nolock) 
	 cross join (select 'D' as shift_code union select 'E' as shift_code union select 'N' as shift_code) as ct
	 cross join dates
	 left join bureau.TDailyStaffing as r with (nolock)	
		on r.loc_id = l.loc_id
		and r.shift_date = dates.shift_date
		and r.shift_code = ct.shift_code
		and r.is_deleted = 0
		and r.ds_type = 'ACTUAL'
where
	 l.loc_id = @lid
	 and (
			(ct.shift_code = 'D' and dates.shift_date = @edate) --the end date's morning shift only
			or (dates.shift_date = @sdate) --the start date, each shift
			or (dates.shift_date > @sdate and dates.shift_date < @edate) --or it falls between the start/end dates exclusive
		)
order by
	 dates.shift_date
	,ct.shift_code