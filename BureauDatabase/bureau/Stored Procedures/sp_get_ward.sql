create procedure [bureau].[sp_get_ward]
	 @lid varchar(5)
as

select
	 l.*
	,hosp.description as Hospital
from
	 bureau.TLocation as l with (nolock)
	 left join bureau.TLookup as hosp with (nolock)
		on hosp.lk_id = l.hospital_lk_id
where
	 l.loc_id = @lid