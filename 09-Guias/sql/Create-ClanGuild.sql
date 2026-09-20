-- Fallen Tale / Source Priston
-- ClanDB (Mestre dos Clan). Cole no SSMS conectado no servidor SQL.
-- O C++ NAO cria estas tabelas no boot — rode este script de novo se fundar cla falhar.
--
-- NAO dropa CL / UL / CT. So cria o que faltar e coloca DEFAULT em colunas
-- NOT NULL comuns do schema antigo (RegiDate, Cpoint, IDX...).
--
-- O jogo usa:
--   UL.ChName, UL.MiconCnt (codigo da marca / ClassClan), UL.ChipFlag (1 lider, 2 vice, 0 membro),
--   UL.ClanName, UL.userid, UL.ChLv, UL.ChType (JOB_CODE), UL.LastField (indice do mapa),
--   UL.Gserver, UL.ClanZang
--   CL.MiconCnt, CL.ClanName, CL.ClanZang, CL.ClanZangID, CL.Note, CL.MemCnt, CL.Cpoint (SoD)
--   CT.ChName (ticket de presenca no login)
--   ClanProfile / ClanApplication / ClanAudit (Mestre dos Clan)

USE ClanDB;
GO

IF OBJECT_ID(N'dbo.CL', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.CL (
		MiconCnt   INT          NOT NULL IDENTITY(1,1),
		ClanName   VARCHAR(32)  NOT NULL,
		Note       VARCHAR(96)  NOT NULL CONSTRAINT DF_CL_Note_new DEFAULT (''),
		ClanZang   VARCHAR(32)  NOT NULL,
		ClanZangID VARCHAR(32)  NOT NULL CONSTRAINT DF_CL_ZangID_new DEFAULT (''),
		MemCnt     INT          NOT NULL CONSTRAINT DF_CL_Mem_new DEFAULT (1),
		Gserver    VARCHAR(16)  NOT NULL CONSTRAINT DF_CL_Gs_new DEFAULT ('FT'),
		CONSTRAINT PK_CL_Micon PRIMARY KEY (MiconCnt)
	);
END
GO

IF OBJECT_ID(N'dbo.UL', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.UL (
		userid    VARCHAR(32)  NOT NULL,
		ChName    VARCHAR(32)  NOT NULL,
		ClanName  VARCHAR(32)  NOT NULL CONSTRAINT DF_UL_CName_new DEFAULT (''),
		ChLv      INT          NOT NULL CONSTRAINT DF_UL_Lv_new DEFAULT (1),
		ChType    INT          NOT NULL CONSTRAINT DF_UL_Type_new DEFAULT (0),
		ChipFlag  INT          NOT NULL CONSTRAINT DF_UL_Chip_new DEFAULT (0),
		Gserver   VARCHAR(16)  NOT NULL CONSTRAINT DF_UL_Gs_new DEFAULT ('FT'),
		ClanZang  VARCHAR(32)  NOT NULL CONSTRAINT DF_UL_Zang_new DEFAULT (''),
		MiconCnt  INT          NOT NULL,
		LastField INT          NOT NULL CONSTRAINT DF_UL_LastField_new DEFAULT (-1),
		CONSTRAINT PK_UL_ChName PRIMARY KEY (ChName)
	);
END
GO

IF COL_LENGTH(N'dbo.CL', N'Note') IS NULL
	ALTER TABLE dbo.CL ADD Note VARCHAR(96) NULL;
IF COL_LENGTH(N'dbo.CL', N'ClanZangID') IS NULL
	ALTER TABLE dbo.CL ADD ClanZangID VARCHAR(32) NULL;
IF COL_LENGTH(N'dbo.CL', N'MemCnt') IS NULL
	ALTER TABLE dbo.CL ADD MemCnt INT NULL;
IF COL_LENGTH(N'dbo.CL', N'Gserver') IS NULL
	ALTER TABLE dbo.CL ADD Gserver VARCHAR(16) NULL;
IF COL_LENGTH(N'dbo.CL', N'MiconCnt') IS NULL
	ALTER TABLE dbo.CL ADD MiconCnt INT NULL;
GO

IF COL_LENGTH(N'dbo.UL', N'MiconCnt') IS NULL
	ALTER TABLE dbo.UL ADD MiconCnt INT NULL;
IF COL_LENGTH(N'dbo.UL', N'ChipFlag') IS NULL
	ALTER TABLE dbo.UL ADD ChipFlag INT NULL;
IF COL_LENGTH(N'dbo.UL', N'Gserver') IS NULL
	ALTER TABLE dbo.UL ADD Gserver VARCHAR(16) NULL;
IF COL_LENGTH(N'dbo.UL', N'ClanZang') IS NULL
	ALTER TABLE dbo.UL ADD ClanZang VARCHAR(32) NULL;
IF COL_LENGTH(N'dbo.UL', N'ChType') IS NULL
	ALTER TABLE dbo.UL ADD ChType INT NULL;
IF COL_LENGTH(N'dbo.UL', N'ChLv') IS NULL
	ALTER TABLE dbo.UL ADD ChLv INT NULL;
IF COL_LENGTH(N'dbo.UL', N'userid') IS NULL
	ALTER TABLE dbo.UL ADD userid VARCHAR(32) NULL;
IF COL_LENGTH(N'dbo.UL', N'LastField') IS NULL
	ALTER TABLE dbo.UL ADD LastField INT NOT NULL CONSTRAINT DF_UL_LastField DEFAULT (-1);
GO

-- DEFAULT so the C++ INSERT can omit old NOT NULL columns.
DECLARE @sql NVARCHAR(MAX);
DECLARE @t SYSNAME, @c SYSNAME, @df SYSNAME, @expr NVARCHAR(200);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
SELECT v.t, v.c, v.df, v.expr
FROM (VALUES
	(N'dbo.CL', N'RegiDate',   N'DF_CL_RegiDate',   N'(GETDATE())'),
	(N'dbo.CL', N'LimitDate',  N'DF_CL_LimitDate',  N'(DATEADD(year, 20, GETDATE()))'),
	(N'dbo.CL', N'DelActive',  N'DF_CL_DelActive',  N'((0))'),
	(N'dbo.CL', N'PFlag',      N'DF_CL_PFlag',      N'((0))'),
	(N'dbo.CL', N'KFlag',      N'DF_CL_KFlag',      N'((0))'),
	(N'dbo.CL', N'Flag',       N'DF_CL_Flag',       N'((0))'),
	(N'dbo.CL', N'Cpoint',     N'DF_CL_Cpoint',     N'((0))'),
	(N'dbo.CL', N'CWin',       N'DF_CL_CWin',       N'((0))'),
	(N'dbo.CL', N'CFail',      N'DF_CL_CFail',      N'((0))'),
	(N'dbo.CL', N'CLose',      N'DF_CL_CLose',      N'((0))'),
	(N'dbo.CL', N'CWD',        N'DF_CL_CWD',        N'((0))'),
	(N'dbo.CL', N'CLD',        N'DF_CL_CLD',        N'((0))'),
	(N'dbo.CL', N'CMC',        N'DF_CL_CMC',        N'((0))'),
	(N'dbo.CL', N'ClanMoney',  N'DF_CL_ClanMoney',  N'((0))'),
	(N'dbo.CL', N'CNFlag',     N'DF_CL_CNFlag',     N'((0))'),
	(N'dbo.CL', N'SiegeMoney', N'DF_CL_SiegeMoney', N'((0))'),
	(N'dbo.CL', N'NoteCnt',    N'DF_CL_NoteCnt',    N'((0))'),
	(N'dbo.CL', N'MemCnt',     N'DF_CL_MemCnt',     N'((1))'),
	(N'dbo.CL', N'Note',       N'DF_CL_Note',       N'('''')'),
	(N'dbo.CL', N'Gserver',    N'DF_CL_Gserver',    N'(''FT'')'),
	(N'dbo.CL', N'ClanZangID', N'DF_CL_ClanZangID', N'('''')'),
	(N'dbo.CL', N'UserID',     N'DF_CL_UserID',     N'('''')'),
	(N'dbo.UL', N'JoinDate',   N'DF_UL_JoinDate',   N'(GETDATE())'),
	(N'dbo.UL', N'DelActive',  N'DF_UL_DelActive',  N'((0))'),
	(N'dbo.UL', N'PFlag',      N'DF_UL_PFlag',      N'((0))'),
	(N'dbo.UL', N'KFlag',      N'DF_UL_KFlag',      N'((0))'),
	(N'dbo.UL', N'Permi',      N'DF_UL_Permi',      N'((0))'),
	(N'dbo.UL', N'IDX',        N'DF_UL_IDX',        N'((0))'),
	(N'dbo.UL', N'ChipFlag',   N'DF_UL_ChipFlag',   N'((0))'),
	(N'dbo.UL', N'ChLv',       N'DF_UL_ChLv',       N'((1))'),
	(N'dbo.UL', N'ChType',     N'DF_UL_ChType',     N'((0))'),
	(N'dbo.UL', N'Gserver',    N'DF_UL_Gserver',    N'(''FT'')'),
	(N'dbo.UL', N'ClanZang',   N'DF_UL_ClanZang',   N'('''')'),
	(N'dbo.UL', N'ClanName',   N'DF_UL_ClanName',   N'('''')'),
	(N'dbo.UL', N'LastField',  N'DF_UL_LastField',  N'((-1))')
) v(t, c, df, expr);

OPEN cur;
FETCH NEXT FROM cur INTO @t, @c, @df, @expr;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF COL_LENGTH(@t, @c) IS NOT NULL
	AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints dc
		INNER JOIN sys.columns col ON col.default_object_id = dc.object_id
		WHERE dc.parent_object_id = OBJECT_ID(@t) AND col.name = @c
	)
	AND NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @df)
	BEGIN
		SET @sql = N'ALTER TABLE ' + @t + N' ADD CONSTRAINT ' + @df + N' DEFAULT ' + @expr + N' FOR ' + @c + N';';
		EXEC sp_executesql @sql;
	END
	FETCH NEXT FROM cur INTO @t, @c, @df, @expr;
END
CLOSE cur;
DEALLOCATE cur;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_UL_ChName' AND object_id = OBJECT_ID(N'dbo.UL'))
	AND OBJECT_ID(N'dbo.UL', N'U') IS NOT NULL
	CREATE INDEX IX_UL_ChName ON dbo.UL (ChName);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_UL_MiconCnt' AND object_id = OBJECT_ID(N'dbo.UL'))
	AND OBJECT_ID(N'dbo.UL', N'U') IS NOT NULL
	AND COL_LENGTH(N'dbo.UL', N'MiconCnt') IS NOT NULL
	CREATE INDEX IX_UL_MiconCnt ON dbo.UL (MiconCnt);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_CL_ClanName' AND object_id = OBJECT_ID(N'dbo.CL'))
	AND OBJECT_ID(N'dbo.CL', N'U') IS NOT NULL
	CREATE INDEX IX_CL_ClanName ON dbo.CL (ClanName);
GO

IF OBJECT_ID(N'dbo.ClanProfile', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.ClanProfile (
		ClanCode     INT          NOT NULL,
		Motd         VARCHAR(96)  NOT NULL CONSTRAINT DF_ClanProfile_Motd DEFAULT (''),
		RecruitOpen  INT          NOT NULL CONSTRAINT DF_ClanProfile_Recruit DEFAULT (1),
		UpdatedAt    DATETIME     NOT NULL CONSTRAINT DF_ClanProfile_Updated DEFAULT (GETDATE()),
		CONSTRAINT PK_ClanProfile PRIMARY KEY (ClanCode),
		CONSTRAINT CK_ClanProfile_Recruit CHECK (RecruitOpen IN (0, 1))
	);
END
GO

IF OBJECT_ID(N'dbo.ClanApplication', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.ClanApplication (
		Id             INT IDENTITY(1,1) NOT NULL,
		ClanCode       INT          NOT NULL,
		ApplicantName  VARCHAR(32)  NOT NULL,
		AccountID      VARCHAR(32)  NOT NULL,
		Message        VARCHAR(80)  NOT NULL CONSTRAINT DF_ClanApp_Msg DEFAULT (''),
		Status         VARCHAR(16)  NOT NULL CONSTRAINT DF_ClanApp_Status DEFAULT ('Pending'),
		CreatedAt      DATETIME     NOT NULL CONSTRAINT DF_ClanApp_Created DEFAULT (GETDATE()),
		ResolvedAt     DATETIME     NULL,
		CONSTRAINT PK_ClanApplication PRIMARY KEY (Id),
		CONSTRAINT CK_ClanApp_Status CHECK (Status IN ('Pending', 'Accepted', 'Rejected', 'Cancelled'))
	);

	CREATE INDEX IX_ClanApp_ClanStatus
		ON dbo.ClanApplication (ClanCode, Status);

	CREATE UNIQUE INDEX UX_ClanApp_PendingChar
		ON dbo.ClanApplication (ApplicantName)
		WHERE Status = 'Pending';
END
GO

IF OBJECT_ID(N'dbo.ClanAudit', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.ClanAudit (
		Id        INT IDENTITY(1,1) NOT NULL,
		ClanCode  INT          NOT NULL,
		Actor     VARCHAR(32)  NOT NULL,
		Action    VARCHAR(24)  NOT NULL,
		Target    VARCHAR(32)  NOT NULL CONSTRAINT DF_ClanAudit_Target DEFAULT (''),
		Detail    VARCHAR(96)  NOT NULL CONSTRAINT DF_ClanAudit_Detail DEFAULT (''),
		At        DATETIME     NOT NULL CONSTRAINT DF_ClanAudit_At DEFAULT (GETDATE()),
		CONSTRAINT PK_ClanAudit PRIMARY KEY (Id)
	);

	CREATE INDEX IX_ClanAudit_ClanAt
		ON dbo.ClanAudit (ClanCode, At DESC);
END
GO

-- Tabelas do ClanDB que o C++ atual NAO le nem grava.
-- Confirme backup, rode so quando quiser limpar o banco legado.
-- NAO drope CL, UL, CT, ClanProfile, ClanApplication, ClanAudit.
--
-- IF OBJECT_ID(N'dbo.ChipLog', N'U') IS NOT NULL DROP TABLE dbo.ChipLog;
-- IF OBJECT_ID(N'dbo.hourstat', N'U') IS NOT NULL DROP TABLE dbo.hourstat;
-- IF OBJECT_ID(N'dbo.playerinfo', N'U') IS NOT NULL DROP TABLE dbo.playerinfo;
-- IF OBJECT_ID(N'dbo.LI', N'U') IS NOT NULL DROP TABLE dbo.LI;
GO
