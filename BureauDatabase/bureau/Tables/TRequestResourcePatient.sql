CREATE TABLE [bureau].[TRequestResourcePatient] (
    [rr_id]       INT          NOT NULL,
    [encounter]   VARCHAR (20) NOT NULL,
    [create_dttm] DATETIME     CONSTRAINT [DF_RequestResourcePatient_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50) CONSTRAINT [DF_RequestResourcePatient_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]  DATETIME     CONSTRAINT [DF_RequestResourcePatient_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50) CONSTRAINT [DF_RequestResourcePatient_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]  SMALLINT     CONSTRAINT [DF_RequestResourcePatient_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RequestResourcePatient] PRIMARY KEY CLUSTERED ([rr_id] ASC, [encounter] ASC) WITH (FILLFACTOR = 90)
);

