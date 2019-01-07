CREATE TABLE [bureau].[TRequestResource] (
    [rr_id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [req_id]              INT            NOT NULL,
    [loc_id]              INT            NOT NULL,
    [loc_freetext]        VARCHAR (200)  NULL,
    [misc_hosp_lk_id]     INT            NULL,
    [status]              INT            NOT NULL,
    [shift_date]          DATETIME       NOT NULL,
    [start_time]          VARCHAR (5)    NOT NULL,
    [desig_id]            INT            NOT NULL,
    [reqtype_id]          INT            NOT NULL,
    [hrs]                 FLOAT (53)     NOT NULL,
    [reason_prim_id]      INT            NOT NULL,
    [reason_sec_id]       INT            NULL,
    [resp_desig_id]       INT            NULL,
    [resp_type_id]        INT            NULL,
    [resp_staff_id]       INT            NULL,
    [resp_staff_freetext] VARCHAR (200)  NULL,
    [resp_hrs]            FLOAT (53)     NULL,
    [resp_starttime]      VARCHAR (5)    NULL,
    [comments]            VARCHAR (1000) NULL,
    [bur_comments]        VARCHAR (1000) NULL,
    [override_rc_code]    VARCHAR (10)   NULL,
    [override_colour]     VARCHAR (50)   NULL,
    [override_bg_colour]  VARCHAR (50)   NULL,
    [create_dttm]         DATETIME       CONSTRAINT [DF_RequestResource_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user]         VARCHAR (50)   CONSTRAINT [DF_RequestResource_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]          DATETIME       CONSTRAINT [DF_RequestResource_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]          VARCHAR (50)   CONSTRAINT [DF_RequestResource_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]          SMALLINT       CONSTRAINT [DF_RequestResource_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RequestResource] PRIMARY KEY CLUSTERED ([rr_id] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_Rpt_View]
    ON [bureau].[TRequestResource]([is_deleted] ASC, [create_dttm] ASC)
    INCLUDE([start_time], [resp_hrs], [override_rc_code], [resp_desig_id], [resp_type_id], [hrs], [reason_prim_id], [desig_id], [reqtype_id], [loc_freetext], [misc_hosp_lk_id], [status], [shift_date], [rr_id], [loc_id]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_isdel_shiftdate_incall]
    ON [bureau].[TRequestResource]([is_deleted] ASC, [shift_date] ASC)
    INCLUDE([rr_id], [status], [loc_id], [start_time], [desig_id], [reqtype_id], [hrs], [reason_prim_id], [resp_desig_id], [resp_type_id]) WITH (FILLFACTOR = 90);

