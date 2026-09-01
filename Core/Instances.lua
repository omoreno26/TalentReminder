local addonName, TR = ...

TR.Instances = {}

-- InstanceIDs grouped by expansion.
-- Some IDs intentionally exist in more than one expansion when an instance was reworked.
TR.Instances.ByExpansion = {
    -- Classic
    CLASSIC = {
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
        [409] = true, -- Núcleo de magma
        [469] = true, -- Guarida de Alanegra
        [509] = true, -- Ruinas de Ahn'Qiraj
        [531] = true, -- Templo de Ahn'Qiraj
        [2792] = true, -- Profundidades de Roca Negra
    },

    -- The Burning Crusade
    TBC = {
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
        [532] = true, -- Karazhan
        [534] = true, -- La Batalla del Monte Hyjal
        [544] = true, -- Guarida de Magtheridon
        [548] = true, -- Caverna Santuario Serpiente
        [550] = true, -- El Ojo
        [564] = true, -- Templo Oscuro
        [565] = true, -- Guarida de Gruul
        [580] = true, -- Meseta de La Fuente del Sol
    },

    -- Wrath of the Lich King
    WOTLK = {
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
        [249] = true, -- Guarida de Onyxia
        [533] = true, -- Naxxramas
        [603] = true, -- Ulduar
        [615] = true, -- El Sagrario Obsidiana
        [616] = true, -- El Ojo de la Eternidad
        [624] = true, -- La Cámara de Archavon
        [631] = true, -- Ciudadela de la Corona de Hielo
        [649] = true, -- Prueba del Cruzado
        [724] = true, -- El Sagrario Rubí
    },

    -- Cataclysm
    CATACLYSM = {
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
        [669] = true, -- Descenso de Alanegra
        [671] = true, -- El Bastión del Crepúsculo
        [720] = true, -- Tierras de Fuego
        [754] = true, -- Trono de los Cuatro Vientos
        [757] = true, -- Bastión de Baradin
        [967] = true, -- Alma de Dragón
    },

    -- Mists of Pandaria
    MOP = {
        [959] = true, -- Monasterio del Shadopan
        [960] = true, -- Templo del Dragón de Jade
        [961] = true, -- Cervecería del Trueno
        [962] = true, -- Puerta del Sol Poniente
        [994] = true, -- Palacio Mogu'shan
        [1001] = true, -- Cámaras Escarlata
        [1004] = true, -- Monasterio Escarlata
        [1007] = true, -- Scholomance
        [1011] = true, -- Asedio del Templo de Niuzao
        [1008] = true, -- Cámaras Mogu'shan
        [1009] = true, -- Corazón del Miedo
        [996] = true, -- Veranda de la Primavera Eterna
        [1098] = true, -- Solio del Trueno
        [1136] = true, -- Asedio de Orgrimmar
    },

    -- Warlords of Draenor
    WOD = {
        [1175] = true, -- Minas Machacasangre
        [1176] = true, -- Cementerio de Sombraluna
        [1182] = true, -- Auchindoun
        [1195] = true, -- Puerto de Hierro
        [1208] = true, -- Terminal Malavía
        [1209] = true, -- Trecho Celestial
        [1279] = true, -- El Vergel Eterno
        [1358] = true, -- Cumbre de Roca Negra Superior
        [1228] = true, -- Ogrópolis
        [1205] = true, -- Fundición Roca Negra
        [1448] = true, -- Ciudadela del Fuego Infernal
    },

    -- Legion
    LEGION = {
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
        [1520] = true, -- Pesadilla Esmeralda
        [1530] = true, -- Bastión Nocturno
        [1648] = true, -- Prueba del Valor
        [1676] = true, -- Tumba de Sargeras
        [1712] = true, -- Antorus, el Trono Ardiente
    },

    -- Battle for Azeroth
    BFA = {
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
        [1861] = true, -- Uldir
        [2070] = true, -- Batalla de Dazar'alor
        [2096] = true, -- Crisol de Tormentas
        [2164] = true, -- Palacio Eterno
        [2217] = true, -- Ny'alotha, Ciudad del Despertar
    },

    -- Shadowlands
    SHADOWLANDS = {
        [2284] = true, -- Cavernas Sanguinas
        [2285] = true, -- Agujas de Ascensión
        [2286] = true, -- Estela Necrótica
        [2287] = true, -- Salas de la Expiación
        [2289] = true, -- Bajapeste
        [2290] = true, -- Nieblas de Tirna Scithe
        [2291] = true, -- El Otro Lado
        [2293] = true, -- Teatro del Dolor
        [2441] = true, -- Tazavesh, el Mercado Velado
        [2296] = true, -- Castillo de Nathria
        [2450] = true, -- Sagrario de Dominación
        [2481] = true, -- Sepulcro de los Primeros
    },

    -- Dragonflight
    DRAGONFLIGHT = {
        [2451] = true, -- Uldaman: Legado de Tyr
        [2515] = true, -- Cámara Azur
        [2516] = true, -- La Ofensiva Nokhud
        [2519] = true, -- Neltharus
        [2520] = true, -- Hondonada Frondacuero
        [2521] = true, -- Estanques de Vida Rubí
        [2526] = true, -- Academia Algeth'ar
        [2527] = true, -- Salas de Infusión
        [2579] = true, -- Amanecer del Infinito
        [2522] = true, -- Cámara de las Encarnaciones
        [2549] = true, -- Amirdrassil, la Esperanza del Sueño
        [2569] = true, -- Aberrus, el Crisol Ensombrecido
    },

    -- The War Within
    TWW = {
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
        [2657] = true, -- Palacio Nerub'ar
        [2769] = true, -- Liberación de Minahonda
        [2810] = true, -- Forja de Maná Omega
        [2680] = true, -- Minas Reptaterra
        [2664] = true, -- Capricho Fúngico
        [2681] = true, -- Reposo de Kriegval
        [2684] = true, -- Foso del Pavor
        [2683] = true, -- Estación de Bombeo
        [2679] = true, -- Caverna del Micomante
        [2687] = true, -- Sumidero
        [2686] = true, -- Sagrario del Ocaso
        [2688] = true, -- Espiral Serpenteante
        [2689] = true, -- Abismo de Tak-Rethan
        [2690] = true, -- El Infrastillo
        [2682] = true, -- Guarida de Zekvir
        [2815] = true, -- Excavación 9
        [2826] = true, -- Canal Callejero
        [2831] = true, -- Cúpula de Demolición
        [2803] = true, -- Asalto Archivístico
        [2951] = true, -- Santuario Filovacío
    },

    -- Midnight
    MIDNIGHT = {
        [2805] = true, -- Aguja Brisaveloz
        [2811] = true, -- Bancal del Magister
        [2813] = true, -- Frontal de la Muerte
        [2825] = true, -- Guarida de Nalorakk
        [2859] = true, -- El Valle Cegador
        [2874] = true, -- Cavernas de Maisara
        [2915] = true, -- Punto de Nexo: Xenas
        [2923] = true, -- Arena Lacravacua
        [2993] = true, -- Altar de los Colmillos
        [1592] = true, -- Micosis
        [2912] = true, -- La Aguja del Vacío
        [2913] = true, -- Marcha a Quel'Danas
        [2939] = true, -- La Falla Onírica
        [2987] = true, -- La Gruta Mareal
        [3004] = true, -- Abismo Venenoso
        [2933] = true, -- Calamidad de Colegiado
        [2953] = true, -- Plaza del Parhelio
        [2962] = true, -- Atal'Aman
        [2952] = true, -- Enclave Sombrío
        [2961] = true, -- Criptas Crepusculares
        [2963] = true, -- Foso de los Agravios
        [2964] = true, -- Abismo del Recuerdo
        [2963] = true, -- Foso de los Agravios
        [2965] = true, -- Sagrario Matasoles
        [2979] = true, -- Punto de la Guarida de las Sombras
        [2966] = true, -- Altar del Tormento        
        [3077] = true, -- Circulo de la Gloria
        [3038] = true, -- Isla Gnaldor
        [3079] = true, -- Cascadas Lluevenono
    },

    -- Temporada actual / Current Season
    -- Este grupo es independiente de la expansión original de la instancia.
    CURRENT_SEASON = {
        [2993] = true, -- Altar de los Colmillos
        [2825] = true, -- Guarida de Nalorakk
        [2813] = true, -- Frontal de la Muerte
        [2859] = true, -- El Valle Cegador
        [2923] = true, -- Arena Lacravacua
        [1762] = true, -- Reposo de los Reyes
        [2521] = true, -- Estanques de Vida Rubí
        [1877] = true, -- Templo de Sethraliss
        [2987] = true, -- La Gruta Mareal
        [3004] = true, -- Abismo Venenoso 
    },

}

function TR.Instances:IsTracked(instanceID)
    if not instanceID then
        return false
    end

    for expansion, instances in pairs(self.ByExpansion) do
        if instances[instanceID] then
            -- If an InstanceID belongs to more than one expansion (rework),
            -- it is tracked when at least one of those expansions is enabled.
            if not TalentReminderDB.expansions or TalentReminderDB.expansions[expansion] ~= false then
                return true
            end
        end
    end

    return false
end

function TR.Instances:IsWorld()
    local inInstance, instanceType = IsInInstance()
    return not inInstance and instanceType == "none"
end
