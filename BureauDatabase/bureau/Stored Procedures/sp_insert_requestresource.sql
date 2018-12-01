

CREATE procedure [bureau].[sp_insert_requestresource]
	 @reqdate varchar(20)
	,@starttime varchar(10)
	,@hours varchar(10)='0'
	,@designation varchar(10)='0'
	,@reqtype varchar(10)='0'
	,@reqreason varchar(10)=''
	,@patient varchar(max)=''
	,@user varchar(50)
	,@lid varchar(10)
	,@comment varchar(max)
	,@hospital varchar(10)=''
	,@locfreetext varchar(200)=''
	,@colour varchar(50) = null
	,@bgcolour varchar(50) = null
as

/*
exec bureau.sp_insert_requestresource @reqdate='18/3/2016' ,@starttime='12:00' ,@hours='61' ,@designation='2' ,@reqtype='' ,@reqreason='9' ,@patient='000791251, 000791269' ,@user='AhnE',@lid=1
*/

--create the request resource
declare @rrid as int
insert into bureau.TRequestResource
(
	 req_id
	,status
	,shift_date
	,start_time
	,desig_id
	,reqtype_id
	,hrs
	,reason_prim_id
	,create_user
	,modif_user
	,loc_id
	,comments
	,loc_freetext
	,misc_hosp_lk_id
	,override_colour
	,override_bg_colour
	,bur_comments
)
select
	 0 /* reqid no longer used */
	,0
	,convert(datetime,@reqdate,103)
	,@starttime
	,@designation
	,@reqtype
	,cast(@hours as float)
	,@reqreason
	,@user
	,@user
	,@lid
	,case when @reqtype = '0' then null else @comment end --when reqtype is 0, it's a resource note, therefore it gets no comments from end-users
	,@locfreetext
	,case when @hospital <> '' then @hospital end
	,@colour
	,@bgcolour
	,case when @reqtype = '0' then @comment else null end --when reqtype is 0, it's a resource note, therefore it gets bur comments instead of regular comments

set @rrid = scope_identity()

--lastly, if patients were submitted, insert patients

if @patient > ''
	begin
		 insert into bureau.TRequestResourcePatient
		 (
			 rr_id
			,encounter
			,create_user
			,modif_user
		 )	
		 select 
			 @rrid
			,ltrim(rtrim(value))
			,@user
			,@user
		 from 
			 bureau.f_multivalueparam(@patient,',')
	end