CREATE procedure [bureau].[sp_get_location]
	 @locid int
as

select
	 loc_id
	,case 
	 when lk.description = 'North Shore' then '[NSH] ' 
	 when lk.description = 'Waitakere' then '[WTK] '
	 when lk.description = 'Mental Health' then '[MH] '
	 else ''
	 end + loc_description as loc_description
	,rc_code
	,trendcare_code
from
	 bureau.TLocation as l with (nolock)
	 inner join bureau.TLookup as lk with (nolock)
		on l.hospital_lk_id = lk.lk_id
where
	 l.loc_id = @locid