CREATE procedure [bureau].[sp_get_bureauview]
	 @locid varchar(max)
	,@status varchar(max)
	,@shift varchar(100)
	,@start datetime
	,@end datetime
	,@proc_rrid int
	,@UserID varchar(50)
	,@hosp varchar(100)
	with recompile
as

/*

-- example call
exec [bureau].[sp_get_bureauview]
	 @locid = -1
	,@status = 16
	,@shift = 'N'
	,@start = '2019-01-01'
	,@end = '2019-01-09'
	,@proc_rrid = 0
	,@UserID =''
	,@hosp = 0

*/

if @proc_rrid > 0
	begin
		exec [bureau].[sp_edit_requeststatus] 'PROC',@UserID,@proc_rrid
	end

;with t as
(
	select
		 rr.rr_id
		,rr.create_user
		,rr.create_dttm as req_dttm
		,case
		 when rrstatus.description is null and rr.rr_id is not null then 'New'
		 else rrstatus.description
		 end as status_desc
		,case
		 when rr.status = 0 then '#f5ffe6'
		 --when rrstatus.description like '%cancel%' then 'FireBrick'
		 else 'White'
		 end as status_color
		,case
		 when rr.status = 0 then 'Black'
		 --when rrstatus.description like '%cancel%' then 'FireBrick'
		 else 'Black'
		 end as status_font_color
		,case
		 when rr.status = 0 then 'Bold'
		 --when rrstatus.description like '%cancel%' then 'FireBrick'
		 else 'Thin'
		 end as status_font_weight
		,case
		 when rrstatus.description = 'Processing' or rr.status = 0 then 'Yellow'
		 when rrstatus.description like '%cancel%' or rrstatus.description in ('Own Staff','Redeployed') then 'MediumPurple'
		 when rrstatus.description like 'Unable to Fill%' then 'Blue'
		 when rtype.description is not null then 'Green' --all other options are "filled"
		 else 'White'
		 end as status_box_color
		,isnull(lk.description + ' - ','') + isnull(l.loc_description,rr.loc_freetext) as loc_description
		,l.trendcare_code
		,rr.shift_date
		,rr.start_time
		,rr.shift_date + rr.start_time as request_date_time
		,rr.hrs
		,desig.code as designation
		,type.description as requesttype
		,reason.description as reason
		,l.loc_id as lid
		,'edit' as button
		,'?typecode=' + case when rr.status = 0 then '1' else '2' end + '&reqid=' + cast(rr.rr_id as varchar(10)) + '&lid=' + cast(rr.loc_id as varchar(10)) as querystring

		,rr.status
		,rrstatus.description as rrStatus
		,rr.resp_desig_id
		,rdesig.code as resp_designation
		,rr.resp_type_id
		,rtype.description as resp_type
		,rr.resp_staff_freetext
		,rr.resp_hrs
		,rr.resp_starttime

		,rr.modif_user
		,rr.modif_dttm

		,bureau.f_get_shiftcode(rr.start_time) as shift_code
		/*
		case
		 when rr.start_time >= isnull(l.day_start,'06:00') and rr.start_time < isnull(l.evening_start,'14:00') then 'D'
		 when rr.start_time >= isnull(l.evening_start,'14:00') and rr.start_time < isnull(l.night_start,'21:00') then 'E'
		 else 'N'
		 end as shift_code
		*/
		,comments
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
		 left join bureau.TLookup as rdesig with (nolock)
			on rdesig.lk_id = rr.resp_desig_id
		 left join bureau.TLookup as rtype with (nolock)
			on rtype.lk_id = rr.resp_type_id
		 left join bureau.TLookup as rrstatus with (nolock)
			on rr.status = rrstatus.lk_id
		 ) 
			on rr.loc_id = l.loc_id
			and rr.is_deleted = 0	 
	where
		 1 = 1	 
		 and (rr.loc_id = @locid or @locid = -1)
		 and (
			(l.hospital_lk_id = @hosp or @hosp = 0)
			or (rr.misc_hosp_lk_id = @hosp and @locid = 0) --misc requests		 
			)
		 and rr.status in(select value from bureau.f_multivalueparam(@status,';'))
		 and (rr.shift_date between @start and @end)
		 and rr.is_deleted = 0
	)

select
	 t.*
	,Coord
	,Orientee
	,RN
	,EN
	,HCA
	,CNM	
from
	 t
	 left join bureau.TDailyStaffing as ds with (nolock)
		on ds.shift_date = t.shift_date
		and ds.shift_code = t.shift_code 
		and ds.loc_id = t.lid
		and ds.is_deleted = 0	
where
	 1 = 1
	 and t.shift_code in(select value from bureau.f_multivalueparam(@shift,';'))