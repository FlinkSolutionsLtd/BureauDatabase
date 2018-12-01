CREATE TABLE [bureau].[TLookupDomain] (
    [domain_id]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [description] VARCHAR (200) NOT NULL,
    [create_dttm] DATETIME      CONSTRAINT [DF_LookupDomain_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50)  CONSTRAINT [DF_LookupDomain_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]  DATETIME      CONSTRAINT [DF_LookupDomain_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50)  CONSTRAINT [DF_LookupDomain_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]  SMALLINT      CONSTRAINT [DF_LookupDomain_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LookupDomain] PRIMARY KEY CLUSTERED ([domain_id] ASC) WITH (FILLFACTOR = 90)
);

