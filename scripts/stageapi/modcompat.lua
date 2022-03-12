StageAPI.LogMinor("Loading Mod Compat")

local subModules = {
    "minimapAPI",
    "musicModCallback",
}

for _, subModule in ipairs(subModules) do
    include("scripts.stageapi.modcompat." .. subModule)
end