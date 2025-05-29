local isVisible = false
local progressBar = Config.progressbar == 'circle' and lib.progressCircle or lib.progressBar
PlayerPed = cache.ped

lib.onCache('ped', function(newPed)
	PlayerPed = newPed
end)

local pedSpawned = false
local blips = {}

function CreatePeds()
    if pedSpawned then return end
    for k = 1, #Config.peds do
        local coords = Config.peds[k].coords
        local pedPoint = lib.points.new({
            coords = coords,
            distance = 300,
            model = joaat(Config.peds[k].model),
            heading = coords.w,
            ped = nil,
            targetOptions = {{
                name = 'renewed_banking_accountmng',
                event = 'Renewed-Banking:client:accountManagmentMenu',
                icon = 'fas fa-money-check',
                label = locale('manage_bank'),
                atm = false,
                canInteract = function(_, distance)
                    return distance < 4.5 and Config.peds[k].createAccounts
                end
            },{
                name = 'renewed_banking_openui',
                event = 'Renewed-Banking:client:openBankUI',
                icon = 'fas fa-money-check',
                label = locale('view_bank'),
                atm = false,
                canInteract = function(_, distance)
                    return distance < 4.5
                end
            }}
        })

        function pedPoint:onEnter()
            lib.requestModel(self.model, 10000)

            self.ped = CreatePed(0, self.model, self.coords.x, self.coords.y, self.coords.z-1, self.heading, false, false)
            SetEntityHeading(self.ped, self.heading)
            SetModelAsNoLongerNeeded(self.model)

            TaskStartScenarioInPlace(self.ped, 'PROP_HUMAN_STAND_IMPATIENT', 0, true)
            FreezeEntityPosition(self.ped, true)
            SetEntityInvincible(self.ped, true)
            SetBlockingOfNonTemporaryEvents(self.ped, true)
            exports.ox_target:addLocalEntity(self.ped, self.targetOptions)
        end

        function pedPoint:onExit()
            exports.ox_target:removeLocalEntity(self.ped, self.advanced and 'renewed_banking_accountmng' or 'renewed_banking_openui')
            if DoesEntityExist(self.ped) then
                DeletePed(self.ped)
            end
            self.ped = nil
        end

        blips[k] = AddBlipForCoord(coords.x, coords.y, coords.z-1)
        SetBlipSprite(blips[k], 108)
        SetBlipDisplay(blips[k], 4)
        SetBlipScale(blips[k], 0.80)
        SetBlipColour(blips[k], 2)
        SetBlipAsShortRange(blips[k], true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Bank')
        EndTextCommandSetBlipName(blips[k])
    end
    pedSpawned = true
end

function DeletePeds()
    if not pedSpawned then return end
    local points = lib.points.getAllPoints()
    for i = 1, #points do
        if DoesEntityExist(points[i].ped) then
            DeletePed(points[i].ped)
        end
        points[i]:remove()
    end
    for i = 1, #blips do
        RemoveBlip(blips[i])
    end
    pedSpawned = false
end

local function nuiHandler(val)
    isVisible = val
    SetNuiFocus(val, val)
end

local function openBankUI(data)
    local isAtm = data.atm or false
    SendNUIMessage({action = 'setLoading', status = true})
    nuiHandler(true)
    
    TriggerServerEvent('Renewed-Banking:server:getBankData')
end

RegisterNetEvent('Renewed-Banking:client:receiveBankData', function(accounts)
    if not accounts then
        nuiHandler(false)
        TriggerEvent('Renewed-Banking:client:sendNotification', {
            message = locale('loading_failed'),
            title = locale('bank_name'),
            type = 'error'
        })
        return
    end
    SetTimeout(1000, function()
        SendNUIMessage({
            action = 'setVisible',
            status = isVisible,
            accounts = accounts,
            loading = false,
            atm = data and data.atm or false,
            platinumThreshold = Config.platinumThreshold
        })
    end)
end)

RegisterNetEvent('Renewed-Banking:client:openBankUI', function(data)
    local txt = data.atm and locale('open_atm') or locale('open_bank')
    TaskStartScenarioInPlace(PlayerPed, 'PROP_HUMAN_ATM', 0, true)
    if progressBar({
        label = txt,
        duration = math.random(3000,5000),
        position = 'bottom',
        useWhileDead = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false,
        }
    }) then
        openBankUI(data)
        Wait(500)
        ClearPedTasksImmediately(PlayerPed)
    else
        ClearPedTasksImmediately(PlayerPed)
        TriggerEvent('Renewed-Banking:client:sendNotification', {
            message = locale('canceled'),
            title = locale('bank_name'),
            type = 'error'
        })
    end
end)

RegisterNUICallback('closeInterface', function(_, cb)
    nuiHandler(false)
    cb('ok')
end)

RegisterCommand('closeBankUI', function() nuiHandler(false) end, false)

-- Banking Actions
local bankActions = {'deposit', 'withdraw', 'transfer'}
CreateThread(function()
    for k=1, #bankActions do
        RegisterNUICallback(bankActions[k], function(data, cb)
            local newTransaction = lib.callback.await('Renewed-Banking:server:'..bankActions[k], false, data)
            cb(newTransaction)
        end)
    end
    
    -- ATM Target Setup
    exports.ox_target:addModel(Config.atms, {{
        name = 'renewed_banking_openui',
        event = 'Renewed-Banking:client:openBankUI',
        icon = 'fas fa-money-check',
        label = locale('view_bank'),
        atm = true,
        canInteract = function(_, distance)
            return distance < 2.5
        end
    }})
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    exports.ox_target:removeModel(Config.atms, {'renewed_banking_openui'})
    DeletePeds()
end)

-- Notification System
RegisterNetEvent('Renewed-Banking:client:sendNotification', function(msg, notificationType)
    if not msg then return end
    
    local notification
    if type(msg) == "string" then
        notification = {
            message = msg,
            type = notificationType or "info"
        }
    else
        notification = msg
    end
    
    SendNUIMessage({
        action = 'notify',
        status = notification,
    })
end)

-- Account Management
RegisterNetEvent('Renewed-Banking:client:viewAccountsMenu', function()
    TriggerServerEvent('Renewed-Banking:server:getPlayerAccounts')
end)

lib.callback.register('Renewed-Banking:client:checkAccountManagement', function()
    local playerCoords = GetEntityCoords(PlayerPed)
    local canManage = false
    local canCreate = false
    
    for k = 1, #Config.peds do
        local pedCoords = vector3(Config.peds[k].coords.x, Config.peds[k].coords.y, Config.peds[k].coords.z)
        local distance = #(playerCoords - pedCoords)
        
        if distance < 10.0 then
            canManage = true
            canCreate = Config.peds[k].createAccounts or false
            break
        end
    end
    
    return {
        showManagement = canManage,
        canCreateAccounts = canCreate
    }
end)

RegisterNetEvent("Renewed-Banking:client:accountManagmentMenu", function()
    TriggerEvent('Renewed-Banking:client:openBankUI', {atm = false, showManagement = false})
end)

-- Server Event Handlers
RegisterNetEvent('Renewed-Banking:client:getPlayerAccounts', function()
    TriggerServerEvent('Renewed-Banking:server:getPlayerAccounts')
end)

RegisterNetEvent('Renewed-Banking:client:createNewAccount', function(accountId)
    TriggerServerEvent('Renewed-Banking:server:createNewAccount', accountId)
end)

RegisterNetEvent('Renewed-Banking:client:viewMemberManagement', function(data)
    TriggerServerEvent('Renewed-Banking:server:viewMemberManagement', data)
end)

RegisterNetEvent('Renewed-Banking:client:addAccountMember', function(account, memberId)
    TriggerServerEvent('Renewed-Banking:server:addAccountMember', account, memberId)
end)

RegisterNetEvent('Renewed-Banking:client:removeAccountMember', function(data)
    TriggerServerEvent('Renewed-Banking:server:removeAccountMember', data)
end)

RegisterNetEvent('Renewed-Banking:client:changeAccountName', function(account, newName)
    TriggerServerEvent('Renewed-Banking:server:changeAccountName', account, newName)
end)

RegisterNetEvent('Renewed-Banking:client:deleteAccount', function(data)
    TriggerServerEvent('Renewed-Banking:server:deleteAccount', data)
end)

-- NUI Callbacks for Account Management
RegisterNUICallback('Renewed-Banking:client:checkAccountManagement', function(_, cb)
    local playerCoords = GetEntityCoords(PlayerPed)
    local canManage = false
    local canCreate = false
    
    for k = 1, #Config.peds do
        local pedCoords = vector3(Config.peds[k].coords.x, Config.peds[k].coords.y, Config.peds[k].coords.z)
        local distance = #(playerCoords - pedCoords)
        
        if distance < 10.0 then
            canManage = true
            canCreate = Config.peds[k].createAccounts or false
            break
        end
    end
    
    cb({
        showManagement = canManage,
        canCreateAccounts = canCreate
    })
end)

RegisterNUICallback('getMemberManagement', function(data, cb)
    if data and data.account then
        lib.callback('Renewed-Banking:server:getMemberManagement', false, function(response)
            if response then
                cb(response)
            else
                cb({account = data.account, members = {}})
            end
        end, data)
    else
        cb({members = {}})
    end
end)

RegisterNUICallback('Renewed-Banking:client:getPlayerAccounts', function(_, cb)
    lib.callback('Renewed-Banking:server:getPlayerAccounts', false, function(accounts)
        SendNUIMessage({
            action = 'accountsData',
            data = accounts
        })
    end)
    cb('ok')
end)

RegisterNUICallback('Renewed-Banking:client:createNewAccount', function(data, cb)
    TriggerServerEvent('Renewed-Banking:server:createNewAccount', data)
    cb('ok')
end)

RegisterNUICallback('Renewed-Banking:client:addAccountMember', function(data, cb)
    TriggerServerEvent('Renewed-Banking:server:addAccountMember', data.account, data.memberId)
    cb('ok')
end)

RegisterNUICallback('Renewed-Banking:client:removeAccountMember', function(data, cb)
    TriggerServerEvent('Renewed-Banking:server:removeAccountMember', data)
    cb('ok')
end)

RegisterNUICallback('Renewed-Banking:client:changeAccountName', function(data, cb)
    TriggerServerEvent('Renewed-Banking:server:changeAccountName', data.account, data.newName)
    cb('ok')
end)

RegisterNUICallback('Renewed-Banking:client:deleteAccount', function(data, cb)
    TriggerServerEvent('Renewed-Banking:server:deleteAccount', data)
    cb('ok')
end)

RegisterNUICallback('Renewed-Banking:server:getBankData', function(_, cb)
    TriggerServerEvent('Renewed-Banking:server:getBankData')
    cb('ok')
end)