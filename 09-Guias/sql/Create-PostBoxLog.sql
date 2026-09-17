-- =============================================================================
-- PostBoxLog — livro de auditoria do Distribuidor
-- Banco: ITEMLogDB  (log de itens / economia)
--
-- ISTO NAO e a caixa do jogador.
-- A fila viva continua no arquivo Data\PostBox\<codigo>\<login>.dat (PB02).
-- Quest.dbo.PostBox e UserDB.dbo.Postbox NAO sao usadas pelo C++ atual.
--
-- Como rodar (SSMS):
-- 1. Conecte no mesmo SQL Server do jogo (veja Server\Config\SQL.ini).
-- 2. Clique em New Query (Ctrl+N).
-- 3. Cole este arquivo inteiro.
-- 4. Execute (F5). A mensagem deve ser "Command(s) completed successfully."
-- 5. Recompile o server.exe e reinicie o servidor.
-- 6. Envie/receba um item no jogo e rode o SELECT no final deste arquivo.
-- =============================================================================

USE ITEMLogDB;
GO

IF OBJECT_ID(N'dbo.PostBoxLog', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PostBoxLog
    (
        LogID           BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        EventTime       DATETIME NOT NULL CONSTRAINT DF_PostBoxLog_EventTime DEFAULT (GETDATE()),
        EventType       VARCHAR(24)  NOT NULL,  -- DEPOSIT, SEND, CLAIM, REFUSE, EXPIRE
        EntryId         INT          NOT NULL CONSTRAINT DF_PostBoxLog_EntryId DEFAULT (0),
        Kind            TINYINT      NOT NULL CONSTRAINT DF_PostBoxLog_Kind DEFAULT (0), -- 0 sistema, 1 jogador
        DestAccount     VARCHAR(32)  NOT NULL CONSTRAINT DF_PostBoxLog_DestAcc DEFAULT (''),
        DestChar        VARCHAR(32)  NOT NULL CONSTRAINT DF_PostBoxLog_DestChar DEFAULT (''),
        SenderAccount   VARCHAR(32)  NOT NULL CONSTRAINT DF_PostBoxLog_SndAcc DEFAULT (''),
        SenderChar      VARCHAR(32)  NOT NULL CONSTRAINT DF_PostBoxLog_SndChar DEFAULT (''),
        ItemCode        VARCHAR(32)  NOT NULL CONSTRAINT DF_PostBoxLog_Code DEFAULT (''), -- ex. WA101, BI102
        ItemName        VARCHAR(64)  NOT NULL CONSTRAINT DF_PostBoxLog_Name DEFAULT (''),
        ItemBinCode     INT          NOT NULL CONSTRAINT DF_PostBoxLog_Bin DEFAULT (0),
        ItemHead        INT          NOT NULL CONSTRAINT DF_PostBoxLog_Head DEFAULT (0),
        ItemChkSum      INT          NOT NULL CONSTRAINT DF_PostBoxLog_Chk DEFAULT (0),
        Quantity        INT          NOT NULL CONSTRAINT DF_PostBoxLog_Qty DEFAULT (0), -- pocoes / gold
        Weight          INT          NOT NULL CONSTRAINT DF_PostBoxLog_W DEFAULT (0),
        Message         VARCHAR(128) NOT NULL CONSTRAINT DF_PostBoxLog_Msg DEFAULT (''),
        HasPass         BIT          NOT NULL CONSTRAINT DF_PostBoxLog_Pass DEFAULT (0),
        DepositedAt     INT          NOT NULL CONSTRAINT DF_PostBoxLog_Dep DEFAULT (0), -- unix
        ExpireAt        INT          NOT NULL CONSTRAINT DF_PostBoxLog_Exp DEFAULT (0), -- unix, 0 = sem prazo
        Reason          VARCHAR(48)  NOT NULL CONSTRAINT DF_PostBoxLog_Reason DEFAULT (''),
        Source          VARCHAR(24)  NOT NULL CONSTRAINT DF_PostBoxLog_Src DEFAULT (''), -- Quest, Shop, P2P...
        DestIP          VARCHAR(45)  NULL
    );

    CREATE INDEX IX_PostBoxLog_EventTime ON dbo.PostBoxLog (EventTime DESC);
    CREATE INDEX IX_PostBoxLog_Dest ON dbo.PostBoxLog (DestAccount, DestChar, EventTime DESC);
    CREATE INDEX IX_PostBoxLog_Sender ON dbo.PostBoxLog (SenderAccount, SenderChar, EventTime DESC);
    CREATE INDEX IX_PostBoxLog_Item ON dbo.PostBoxLog (ItemCode, ItemHead, ItemChkSum);
    CREATE INDEX IX_PostBoxLog_Type ON dbo.PostBoxLog (EventType, EventTime DESC);
END
GO

-- Conferir se a tabela existe:
SELECT TOP 20 *
FROM dbo.PostBoxLog
ORDER BY LogID DESC;
GO
