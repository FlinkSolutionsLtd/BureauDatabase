CREATE TABLE [bureau].[TShiftConfirmation] (
    [conf_id]     INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [hospital_id] INT          NULL,
    [shift_date]  DATETIME     NOT NULL,
    [shift_code]  VARCHAR (10) NOT NULL,
    [conf_status] VARCHAR (50) NOT NULL,
    [create_dttm] DATETIME     CONSTRAINT [DF_TShiftConfirmation_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50) NOT NULL,
    [modif_dttm]  DATETIME     CONSTRAINT [DF_TShiftConfirmation_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TShiftConfirmation] PRIMARY KEY CLUSTERED ([conf_id] ASC) WITH (FILLFACTOR = 90)
);

