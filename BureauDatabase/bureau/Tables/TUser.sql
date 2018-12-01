CREATE TABLE [bureau].[TUser] (
    [user_id]        VARCHAR (50) NOT NULL,
    [default_loc_id] INT          NOT NULL,
    [create_dttm]    DATETIME     CONSTRAINT [DF_User_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user]    VARCHAR (50) CONSTRAINT [DF_User_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]     DATETIME     CONSTRAINT [DF_User_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]     VARCHAR (50) CONSTRAINT [DF_User_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]     SMALLINT     CONSTRAINT [DF_User_is_deleted] DEFAULT ((0)) NOT NULL,
    [is_bureau]      SMALLINT     CONSTRAINT [DF_TUser_is_bureau] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([user_id] ASC) WITH (FILLFACTOR = 90)
);

