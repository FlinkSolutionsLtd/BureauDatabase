CREATE procedure [bureau].[sp_get_staffing_summary_eww]	 
as
	 
declare @start datetime
set @start = '2018-02-16'

declare @end datetime 
set @end = dateadd(day,0,datediff(day,0,getdate()))

;with r as (
	select
		 rr.rr_id
		,rr.loc_id
		,rr.shift_date
		,bureau.f_get_shiftcode(rr.start_time) as shift_code
		,isnull(rdesig.code,desig.code) as Designation		
		,rtype.description as req_type	
	from 
		bureau.TRequestResource as rr with (nolock)
		full outer join bureau.TLocation as l with (nolock)
			on rr.loc_id = l.loc_id
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
	where 
		 rr.is_deleted = 0
		 and rrstatus.description = 'Filled' 
		 and rr.shift_date between @start and @end	
	)


select 
	 t.loc_id
	,l.rc_code
	,l.trendcare_code
	,t.shift_date
	,t.shift_code
	,t.RN + count(case when r.Designation = 'RN' and req_type <> 'Watch' then rr_id end) as RN
	,t.EN + count(case when r.Designation = 'EN' and req_type <> 'Watch'  then rr_id end) as EN
	,t.HCA + count(case when r.Designation = 'HCA' and req_type <> 'Watch'  then rr_id end) as HCA
	,t.Coord + count(case when r.Designation = 'Coord' and req_type <> 'Watch'  then rr_id end) as Coord
	,count(case when req_type = 'Watch' then rr_id end) as Watch
	--,t.ds_type
	,t.Coord_Name
from 
	 bureau.TDailyStaffing as t with (nolock)
	 inner join bureau.TLocation as l with (nolock)
		on t.loc_id = l.loc_id
	 left join r
		 on r.loc_id = l.loc_id
		 and r.shift_date = t.shift_date
		 and r.shift_code = t.shift_code

where 
	 t.shift_date between @start and @end	
	 and t.ds_type in('ACTUAL')
	
group by
	 t.loc_id
	,l.rc_code
	,l.trendcare_code
	,t.shift_date
	,t.shift_code
	,t.RN 
	,t.EN
	,t.HCA
	,t.Coord
	,t.ds_type
	,t.Coord_Name