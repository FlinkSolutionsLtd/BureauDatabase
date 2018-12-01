CREATE procedure [bureau].[sp_get_lookup]
	 @domain varchar(200)
as

select
	 l.lk_id
	,l.code
	,l.value
	,l.description

from
	 bureau.TLookup as l with (nolock)
	 inner join bureau.TLookupDomain as ld with (nolock)
		on l.domain_id = ld.domain_id

where
	 l.is_deleted = 0
	 and ld.description = @domain

order by
	 l.sort_order
	,l.description