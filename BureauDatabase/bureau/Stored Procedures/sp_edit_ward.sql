
create procedure [bureau].[sp_edit_ward]
	 @lid varchar(10)
	,@user varchar(50)
	,@coord_e varchar(10)
	,@orientee_e varchar(10)
	,@rn_e varchar(10)
	,@en_e varchar(10)
	,@hca_e varchar(10)
	,@coord_n varchar(10)
	,@orientee_n varchar(10)
	,@rn_n varchar(10)
	,@en_n varchar(10)
	,@hca_n varchar(10)
	,@coord_d varchar(10)
	,@orientee_d varchar(10)
	,@rn_d varchar(10)
	,@en_d varchar(10)
	,@hca_d varchar(10)
	,@cnm_d varchar(10)
as

update bureau.TLocation
set
	 E_Coord = @coord_e
	,E_Orientee = @orientee_e
	,E_RN = @rn_e
	,E_EN = @en_e
	,E_HCA = @hca_e
	,N_Coord = @coord_n
	,N_Orientee = @orientee_n
	,N_RN = @rn_n
	,N_EN = @en_n
	,N_HCA = @hca_n
	,D_Coord = @coord_d
	,D_Orientee = @orientee_d
	,D_RN = @rn_d
	,D_EN = @en_d
	,D_HCA = @hca_d
	,D_CNM = @cnm_d
	,modif_user =  @user
where
	 loc_id = @lid