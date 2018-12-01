
CREATE procedure [bureau].[sp_edit_requeststatus]
	 @status_lk_code varchar(10)	
	,@user varchar(50)
	,@reqid varchar(10)
as

declare @status as int

set @status = (select top 1 lk_id
			   from bureau.TLookup as l with (nolock) 
			   inner join bureau.TLookupDomain as d with (nolock) 
			   on l.domain_id = d.domain_id 
			   where 1 = 1
			   and d.description = 'System Status' 
			   and l.code = @status_lk_code)

if @status is not null
	update bureau.TRequestResource
	set  status = @status
		,modif_user = @user
		,modif_dttm = getdate()
	where
		 rr_id = @reqid