

create procedure [bureau].[sp_get_user_security]
	 @userid varchar(50)
as

select
	 isnull((
		select top 1
			 case
			 when u.is_bureau = 1 then 'Bureau user'
			 else 'Standard user'
			 end as secur
		from
			 bureau.TUser as u with (nolock)
		where
			 u.is_deleted = 0
			 and u.user_id = @userid
			),'Standard user') as secur