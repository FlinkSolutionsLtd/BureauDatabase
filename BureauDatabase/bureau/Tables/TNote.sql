CREATE TABLE [bureau].[TNote] (
    [note_id]     INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [req_id]      INT            NULL,
    [note]        VARCHAR (1000) NULL,
    [note_dttm]   DATETIME       NOT NULL,
    [create_dttm] DATETIME       CONSTRAINT [DF_Note_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50)   CONSTRAINT [DF_Note_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]  DATETIME       CONSTRAINT [DF_Note_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50)   CONSTRAINT [DF_Note_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]  SMALLINT       CONSTRAINT [DF_Note_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED ([note_id] ASC) WITH (FILLFACTOR = 90)
);



