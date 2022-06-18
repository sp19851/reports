local QBCore = exports['qb-core']:GetCoreObject()
local reports = {}

--[[QBCore.Commands.Add('report2', 'Тикет администрации', {}, true, function(source)
    local src = source
    TriggerClientEvent('reports:client:newreport', src)
    --print('args', json.encode(args))
    --[[local description = args[1]
    local caller = QBCore.Functions.GetPlayer(src)
    if description ~= nil then
        TriggerClientEvent('QBCore:Notify', src, 'Тикет отправлен')
        reports[#reports+1] = {
            id = #reports+1,
            callerid = src,
            caller = caller.PlayerData.charinfo.firstname.." ".. caller.PlayerData.charinfo.lastname,
            citizenid = caller.PlayerData.citizenid,
            info = description,
            admin = "none",
            active = true,
            description = ""
        }
        
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player then
                --print('QBCore.Functions.HasPermission', Player.PlayerData.source, QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator'), QBCore.Functions.IsOptin(Player.PlayerData.source))
                if QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator') or IsPlayerAceAllowed(Player.PlayerData.source, 'command') then
                    local t = {}
                    t = {
                        reports = reports,
                        admin = GetPlayerName(Player.PlayerData.source)
                    }
                    --print('reports:client:open', Player.PlayerData.source, json.encode(t))
                    TriggerClientEvent('reports:client:open', Player.PlayerData.source, t)
                   
                    
                end
            end
        end
        
        
        
        
    else 
        TriggerClientEvent('QBCore:Notify', src, 'Вы не заполнили аргумент. Опишите суть вашей проблемы', 'error', 7500)
    end
end)

QBCore.Commands.Add('report3', 'Тикет администрации', {{name='Текст тикета', help='Описание вашей проблемы'}}, true, function(source, args)
    local src = source
    
    --print('args', json.encode(args))
    local description = args[1]
    local caller = QBCore.Functions.GetPlayer(src)
    if description ~= nil then
        TriggerClientEvent('QBCore:Notify', src, 'Тикет отправлен')
        reports[#reports+1] = {
            id = #reports+1,
            callerid = src,
            caller = caller.PlayerData.charinfo.firstname.." ".. caller.PlayerData.charinfo.lastname,
            citizenid = caller.PlayerData.citizenid,
            info = description,
            admin = "none",
            active = true,
            description = ""
        }
        
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player then
                --print('QBCore.Functions.HasPermission', Player.PlayerData.source, QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator'), QBCore.Functions.IsOptin(Player.PlayerData.source))
                if QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator') or IsPlayerAceAllowed(Player.PlayerData.source, 'command') then
                    local t = {}
                    t = {
                        reports = reports,
                        admin = GetPlayerName(Player.PlayerData.source)
                    }
                    --print('reports:client:open', Player.PlayerData.source, json.encode(t))
                    TriggerClientEvent('reports:client:open', Player.PlayerData.source, t)
                   
                    
                end
            end
        end
        
        
        
        
    else 
        TriggerClientEvent('QBCore:Notify', src, 'Вы не заполнили аргумент. Опишите суть вашей проблемы', 'error', 7500)
    end
end)--]]


RegisterServerEvent('reports:server:new')
AddEventHandler('reports:server:new', function(data)
    local src = source
    local description = data.context
    local caller = QBCore.Functions.GetPlayer(src)
    print('reports:server:new', json.encode(data))
    TriggerClientEvent('QBCore:Notify', src, 'Тикет отправлен')
    reports[#reports+1] = {
        id = #reports+1,
        callerid = src,
        caller = caller.PlayerData.charinfo.firstname.." ".. caller.PlayerData.charinfo.lastname,
        citizenid = caller.PlayerData.citizenid,
        info = description,
        admin = "none",
        active = true,
        description = ""
    }
        
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player then
            --print('QBCore.Functions.HasPermission', Player.PlayerData.source, QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator'), QBCore.Functions.IsOptin(Player.PlayerData.source))
            if QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator') or IsPlayerAceAllowed(Player.PlayerData.source, 'command') then
                local t = {}
                t = {
                    reports = reports,
                    admin = GetPlayerName(Player.PlayerData.source)
                }
                --print('reports:client:open', Player.PlayerData.source, json.encode(t))
                TriggerClientEvent('reports:client:open', Player.PlayerData.source, t)
            end
        end
    end
end)

RegisterServerEvent('reports:server:refresh')
AddEventHandler('reports:server:refresh', function(data)
    local src = source
    reports = data.reports
    local caller = data.caller
    --print('caller', json.encode(data), caller)
    if data.type == "attach" then
        TriggerClientEvent('QBCore:Notify', caller, 'Тикет принят к рассмотрению ' ..GetPlayerName(tonumber(src)))
    elseif data.type == "dettach" then
        TriggerClientEvent('QBCore:Notify', caller, 'Ваш тикет передан другому члену команды', "error")
    end
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player then
            if QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator')  then
                --print('reports:client:refresh', Player.PlayerData.source, json.encode(reports))
                TriggerClientEvent('reports:client:refresh', Player.PlayerData.source, reports)
            end
        end
    end
end)

RegisterServerEvent('reports:server:spec')
AddEventHandler('reports:server:spec', function(data)
    local src = source
    reports = data.reports
    local caller = data.caller
    --print('caller', json.encode(data), caller)
    if data.type == "spec" then
        TriggerClientEvent('QBCore:Notify', caller, 'Тикет принят к рассмотрению ' ..GetPlayerName(tonumber(src)))
        
        local targetped = GetPlayerPed(caller)
        local coords = GetEntityCoords(targetped)
        print(caller, targetped, coords)
        TriggerClientEvent('qb-admin:client:spectate', src, caller, coords)
    end
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player then
            if QBCore.Functions.HasPermission(Player.PlayerData.source, 'curator')  then
                --print('reports:client:refresh', Player.PlayerData.source, json.encode(reports))
                TriggerClientEvent('reports:client:refresh', Player.PlayerData.source, reports)
            end
        end
    end
end)



RegisterServerEvent('reports:server:reply')
AddEventHandler('reports:server:reply', function(data)
    local src = source
    local caller = tonumber(data.ticket.callerid)
    local ticketid = data.ticket.id
    print('caller', json.encode(data))
    TriggerClientEvent('QBCore:Notify', caller, 'Ответ на ваш тикет № '..ticketid.. " | "  ..data.answer, "success", 15000)
end)

RegisterServerEvent('reports:server:load')
AddEventHandler('reports:server:load', function()
    local src = source
    print('reports:server:load', QBCore.Functions.HasPermission(src, 'curator') )
    if QBCore.Functions.HasPermission(src, 'curator')  then
        local t = {}
        t = {
            reports = reports,
            admin = GetPlayerName(src)
        }
        --print('reports:client:open', Player.PlayerData.source, json.encode(t))
        TriggerClientEvent('reports:client:open', src, t)
    end
    

end)

