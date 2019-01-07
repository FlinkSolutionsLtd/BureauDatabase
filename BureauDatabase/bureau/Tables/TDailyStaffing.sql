CREATE TABLE [bureau].[TDailyStaffing] (
    [ds_id]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [loc_id]        INT            NOT NULL,
    [ds_type]       VARCHAR (10)   CONSTRAINT [DF_TDailyStaffing_ds_type] DEFAULT ('ACTUAL') NOT NULL,
    [req_user]      VARCHAR (50)   NOT NULL,
    [shift_date]    DATETIME       NULL,
    [shift_code]    VARCHAR (2)    NOT NULL,
    [hrs_per_shift] DECIMAL (6, 1) NULL,
    [Coord]         DECIMAL (6, 1) NULL,
    [Orientee]      DECIMAL (6, 1) NULL,
    [RN]            DECIMAL (6, 1) NULL,
    [EN]            DECIMAL (6, 1) NULL,
    [HCA]           DECIMAL (6, 1) NULL,
    [CNM]           DECIMAL (6, 1) NULL,
    [Coord_Name]    VARCHAR (255)  NULL,
    [comments]      VARCHAR (1000) NULL,
    [create_dttm]   DATETIME       CONSTRAINT [DF_Daily_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user]   VARCHAR (50)   CONSTRAINT [DF_Daily_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]    DATETIME       CONSTRAINT [DF_Daily_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]    VARCHAR (50)   CONSTRAINT [DF_Daily_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]    SMALLINT       CONSTRAINT [DF_Daily_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bureau.DailyStaffing] PRIMARY KEY CLUSTERED ([ds_id] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_loc_shiftcode_inc_all]
    ON [bureau].[TDailyStaffing]([loc_id] ASC, [shift_code] ASC)
    INCLUDE([Coord_Name], [HCA], [Coord], [RN], [EN], [ds_type], [shift_date]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_bureauview]
    ON [bureau].[TDailyStaffing]([is_deleted] ASC, [shift_date] ASC)
    INCLUDE([loc_id], [Orientee], [RN], [shift_code], [Coord], [EN], [HCA], [CNM]) WITH (FILLFACTOR = 90);

