local mod = require("scripts.stageapi.mod")
local shared = require("scripts.stageapi.shared")

-- load on game start, as mmc is loaded before

local Loaded = false

local function LoadMMCCompat()
    if Loaded then return end

    StageAPI.MMC_ENABLED = not not MMC

    if StageAPI.MMC_ENABLED then
        StageAPI.LogMinor("Late loading MMC Compat...")

        -- Replace with MMC version
        shared.Music = MMC.Manager()

        local function GetKeyFromValue(tbl, value)
            for k, v in pairs(tbl) do
                if v == value then
                    return k
                end
            end
            return nil
        end

        local toStopOverriding = {}

        -- MMC replaces the music enum, so readd the tracks to no override
        for _, noOverrideEntry in ipairs(StageAPI.NonOverrideMusic) do
            local id, canOverrideQueue, neverOverrideQueue
            if type(noOverrideEntry) == "number" then
                id = noOverrideEntry
            else
                id, canOverrideQueue, neverOverrideQueue = 
                    noOverrideEntry[1], noOverrideEntry[2], noOverrideEntry[3]
            end
            local key = GetKeyFromValue(MusicPreMMC, id)
            if key and Music[key] ~= MusicPreMMC[key] then
                toStopOverriding[#toStopOverriding+1] = {Music[key], canOverrideQueue, neverOverrideQueue}
            end
        end

        for _, entry in ipairs(toStopOverriding) do
            StageAPI.StopOverridingMusic(table.unpack(entry, 1, 3))
        end
    end
    
    Loaded = true
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, LoadMMCCompat)