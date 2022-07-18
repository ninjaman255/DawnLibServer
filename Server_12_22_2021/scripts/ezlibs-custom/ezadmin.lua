local admin_script = {}
admin_script.admins = {}
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')

admin_script.players = {}

Net:on("player_join", function(event)
  -- { player_id: string }
  admin_script.players[event.player_id] = true
end)

Net:on("player_disconnect", function(event)
  admin_script.players[event.player_id] = false
end)

Net:on("tile_interaction", function(event)
  -- { player_id: string }
  local button = event.button
  if button == 1 then
    -- Shoulder L
    local admin = event.player_id
    local count = ezmemory.count_player_item(admin, "Admin")
    if count < 1 then return end
    local co = coroutine.create(function()
      local kick_player = Async.await(Async.prompt_player(admin, 60, "Player ID"))
      if kick_player == "ALL PLAYERS" then
        local kick_reason = Async.await(Async.prompt_player(admin, 60, "MASS KICK"))
        for key, value in pairs(admin_script.players) do
          Net.kick_player(key, kick_reason, false)
        end
      elseif admin_script.players[kick_player] ~= nil then
        local kick_reason = Async.await(Async.prompt_player(admin, 60, "You've been kicked by an admin."))
        Net.kick_player(kick_player, kick_reason, false)
      else
        local mug = Net.get_player_mugshot(admin)
        Net.message_player(admin, "Hmm...they don't seem to be online...", mug.texture_path, mug.animation_path)
      end
    end)
    return Async.promisify(co)
  end
end)

return admin_script