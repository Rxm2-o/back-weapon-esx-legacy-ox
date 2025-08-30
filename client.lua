local weaponsOnBack = {}

-- Table des modèles 3D des armes
local weaponModels = {
    ["pistol"] = "w_pi_pistol",
    ["smg"] = "w_sb_smg",
    ["carbinerifle"] = "w_ar_carbinerifle"
}

-- Animation pour ranger / sortir l’arme
local function PlayAnimation(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, 1.0, duration or 1000, 48, 0, false, false, false)
end

-- Attacher arme au dos
local function AttachWeaponToBack(weaponName)
    local playerPed = PlayerPedId()
    if weaponsOnBack[weaponName] then return end

    local model = GetHashKey(weaponModels[weaponName])
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    local weaponObject = CreateObject(model, 1.0, 1.0, 1.0, true, true, false)
    AttachEntityToEntity(weaponObject, playerPed, GetPedBoneIndex(playerPed, 24817), -- spine_1
    0.0, -0.20, -0.10,   -- X, Y, Z
    180.0, 0.0, 0.0,     -- rotation
    true, true, false, true, 1, true)



    weaponsOnBack[weaponName] = weaponObject
end

-- Détacher arme du dos
local function DetachWeaponFromBack(weaponName)
    if weaponsOnBack[weaponName] then
        DeleteEntity(weaponsOnBack[weaponName])
        weaponsOnBack[weaponName] = nil
    end
end

-- Quand une arme est équipée via ox_inventory
RegisterNetEvent('ox_inventory:useItem')
AddEventHandler('ox_inventory:useItem', function(item)
    if weaponModels[item] then
        DetachWeaponFromBack(item)
        PlayAnimation("reaction@intimidation@cop@unarmed", "intro", 1000)
        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_"..string.upper(item)), 100, false, true)
    end
end)

-- Quand une arme est retirée/rangée
RegisterNetEvent('ox_inventory:removeItem')
AddEventHandler('ox_inventory:removeItem', function(item)
    if weaponModels[item] then
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_"..string.upper(item)))
        PlayAnimation("reaction@intimidation@cop@unarmed", "outro", 1000)
        AttachWeaponToBack(item)
    end
end)

-- Touche G pour ranger/sortir une arme
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(playerPed)

        if IsControlJustReleased(0, 47) then -- G
            if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
                -- Ranger l’arme dans le dos avec animation
                for k, v in pairs(weaponModels) do
                    if GetHashKey("WEAPON_"..string.upper(k)) == currentWeapon then
                        PlayAnimation("reaction@intimidation@cop@unarmed", "outro", 1000)
                        AttachWeaponToBack(k)
                        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
                        break
                    end
                end
            else
                -- Sortir la première arme du dos avec animation
                for weaponName, _ in pairs(weaponsOnBack) do
                    DetachWeaponFromBack(weaponName)
                    PlayAnimation("reaction@intimidation@cop@unarmed", "intro", 1000)
                    GiveWeaponToPed(playerPed, GetHashKey("WEAPON_"..string.upper(weaponName)), 100, false, true)
                    break
                end
            end
        end
    end
end)
