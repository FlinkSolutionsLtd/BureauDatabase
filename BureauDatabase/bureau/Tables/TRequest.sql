﻿CREATE TABLE [bureau].[TRequest] (
    [req_id]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [loc_id]      INT           NOT NULL,
    [req_user]    VARCHAR (50)  NOT NULL,
    [E_date]      DATETIME      NULL,
    [E_Coord]     INT           NULL,
    [E_Orientee]  INT           NULL,
    [E_RN]        INT           NULL,
    [E_EN]        INT           NULL,
    [E_HCA]       INT           NULL,
    [N_date]      DATETIME      NULL,
    [N_Coord]     INT           NULL,
    [N_Orientee]  INT           NULL,
    [N_RN]        INT           NULL,
    [N_EN]        INT           NULL,
    [N_HCA]       INT           NULL,
    [D_date]      DATETIME      NULL,
    [D_Coord]     INT           NULL,
    [D_Orientee]  INT           NULL,
    [D_RN]        INT           NULL,
    [D_EN]        INT           NULL,
    [D_HCA]       INT           NULL,
    [D_CNM]       INT           NULL,
    [status]      INT           NOT NULL,
    [comments]    VARCHAR (MAX) NULL,
    [create_dttm] DATETIME      CONSTRAINT [DF_Request_create_dttm] DEFAULT (getdate()) NOT NULL,
    [create_user] VARCHAR (50)  CONSTRAINT [DF_Request_create_user] DEFAULT ('bureau_system') NOT NULL,
    [modif_dttm]  DATETIME      CONSTRAINT [DF_Request_modif_dttm] DEFAULT (getdate()) NOT NULL,
    [modif_user]  VARCHAR (50)  CONSTRAINT [DF_Request_modif_user] DEFAULT ('bureau_system') NOT NULL,
    [is_deleted]  SMALLINT      CONSTRAINT [DF_Request_is_deleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_bureau.Request] PRIMARY KEY CLUSTERED ([req_id] ASC) WITH (FILLFACTOR = 90)
);

