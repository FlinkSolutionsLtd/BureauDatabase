CREATE TABLE [bureau].[TLookup] (
    [lk_id]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [domain_id]   INT           NOT NULL,
    [code]        VARCHAR (50)  NOT NULL,
    [value]       FLOAT (53)    NULL,
    [description] VARCHAR (200) NOT NULL,
    [sort_order]  INT           NULL,
    [create_dttm] DATETIME      CONSTRAINT [DF_Lookup_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50)  CONSTRAINT [DF_Lookup_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]  DATETIME      CONSTRAINT [DF_Lookup_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50)  CONSTRAINT [DF_Lookup_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]  SMALLINT      CONSTRAINT [DF_Lookup_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED ([lk_id] ASC) WITH (FILLFACTOR = 90)
);

