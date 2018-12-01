
CREATE view [bureau].[vBureauRequests]
as

/*

BUREAU REPORTING VIEW

Dimensions - 
	Date/time: 
		year
		month
		FN2 fortnight (nursing pay period)
		week
		day
		shift
		time

	Location/RC: 
		Division
		Service
		RC

	Hospital

	AC:
		AC

	Source of request:
		Internal/External/Own staff

	Request status:
		Filled/Unfilled/Cancelled/Unknown --which means not actioned by bureau

	request category:
		Watch (watch, special)
			watch reasons
		Other
			cover
				cover reasons
			acuity
				acutiy reasons ---MISSING

	staff designation

Facts -
	Requests (requestresource)
		shifts (hours / 8)
		hours

	Budget (dailystaffing budget)
		shifts
		hours

	Rostered (dailystaffing actual)
		shifts
		hours

*/

with fts as
(
	--based on an anchor date known as the start of a FN2 pay period. 
	--without integration to leader, it'll have to rely on a point in time to determine a fortnight's range
	select cast('2015-01-05' as datetime) as dt, dateadd(day,13,cast('2015-01-05' as datetime)) as edt
	union all select dateadd(day,14,dt), dateadd(day,14,edt) from fts where dateadd(day,14,edt) < getdate()
)

select
	--fact ids
	'R' + cast(rr.rr_id as varchar(10)) as rec_id

	--location/rc dimensions
	,l.loc_id
	,isnull(l.loc_description,rr.loc_freetext) as loc_description
	,isnull(l.rc_code,override_rc_code) as rc_code
	,hosp.description as hospital
	,rc.Division
	,rc.Service

	--date dimensions
	,rr.shift_date	
	,WDHB_Research.bureau.f_get_shiftcode(rr.start_time) as shift_code
	,rr.start_time	
	,fts.dt as fortnight_start
	,fts.edt as fortnight_end
	,dt.cal_month_first_date as month_start
	,dateadd(day,0,datediff(day,0,dt.cal_month_last_date)) as month_end
	,dt.week_start_date as week_start
	,dt.week_end_date as week_end
	
	--other fact dimensions		
	,isnull(rrstatus.description,'Unknown') as request_status
	,isnull(rdesig.code,desig.code) as desig
	,case isnull(rdesig.code,desig.code)
	 when 'MW' then 'RN'
	 else isnull(rdesig.code,desig.code) 
	 end as rpt_desig --replace MW as RN
	,isnull(rsource.description,'Unknown') as source
	,case
	 when rsource.description like 'External%' then replace(rsource.description,'External - ','') 
	 end as external_source
	,case when rtype.description in('Special','Watch') then 'Watch'
	 else 'Other'
	 end as req_category
	,rtype.description as req_type
	,rreason.description as req_reason

	--values
	,isnull(resp_hrs,hrs) as hrs
	,isnull(resp_hrs,hrs)/convert(real,8) as shifts
	
from
	[bureau].[TRequestResource] as rr with (nolock)
	inner join dbo.dim_date as dt with (nolock)
		on rr.shift_date = dt.calendar_date
	inner join bureau.TLocation as l with (nolock)
		on rr.loc_id = l.loc_id
	left join vdimRC as rc with (nolock)
		on rc.rc = l.rc_code
	left join bureau.TLookup as hosp with (nolock) on hosp.lk_id = l.hospital_lk_id or hosp.lk_id = rr.misc_hosp_lk_id
	left join bureau.TLookup as rrstatus with (nolock)
		on rrstatus.lk_id = rr.status
	left join bureau.TLookup as desig with (nolock)
		on desig.lk_id = rr.desig_id
	left join bureau.TLookup as rdesig with (nolock)
		on rdesig.lk_id = rr.resp_desig_id
	left join bureau.TLookup as rsource with (nolock)
		on rsource.lk_id = rr.resp_type_id
	left join bureau.TLookup as rtype with (nolock)
		on rtype.lk_id = rr.reqtype_id
	left join bureau.TLookup as rreason with (nolock)
		on rreason.lk_id = rr.reason_prim_id
	left join fts
		on rr.shift_date between fts.dt and fts.edt

where
	rr.is_deleted = 0				
	and l.rc_code <> '?' --unknown locations
	and rr.reqtype_id >0 --zero are just notes that bureau are adding and not real requests
	and rr.create_dttm >= '2016-07-25' --go-live date