local addonName, TR = ...

TR.Instances = {}

TR.Instances.Tracked = {
    -- ==================================================
    -- Classic
    -- ==================================================
    -- Dungeons
    [33] = true, -- Castillo de Colmillo Oscuro
    [34] = true, -- Las Mazmorras
    [36] = true, -- Minas de la Muerte
    [43] = true, -- Cuevas de los Lamentos
    [47] = true, -- Horado Rajacieno
    [48] = true, -- Cavernas de Brazanegra
    [70] = true, -- Uldaman
    [90] = true, -- Gnomeregan
    [109] = true, -- El Templo de Atal'Hakkar
    [129] = true, -- Zahúrda Rajacieno
    [209] = true, -- Zul'Farrak
    [229] = true, -- Cumbre de Roca Negra Inferior
    [230] = true, -- Profundidades de Roca Negra
    [329] = true, -- Stratholme: Entrada Principal
    [349] = true, -- Maraudon
    [389] = true, -- Sima Ígnea
    [429] = true, -- La Masacre: Barrio Alabeo
    [1001] = true, -- Cámaras Escarlata
    [1004] = true, -- Monasterio Escarlata
    [1007] = true, -- Scholomance
    -- Raids
    [409] = true, -- Núcleo de magma
    [469] = true, -- Guarida de Alanegra
    [509] = true, -- Ruinas de Ahn'Qiraj
    [531] = true, -- Templo de Ahn'Qiraj
    [2792] = true, -- Profundidades de Roca Negra
  
    -- ==================================================
    -- The Burning Crusade
    -- ==================================================
    -- Dungeons
    [269] = true, -- La Ciénaga Negra
    [540] = true, -- Las Salas Arrasadas
    [542] = true, -- El Horno de Sangre
    [543] = true, -- Murallas del Fuego Infernal
    [545] = true, -- La Cámara de Vapor
    [546] = true, -- La Sotiénaga
    [547] = true, -- Recinto de los Esclavos
    [552] = true, -- El Arcatraz
    [553] = true, -- El Invernáculo
    [554] = true, -- El Mechanar
    [555] = true, -- Laberinto de las Sombras
    [556] = true, -- Salas Sethekk
    [557] = true, -- Tumbas de Maná
    [558] = true, -- Criptas Auchenai
    [560] = true, -- Antiguas Laderas de Trabalomas
    [585] = true, -- Bancal del Magister
    -- Raids
    [532] = true, -- Karazhan
    [534] = true, -- La Batalla del Monte Hyjal
    [544] = true, -- Guarida de Magtheridon
    [548] = true, -- Caverna Santuario Serpiente
    [550] = true, -- El Ojo
    [564] = true, -- Templo Oscuro
    [565] = true, -- Guarida de Gruul
    [580] = true, -- Meseta de La Fuente del Sol  
 
    -- ==================================================
    -- Wrath of the Lich King
    -- ==================================================
    -- Dungeons
    [574] = true, -- Fortaleza de Utgarde
    [575] = true, -- Pináculo de Utgarde
    [576] = true, -- El Nexo
    [578] = true, -- El Oculus
    [595] = true, -- La Matanza de Stratholme
    [599] = true, -- Cámaras de Piedra
    [600] = true, -- Fortaleza de Drak'Tharon
    [601] = true, -- Azjol-Nerub
    [602] = true, -- Cámaras de Relámpagos
    [604] = true, -- Gundrak
    [608] = true, -- El Bastión Violeta
    [619] = true, -- Ahn'kahet: El Antiguo Reino
    [632] = true, -- La Forja de Almas
    [650] = true, -- Prueba del Campeón
    [658] = true, -- Foso de Saron
    [668] = true, -- Cámaras de Reflexión
    -- Raids
    [249] = true, -- Guarida de Onyxia
    [533] = true, -- Naxxramas
    [603] = true, -- Ulduar
    [615] = true, -- El Sagrario Obsidiana
    [616] = true, -- El Ojo de la Eternidad
    [624] = true, -- La Cámara de Archavon
    [631] = true, -- Ciudadela de la Corona de Hielo
    [649] = true, -- Prueba del Cruzado
    [724] = true, -- El Sagrario Rubí
   
    -- ==================================================
    -- Cataclysm
    -- ==================================================
    -- Dungeons
    [33] = true, -- Castillo de Colmillo Oscuro
    [36] = true, -- Minas de la Muerte
    [568] = true, -- Zul'Aman
    [643] = true, -- Trono de las Mareas
    [644] = true, -- Cámaras de los Orígenes
    [645] = true, -- Cavernas Roca Negra
    [657] = true, -- La Cumbre del Vórtice
    [670] = true, -- Grim Batol
    [725] = true, -- El Núcleo Pétreo
    [755] = true, -- Ciudad Perdida de los Tol'vir
    [859] = true, -- Zul'Gurub
    [938] = true, -- Fin de los Días
    [939] = true, -- Pozo de la Eternidad
    [940] = true, -- Hora del Crepúsculo
    -- Raids
    [669] = true, -- Descenso de Alanegra
    [671] = true, -- El Bastión del Crepúsculo
    [720] = true, -- Tierras de Fuego
    [754] = true, -- Trono de los Cuatro Vientos
    [757] = true, -- Bastión de Baradin
    [967] = true, -- Alma de Dragón
  
    -- ==================================================
    -- Mists of Pandaria
    -- ==================================================
    -- Dungeons
    [959] = true, -- Monasterio del Shadopan
    [960] = true, -- Templo del Dragón de Jade
    [961] = true, -- Cervecería del Trueno
    [962] = true, -- Puerta del Sol Poniente
    [994] = true, -- Palacio Mogu'shan
    [1001] = true, -- Cámaras Escarlata
    [1004] = true, -- Monasterio Escarlata
    [1007] = true, -- Scholomance
    [1011] = true, -- Asedio del Templo de Niuzao
    -- Raids
    [996] = true, -- Pandaria
    [1008] = true, -- Cámaras Mogu'shan
    [1009] = true, -- Corazón del Miedo
    [1098] = true, -- Solio del Trueno
    [1136] = true, -- Asedio de Orgrimmar

    -- ==================================================
    -- Warlords of Draenor
    -- ==================================================
    -- Dungeons
    [1175] = true, -- Minas Machacasangre
    [1176] = true, -- Cementerio de Sombraluna
    [1182] = true, -- Auchindoun
    [1195] = true, -- Puerto de Hierro
    [1208] = true, -- Terminal Malavía
    [1209] = true, -- Trecho Celestial
    [1279] = true, -- El Vergel Eterno
    [1358] = true, -- Cumbre de Roca Negra Superior
    -- Raids
    [1205] = true, -- Fundición Roca Negra
    [1228] = true, -- Draenor
    [1448] = true, -- Ciudadela del Fuego Infernal

    -- ==================================================
    -- Legion
    -- ==================================================
    -- Dungeons
    [1456] = true, -- Ojo de Azshara
    [1458] = true, -- Guarida de Neltharion
    [1466] = true, -- Arboleda Corazón Oscuro
    [1477] = true, -- Cámaras del Valor
    [1492] = true, -- Fauce de Almas
    [1493] = true, -- Cámara de las Celadoras
    [1501] = true, -- Torreón Grajo Negro
    [1516] = true, -- La Arquería
    [1544] = true, -- Asalto al Bastión Violeta
    [1571] = true, -- Corte de las Estrellas
    [1651] = true, -- Regreso a Karazhan
    [1677] = true, -- Catedral de la Noche Eterna
    [1753] = true, -- Trono del Triunvirato
    -- Raids
    [1520] = true, -- Islas Abruptas
    [1530] = true, -- Bastión Nocturno
    [1648] = true, -- Prueba del Valor
    [1676] = true, -- Tumba de Sargeras
    [1712] = true, -- Antorus, el Trono Ardiente

    -- ==================================================
    -- Battle for Azeroth
    -- ==================================================
    -- Dungeons
    [1594] = true, -- VETA MADRE
    [1754] = true, -- Fuerte Libre
    [1762] = true, -- Reposo de los Reyes
    [1763] = true, -- Atal'Dazar
    [1771] = true, -- Tol Dagor
    [1822] = true, -- Asedio de Boralus
    [1841] = true, -- Catacumbas Putrefactas
    [1862] = true, -- Mansión Crestavía
    [1864] = true, -- Altar de la Tormenta
    [1877] = true, -- Templo de Sethraliss
    [2097] = true, -- Operación: Mecandria
    -- Raids
    [1861] = true, -- Azeroth
    [2070] = true, -- Batalla de Dazar'alor
    [2096] = true, -- Crisol de Tormentas
    [2164] = true, -- Palacio Eterno
    [2217] = true, -- Ny'alotha, Ciudad del Despertar
 
    -- ==================================================
    -- Shadowlands
    -- ==================================================
    -- Dungeons
    [2284] = true, -- Cavernas Sanguinas
    [2285] = true, -- Agujas de Ascensión
    [2286] = true, -- Estela Necrótica
    [2287] = true, -- Salas de la Expiación
    [2289] = true, -- Bajapeste
    [2290] = true, -- Nieblas de Tirna Scithe
    [2291] = true, -- El Otro Lado
    [2293] = true, -- Teatro del Dolor
    [2441] = true, -- Tazavesh, el Mercado Velado
    -- Raids
    [2296] = true, -- Castillo de Nathria
    [2450] = true, -- Sagrario de Dominación
    [2481] = true, -- Sepulcro de los Primeros
    [2559] = true, -- Tierras Sombrías
 
    -- ==================================================
    -- Dragonflight
    -- ==================================================
    -- Dungeons
    [2451] = true, -- Uldaman: Legado de Tyr
    [2515] = true, -- Cámara Azur
    [2516] = true, -- La Ofensiva Nokhud
    [2519] = true, -- Neltharus
    [2520] = true, -- Hondonada Frondacuero
    [2521] = true, -- Estanques de Vida Rubí
    [2526] = true, -- Academia Algeth'ar
    [2527] = true, -- Salas de Infusión
    [2579] = true, -- Amanecer del Infinito
    -- Raids
    [2522] = true, -- Cámara de las Encarnaciones
    [2549] = true, -- Amirdrassil, la Esperanza del Sueño
    [2569] = true, -- Aberrus, el Crisol Ensombrecido
    [2574] = true, -- Islas Dragón
 
    -- ==================================================
    -- The War Within
    -- ==================================================
    -- Dungeons
    [2648] = true, -- El Grajero
    [2649] = true, -- Priorato de la Llama Sagrada
    [2651] = true, -- Grieta de Flama Oscura
    [2652] = true, -- La Petrocámara
    [2660] = true, -- Ara-Kara, Ciudad de los Ecos
    [2661] = true, -- Lagar de Tragoceniza
    [2662] = true, -- El Rompealbas
    [2669] = true, -- Ciudad Tejida
    [2773] = true, -- Operación: Compuerta
    [2830] = true, -- Ecodomo Al'dani
    -- Raids
    [2657] = true, -- Palacio Nerub'ar
    [2769] = true, -- Liberación de Minahonda
    [2774] = true, -- Khaz Algar
    [2810] = true, -- Forja de Maná Omega

    -- Delves
    

    -- ==================================================
    -- Midnight
    -- ==================================================
    -- Dungeons
    [2805] = true, -- Aguja Brisaveloz
    [2811] = true, -- Bancal del Magister
    [2813] = true, -- Frontal de la Muerte
    [2825] = true, -- Guarida de Nalorakk
    [2859] = true, -- El Valle Cegador
    [2874] = true, -- Cavernas de Maisara
    [2915] = true, -- Punto de Nexo: Xenas
    [2923] = true, -- Arena Lacravacua
    [2993] = true, -- Altar de los Colmillos
    -- Raids
    [1592] = true, -- Micosis
    [2912] = true, -- La Aguja del Vacío
    [2913] = true, -- Marcha a Quel'Danas
    [2939] = true, -- La Falla Onírica
    [2987] = true, -- La Gruta Mareal
    [3004] = true, -- Abismo Venenoso
    -- Delves
}

function TR.Instances:IsTracked(instanceID)
    return instanceID and self.Tracked[instanceID] == true
end

function TR.Instances:IsWorld(instanceID)
    return not self:IsTracked(instanceID)
end


-- Encounter Journal dump
-- Prints dungeon and raid InstanceIDs grouped by expansion.
-- Usage:
--   /tr instances
--   /tr instances all
--   /tr instances dungeons
--   /tr instances raids
--
-- WoW's Encounter Journal filter is changed temporarily while collecting
-- each expansion and restored afterwards.
local EXPANSIONS = {
    { level = 0,  name = "Classic",                   aliases = { "classic", "vanilla" } },
    { level = 1,  name = "The Burning Crusade",       aliases = { "tbc", "bc", "burningcrusade" } },
    { level = 2,  name = "Wrath of the Lich King",    aliases = { "wotlk", "wrath" } },
    { level = 3,  name = "Cataclysm",                 aliases = { "cata", "cataclysm" } },
    { level = 4,  name = "Mists of Pandaria",         aliases = { "mop", "pandaria" } },
    { level = 5,  name = "Warlords of Draenor",       aliases = { "wod", "draenor" } },
    { level = 6,  name = "Legion",                    aliases = { "legion" } },
    { level = 7,  name = "Battle for Azeroth",        aliases = { "bfa", "battleforazeroth" } },
    { level = 8,  name = "Shadowlands",               aliases = { "sl", "shadowlands" } },
    { level = 9,  name = "Dragonflight",              aliases = { "df", "dragonflight" } },
    { level = 10, name = "The War Within",            aliases = { "tww", "warwithin", "thewarwithin" } },
    { level = 11, name = "Midnight",                  aliases = { "midnight", "mn" } },
}

local function NormalizeExpansionArg(value)
    return (value or ""):lower():gsub("[%s%p_]+", "")
end

local function FindExpansionTier(value)
    local normalized = NormalizeExpansionArg(value)
    if normalized == "" then
        return nil
    end

    for tier, expansion in ipairs(EXPANSIONS) do
        if NormalizeExpansionArg(expansion.name) == normalized then
            return tier
        end

        for _, alias in ipairs(expansion.aliases or {}) do
            if NormalizeExpansionArg(alias) == normalized then
                return tier
            end
        end
    end
end

local function PrintLine(line)
    DEFAULT_CHAT_FRAME:AddMessage(line)
end

local function CollectJournalInstances(isRaid)
    local results = {}
    local index = 1

    while true do
        local journalID, name, _, _, _, _, _, _, _, _, mapID =
            EJ_GetInstanceByIndex(index, isRaid)

        if not journalID then
            break
        end

        if mapID and mapID > 0 then
            results[#results + 1] = {
                id = mapID,
                name = name or ("Journal " .. tostring(journalID)),
            }
        end

        index = index + 1
    end

    table.sort(results, function(a, b)
        if a.id == b.id then
            return a.name < b.name
        end
        return a.id < b.id
    end)

    return results
end

local function PrintInstanceTable(title, entries)
    PrintLine("-- " .. title)

    if #entries == 0 then
        PrintLine("-- (none)")
        return
    end

    local seen = {}
    for _, entry in ipairs(entries) do
        if not seen[entry.id] then
            seen[entry.id] = true
            PrintLine(string.format("[%d] = true, -- %s", entry.id, entry.name))
        end
    end
end


local DELVE_EXPANSION_MAPS = {
    -- Expansion root/continent UiMapIDs are discovered by name where possible.
    -- These labels are intentionally English API-independent fallbacks.
    ["The War Within"] = true,
    ["Midnight"] = true,
}

local function FindExpansionRootMaps()
    local roots = {}

    -- Traverse the cosmic map and collect maps whose localized names match
    -- the expansions we care about. Delve POIs are then queried from every
    -- descendant map.
    if not C_Map or not C_Map.GetMapChildrenInfo then
        return roots
    end

    local cosmicCandidates = { 946, 947 }
    local seen = {}

    local function Walk(mapID)
        if seen[mapID] then return end
        seen[mapID] = true

        local info = C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
        if info and DELVE_EXPANSION_MAPS[info.name] then
            roots[info.name] = info.mapID
        end

        local children = C_Map.GetMapChildrenInfo(mapID, nil, false)
        if children then
            for _, child in ipairs(children) do
                Walk(child.mapID)
            end
        end
    end

    for _, mapID in ipairs(cosmicCandidates) do
        Walk(mapID)
    end

    return roots
end

local function CollectDelvesForExpansion(rootMapID)
    local results = {}
    local seenPOI = {}
    local seenMap = {}

    if not rootMapID or not C_AreaPoiInfo or not C_AreaPoiInfo.GetDelvesForMap then
        return results
    end

    local maps = { rootMapID }

    if C_Map and C_Map.GetMapChildrenInfo then
        local descendants = C_Map.GetMapChildrenInfo(rootMapID, nil, true)
        if descendants then
            for _, info in ipairs(descendants) do
                maps[#maps + 1] = info.mapID
            end
        end
    end

    for _, uiMapID in ipairs(maps) do
        local poiIDs = C_AreaPoiInfo.GetDelvesForMap(uiMapID)
        if poiIDs then
            for _, poiID in ipairs(poiIDs) do
                if not seenPOI[poiID] then
                    seenPOI[poiID] = true

                    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(uiMapID, poiID)
                    if poiInfo then
                        -- The POI's uiMapID identifies the entrance/world map.
                        -- It is useful for discovery, but it is NOT guaranteed
                        -- to equal GetInstanceInfo()'s instanceID.
                        local mapID = poiInfo.uiMapID or uiMapID
                        local key = tostring(mapID) .. ":" .. tostring(poiInfo.name)

                        if not seenMap[key] then
                            seenMap[key] = true
                            results[#results + 1] = {
                                id = mapID,
                                name = poiInfo.name or ("Delve POI " .. tostring(poiID)),
                                poiID = poiID,
                            }
                        end
                    end
                end
            end
        end
    end

    table.sort(results, function(a, b)
        if a.id == b.id then
            return a.name < b.name
        end
        return a.id < b.id
    end)

    return results
end

local function PrintDelveTable(entries)
    PrintLine("-- Delves")
    if #entries == 0 then
        PrintLine("-- (none found)")
        return
    end

    for _, entry in ipairs(entries) do
        PrintLine(string.format(
            "-- uiMapID %d, POI %d -- %s",
            entry.id,
            entry.poiID,
            entry.name
        ))
    end

    PrintLine("-- NOTE: Delve POI uiMapIDs are not guaranteed to be InstanceIDs.")
    PrintLine("-- Use /tr id while inside a Delve to obtain its real GetInstanceInfo() InstanceID.")
end

function TR.Instances:PrintJournalInstances(mode, expansionArg)
    mode = (mode or "all"):lower()

    -- A single expansion name/alias can also be passed as the first argument.
    local requestedTier = FindExpansionTier(expansionArg)
    if not requestedTier then
        local tierFromMode = FindExpansionTier(mode)
        if tierFromMode then
            requestedTier = tierFromMode
            mode = "all"
        end
    end

    local showDungeons = mode == "all" or mode == "" or mode == "dungeons" or mode == "dungeon"
    local showRaids = mode == "all" or mode == "" or mode == "raids" or mode == "raid"
    local showDelves = mode == "all" or mode == "" or mode == "delves" or mode == "delve"

    if expansionArg and not requestedTier then
        PrintLine("|cffffcc00Talent Reminder:|r unknown expansion: " .. tostring(expansionArg))
        PrintLine("/tr instances [expansion] [all|dungeons|raids|delves]")
        return
    end

    if not showDungeons and not showRaids and not showDelves then
        PrintLine("|cffffcc00Talent Reminder:|r /tr instances [expansion] [all|dungeons|raids|delves]")
        return
    end

    if not EJ_GetInstanceByIndex or not EJ_SelectTier then
        PrintLine("|cffff2020Talent Reminder:|r Encounter Journal API unavailable.")
        return
    end

    local oldTier = EJ_GetCurrentTier and EJ_GetCurrentTier() or nil
    local maxTier = EJ_GetNumTiers and EJ_GetNumTiers() or #EXPANSIONS

    PrintLine("|cffffcc00Talent Reminder - InstanceID dump|r")
    PrintLine("-- Generated from WoW APIs")

    local delveRoots = showDelves and FindExpansionRootMaps() or {}

    local firstTier = requestedTier or 1
    local lastTier = requestedTier or maxTier

    for tier = firstTier, math.min(lastTier, maxTier) do
        EJ_SelectTier(tier)

        local expansion = EXPANSIONS[tier]
        local expansionName = expansion and expansion.name or ("Expansion " .. tostring(tier - 1))

        PrintLine(" ")
        PrintLine("-- ==================================================")
        PrintLine("-- " .. expansionName)
        PrintLine("-- ==================================================")

        if showDungeons then
            PrintInstanceTable("-- Dungeons", CollectJournalInstances(false))
        end

        if showRaids then
            PrintInstanceTable("-- Raids", CollectJournalInstances(true))
        end

        if showDelves and (expansionName == "The War Within" or expansionName == "Midnight") then
            PrintDelveTable(CollectDelvesForExpansion(delveRoots[expansionName]))
        end
    end

    if oldTier then
        EJ_SelectTier(oldTier)
    end

    PrintLine(" ")
    PrintLine("|cff00ff00Talent Reminder:|r InstanceID dump finished.")
end
