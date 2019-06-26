
CREATE procedure [bureau].[sp_edit_requestresource_cancel]
	 @user varchar(50)
	,@rrid varchar(10)
as

update bureau.TRequestResource
set
	 status = 18 --cancelled status
	,modif_user = @user
	,modif_dttm = getdate()	
where
	 rr_id = @rrid