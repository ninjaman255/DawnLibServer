local eznpcs = require('scripts/ezlibs-scripts/eznpcs/eznpcs')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local ezmystery = require('scripts/ezlibs-scripts/ezmystery')
local ezweather = require('scripts/ezlibs-scripts/ezweather')
local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local ezencounters = require('scripts/ezlibs-scripts/ezencounters/main')
local helpers = require('scripts/ezlibs-scripts/helpers')
local LibPlugin = require('scripts/ezlibs-custom/nebulous-liberations/main')
local CustPlugin = require('scripts/ezlibs-custom/custom')
local naviNames = helpers.safe_require('scripts/ezlibs-custom/navi_names')
local ezshortcuts = helpers.safe_require('scripts/ezlibs-custom/ezshortcuts')

local liberation_item_list = {
	{n="LongSwrd",d="A Long Sword Chip. Use it in Liberations!"},
	{n="WideSwrd",d="A Wide Sword Chip. Use it in Liberations!"},
	{n="OldSaber",d="A Saber projection hilt, scarred with age. Use it in Liberations!"},
	{n="HevyShld",d="A heavy shield, great for defense. Use it in Liberations!"},
	{n="HexScyth",d="A wicked scythe which cleaves most anything. Use it in Liberations!"},
	{n="NumGadgt",d="A gadget that's constantly calculating outcomes. Use it in Liberations!"},
	{n="GutsHamr",d="A hammer that takes guts to wield. Use it in Liberations!"},
	{n="ShdwShoe",d="Delicate shoes that let you walk on air. Wear them in Liberations!"}
}

local CreateCheckpointEvent = {
	name = "Create Checkpoint",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local pos = Net.get_player_position(player_id)
			ezshortcuts.create_checkpoint(player_id,pos.x,pos.y,pos.z,false)
		end)
	end
}

local RematchProgEvent ={
	name = "Refight Liberation",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			return LibPlugin.start_game_for_player(player_id, dialogue.custom_properties["Liberation Map"])
		end)
	end
}

local FightGutsmanEvent = {
	name = "Gutsman Battle",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			ezmemory.create_or_update_item("GutsProof","Proof of Gutsman's defeat.",false)
			local results = Async.await(Async.initiate_encounter(player_id, "/server/assets/encounters/dependencies/com_Thor_Gutsman_V1.zip", {}))
			if not results.ran and results.health > 0 then
				ezmemory.give_player_item(player_id,"GutsProof",1)
				local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
				Net.message_player(player_id, "N-No way, guts!", mug.texture_path, mug.animation_path)
				Net.message_player(player_id, "Y-You're dead,\n"..naviNames.player_navi_names[player_id].."!", mug.texture_path, mug.animation_path)
			end
		end)
	end
}

local FightGutsmanV2Event = {
	name = "Gutsman V2 Battle",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			ezmemory.create_or_update_item("GutsShame","Proof of Gutsman's shameful defeat.",false)
			local results = Async.await(Async.initiate_encounter(player_id, "/server/assets/encounters/dependencies/com_Thor_Gutsman_V2.zip", {}))
			if not results.ran and results.health > 0 then
				ezmemory.give_player_item(player_id,"GutsShame",1)
				local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
				Net.message_player(player_id, "S-So shameful, guts...!", mug.texture_path, mug.animation_path)
				Net.message_player(player_id, "H-How are you\nso strong,\n"..naviNames.player_navi_names[player_id].."!?", mug.texture_path, mug.animation_path)
			end
		end)
	end
}

local FightGutsmanV3Event = {
	name = "Gutsman V3 Battle",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			ezmemory.create_or_update_item("GutsRage","Proof of Gutsman's rage.",false)
			local results = Async.await(Async.initiate_encounter(player_id, "/server/assets/encounters/dependencies/com_Thor_Gutsman_V3.zip", {}))
			if not results.ran and results.health > 0 then
				ezmemory.give_player_item(player_id,"GutsRage",1)
				local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
				Net.message_player(player_id, "I-I'll get you next time, guts!", mug.texture_path, mug.animation_path)
			end
		end)
	end
}

local FightGutsmanV4Event = {
	name = "Gutsman V4 Battle",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			ezmemory.create_or_update_item("GutsHamr","A hammer that takes guts to wield. Use it in Liberations!",true)
			ezmemory.create_or_update_item("GutsBadge","Proof of understanding Gutsman.",false)
			local results = Async.await(Async.initiate_encounter(player_id, "/server/assets/encounters/dependencies/com_Thor_Gutsman_V4.zip", {}))
			if results and not results.ran and results.health > 0 then
				ezmemory.give_player_item(player_id,"GutsBadge",1)
				local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
				Net.message_player(player_id, "...\n\n\nYou really get me, guts! Take this.", mug.texture_path, mug.animation_path)
				Net.message_player(player_id, "You got Guts Hammer! Use it in liberations.")
				for i = 1, #liberation_item_list, 1 do
					ezmemory.create_or_update_item(liberation_item_list[i].n, liberation_item_list[i].d, true)
					local item_count = ezmemory.count_player_item(player_id, liberation_item_list[i].n)
					if item_count > 0 then ezmemory.remove_player_item(player_id, liberation_item_list[i].n, item_count) end
				end
				local count = ezmemory.count_player_item(player_id,"GutsHamr")
				if count > 0 then ezmemory.remove_player_item(player_id, "GutsHamr", count) end
				ezmemory.give_player_item(player_id,"GutsHamr",1)
			end
		end)
	end
}

local RemoveBass1 = {
	name="Remove Bass ACDC 4",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			Net.lock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=255}, 1)
			if ezmemory.count_player_item(player_id, "Met Bass 1") == 0 then
				ezmemory.create_or_update_item("Met Bass 1","",false)
				ezmemory.give_player_item(player_id,"Met Bass 1",1)
			end
			Async.await(Async.sleep(1))
			local area_id = Net.get_player_area(player_id)
			local safe_secret = helpers.get_safe_player_secret(player_id)
			Net.exclude_actor_for_player(player_id, npc.bot_id)
			-- local player_area_memory = ezmemory.get_player_area_memory(safe_secret,area_id)
			-- player_area_memory.hidden_actors[tostring(npc.bot_id)] = true
			-- ezmemory.save_player_memory(safe_secret)
			Net.unlock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=0}, 1)
		end)
	end
}

local GetYaiCode = {
	name="Get Yai Code",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			Net.lock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=255}, 1)
			if ezmemory.count_player_item(player_id, "YaiCode") == 0 then
				ezmemory.create_or_update_item("YaiCode","A PCode to enter Yai's HP. You must've helped her out!",true)
				ezmemory.give_player_item(player_id,"YaiCode",1)
			end
			Async.await(Async.sleep(1))
			local area_id = Net.get_player_area(player_id)
			local safe_secret = helpers.get_safe_player_secret(player_id)
			Net.exclude_actor_for_player(player_id, npc.bot_id)
			-- local player_area_memory = ezmemory.get_player_area_memory(safe_secret,area_id)
			-- player_area_memory.hidden_actors[tostring(npc.bot_id)] = true
			-- ezmemory.save_player_memory(safe_secret)
			Net.unlock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=0}, 1)
		end)
	end
}

local GiveCopyLicense = {
	name="Give CopyLicense",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			if ezmemory.count_player_item(player_id, "CopyLicense") == 0 then
				ezmemory.create_or_update_item("CopyLicense","Proof of Copyman's trust in you.",true)
				ezmemory.give_player_item(player_id,"CopyLicense",1)
			end
		end)
	end
}

local GetYaiData = {
	name="Get Yai Data",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			Net.lock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=255}, 1)
			if ezmemory.count_player_item(player_id, "YaiData") == 0 then
				ezmemory.create_or_update_item("YaiData","It seems to be Yai's portion of a book report...",true)
				ezmemory.give_player_item(player_id,"YaiData",1)
			end
			Async.await(Async.sleep(1))
			local area_id = Net.get_player_area(player_id)
			local safe_secret = helpers.get_safe_player_secret(player_id)
			Net.exclude_actor_for_player(player_id, npc.bot_id)
			-- local player_area_memory = ezmemory.get_player_area_memory(safe_secret,area_id)
			-- player_area_memory.hidden_actors[tostring(npc.bot_id)] = true
			-- ezmemory.save_player_memory(safe_secret)
			Net.unlock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=0}, 1)
		end)
	end
}

local GlydeProgQuestTrigger = {
	name="GlydeProgQuest",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			if ezmemory.count_player_item(player_id, "GlydeReq") == 0 then
				ezmemory.create_or_update_item("GlydeReq","",false)
				ezmemory.give_player_item(player_id,"GlydeReq",1)
			end
		end)
	end
}

local OpenHospGate = {
	name="Open Hospital Gate",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			Net.lock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=255}, 1)
			Async.await(Async.sleep(1))
			local area_id = Net.get_player_area(player_id)
			local safe_secret = helpers.get_safe_player_secret(player_id)
			Net.exclude_actor_for_player(player_id, npc.bot_id)
			-- local player_area_memory = ezmemory.get_player_area_memory(safe_secret,area_id)
			-- player_area_memory.hidden_actors[tostring(npc.bot_id)] = true
			-- ezmemory.save_player_memory(safe_secret)
			Net.unlock_player_input(player_id)
			Net.fade_player_camera(player_id, {r=0, g=0, b=0, a=0}, 1)
		end)
	end
}

local PlaydomePlaytime = {
	name="Playdome Playtime",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local area_id = Net.get_player_area(player_id)
			local object = Net.get_object_by_name(area_id, "Playdome")
			Net.lock_player_input(player_id)
			Net.move_player_camera(player_id, object.x, object.y, object.z, 5)
			Net.exclude_actor_for_player(player_id, player_id)
			Async.await(Async.sleep(5))
			Net.unlock_player_camera(player_id)
			Net.include_actor_for_player(player_id, player_id)
			Net.unlock_player_input(player_id)
		end)
	end
}

local GetOvenCoolant = {
	name="Obtain Oven Coolant",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local name = "OvenCoolant"
			if not ezmemory.get_item_id_by_name(name) then ezmemory.create_or_update_item(name,"",false) end
			local count = ezmemory.count_player_item(player_id, name)
			if count > 0 then ezmemory.remove_player_item(player_id, name, count) end
			ezmemory.give_player_item(player_id,name,10)
			Net.message_player(player_id, "You got Coolant! Use it wisely!")
			local safe_secret = helpers.get_safe_player_secret(player_id)
			local player_area_memory = ezmemory.get_player_area_memory(safe_secret,"Oven Network")
			local player_area_memory_two = ezmemory.get_player_area_memory(safe_secret,"Oven Network 2")
			for object_id, is_hidden in pairs(player_area_memory.hidden_objects) do
				if Net.get_object_by_id("Oven Network", object_id).type == "Checkpoint" then
					player_area_memory.hidden_objects[object_id] = nil
					Net.include_object_for_player(player_id, object_id)
				end
			end
			for object_id2, is_hidden in pairs(player_area_memory_two.hidden_objects) do
				if Net.get_object_by_id("Oven Network 2", object_id2).type == "Checkpoint" then
					player_area_memory_two.hidden_objects[object_id2] = nil
					Net.include_object_for_player(player_id, object_id2)
				end
			end
			ezmemory.save_player_memory(safe_secret)
		end)
	end
}

local FightFiremanRV ={
	name = "FiremanRV Battle",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			Net.initiate_encounter(player_id, "/server/assets/encounters/FiremanRV.zip", {})
			return Net.exclude_actor_for_player(player_id, npc.bot_id)
		end)
	end
}

local GrantLiberationAbility = {
	name = "Grant Liberation Mission Ability",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			for i = 1, #liberation_item_list, 1 do
				ezmemory.create_or_update_item(liberation_item_list[i].n, liberation_item_list[i].d, true)
				local item_count = ezmemory.count_player_item(player_id, liberation_item_list[i].n)
				if item_count > 0 then ezmemory.remove_player_item(player_id, liberation_item_list[i].n, item_count) end
			end

			if dialogue.custom_properties["Ability Item"] ~= nil then ezmemory.give_player_item(player_id, dialogue.custom_properties["Ability Item"], 1) end
		end)
	end
}

local GiveCoffeeEvent = {
	name = "Buy Coffee",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
			local player_mug = Net.get_player_mugshot(player_id)
			if Net.get_player_money(player_id) < 50 then
				Net.message_player(player_id, "We aren't running a charity here.", mug.texture_path, mug.animation_path)
			else
				Async.await(Async.message_player(player_id, "You hand over 50 Monies and get a hot cuppa joe."))
				ezmemory.spend_player_money(player_id, 50)
				Net.play_sound_for_player(player_id, "/server/assets/NebuLibsAssets/sound effects/recover.ogg")
				local hp = ezmemory.get_player_health(player_id)
				ezmemory.set_player_health(player_id, hp+math.floor(hp*0.2))
				local message_list = {
					"Dark and bitter.\nYet, refreshing.\nJust like life?",
					"Disgustingly stale...\n\nIs this from last week...?",
					"Coffee made with apathy...Delicious!",
					"Did she put sugar in this?\n\nHah, that'd be the day!",
					"Who needs Dark Chips? I have this coffee!",
				}
				Async.await(Async.message_player(player_id, message_list[math.random(#message_list)], player_mug.texture_path, player_mug.animation_path))
			end
		end)
	end
}

local GiveTeaEvent = {
	name = "Buy Tea",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
			local player_mug = Net.get_player_mugshot(player_id)
			if Net.get_player_money(player_id) < 50 then
				Net.message_player(player_id, "I'm sorry, but that's not enough cash~!", mug.texture_path, mug.animation_path)
			else
				Async.await(Async.message_player(player_id, "You hand over 50 Monies and get a calming cuppa tea."))
				ezmemory.spend_player_money(player_id, 50)
				Net.play_sound_for_player(player_id, "/server/assets/NebuLibsAssets/sound effects/recover.ogg")
				local hp = ezmemory.get_player_health(player_id)
				ezmemory.set_player_health(player_id, hp+math.floor(hp*0.2))
				local message_list = {
					"*sip*.\n\n\nSo calming...!\nI needed this.",
					"Hot hot hot!\nMaybe I should let it cool next time...",
					"Tea made with genuine care...wonderful.",
					"There's honey in this! Is she sweet on me...?",
					"Not even a Secret Chip can measure up to the secret of her teamaking...!",
				}
				Async.await(Async.message_player(player_id, message_list[math.random(#message_list)], player_mug.texture_path, player_mug.animation_path))
			end
		end)
	end
}

local VirologistDateCheck = {
	name = "Virologist Timer Check",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			--Get the player's safe secret for ezmemory
			local safe_secret = helpers.get_safe_player_secret(player_id)
			--Get the player memory
			local player_memory = ezmemory.get_player_memory(safe_secret)
			--If the specified player doesn't have quest data in their memory, initialize it.
			if not player_memory.quest_data then player_memory.quest_data = {} end
			--Get the NPC mugshot for message use.
			local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
			--If the player memory has a virologist date saved (custom data from me), and the current time is less than that date, tell the player to return later.
			if player_memory.quest_data["ACDC2Virologist"] and os.time() < player_memory.quest_data["ACDC2Virologist"] then
				Async.await(Async.message_player(player_id, "I'm sorry, I'm still studying the data.", mug.texture_path, mug.animation_path))
				Async.await(Async.message_player(player_id, "Please come back later.", mug.texture_path, mug.animation_path))
				--Don't proceed. We're too early to try this quest again.
				return nil
			end
			return dialogue.custom_properties["Next 1"]
		end)
	end
}

local VirologistAssistance = {
	name = "Virologist Battle",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			--Get the player's safe secret for ezmemory
			local safe_secret = helpers.get_safe_player_secret(player_id)
			--Get the player memory
			local player_memory = ezmemory.get_player_memory(safe_secret)
			--If the specified player doesn't have quest data in their memory, initialize it.
			if not player_memory.quest_data then player_memory.quest_data = {} end
			--Get the NPC mugshot for message use.
			local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
			--Get the max HP and modify it.
			local modified_hp = ezmemory.calculate_player_modified_max_hp(player_id,ezmemory.get_player_max_health(player_id),20,"HPMem")
			--Initiate an encounter.
			local results = Async.await(Async.initiate_encounter(player_id, "/server/assets/encounters/VirologistData.zip", {}))
			--If we won and didn't run, let's begin processing our reward!
			if not results.ran then
				--Default timer is 24 hours later. Save the date!
				local new_date = os.time()
				if results.health > 0 then
					new_date = new_date + ((60*60)*24)
					--Set our emotion...
					if results.emotion == 1 then
						Net.set_player_emotion(player_id, results.emotion)
					else
						Net.set_player_emotion(player_id, 0)
					end
					--Set our health...
					Net.set_player_health(player_id,results.health)
					Net.lock_player_input(player_id)
					Async.await(Async.message_player(player_id, "Most informative! Thank you.", mug.texture_path, mug.animation_path))
					--Virologist heals us.
					Async.await(Async.message_player(player_id, "Allow me to restore your health.", mug.texture_path, mug.animation_path))
					--Heal to max
					ezmemory.set_player_health(player_id, modified_hp)
					--Provide a recover SFX from the server so that we guarantee it exists.
					Net.play_sound_for_player(player_id, "/server/assets/NebuLibsAssets/sound effects/recover.ogg")
					--Give the player 500 Monies!
					Async.await(Async.message_player(player_id, "Please, take this for your trouble.", mug.texture_path, mug.animation_path))
					Async.await(Async.message_player(player_id, "Got $500!"))
					--Spend in reverse to gain.
					ezmemory.spend_player_money(player_id, -500)
					--Tell the player what the Virologist is up to for the next while, and when to come back.
					Async.await(Async.message_player(player_id, "I need to study this data...", mug.texture_path, mug.animation_path))
					Async.await(Async.message_player(player_id, "Could you give me 24 hours?", mug.texture_path, mug.animation_path))
					Net.unlock_player_input(player_id)
				else
					--Retry date is an hour later.
					new_date = new_date + (60*60)
					Net.lock_player_input(player_id)
					--We're Worried now.
					Net.set_player_emotion(player_id, 5)
					--Health is 1 because we lost during an event.
					Net.set_player_health(player_id,1)
					--Virologist is upset. Swears based on Battle Network terms.
					Async.await(Async.message_player(player_id, "Bust it all, that was too close!", mug.texture_path, mug.animation_path))
					--Virologist heals us.
					Async.await(Async.message_player(player_id, "I'm sorry. Let me fix you up.", mug.texture_path, mug.animation_path))
					--Heal to max
					ezmemory.set_player_health(player_id, modified_hp)
					--Provide a recover SFX from the server so that we guarantee it exists.
					Net.play_sound_for_player(player_id, "/server/assets/NebuLibsAssets/sound effects/recover.ogg")
					Async.await(Async.message_player(player_id, "I'll log this incident right away.", mug.texture_path, mug.animation_path))
					Async.await(Async.message_player(player_id, "Come back in an hour if you're still willing to help me with my research.", mug.texture_path, mug.animation_path))
					Net.unlock_player_input(player_id)
				end
				--Set reattempt timer.
				player_memory.quest_data["ACDC2Virologist"] = new_date
				--Save the player memory so they can attempt later.
				ezmemory.save_player_memory(safe_secret)
			end
		end)
	end
}

local GiveSirProof = {
	name = "Grant SirProof",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			ezmemory.create_or_update_item("SirProof","Proof of helping a distinguished Sir.",false)
			ezmemory.give_player_item(player_id, "SirProof", 1)
			Async.message_player(player_id, "You got an HPMemory!")
			ezmemory.give_player_item(player_id, "HPMem", 1)
		end)
	end
}

local CyberRailWarp = {
	name = "Conductor Teleport",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local area_id = dialogue.custom_properties["Warp Map"]
			local object = Net.get_object_by_name(area_id, "Conductor Warp")
			local direction = object.custom_properties["Direction"] or Net.get_player_direction(player_id)
			Net.transfer_player(player_id, area_id, true, object.x, object.y, object.z, direction)
		end)
	end
}

local GiveRailPassPls = {
	name = "Give RailPass",
	action = function(npc, player_id, dialogue, relay_object)
		return async(function()
			local mug = eznpcs.get_dialogue_mugshot(npc,player_id,dialogue)
			Net.lock_player_input(player_id)
			Net.message_player(player_id, "HELLO!\nWE HAVE A\nNEW SERVICE!\nWE WEREN'T ABLE\nTO REPAIR THE\nRAILWAY, SO\nWE NOW OFFER\nA TELEPORT\nSERVICE!\nHERE'S YOUR\nCOMPLIMENTARY\nRAILPASS!", mug.texture_path, mug.animation_path)
			ezmemory.create_or_update_item("RailPass","Allows you to ride the rails!",true)
			ezmemory.give_player_item(player_id,"RailPass",1)
			Net.unlock_player_input(player_id)
		end)
	end
}

eznpcs.add_event(GiveRailPassPls)
eznpcs.add_event(CyberRailWarp)
eznpcs.add_event(GiveTeaEvent)
eznpcs.add_event(GiveSirProof)
eznpcs.add_event(VirologistDateCheck)
eznpcs.add_event(VirologistAssistance)
eznpcs.add_event(GiveCoffeeEvent)
eznpcs.add_event(GrantLiberationAbility)
eznpcs.add_event(GetOvenCoolant)
eznpcs.add_event(PlaydomePlaytime)
eznpcs.add_event(GlydeProgQuestTrigger)
eznpcs.add_event(GetYaiCode)
eznpcs.add_event(GiveCopyLicense)
eznpcs.add_event(GetYaiData)
eznpcs.add_event(RemoveBass1)
eznpcs.add_event(OpenHospGate)
eznpcs.add_event(FightGutsmanEvent)
eznpcs.add_event(FightGutsmanV2Event)
eznpcs.add_event(FightGutsmanV3Event)
eznpcs.add_event(FightGutsmanV4Event)
eznpcs.add_event(RematchProgEvent)
eznpcs.add_event(FightFiremanRV)
eznpcs.add_event(CreateCheckpointEvent)