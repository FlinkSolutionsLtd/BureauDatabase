CREATE procedure [bureau].[sp_get_request]
	 @reqid as int
as

select
	 rr.req_id
	,rr.create_user as req_user
	,case
	 when rr.status = 0 then null
	 else rr.modif_user 
	 end as bureau_user
	,rr.create_dttm as req_dttm
	,rr.status as req_status
	,case
	 when rr.status = 0 then 'New'
	 else status.description
	 end as status_desc
	,case 
	 when lk.description = 'North Shore' or rr.misc_hosp_lk_id = 28 then '[NSH] ' 
	 when lk.description = 'Waitakere' or rr.misc_hosp_lk_id = 29 then '[WTK] '
	 when lk.description = 'Mental Health' then '[MH] '
	 end + isnull(l.loc_description,rr.loc_freetext) as loc_description
	,l.rc_code
	,l.trendcare_code
	,rr.rr_id
	,rr.shift_date
	,rr.start_time
	,rr.hrs
	,rr.desig_id
	,rr.reqtype_id
	,rr.reason_prim_id
	,desig.code as designation
	,type.description as requesttype
	,reason.description as reason
	,pats.Patients

	,l.loc_id as lid
	,rr.override_rc_code
		
	,rr.resp_hrs
	,rr.resp_starttime
	,rr.resp_desig_id
	,rr.resp_type_id
	,rr.resp_staff_id
	,rr.resp_staff_freetext
	,rr.status
	,rr.comments
	,rr.bur_comments
from
	 bureau.TLocation as l with (nolock)
	 inner join bureau.TLookup as lk with (nolock)
		on l.hospital_lk_id = lk.lk_id
	 full outer join 
	 (		
	 bureau.TRequestResource as rr with (nolock)
	 left join bureau.TLookup as desig with (nolock)
		on desig.lk_id = rr.desig_id
	 left join bureau.TLookup as type with (nolock)
		on type.lk_id = rr.reqtype_id
	 left join bureau.TLookup as reason with (nolock)
		on reason.lk_id = rr.reason_prim_id
	 left join bureau.TLookup as status with (nolock)
		on rr.status = status.lk_id
	 ) 
		 on rr.loc_id = l.loc_id
		 and rr.is_deleted = 0
	 left join
	 (
		select distinct
			 rr_id
			,substring(	
				(
				select ',' + ltrim(rtrim(encounter)) AS [text()]
				from bureau.TRequestResourcePatient as rrp2 with (nolock)
				where rrp2.is_deleted = 0
				and rrp2.rr_id = rrp.rr_id
				for XML PATH ('')
				)
				,2,1000) Patients
		from
			 bureau.TRequestResourcePatient as rrp with (nolock)
	 ) as pats
	 on pats.rr_id = rr.rr_id
where
	 1 = 1	 
	 and rr.rr_id = @reqid