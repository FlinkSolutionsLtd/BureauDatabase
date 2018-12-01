
create procedure bureau.sp_get_resourcenote
	 @reqid varchar(10)
as

--set @reqid = '11851'

select
	 shift_date as reqdate
	,bureau.f_get_shiftcode(start_time) as starttime
	,override_colour as Colour
	,override_bg_colour as BGColour
	,bur_comments as Comments
from
	 WDHB_Research.bureau.TRequestResource with (nolock)
where
	 rr_id = @reqid