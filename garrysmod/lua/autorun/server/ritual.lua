local gravityTable = { '400', '500', '600', '700', '800', '850', '900' }
local propForceTable = { '110', '220', '330' }
local propBaseTable = { '8', '12', '15', '18', '3' }

local function onRitualDeath ( ply )
  local choiceOne = math.random( 1, 7 )
  local choiceTwo = math.random( 1, 3 )
  local choiceThree = math.random( 1, 5 )
  print( "onRitualDeath: changing gravity to", gravityTable[choiceOne] )
  print( "onRitualDeath: changing prop force to", propForceTable[choiceTwo] )
  print( "onRitualDeath: changing prop base to", propBaseTable[choiceThree] )
  RunConsoleCommand( "sv_gravity", gravityTable[choiceOne] )
  RunConsoleCommand( "ttt_spec_prop_force", propForceTable[choiceTwo] )
  RunConsoleCommand( "ttt_spec_prop_base", propBaseTable[choiceThree] )
end

hook.Add( "PostPlayerDeath", "ritualHook", onRitualDeath )