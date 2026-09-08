$ErrorActionPreference = "Stop"
$src = "C:\Users\carol\Desktop\doc-projeto\Dados-SQL"
$out = Join-Path $src "ShopItems-catalog.sql"

function Parse-Table([string]$path) {
    $headers = $null
    $rows = @()
    foreach ($raw in Get-Content -Path $path -Encoding UTF8) {
        $line = $raw.Trim()
        if (-not $line.StartsWith("|")) { continue }
        $cols = @($line.Trim("|").Split("|") | ForEach-Object { $_.Trim() })
        if ($cols.Count -eq 0) { continue }
        $isSep = $true
        foreach ($c in $cols) {
            if ($c -notmatch '^[-: ]+$') { $isSep = $false; break }
        }
        if ($isSep) { continue }
        if ($null -eq $headers) {
            $headers = $cols
            continue
        }
        if ($cols[0] -eq "Seq") { continue }
        while ($cols.Count -lt $headers.Count) { $cols += "" }
        $row = @{}
        for ($i = 0; $i -lt $headers.Count; $i++) {
            $row[$headers[$i]] = $cols[$i]
        }
        $rows += $row
    }
    return $rows
}

function To-Int($value) {
    if ($null -eq $value) { return 0 }
    $s = ([string]$value).Trim() -replace '[^\d\-]', ''
    if ([string]::IsNullOrWhiteSpace($s) -or $s -eq "-") { return 0 }
    try { return [int]$s } catch { return 0 }
}

function Is-Active($row) {
    $a = [string]$row["Active"]
    if ([string]::IsNullOrWhiteSpace($a)) { return $true }
    return $a.Trim() -notin @("0", "false", "False")
}

function Coin-Price([int]$level, [int]$gold) {
    $byGold = 0
    if ($gold -gt 0) {
        $byGold = [Math]::Max(10, [Math]::Min(2500, [int]($gold / 1000)))
    }
    $byLvl = 15
    if ($level -ge 160) { $byLvl = 800 }
    elseif ($level -ge 130) { $byLvl = 600 }
    elseif ($level -ge 118) { $byLvl = 500 }
    elseif ($level -ge 100) { $byLvl = 400 }
    elseif ($level -ge 80) { $byLvl = 250 }
    elseif ($level -ge 60) { $byLvl = 120 }
    elseif ($level -ge 40) { $byLvl = 60 }
    elseif ($level -ge 20) { $byLvl = 30 }
    if ($byGold -gt 0) { return [Math]::Max($byLvl, $byGold) }
    return $byLvl
}

function Sql-Str([string]$value) {
    $t = $value
    if ($t.Length -gt 63) { $t = $t.Substring(0, 63) }
    return "N'" + ($t -replace "'", "''") + "'"
}

$items = [ordered]@{}

function Add-Item([int]$cat, [int]$sub, [string]$code, [string]$name, [int]$level, [int]$gold) {
    $code = $code.Trim()
    $name = $name.Trim()
    if ([string]::IsNullOrWhiteSpace($code) -or [string]::IsNullOrWhiteSpace($name)) { return }
    $key = $code.ToUpperInvariant()
    if ($items.Contains($key)) { return }
    $items[$key] = [pscustomobject]@{
        Cat = $cat; Sub = $sub; Code = $code; Name = $name; Price = (Coin-Price $level $gold)
    }
}

function Load-Equip([string]$file, [scriptblock]$classify) {
    $path = Join-Path $src $file
    foreach ($row in (Parse-Table $path)) {
        if (-not (Is-Active $row)) { continue }
        $code = [string]$row["Code"]
        $name = [string]$row["Name"]
        $mapped = & $classify $code
        if ($null -eq $mapped) { continue }
        Add-Item $mapped[0] $mapped[1] $code $name (To-Int $row["ItemLevel"]) (To-Int $row["Price"])
    }
}

Load-Equip "Weapons.md" {
    param($code)
    $c = $code.ToUpperInvariant()
    if ($c.StartsWith("WS2")) { return 1, 2 }
    if ($c.StartsWith("WS1")) { return 1, 9 }
    if ($c.StartsWith("WA")) { return 1, 6 }
    if ($c.StartsWith("WC")) { return 1, 4 }
    if ($c.StartsWith("WH")) { return 1, 7 }
    if ($c.StartsWith("WM")) { return 1, 8 }
    if ($c.StartsWith("WP")) { return 1, 3 }
    if ($c.StartsWith("WT")) { return 1, 5 }
    return $null
}
Load-Equip "Armor.md" {
    param($code)
    $c = $code.ToUpperInvariant()
    if ($c.StartsWith("DA2")) { return $null }
    if ($c.StartsWith("DA")) { return 2, 5 }
    return $null
}
Load-Equip "Robes.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("DA2")) { return 2, 2 }
    return $null
}
Load-Equip "Shields.md" {
    param($code)
    $c = $code.ToUpperInvariant()
    if ($c.StartsWith("DS")) { return 2, 3 }
    if ($c.StartsWith("OM")) { return 2, 4 }
    return $null
}
Load-Equip "Gloves.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("DG")) { return 2, 6 }
    return $null
}
Load-Equip "Boots.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("DB")) { return 3, 2 }
    return $null
}
Load-Equip "Bracelets.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("OA2")) { return 3, 1 }
    return $null
}
Load-Equip "Rings.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("OR")) { return 3, 4 }
    return $null
}
Load-Equip "Amuletos.md" {
    param($code)
    $c = $code.ToUpperInvariant()
    if ($c.StartsWith("OA2")) { return $null }
    if ($c.StartsWith("OA")) { return 3, 5 }
    return $null
}
Load-Equip "Brincos.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("OE")) { return 3, 3 }
    return $null
}
Load-Equip "Costumes.md" {
    param($code)
    $c = $code.ToUpperInvariant()
    if (-not $c.StartsWith("CA")) { return $null }
    $digits = ($c -replace '\D', '')
    if ([string]::IsNullOrWhiteSpace($digits)) { return $null }
    $n = [int]$digits
    if (($n % 2) -eq 1) { return 4, 1 } else { return 4, 2 }
}
Load-Equip "Forces.md" {
    param($code)
    if ($code.ToUpperInvariant().StartsWith("FO")) { return 5, 3 }
    return $null
}

foreach ($row in (Parse-Table (Join-Path $src "Premiuns.md"))) {
    if (-not (Is-Active $row)) { continue }
    $code = ([string]$row["Code"]).Trim()
    $name = ([string]$row["Name"]).Trim()
    $c = $code.ToUpperInvariant()
    $u = $name.ToUpperInvariant()
    $cat = $null
    $sub = $null
    if ($c.StartsWith("PZ") -or $c.StartsWith("RS") -or $c.StartsWith("EC")) { continue }
    if ($u.Contains("CAIXA DE ATAQUE")) { $cat = 1; $sub = 1 }
    elseif ($u.Contains("CAIXA") -and $c.StartsWith("BI")) { $cat = 1; $sub = 1 }
    elseif ($c.StartsWith("SP") -and $u.Contains("CAIXA")) { $cat = 1; $sub = 1 }
    elseif ($c.StartsWith("FO")) { $cat = 5; $sub = 3 }
    elseif ($c.StartsWith("SA") -or $u.Contains("AGING") -or $u.Contains("MIX") -or $u.Contains("MATURA")) { $cat = 5; $sub = 2 }
    elseif ($u.Contains("EXP") -or $u.Contains("OLHO") -or $u.Contains("BOOST") -or $u.Contains("FÊNIX") -or $u.Contains("FENIX") -or $u.Contains("EXPER")) { $cat = 5; $sub = 1 }
    elseif ($c.StartsWith("BC") -or $c.StartsWith("BI")) {
        if ($u.Contains("PEDRA DO AGING") -or $u.Contains("CORE M") -or $u.Contains("OURO M")) { $cat = 5; $sub = 2 }
        else { $cat = 5; $sub = 4 }
    }
    elseif ($c.StartsWith("SE")) { $cat = 3; $sub = 6 }
    else { continue }
    Add-Item $cat $sub $code $name 0 (To-Int $row["Price"])
}

foreach ($raw in Get-Content -Path (Join-Path $src "ListaItens_Drop.md") -Encoding UTF8) {
    if ($raw -match '`OS1(\d{2})`\s*\|\s*([^|]+)') {
        $code = "OS1$($Matches[1])"
        $name = $Matches[2].Trim()
        $n = [int]$Matches[1]
        if ($n -gt 19) { continue }
        if ($name -match "Magic") { continue }
        Add-Item 3 6 $code $name 0 0
    }
    elseif ($raw -match '`WM(\d{3})`\s*\|\s*([^|]+)') {
        $code = "WM$($Matches[1])"
        $name = $Matches[2].Trim()
        Add-Item 1 8 $code $name 0 0
    }
}

$rows = $items.Values | Sort-Object Cat, Sub, Code
$counts = @{}
foreach ($r in $rows) {
    $k = "$($r.Cat),$($r.Sub)"
    if ($counts.ContainsKey($k)) { $counts[$k]++ } else { $counts[$k] = 1 }
}

$labels = @{
    "1,1" = "Ataque/Caixas"
    "1,2" = "Ataque/Espadas"
    "1,3" = "Ataque/Foices"
    "1,4" = "Ataque/Garras"
    "1,5" = "Ataque/Lanças"
    "1,6" = "Ataque/Machados"
    "1,7" = "Ataque/Martelos"
    "1,8" = "Ataque/Varinhas"
    "1,9" = "Ataque/Arcos"
    "2,1" = "Defesa/Caixas"
    "2,2" = "Defesa/Roupões"
    "2,3" = "Defesa/Escudos"
    "2,4" = "Defesa/Orbitais"
    "2,5" = "Defesa/Armaduras"
    "2,6" = "Defesa/Luvas"
    "3,1" = "Acessórios/Braceletes"
    "3,2" = "Acessórios/Botas"
    "3,3" = "Acessórios/Brincos"
    "3,4" = "Acessórios/Anéis"
    "3,5" = "Acessórios/Colares"
    "3,6" = "Acessórios/Pedras"
    "4,1" = "Trajes/Masculinos"
    "4,2" = "Trajes/Femininos"
    "5,1" = "Premium/Aprimoramento"
    "5,2" = "Premium/Aging e Mix"
    "5,3" = "Premium/Forças"
    "5,4" = "Premium/Utilitários"
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("-- Catalogo da Loja de Coins gerado a partir de Dados-SQL (markdown).")
[void]$sb.AppendLine("-- Banco: ShopCoin  |  tabela: ShopItems")
[void]$sb.AppendLine("--")
[void]$sb.AppendLine("-- Como aplicar no SSMS:")
[void]$sb.AppendLine("--   1. Conecte no mesmo SQL Server do server.exe (Server\Config\SQL.ini)")
[void]$sb.AppendLine("--   2. Execute este script inteiro")
[void]$sb.AppendLine("--   3. Reinicie o server.exe (ele le ShopItems quando o NPC da loja abre)")
[void]$sb.AppendLine("--")
[void]$sb.AppendLine("-- Precos em Coins sao uma escala de TESTE (nivel/ouro). Ajuste depois.")
[void]$sb.AppendLine("-- Escudos (DS*) ficam na aba Escudos; orbitais (OM*) na aba Orbitais.")
[void]$sb.AppendLine("--")
[void]$sb.AppendLine("-- Total de itens: $($rows.Count)")
foreach ($k in ($counts.Keys | Sort-Object)) {
    $lab = $labels[$k]
    if (-not $lab) { $lab = $k }
    [void]$sb.AppendLine("--   ${lab}: $($counts[$k])")
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("USE ShopCoin;")
[void]$sb.AppendLine("GO")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("DELETE FROM ShopItems;")
[void]$sb.AppendLine("GO")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("INSERT INTO ShopItems (CategoryID, SubCategoryID, ItemCode, ItemName, Price, DiscountPercent) VALUES")

for ($i = 0; $i -lt $rows.Count; $i++) {
    $r = $rows[$i]
    $comma = if ($i -lt $rows.Count - 1) { "," } else { ";" }
    $nameSql = Sql-Str $r.Name
    [void]$sb.AppendLine("($($r.Cat), $($r.Sub), '$($r.Code)', $nameSql, $($r.Price), 0)$comma")
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("GO")
[void]$sb.AppendLine("")

[System.IO.File]::WriteAllText($out, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
Write-Output "Wrote $($rows.Count) items to $out"
foreach ($k in ($counts.Keys | Sort-Object)) {
    $lab = $labels[$k]
    if (-not $lab) { $lab = $k }
    Write-Output ("  {0}: {1}" -f $lab, $counts[$k])
}
