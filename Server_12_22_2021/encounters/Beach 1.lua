local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local sfx = {
    item_get='/server/assets/ezlibs-assets/sfx/item_get.ogg'
}
local default_path="/server/assets/ezlibs-assets/ezencounters/ezencounters.zip"

local give_result_awards = function (player_id,encounter_info,stats)
    -- stats = { health: number, score: number, time: number, ran: bool, emotion: number, turns: number, npcs: { id: String, health: number }[] }
    -- set the player emotion if they left the battle with full sync (1)
    if stats.emotion == 1 then
        Net.set_player_emotion(player_id, stats.emotion)
    else
        Net.set_player_emotion(player_id, 0)
    end
    -- set the player health to whatever they finished the battle with
    Net.set_player_health(player_id,stats.health)
    if stats.ran then
        return -- no rewards for wimps
    end
    local reward_monies = (stats.score*50)
    ezmemory.spend_player_money(player_id,-reward_monies) -- spending money backwards gives money
    Net.message_player(player_id,"Got $"..reward_monies.."!")
    Net.play_sound_for_player(player_id,sfx.item_get)
end

local SomethingFishyThisWaySwims = {
    path=default_path,
    weight=50,
    enemies = {
        {name="Piranha",rank=1},
        {name="Puffy",rank=1},
        {name="Quaker",rank=1}
    },
    positions = {
        {0,0,0,1,0,0},
        {0,0,0,0,2,0},
        {0,0,0,0,0,1}
    },
    {
        {0,0,0,0,0,1},
        {0,0,0,0,2,0},
        {0,0,0,1,0,0}
    },
    {
        {0,0,0,0,0,3},
        {0,0,0,0,2,0},
        {0,0,0,2,0,0}
    },
    {
        {0,0,0,0,0,0},
        {0,0,0,1,3,1},
        {0,0,0,0,0,0}
    },
    {
        {0,0,0,0,0,1},
        {0,0,0,0,1,0},
        {0,0,0,1,0,0}
    },
    {
        {0,0,0,1,0,0},
        {0,0,0,0,1,0},
        {0,0,0,0,0,1}
    },
    {
        {0,0,0,3,0,0},
        {0,0,0,0,0,3},
        {0,0,0,0,3,0}
    },
    results_callback = give_result_awards, --function (player_id,encounter_info,stats)
}


return {
    minimum_steps_before_encounter=60,
    encounter_chance_per_step=0.02,
    encounters={SomethingFishyThisWaySwims}
}