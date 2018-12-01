﻿
CREATE procedure bureau.rp_casual_staff_usage
	 @start as datetime
	,@Division as varchar(255)
as

declare @startdate as datetime;
set datefirst 1;

--set first monday of the year
set @startdate = cast(cast(year(getdate()) as char(4)) + '-01-01' as datetime)
if datepart(weekday,@startdate) > 1
	begin
		set @startdate = dateadd(day,8 - datepart(weekday,@startdate),@startdate)
	end

;with prevdates as
(
	select @startdate as dt, dateadd(day,13,@startdate) as edt
	union all select dateadd(day,-14,dt), dateadd(day,-14,edt) from prevdates where dt > @start
)
,nextdates as
(
	select dateadd(day,14,@startdate) as dt, dateadd(day,27,@startdate) as edt
	union all select dateadd(day,14,dt), dateadd(day,14,edt) from nextdates where dateadd(day,14,edt) <= getdate()
)
,fortnights as
(
	select * from prevdates
	union select * from nextdates
)
,t as
(
	select
		 dt
		,edt
		,[loc_description]
		,[rc_code]
		,rc.Service
		,rc.Division
		,[hospital]
		,sum([vol]) as hrs
		,count(*) as shifts
		,case [req_type] 
		 when 'UTF' then 'UTF'
		 when 'Acuity' then 'Watch'
		 when 'Special' then 'Watch'
		 else [req_type]
		 end as req_type
		,[source]
	from 
		 fortnights
		 inner join 
		 (
			select
				'R' + cast(rr.rr_id as varchar(10)) as rec_id
				,l.loc_id
				,isnull(l.loc_description,rr.loc_freetext) as loc_description
				,isnull(l.rc_code,override_rc_code) as rc_code
				,hosp.description as hospital
				,rr.shift_date			
				,isnull(resp_hrs,hrs) as vol
				,case
				 when rrstatus.description like 'Unable to fill%' then 'UTF'
				 else rtype.description 
				 end as req_type
				,isnull(rsource.description,'Unknown') as source
			from
				[bureau].[TRequestResource] as rr with (nolock)
				full outer join bureau.TLocation as l with (nolock)
					on rr.loc_id = l.loc_id
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
			where
				rr.is_deleted = 0				
				and rrstatus.description not like 'Cancel%'
				and rr.create_dttm >= '2016-07-25' --go-live date
		 ) as ba
			on ba.shift_date between dt and edt
		 left join vdimRC as rc
			on ba.rc_code = rc.RC
	where
		 1 = 1
		 and source <> 'Internal' --exclude filled by internal staff members
		 and loc_id is not null --exclude non-standard locations
		 and (Division = @Division or @Division = '-All Divisions-')
	group by
		 [loc_id]
		,[loc_description]
		,[rc_code]
		,[hospital]
		,case [req_type] 
		 when 'UTF' then 'UTF'
		 when 'Acuity' then 'Watch'
		 when 'Special' then 'Watch'
		 else [req_type]
		 end
		,[source]
		,dt
		,edt
		,rc.Service
		,rc.Division
)

select
	 dt
	,edt
	,loc_description
	,rc_code
	,Service
	,Division
	,hospital
	,sum(case when req_type = 'Watch' then shifts end) as watch_shifts
	,sum(case when req_type = 'Watch' then hrs end) as watch_hrs
	,sum(case when source not like 'External%' then shifts end) as ib_shifts
	,sum(case when source not like 'External%' then hrs end) as ib_hrs
	,sum(case when source like 'External%' then shifts end) as ex_shifts
	,sum(case when source like 'External%' then hrs end) as ex_hrs
	,sum(shifts) as total_shifts
	,sum(hrs) as total_hrs
from
	 t
group by
	 dt
	,edt
	,loc_description
	,rc_code
	,Service
	,Division
	,hospital