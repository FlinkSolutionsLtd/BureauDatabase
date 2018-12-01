CREATE procedure [bureau].[sp_insert_request]
	 @user varchar(50)
	,@lid varchar(10)
as

set nocount on;

--first create the request record
declare @reqid int
insert into bureau.TRequest
(
	 loc_id
	,req_user
	,status
	,loc_rc_code
	,create_user
	,modif_user
)
select
	 cast(@lid as int)
	,@user
	,1
	,(select rc_code from bureau.TLocation as tl with (nolock) where tl.loc_id = cast(@lid as int))
	,@user
	,@user
set @reqid = scope_identity()

select @reqid