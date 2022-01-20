local ESX

TriggerEvent("esx:getSharedObject", function(lib) ESX = lib end)


local function getPlayerNameWhereIdentifier(identifier)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            fullName = result[1].firstname.." "..result[1].lastname
        else
            fullName = "Inconnu"
        end
    end)
    return fullName
end


ESX.RegisterServerCallback('rPermisPoint:getAllLicenses', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
        local allLicenses = {}
        MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {['owner'] = xPlayer.identifier}, function(result)
            for k,v in pairs(result) do
                table.insert(allLicenses, {
                    Name = xPlayer.getName(),
                    Type = v.type,
                    Point = v.point,
                    Owner = v.owner
                })
            end
            cb(allLicenses)
        end)
    end)


ESX.RegisterServerCallback('rPermisPoint:getLicenses', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local mylicense = {}
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        for k,v in pairs(result) do
                table.insert(mylicense, {
                    Name = xPlayer.getName(),
                    Type = v.type,
                    Point = v.point,
                    Owner = v.owner
                })
        end
        cb(mylicense)
    end)
end)


RegisterServerEvent('rPermisPoint:addPoint')
AddEventHandler('rPermisPoint:addPoint', function(permis, qty, owner)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE type = @type AND owner = @owner', {['type'] = permis, ['owner'] = owner}, function(result)

    if result[1].point + qty < 13 then

    MySQL.Async.fetchAll("UPDATE user_licenses SET point = @point WHERE owner = @owner AND type = @type",
    {
      ['point'] = result[1].point + qty,
      ['owner'] = owner,
      ['type'] = permis
    },
    function(result)
        TriggerClientEvent('esx:showNotification', _src, "Vous avez ajouté "..qty.." point(s) à ~y~"..ESX.GetPlayerFromIdentifier(owner).getName())
    end)
else
    TriggerClientEvent('esx:showNotification', _src, "Vous pouvez pas mettre plus que 12 point ~r~!")
end
end)
end)


RegisterServerEvent('rPermisPoint:removePoint')
AddEventHandler('rPermisPoint:removePoint', function(permis, qty, owner)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE type = @type AND owner = @owner', {['type'] = permis, ['owner'] = owner}, function(result)

    if result[1].point - qty > -1 then

    MySQL.Async.fetchAll("UPDATE user_licenses SET point = @point WHERE owner = @owner AND type = @type",
    {
      ['point'] = result[1].point - qty,
      ['owner'] = owner,
      ['type'] = permis
    },
    function(R)
        TriggerClientEvent('esx:showNotification', _src, "Vous avez retier "..qty.." point(s) à ~y~"..ESX.GetPlayerFromIdentifier(owner).getName())
        if result[1].point - qty == 0 then
            MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner AND type = @type', {['type'] = permis, ['owner'] = owner})
            TriggerClientEvent('esx:showNotification', _src, "La licence de "..ESX.GetPlayerFromIdentifier(owner).getName().." a été retiré car il avait 0 point")
        end
    end)
else
    TriggerClientEvent('esx:showNotification', _src, "Vous pouvez pas mettre moins que 0 point ~r~!")
end
end)
end)



ESX.RegisterServerCallback('rPermisPoint:getAllLicensesForPlayer', function(source, cb)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local allLicensesForMe = {}
    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {['owner'] = xPlayer.identifier}, function(result)
        for k,v in pairs(result) do
            if v.type ~= "dmv" then
                table.insert(allLicensesForMe, {
                    Type = v.type,
                    Point = v.point
                })
            end
        end
        cb(allLicensesForMe)
    end)
end)