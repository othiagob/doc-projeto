-- PainelDB: o server.exe exige este banco no boot (SQLConnection.cpp).
-- GM grava bans em dbo.Banneds. Se o banco foi dropado "porque nao servia",
-- o servidor tenta recriar via master (EnsurePainelDatabase). Este script
-- e o equivalente manual no SSMS (rodar conectado em master).

IF DB_ID(N'PainelDB') IS NULL
    CREATE DATABASE PainelDB;
GO

USE PainelDB;
GO

IF OBJECT_ID(N'dbo.Banneds', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Banneds (
        Account   VARCHAR(50)  NOT NULL,
        Character VARCHAR(50)  NULL,
        Date      DATETIME     NULL,
        Reason    VARCHAR(255) NULL,
        Operator  VARCHAR(50)  NULL,
        Unlock    VARCHAR(50)  NULL
    );
END
GO
