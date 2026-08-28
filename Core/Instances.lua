local addonName, TR = ...

TR.Instances = {}

TR.Instances.Tracked = {
    [1234] = true,
    [5678] = true,
    [9012] = true,
}

function TR.Instances:IsTracked(instanceID)
    return instanceID and self.Tracked[instanceID] == true
end

function TR.Instances:IsWorld(instanceID)
    return not self:IsTracked(instanceID)
end
