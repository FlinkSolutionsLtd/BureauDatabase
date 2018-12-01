
create procedure [bureau].[sp_get_user_location_write]
	 @userid varchar(50)
as

--shows all locations user can write to

select
	 ul.loc_id
	,l.loc_description
	,u.default_loc_id
from
	 bureau.TUser as u with (nolock)
	 inner join bureau.TUserLocation as ul with (nolock)
		on u.user_id = ul.user_id
	 inner join bureau.TLocation as l with (nolock)
		on l.loc_id = ul.loc_id
	 inner join bureau.TSecurity as s with (nolock)
		on s.sec_id = ul.sec_id
where
	 u.is_deleted = 0
	 and ul.is_deleted = 0
	 and ul.user_id = @userid
	 and s.sec_description <> 'Request - Read'