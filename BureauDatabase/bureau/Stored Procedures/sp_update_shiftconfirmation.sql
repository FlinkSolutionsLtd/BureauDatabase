CREATE procedure [bureau].[sp_update_shiftconfirmation]
	 @user varchar(50)
	,@status varchar(50)
	,@shiftdate datetime
	,@shiftcode varchar(10)
	,@hospital int
as

if exists(select '' 
			from bureau.TShiftConfirmation ts with (nolock)
			where ts.shift_date = @shiftdate
			and ts.shift_code = @shiftcode
			and ts.hospital_id = @hospital)
	begin
		update bureau.TShiftConfirmation
		set conf_status = @status
			,modif_dttm = getdate()
			,modif_user = @user
		where shift_date = @shiftdate
		and shift_code = @shiftcode
		and hospital_id = @hospital
	end
else
	begin
		insert into bureau.TShiftConfirmation
			(
				 shift_date
				,shift_code			
				,conf_status
				,create_user
				,modif_user
				,hospital_id
			)
		values
			(
				 @shiftdate
				,@shiftcode
				,@status
				,@user
				,@user
				,@hospital
			)
	end