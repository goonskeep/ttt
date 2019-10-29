local jumpHeight = GetConVar("ttt_default_jumppower"):GetInt()

hook.Add("PlayerShouldTaunt", "TauntReenable", function()
    return true
end)
  
hook.Add("PlayerStartTaunt", "TauntFreeze", function(ply, act, length)
    local currentWeapon = ply:GetActiveWeapon():GetClass()
    ply.isTaunting = true
    ply:SetActiveWeapon( "weapon_ttt_unarmed" ) -- SelectWeapon() doesn't work, dont know why but this works 
    ply:SetJumpPower( 0 )
    ply:ConCommand("ulx thirdperson") -- fix: just toggles thirdperson, if someones already in thirdperson they get switched to firstperson. would use the regular source thirdperson concommand, but thats blocked by sv_cheats.
    timer.Create("tauntTimer", length, 1, function() zActFinish(ply) end)
end)

hook.Add("PlayerSwitchWeapon", "TauntCheckWepSwitch", function(ply, oldWeapon, newWeapon)
    if newWeapon:GetSlot() ~= 5 and ply.isTaunting == true then 
        return true
    end
end)

hook.Add( "Move", "TauntMoveCheck", function(ply, mv)
    if ply.isTaunting == true then
        mv:SetForwardSpeed( 0 )
        mv:SetSideSpeed( 0 )
    end
end)

hook.Add( "PlayerDeath", "TauntDeathFix", function(ply, inflictor, attacker)
    if ply.isTaunting == true then
        zActFinish(ply)
    end
end)

hook.Add( "TTTPrepareRound", "TauntSpawnFix", function()
    for k, v in pairs( player.GetAll() ) do
        v.isTaunting = false
	end
end)

function zActFinish(ply)
    if timer.Exists("tauntTimer") then -- just incase a timer is still running on death.
        timer.Stop("tauntTimer")
    end
    ply.isTaunting = false
    ply:SelectWeapon( currentWeapon )
    ply:SetJumpPower( jumpHeight )
    ply:ConCommand("ulx thirdperson")
end