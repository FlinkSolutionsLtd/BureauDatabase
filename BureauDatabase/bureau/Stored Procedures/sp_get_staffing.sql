CREATE procedure [bureau].[sp_get_staffing]
	 @start datetime = '2016-08-12'
	,@hospital int = 28
as

--declare @start as datetime
--	,@hospital varchar(50)
--	,@shift varchar(50)


--select @start = '2016-07-22'
--		,@hospital = 28

--select the top 1 available budget. priority goes to the shift date that is closest to the requested date
;with budget_filler as
(
	select
		 loc_id
		,shift_date
		,shift_code
		,RN
		,Coord
		,EN
		,HCA
		,row_number() over (partition by loc_id, shift_code order by abs(datediff(day,@start,bud.shift_date))) as rown
		,ds_type
		,null as Coord_name
	from 
		 bureau.TDailyStaffing as bud with (nolock) 
	where 
		 ds_type = 'BUDGET'
		 and not exists (select '' from bureau.TDailyStaffing as bud2 with (nolock) where bud.loc_id = bud2.loc_id and bud.shift_code = bud2.shift_code and bud2.shift_date = @start and ds_type = 'BUDGET')
)

select
	 loc.loc_id
	,isnull(loc.loc_description,reqs.loc_freetext) as loc_description
	,loc.config_rpt_colour
	,loc.config_rpt_group
	,loc.config_rpt_group_order
	,loc.config_rpt_font_colour
	,loc.shift_code
	,loc.conf_status
	,loc.conf_colour
	,loc.conf_background_colour
	,daily.Coord_Name
	,daily.RN
	,daily.EN
	,daily.HCA
	,daily.RN_Bud
	,daily.EN_Bud
	,daily.HCA_Bud

	,case
	 when loc.shift_code = 'D' then 'AM'
	 when loc.shift_code = 'E' then 'PM'
	 when loc.shift_code = 'N' then 'NGT'
	 end as shift_short_name
	,case
	 when loc.shift_code = 'D' then 'Mornings'
	 when loc.shift_code = 'E' then 'Afternoons'
	 when loc.shift_code = 'N' then 'Nights'
	 end as shift_name

	,rr_id
	,isnull(REQ,'') as REQ
	,HRS
	,OK
	,NAME	

	,case
	 when override_colour is not null then override_colour
	 when OK = 'OS' or OK = 'CX' then 'MediumPurple'
	 when OK = 'Y' then 'Red'
	 when OK = 'E' then 'ForestGreen'
	 when OK = '?' then 'Black'
	 when OK = 'N' then 'Blue'
	 end as OK_font_colour
	,case	 
	 when override_bg_colour is not null then override_bg_colour
	 when OK = '?' then 'Yellow'
	 else 'White'
	 end as OK_background_colour
from	
	(
		select
			 loc_union.*
			,sc.shift_code
			,isnull(ts.conf_status,'PROVISIONAL') as conf_status
			,case
			 when ts.conf_status = 'CONFIRMED' then 'MediumSeaGreen'
			 else 'IndianRed'
			 end as conf_colour
			,case
			 when ts.conf_status = 'CONFIRMED' then 'Honeydew'
			 else 'MistyRose'
			 end as conf_background_colour
		from
		(		
			select 
				 loc.loc_id
				,loc.loc_description			
				,loc.config_rpt_colour
				,loc.config_rpt_group
				,loc.config_rpt_group_order
				,loc.config_rpt_font_colour
			from
				 bureau.TLocation as loc with (nolock)
				 inner join bureau.TLookup as hosp with (nolock)
					on hosp.lk_id = loc.hospital_lk_id			
			where	
				 loc.hospital_lk_id = @hospital		
			/* misc locations  */
			union all
			select
				 0 as loc_id
				,null as loc_description			
				,'LightGrey' as config_rpt_colour
				,'Misc' as config_rpt_group
				,99 as config_rpt_group_order
				,'Black'
		) as loc_union
		cross join (select 'D' as shift_code union select 'E' union select 'N') as sc
		left join bureau.TShiftConfirmation ts with (nolock)
			on ts.shift_date = @start
			and ts.shift_code = sc.shift_code
			and ts.hospital_id = @hospital
	) as loc

	left join 
	(
		select
			 loc_id
			,shift_date
			,shift_code
			,sum(case when ds_type = 'ACTUAL' then isnull(RN,0) + isnull(Coord,0) end) as RN
			,sum(case when ds_type = 'ACTUAL' then EN end) as EN
			,sum(case when ds_type = 'ACTUAL' then HCA end) as HCA
			,sum(case when ds_type = 'BUDGET' then isnull(RN,0) + isnull(Coord,0) end) as RN_Bud
			,sum(case when ds_type = 'BUDGET' then EN end) as EN_Bud
			,sum(case when ds_type = 'BUDGET' then HCA end) as HCA_Bud
			,max(Coord_Name) as Coord_Name
		from
			(
			select loc_id, shift_date, shift_code, RN, Coord, EN, HCA, 1 as rown, ds_type, Coord_Name
			from bureau.TDailyStaffing as t  with (nolock)
			where t.shift_date = @start and t.ds_type in('ACTUAL','BUDGET')
			union all select * from budget_filler where rown = 1
			) as t
		group by
			 loc_id
			,shift_date
			,shift_code
	) as daily 
		 on loc.loc_id = daily.loc_id
		 and loc.shift_code = daily.shift_code
	left join 
	(
		 select
			 rr.rr_id
			,rr.loc_id
			,rr.loc_freetext
			,rr.shift_date
			,isnull(rdesig.code,desig.code) as Designation
			,bureau.f_get_shiftcode(rr.start_time) as shift_code
			/*
			case
			 when rr.start_time >= isnull(l.day_start,'06:00') and rr.start_time < isnull(l.evening_start,'14:00') then 'D'
			 when rr.start_time >= isnull(l.evening_start,'14:00') and rr.start_time < isnull(l.night_start,'21:00') then 'E'
			 else 'N'
			 end as shift_code
			 */
			,case
			 when rtype.description = 'Watch' then 'W'
			 when rtype.description = 'Special' then 'S'
			 when isnull(rdesig.code,desig.code) in('RN','EN','HCA','MW') then isnull(rdesig.code,desig.code) 
			 end as REQ
			,case
			 when rrstatus.description = 'Filled' then 
				case
				when rsource.description = 'Internal' then 'OS'
				when rsource.description = 'Bureau - Internal' then 'Y'
				when rsource.description like 'External%' then 'E'
				end
			 when rrstatus.description like 'Unable to Fill%' then 'N'
			 when rrstatus.description like 'Cancel%' then 'CX'
			 else '?'
			 end as OK
			,isnull(resp_hrs,hrs) as HRS
			,case
			 when rrstatus.description = 'Filled' then isnull(resp_staff_freetext + '<br>','') + isnull(rr.bur_comments,'')
			 else isnull(rr.bur_comments,case when rrstatus.description like 'Unable to Fill%' then 'UNABLE TO FILL' end)
			 end as NAME
			,override_colour
			,override_bg_colour
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
			 and (isnull(rr.misc_hosp_lk_id,0) = 0 or rr.misc_hosp_lk_id = @hospital)
	) as reqs
		on reqs.shift_date = @start
		and reqs.loc_id = loc.loc_id
		and reqs.Shift_code = loc.Shift_code
where
	 1=1

order by 1, 2