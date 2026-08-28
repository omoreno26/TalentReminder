local addonName, TR = ...

TR.Defaults = {
    message = "TALENT REMINDER!",
    fontSize = 36,
    textColor = { r = 1, g = 1, b = 1 },
    duration = 5.0,
    fadeTime = 1.0,
    remindInWorld = false,

    soundType = "WOW",
    soundValue = "RAID_WARNING",

    point = "CENTER",
    relativePoint = "CENTER",
    posX = 0,
    posY = 150,
}

function TR:CopyDefaults(source, destination)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(destination[key]) ~= "table" then
                destination[key] = {}
            end
            self:CopyDefaults(value, destination[key])
        elseif destination[key] == nil then
            destination[key] = value
        end
    end
end
