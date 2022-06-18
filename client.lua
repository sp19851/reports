Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

local QBCore = exports['qb-core']:GetCoreObject()
local inUIPage = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
   TriggerServerEvent("reports:server:load")
end)

RegisterNetEvent("reports:client:newreport")
AddEventHandler("reports:client:newreport", function()
    print('inUIPage', inUIPage)
    if not inUIPage then
        SendNUIMessage({
            action = "newreport",
        })
        SetNuiFocus(true, true)
        inUIPage = true
    end
end)

RegisterNetEvent("reports:client:open")
AddEventHandler("reports:client:open", function(data)

    --if not inUIPage then
        SendNUIMessage({
            action = "open",
            reports = data.reports,
            admin = data.admin
            
            
        })
        --SetNuiFocus(true, true)
        --inUIPage = true
    --end
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    inUIPage = false
    
end)

RegisterNUICallback('new', function(data)
    inUIPage = false
    print('new', json.encode(data))
    SetNuiFocus(false, false)
    Wait(100)
    TriggerServerEvent('reports:server:new', data)
end)


RegisterNUICallback('cancelticket', function()
    SetNuiFocus(false, false)
    inUIPage = false
    
end)


RegisterNUICallback('refresh', function(data)
    --print('RegisterNUICallback refresh', json.encode(data))
    TriggerServerEvent('reports:server:refresh', data)
end)

RegisterNUICallback('reply', function(data)
    --print('RegisterNUICallback reply', json.encode(data))
    local targetPed = data.caller
   
    TriggerServerEvent('reports:server:reply', data)
end)

RegisterNUICallback('spec', function(data)
    --print('RegisterNUICallback spec', json.encode(data))
    --local targetPed = tonumber(data.caller)
    TriggerServerEvent('reports:server:spec', data)
    --TriggerEvent('qb-admin:client:spectate', targetPed)
end)

RegisterNUICallback('notify', function(data)
    QBCore.Functions.Notify(data.content, 'error')
end)

RegisterNetEvent("reports:client:refresh")
AddEventHandler("reports:client:refresh", function(reports)
    SendNUIMessage({
        action = "refresh",
        reports = reports,
    })
end)

RegisterCommand('+playerfocusreports', function()
    --if headerShown then
        SetNuiFocus(true, true)
    --end
end)

RegisterKeyMapping('+playerfocusreports', 'Give Menu Focus', 'keyboard', 'h')