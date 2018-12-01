
create procedure [bureau].[sp_get_user_rc_security]
	 @userid varchar(50)
	,@locid int
as

select
	 s.sec_id
	,s.sec_description
from
	 bureau.TUser as u with (nolock)
	 inner join bureau.TUserLocation as ul with (nolock)
		on u.user_id = ul.user_id
	 inner join bureau.TSecurity as s with (nolock)
		on s.sec_id = ul.sec_id
where
	 u.is_deleted = 0
	 and ul.is_deleted = 0
	 and ul.user_id = @userid
	 and ul.loc_id = @locid