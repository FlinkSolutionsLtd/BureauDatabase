





CREATE view [bureau].[vBureau_BudgetActual]
as

select
	 'D' + cast(t.ds_id as varchar(10)) as rec_id
    ,l.loc_id
	,l.loc_description
	,l.rc_code
	,l.rc_code as charge_rc_code
	,l.trendcare_code
	,hosp.description as hospital	
	,shift_date
	,shift_code
	,d.desig
	,max(
		case
		when d.desig = 'CNM' then CNM
		when d.desig = 'RN' then isnull(RN,0) + isnull(Coord,0)
		when d.desig = 'EN' then EN
		when d.desig = 'HCA' then HCA
		end
		) * 8 as vol
	,'actual' as vol_type
	,'Rostered' as req_type
	,null as req_reason
	,null as source
from
	bureau.TDailyStaffing as t  with (nolock)
	inner join bureau.TLocation as l with (nolock)
		on t.loc_id = l.loc_id
	inner join bureau.TLookup as hosp with (nolock) on hosp.lk_id = l.hospital_lk_id
	cross join
		(
			 select 'CNM' as desig 
			 union select 'RN'
			 union select 'EN'
			 union select 'HCA'
		) as d
where
	t.ds_type = 'ACTUAL'

group by
	 l.loc_id
	,shift_date
	,shift_code
	,d.desig
	,l.loc_description
	,t.ds_id
	,hosp.description
	,l.rc_code
	,l.trendcare_code

union all 

select
	 'D' + cast(t.ds_id as varchar(10)) as rec_id
    ,l.loc_id
	,l.loc_description
	,l.rc_code
	,l.rc_code
	,l.trendcare_code
	,hosp.description as hospital
	,shift_date
	,shift_code
	,d.desig
	,SUM(
		case
		when d.desig = 'CNM' then CNM
		when d.desig = 'RN' then isnull(RN,0) + isnull(Coord,0)
		when d.desig = 'EN' then EN
		when d.desig = 'HCA' then HCA
		else 0
		end
		* isnull(t.hrs_per_shift,8)
		) as vol
	,'budget' as vol_type
	,'Budget' as req_type
	,null as req_reason
	,null as source
from
	bureau.TDailyStaffing as t  with (nolock)
	inner join bureau.TLocation as l with (nolock)
		on t.loc_id = l.loc_id
	inner join bureau.TLookup as hosp with (nolock) on hosp.lk_id = l.hospital_lk_id
	cross join
		(
			 select 'CNM' as desig 
			 union select 'RN'
			 union select 'EN'
			 union select 'HCA'
		) as d
where
	t.ds_type in('BUDGET','WATCH')

group by
	 l.loc_id
	,shift_date
	,shift_code
	,d.desig
	,l.loc_description
	,t.ds_id
	,l.rc_code
	,l.trendcare_code
	,hosp.description

union all

select
	 'R' + cast(rr.rr_id as varchar(10)) as rec_id
	,l.loc_id
	,isnull(l.loc_description,rr.loc_freetext) as loc_description
	,isnull(l.rc_code,override_rc_code) as rc_code
	,isnull(rr.override_rc_code,l.rc_code) as charge_rc_code
	,l.trendcare_code
	,hosp.description as hospital
	,rr.shift_date
	,case
	 when rr.start_time >= isnull(l.day_start,'06:00') and rr.start_time < isnull(l.evening_start,'14:00') then 'D'
	 when rr.start_time >= isnull(l.evening_start,'14:00') and rr.start_time < isnull(l.night_start,'21:00') then 'E'
	 else 'N'
	 end as shift_code
	,isnull(rdesig.code,desig.code) as desig
	,isnull(resp_hrs,hrs) as vol
	,'actual' as vol_type
	,rtype.description as req_type
	,isnull(rreason.description,'Unknown') as req_reason
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
	 and rrstatus.description not like 'Unable to fill%'
	 and rrstatus.description not like 'Cancel%'
	 and rr.create_dttm >= '2016-07-25' --go-live date
	 and l.loc_id not between 88 and 91