CREATE procedure [bureau].[sp_edit_requestresource_bureau]
	 @status varchar(10)
	,@starttime varchar(10) = ''
	,@stafftype varchar(10) = ''
	,@staff varchar(200) = ''
	,@hours varchar(5) = ''
	,@designation varchar(10) = ''
	,@user varchar(50)
	,@rrid varchar(10)
	,@override varchar(20) = ''
	,@comment varchar(max)
	,@colour varchar(50) = null
	,@bgcolour varchar(50) = null
as

update bureau.TRequestResource
set
	 status = @status
	,modif_user = @user
	,modif_dttm = getdate()
	,resp_starttime = nullif(@starttime,'')
	,resp_hrs = nullif(@hours,'')
	,resp_desig_id = nullif(@designation,'')
	,resp_staff_freetext = nullif(@staff,'')
	,resp_type_id = nullif(@stafftype,'')
	,override_rc_code = nullif(@override,'')
	,bur_comments = nullif(@comment,'')
	,override_colour = nullif(@colour,'')
	,override_bg_colour = nullif(@bgcolour,'')
where
	 rr_id = @rrid