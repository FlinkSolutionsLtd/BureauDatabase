CREATE procedure [bureau].[sp_insert_daily]
	 @locid varchar(10)
	,@user varchar(50)
	,@shiftdate varchar(10)
	,@shiftcode varchar(2)
	,@coord varchar(10)
	,@orientee varchar(10)
	,@rn varchar(10)
	,@en varchar(10)
	,@hca varchar(10)	
	,@cnm varchar(10)
	,@coord_name varchar(250)
	,@comment varchar(max)
as

if @coord = ''
	set @coord = '0'

if @orientee = ''
	set @orientee = '0'

if @rn = ''
	set @rn = '0'

if @en = ''
	set @en = '0'

if @hca = ''
	set @hca = '0'

if @cnm = ''
	set @cnm = '0'

--exec bureau.sp_insert_daily @shift_date='26/04/2016',@shift_code='E',@locid='6', @user='AhnE',@Coord='',@Orientee='',@CNM='',@RN='4',@EN='',@HCA='3',@Coord_Name='',@comment=''

--first check for resubmissions 
declare @ds_id as int
set @ds_id = (select top 1 ds_id from bureau.TDailyStaffing where shift_date = convert(datetime,@shiftdate,103) and shift_code = @shiftcode and loc_id = @locid and ds_type='ACTUAL')

if @ds_id is null
	begin
		insert into bureau.TDailyStaffing
		(
			 loc_id
			,req_user
			,shift_date
			,shift_code
			,Coord
			,Orientee
			,RN
			,EN
			,HCA
			,CNM
			,Coord_Name
			,create_user
			,modif_user
			,comments
		)
		values
		(
			 @locid
			,@user
			,convert(datetime,@shiftdate,103)
			,@shiftcode
			,@coord
			,@orientee
			,@rn
			,@en
			,@hca
			,@cnm
			,@coord_name
			,@user
			,@user
			,@comment
		)
	end
else
	begin
		exec bureau.sp_edit_daily @ds_id, @user, @coord, @orientee, @cnm, @rn, @en, @hca, @coord_name, @comment, 0
	end