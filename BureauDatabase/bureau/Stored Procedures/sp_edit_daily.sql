CREATE procedure [bureau].[sp_edit_daily]
	 @ds_id varchar(10)	
	,@user varchar(50)
	,@Coord varchar(10)
	,@Orientee varchar(10)
	,@CNM varchar(10)
	,@RN varchar(10)
	,@EN varchar(10)
	,@HCA varchar(10)
	,@Coord_Name varchar(10)
	,@comment varchar(max)
	,@is_deleted smallint = 0
as

--exec sp_edit_daily @ds_id='1', @shift_date='26/04/2016',@shift_code='E',@locid='1',@user='AhnE',@Coord='0',@Orientee='1',@CNM='',@RN='2',@EN='3',@HCA='4',@Coord_Name='a',@comment='s'
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

update bureau.TDailyStaffing
set  modif_user = @user
	,Coord = @Coord
	,Orientee = @Orientee
	,CNM = @CNM
	,RN = @RN
	,EN = @EN
	,HCA = @HCA
	,Coord_Name = @Coord_Name
	,comments = @comment
	,is_deleted = @is_deleted
	,modif_dttm = getdate()
where
	 ds_id = @ds_id