CREATE TABLE [bureau].[TUserLocation] (
    [user_id]     VARCHAR (50) NOT NULL,
    [loc_id]      INT          NOT NULL,
    [sec_id]      INT          NOT NULL,
    [create_dttm] DATETIME     CONSTRAINT [DF_UserLocation_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50) CONSTRAINT [DF_UserLocation_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]  DATETIME     CONSTRAINT [DF_UserLocation_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50) CONSTRAINT [DF_UserLocation_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]  SMALLINT     CONSTRAINT [DF_UserLocation_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_UserLocation] PRIMARY KEY CLUSTERED ([user_id] ASC, [loc_id] ASC) WITH (FILLFACTOR = 90)
);

