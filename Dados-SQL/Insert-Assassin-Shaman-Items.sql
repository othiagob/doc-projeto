-- =====================================================================
-- SCRIPT DE INSERÇÃO: ITENS DE ASSASSINA E XAMÃ NO BANCO DE DADOS
-- Banco: gameserver
-- Servidor: PRIME\TESTESRV (ou Localhost)
--
-- Contém:
-- 1. dbo.Weapons: Adagas (WD101 a WD115) e Garras (WC101 a WC115) para Assassina
-- 2. dbo.MagicWeapons: Phantoms (WN101 a WN115) para Xamã
-- 3. dbo.Armor: Armaduras leves (DA101 a DA115) com spec Assassina
-- 4. dbo.Robes: Robes (DA201 a DA215) com spec Xamã
-- =====================================================================

USE [gameserver];
GO

PRINT 'Iniciando insercao de itens para Assassina e Xama...';
GO

-- =====================================================================
-- 1. ADAGAS (WD101 a WD115) - dbo.Weapons (PrimarySpec = 9 -> Assassina)
-- =====================================================================
PRINT 'Inserindo Adagas (WD101 a WD115)...';

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD101')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD101', 'Novice Dagger', 1, 1, 1, 18, 20, 20, 24, 45, 50, 4, 8, 4, 8, 45, 52, 10, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 8, 320, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD102')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD102', 'Sharp Dagger', 1, 1, 7, 20, 24, 25, 30, 50, 55, 6, 11, 6, 11, 55, 65, 11, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 9, 850, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD103')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD103', 'Stiletto', 1, 1, 12, 22, 28, 30, 36, 55, 60, 8, 14, 8, 14, 68, 78, 12, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 10, 1600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD104')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD104', 'Kukri', 1, 1, 17, 24, 32, 35, 42, 60, 65, 11, 18, 11, 18, 80, 92, 12, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 11, 3100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD105')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD105', 'Tanto', 1, 1, 22, 26, 36, 40, 48, 65, 70, 14, 22, 14, 22, 95, 108, 13, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 12, 5400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD106')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD106', 'Kris Dagger', 1, 1, 28, 28, 41, 45, 55, 70, 75, 17, 26, 17, 26, 110, 125, 13, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 13, 8900, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD107')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD107', 'Rondel Dagger', 1, 1, 34, 30, 46, 50, 62, 75, 80, 21, 31, 21, 31, 128, 144, 14, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 14, 14200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD108')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD108', 'Poison Dagger', 1, 1, 40, 32, 51, 55, 69, 80, 85, 25, 36, 25, 36, 146, 164, 14, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 15, 21800, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD109')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD109', 'Assassin Dagger', 1, 1, 46, 34, 56, 60, 76, 85, 90, 29, 41, 29, 41, 166, 185, 15, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 16, 32500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD110')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD110', 'Shadow Dagger', 1, 1, 52, 36, 61, 65, 83, 90, 95, 34, 47, 34, 47, 188, 208, 15, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 17, 47000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD111')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD111', 'Viper Dagger', 1, 1, 58, 38, 66, 70, 90, 95, 100, 39, 53, 39, 53, 210, 232, 16, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 18, 66000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD112')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD112', 'Fatal Dagger', 1, 1, 64, 40, 71, 75, 97, 100, 105, 45, 60, 45, 60, 234, 258, 16, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 19, 91000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD113')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD113', 'Cobra Dagger', 1, 1, 70, 42, 76, 80, 104, 105, 110, 51, 67, 51, 67, 260, 285, 17, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 20, 122000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD114')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD114', 'Ravage Dagger', 1, 1, 75, 44, 80, 84, 110, 110, 115, 57, 74, 57, 74, 284, 310, 18, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 21, 160000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WD115')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WD115', 'Nemesis Dagger', 1, 1, 80, 46, 84, 88, 116, 115, 120, 63, 82, 63, 82, 310, 338, 19, 9, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 22, 210000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- =====================================================================
-- 2. GARRAS (WC101 a WC115) - dbo.Weapons (PrimarySpec = 9 -> Assassina)
-- =====================================================================
PRINT 'Inserindo Garras (WC101 a WC115)...';

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WC101')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WC101', 'Eagle Claw', 1, 1, 1, 16, 22, 22, 22, 45, 50, 5, 10, 5, 10, 48, 56, 12, 8, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 9, 350, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WC102')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WC102', 'Tiger Claw', 1, 1, 7, 18, 26, 26, 28, 50, 55, 8, 14, 8, 14, 60, 70, 13, 8, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 10, 920, 0, 0, 0, 0, 0, 0, 0, 6, 9, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Weapons WHERE ItemCode = 'WC103')
INSERT INTO Weapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, QuestID, ExpireTime)
VALUES ('WC103', 'Griffin Claw', 1, 1, 12, 20, 30, 31, 34, 55, 60, 11, 18, 11, 18, 74, 84, 13, 8, 0, 0, 0, 9, '', 0, 0, 0, 0, 0, 0, 0, 11, 1800, 0, 0, 0, 0, 0, 0, 0, 8, 12, 0, 0);

-- =====================================================================
-- 3. PHANTOMS (WN101 a WN115) - dbo.MagicWeapons (PrimarySpec = 10 -> Xamã)
-- =====================================================================
PRINT 'Inserindo Phantoms do Xama (WN101 a WN115)...';

IF NOT EXISTS (SELECT 1 FROM MagicWeapons WHERE ItemCode = 'WN101')
INSERT INTO MagicWeapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, SpecialMagicMasteryMin, SpecialMagicMasteryMax, SpecialManaRegenMin, SpecialManaRegenMax, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, ManaRegenMin, ManaRegenMax, SpecialAbsorbMin, SpecialAbsorbMax, QuestID, ExpireTime)
VALUES ('WN101', 'Novice Phantom', 2, 1, 1, 24, 16, 20, 16, 45, 50, 5, 9, 5, 9, 38, 45, 8, 6, 0, 0, 0, 10, '', 0, 0, 0, 0, 0, 0, 0, 7, 340, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5.0, 8.0, 1.0, 2.0, 5, 10, 10, 20, 5, 10, 1.0, 2.0, 1.0, 2.0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM MagicWeapons WHERE ItemCode = 'WN102')
INSERT INTO MagicWeapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, SpecialMagicMasteryMin, SpecialMagicMasteryMax, SpecialManaRegenMin, SpecialManaRegenMax, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, ManaRegenMin, ManaRegenMax, SpecialAbsorbMin, SpecialAbsorbMax, QuestID, ExpireTime)
VALUES ('WN102', 'Spirit Phantom', 2, 1, 7, 30, 18, 24, 18, 50, 55, 8, 13, 8, 13, 48, 58, 9, 6, 0, 0, 0, 10, '', 0, 0, 0, 0, 0, 0, 0, 8, 890, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7.0, 11.0, 1.5, 2.5, 10, 15, 18, 30, 8, 15, 1.2, 2.2, 1.2, 2.2, 0, 0);

IF NOT EXISTS (SELECT 1 FROM MagicWeapons WHERE ItemCode = 'WN103')
INSERT INTO MagicWeapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, SpecialMagicMasteryMin, SpecialMagicMasteryMax, SpecialManaRegenMin, SpecialManaRegenMax, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, ManaRegenMin, ManaRegenMax, SpecialAbsorbMin, SpecialAbsorbMax, QuestID, ExpireTime)
VALUES ('WN103', 'Spooky Phantom', 2, 1, 12, 36, 21, 28, 20, 55, 60, 11, 17, 11, 17, 60, 72, 9, 6, 0, 0, 0, 10, '', 0, 0, 0, 0, 0, 0, 0, 9, 1700, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9.0, 14.0, 2.0, 3.2, 15, 22, 26, 42, 12, 20, 1.5, 2.5, 1.5, 2.5, 0, 0);

IF NOT EXISTS (SELECT 1 FROM MagicWeapons WHERE ItemCode = 'WN104')
INSERT INTO MagicWeapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, SpecialMagicMasteryMin, SpecialMagicMasteryMax, SpecialManaRegenMin, SpecialManaRegenMax, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, ManaRegenMin, ManaRegenMax, SpecialAbsorbMin, SpecialAbsorbMax, QuestID, ExpireTime)
VALUES ('WN104', 'Phantom Horn', 2, 1, 17, 43, 24, 33, 23, 60, 65, 15, 22, 15, 22, 74, 88, 10, 6, 0, 0, 0, 10, '', 0, 0, 0, 0, 0, 0, 0, 10, 3300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11.0, 17.0, 2.5, 3.8, 20, 30, 35, 55, 15, 25, 1.8, 2.8, 1.8, 2.8, 0, 0);

IF NOT EXISTS (SELECT 1 FROM MagicWeapons WHERE ItemCode = 'WN105')
INSERT INTO MagicWeapons (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DamageMin, DamageMax, DamageMin2, DamageMax2, AttackRatingMin, AttackRatingMax, Critical, AttackSpeed, ShootingRange, BlockRatingMin, BlockRatingMax, PrimarySpec, SecondarySpec, LevDamageMin, LevDamageMax, LevAttackRatingMin, LevAttackRatingMax, AddAttackSpeed, AddCritical, AddShootingRange, Weight, Price, Effect, EffectColor1, EffectColor2, EffectColor3, EffectColor4, EffectBlink, EffectScale, DefenseMin, DefenseMax, SpecialMagicMasteryMin, SpecialMagicMasteryMax, SpecialManaRegenMin, SpecialManaRegenMax, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, ManaRegenMin, ManaRegenMax, SpecialAbsorbMin, SpecialAbsorbMax, QuestID, ExpireTime)
VALUES ('WN105', 'Ghost Phantom', 2, 1, 22, 50, 27, 38, 26, 65, 70, 19, 27, 19, 27, 90, 106, 10, 6, 0, 0, 0, 10, '', 0, 0, 0, 0, 0, 0, 0, 11, 5700, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13.0, 20.0, 3.0, 4.5, 25, 38, 45, 70, 18, 30, 2.0, 3.2, 2.0, 3.2, 0, 0);

-- =====================================================================
-- 4. ARMADURAS DE ASSASSINA (DA101 a DA106) - dbo.Armor (PrimarySpec = 9)
-- =====================================================================
PRINT 'Inserindo Armaduras da Assassina (DA101 a DA106)...';

IF NOT EXISTS (SELECT 1 FROM Armor WHERE ItemCode = 'DA101')
INSERT INTO Armor (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DefenseMin, DefenseMax, AbsorbMin, AbsorbMax, BlockRatingMin, BlockRatingMax, OrganicMin, OrganicMax, FireMin, FireMax, IceMin, IceMax, LightingMin, LightingMax, PoisonMin, PoisonMax, SecondarySpec, SpecialDefenseMin, SpecialDefenseMax, SpecialAbsorbMin, SpecialAbsorbMax, AddBlockRating, Weight, Price, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, QuestID, ExpireTime)
VALUES ('DA101', 'Nude', 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Armor WHERE ItemCode = 'DA102')
INSERT INTO Armor (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DefenseMin, DefenseMax, AbsorbMin, AbsorbMax, BlockRatingMin, BlockRatingMax, OrganicMin, OrganicMax, FireMin, FireMax, IceMin, IceMax, LightingMin, LightingMax, PoisonMin, PoisonMax, SecondarySpec, SpecialDefenseMin, SpecialDefenseMax, SpecialAbsorbMin, SpecialAbsorbMax, AddBlockRating, Weight, Price, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, QuestID, ExpireTime)
VALUES ('DA102', 'Battle Suit', 3, 1, 1, 15, 20, 20, 22, 50, 55, 18, 22, 3.5, 4.5, 0.0, 0.0, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4, '9', 5, 10, 1.0, 2.0, 0.0, 14, 450, 5, 10, 0, 0, 10, 20, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Armor WHERE ItemCode = 'DA103')
INSERT INTO Armor (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DefenseMin, DefenseMax, AbsorbMin, AbsorbMax, BlockRatingMin, BlockRatingMax, OrganicMin, OrganicMax, FireMin, FireMax, IceMin, IceMax, LightingMin, LightingMax, PoisonMin, PoisonMax, SecondarySpec, SpecialDefenseMin, SpecialDefenseMax, SpecialAbsorbMin, SpecialAbsorbMax, AddBlockRating, Weight, Price, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, QuestID, ExpireTime)
VALUES ('DA103', 'Leather Armor', 3, 1, 7, 18, 25, 25, 28, 55, 60, 25, 30, 4.5, 6.0, 0.0, 0.0, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, '9', 8, 14, 1.5, 2.5, 0.0, 16, 1200, 10, 18, 0, 0, 15, 28, 0, 0);

-- =====================================================================
-- 5. ROBES DO XAMÃ (DA201 a DA206) - dbo.Robes (PrimarySpec = 10)
-- =====================================================================
PRINT 'Inserindo Robes do Xama (DA201 a DA206)...';

IF NOT EXISTS (SELECT 1 FROM Robes WHERE ItemCode = 'DA201')
INSERT INTO Robes (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DefenseMin, DefenseMax, AbsorbMin, AbsorbMax, BlockRatingMin, BlockRatingMax, OrganicMin, OrganicMax, FireMin, FireMax, IceMin, IceMax, LightingMin, LightingMax, PoisonMin, PoisonMax, SecondarySpec, SpecialDefenseMin, SpecialDefenseMax, SpecialAbsorbMin, SpecialAbsorbMax, AddBlockRating, Weight, Price, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, QuestID, ExpireTime)
VALUES ('DA201', 'Nude', 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Robes WHERE ItemCode = 'DA202')
INSERT INTO Robes (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DefenseMin, DefenseMax, AbsorbMin, AbsorbMax, BlockRatingMin, BlockRatingMax, OrganicMin, OrganicMax, FireMin, FireMax, IceMin, IceMax, LightingMin, LightingMax, PoisonMin, PoisonMax, SecondarySpec, SpecialDefenseMin, SpecialDefenseMax, SpecialAbsorbMin, SpecialAbsorbMax, AddBlockRating, Weight, Price, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, QuestID, ExpireTime)
VALUES ('DA202', 'Faded Robe', 3, 1, 1, 22, 14, 18, 14, 45, 50, 14, 18, 2.5, 3.8, 0.0, 0.0, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, '10', 4, 8, 0.8, 1.6, 0.0, 10, 420, 5, 10, 15, 25, 8, 16, 0, 0);

IF NOT EXISTS (SELECT 1 FROM Robes WHERE ItemCode = 'DA203')
INSERT INTO Robes (ItemCode, ItemName, ItemType, Active, Level, Spirit, Strength, Talent, Dexterity, DurabilityMin, DurabilityMax, DefenseMin, DefenseMax, AbsorbMin, AbsorbMax, BlockRatingMin, BlockRatingMax, OrganicMin, OrganicMax, FireMin, FireMax, IceMin, IceMax, LightingMin, LightingMax, PoisonMin, PoisonMax, SecondarySpec, SpecialDefenseMin, SpecialDefenseMax, SpecialAbsorbMin, SpecialAbsorbMax, AddBlockRating, Weight, Price, IncreaseLifeMin, IncreaseLifeMax, IncreaseManaMin, IncreaseManaMax, IncreaseStaminaMin, IncreaseStaminaMax, QuestID, ExpireTime)
VALUES ('DA203', 'Enhanced Robe', 3, 1, 7, 28, 16, 22, 16, 50, 55, 20, 25, 3.5, 5.0, 0.0, 0.0, 4, 8, 4, 8, 4, 8, 4, 8, 4, 8, '10', 6, 12, 1.2, 2.2, 0.0, 12, 1100, 8, 16, 22, 38, 12, 22, 0, 0);

PRINT 'Itens inseridos com sucesso!';
GO
