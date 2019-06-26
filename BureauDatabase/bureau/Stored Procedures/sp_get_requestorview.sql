CREATE procedure [bureau].[sp_get_requestorview]
	 @locid varchar(max)
	 with recompile
as

select
	 rr.rr_id
	,rr.create_user as req_user
	,rr.create_dttm as req_dttm
	,case
	 when status.description is null and rr.rr_id is not null then 'New'
	 else status.description
	 end as status_desc
	,case
	 when status.description = 'Filled' then 'ForestGreen'
	 when status.description like '%cancel%' then 'FireBrick'
	 when status.description like 'Unable to Fill%' then 'FireBrick'
	 end as status_colour
	,case
	 when status.description is null then 'Default'
	 else 'Bold'
	 end as status_weight
	,isnull(l.loc_description,rr.loc_freetext) as loc_description
	,l.trendcare_code
	,rr.shift_date
	,isnull(rr.resp_starttime,rr.start_time) as start_time
	,case
	 when rr.resp_starttime is not null and rr.resp_starttime <> rr.start_time then 'Italic'
	 else 'Default'
	 end as start_decoration
	,isnull(resp_hrs,rr.hrs) as hrs
	,case
	 when resp_hrs is not null and resp_hrs <> hrs then 'Italic'
	 else 'Default'
	 end as hrs_decoration
	,isnull(rdesig.code,desig.code) as designation
	,case
	 when rdesig.code <> desig.code and rdesig.code is not null then 'Italic'
	 else 'Default'
	 end as desig_decoration
	,type.description as requesttype
	,reason.description as reason
	,count(rrp.rr_id) as patients

	,rtype.description as rsource
	,rr.resp_staff_freetext

	,isnull(l.loc_id,0) as lid
	
	,rr.comments
	,rr.bur_comments

	,case
	 when rr.status between 16 and 18 then 0
	 else 1
	 end as isCancellable
from
	 bureau.TLocation as l with (nolock)
	 full outer join 
	 (
	 bureau.TRequestResource as rr with (nolock)
	 left join bureau.TLookup as desig with (nolock)
		on desig.lk_id = rr.desig_id
	 left join bureau.TLookup as type with (nolock)
		on type.lk_id = rr.reqtype_id
	 left join bureau.TLookup as reason with (nolock)
		on reason.lk_id = rr.reason_prim_id
	 left join bureau.TRequestResourcePatient as rrp with (nolock)
		on rrp.rr_id = rr.rr_id
		and rrp.is_deleted = 0
	 left join bureau.TLookup as status with (nolock)
		on rr.status = status.lk_id
	 left join bureau.TLookup as rdesig with (nolock)
		on rdesig.lk_id = rr.resp_desig_id
	 left join bureau.TLookup as rtype with (nolock)
		on rtype.lk_id = rr.resp_type_id
	 ) 
		on rr.loc_id = l.loc_id			
where
	 1 = 1	 	 
	 and rr.is_deleted = 0
	 and (rr.shift_date >= dateadd(day,0,datediff(day,0,getdate()))) /*  today onwards */
	 and (l.loc_id in(select value from bureau.f_multivalueparam(@locid,';')) or (rr.loc_id = 0 and @locid=0))

group by
	 rr.rr_id
	,rr.create_user
	,rr.create_dttm
	,status.description
	,isnull(l.loc_description,rr.loc_freetext)
	,l.trendcare_code
	,rr.shift_date
	,isnull(resp_starttime,rr.start_time)
	,isnull(resp_hrs,rr.hrs)
	,isnull(rdesig.code,desig.code)
	,type.description
	,reason.description
	,l.loc_id	
	,rr.comments
	,case
	 when rr.resp_starttime is not null and rr.resp_starttime <> rr.start_time then 'Italic'
	 else 'Default'
	 end
	,case
	 when resp_hrs is not null and resp_hrs <> hrs then 'Italic'
	 else 'Default'
	 end
	,case
	 when rdesig.code <> desig.code and rdesig.code is not null then 'Italic'
	 else 'Default'
	 end
	,rr.bur_comments
	,rtype.description
	,rr.resp_staff_freetext
	,rr.status