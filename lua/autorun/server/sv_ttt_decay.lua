--[[
first addon / first version:
https://steamcommunity.com/sharedfiles/filedetails/?id=654614811

fork of the previous / second version:
https://steamcommunity.com/sharedfiles/filedetails/?id=1605903001

This is the third iteration and forked from the second, done by https://github.com/06000208 for GK

v3.6

--]]

CreateConVar("ttt_decay_time", 60, bit.bor(FCVAR_NOTIFY,FCVAR_ARCHIVE),"How many seconds a body must be unidentified before decaying.")
CreateConVar("ttt_decay_skeleton_time", 60, bit.bor(FCVAR_NOTIFY,FCVAR_ARCHIVE),"How many additional seconds a decayed body must be unidentified before turning into a skeleton.")

timer.Create("TTT_Decay_Timer", 5, 0, function()
  local st = GetConVar("ttt_decay_time"):GetInt();
  local stt = st + GetConVar("ttt_decay_skeleton_time"):GetInt();
  for k,v in pairs(ents.FindByClass("prop_ragdoll")) do 
    if (v.player_ragdoll) then
      if (v.ttt_decay and v.ttt_decay >= st) and !CORPSE.GetFound(v) then
        v:EmitSound("ambient/creatures/flies" .. math.random(1,5) .. ".wav",60,95);
        if not v.ttt_decay_rotten or (not v.ttt_decay_skeleton and v.ttt_decay > stt and stt != st) then

	        local rag = ents.Create("prop_ragdoll")
	        rag:SetModel(v.ttt_decay_rotten and "models/player/skeleton.mdl" or "models/player/charple.mdl");
          rag:SetPos(v:GetPos())
          rag:SetAngles(v:GetAngles())
          rag:Spawn()
          rag:SetCollisionGroup(COLLISION_GROUP_WEAPON);

          if (v.ttt_decay_rotten) then 
            rag.ttt_decay_skeleton = true 
          end

          rag:SetSkin(2);
          rag.was_role = v.was_role
          rag.equipment = v.equipment or EQUIP_NONE
          rag.bomb_wire = v.bomb_wire or -1
          rag.dtime = v.dtime
          rag.uqid = v.uqid
          rag.sid = v.sid
          rag.kills = {}

          if IsValid(player.GetByUniqueID(rag.uqid)) then 
            CORPSE.SetPlayerNick(rag, player.GetByUniqueID(rag.uqid));
          end

          rag.CanUseKey = true;

          function rag:UseOverride(ply)
            if (self.ttt_decay_skeleton) then
              ply:SendLua("local ply = LocalPlayer() ply:EmitSound('plats/platstop1.wav', 100, 90) chat.AddText( Color( 255,220, 0 ), 'This body has completely rotted away... Theres no way to identify this.' )");
            else
              if (ply:HasWeapon( 'weapon_ttt_wtester' )) then
                CORPSE.ShowSearch(ply, self, (ply:KeyDown(IN_WALK) or ply:KeyDownLast(IN_WALK)))
              else
                ply:SendLua("local ply = LocalPlayer() ply:EmitSound('plats/platstop1.wav', 100, 90) chat.AddText( Color( 255,220, 0 ), 'This body is rotting away before your very eyes... You might be able to identify it with a dna scanner, but only if you hurry.' )");
              end
            end
          end

          rag.ttt_decay_rotten = true;
          rag.ttt_decay = v.ttt_decay;
          rag.player_ragdoll = true;
          -- position the bones
          local num = rag:GetPhysicsObjectCount()-1
          local ve =  v:GetVelocity() 

          for i=0, num do
            local bone = rag:GetPhysicsObjectNum(i)
            if IsValid(bone) then
              local bp, ba = v:GetBonePosition(rag:TranslatePhysBoneToBone(i))
              if bp and ba then
                bone:SetPos(bp)
                bone:SetAngles(ba)
              end
            end
          end

          rag:Fire("disablemotion");
          rag:Fire("enablemotion", "", 1);
          v:Remove();
        end
      end
      v.ttt_decay = (v.ttt_decay or 0) + 5
    end
  end
end);
