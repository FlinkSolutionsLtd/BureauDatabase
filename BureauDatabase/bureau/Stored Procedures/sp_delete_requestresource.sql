
create procedure bureau.sp_delete_requestresource
	 @rrid as int
as

update bureau.TRequestResource
set is_deleted = 1
where rr_id = @rrid