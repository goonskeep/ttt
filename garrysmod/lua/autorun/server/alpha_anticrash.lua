-- prototype anticrash
local sysTime=SysTime()
hook.Add("Tick", "AutoAntiCrashSystem", function()
  local P=(engine.TickInterval()/(SysTime()-sysTime))
  sysTime=SysTime()
  if P<0.1 then
    local Ents1=ents.FindByClass( "prop_physics" )
    local Ents2=ents.FindByClass( "prop_ragdoll" )
    for k, v in pairs( Ents1 ) do
      local phys=v:GetPhysicsObject()
      phys:EnableMotion(false)
    end
    for k, v in pairs( Ents2 ) do
      local phys=v:GetPhysicsObject()
      phys:EnableMotion(false)
    end
  end
end)