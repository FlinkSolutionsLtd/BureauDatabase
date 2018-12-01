CREATE TABLE [bureau].[TSecurity] (
    [sec_id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [sec_description] VARCHAR (100) NOT NULL,
    [create_dttm]     DATETIME      CONSTRAINT [DF_Security_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user]     VARCHAR (50)  CONSTRAINT [DF_Security_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]      DATETIME      CONSTRAINT [DF_Security_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]      VARCHAR (50)  CONSTRAINT [DF_Security_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]      SMALLINT      CONSTRAINT [DF_Security_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Security] PRIMARY KEY CLUSTERED ([sec_id] ASC) WITH (FILLFACTOR = 90)
);

