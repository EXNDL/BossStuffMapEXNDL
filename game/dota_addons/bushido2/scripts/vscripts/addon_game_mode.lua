if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

require( 'toolsmode') --Debugging functions

require( 'libraries/timers' )
require( 'libraries/animations' )
require( 'libraries/physics' )
	
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "model_folder", "particles/folder", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheModel("models/heroes/viper/viper.vmdl", context)
			PrecacheItemByNameSync("example_ability", context)
			PrecacheUnitByNameSync("npc_dota_hero_viper", context)
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CAddonTemplateGameMode, 'OnNPCSpawned'), self)

	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CAddonTemplateGameMode, "ExecuteOrderFilter" ), self )

	SendToServerConsole("dota_surrender_on_disconnect 0")	
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetCustomGameSetupAutoLaunchDelay( 1 )
	GameRules:SetCustomGameSetupRemainingTime( 1 )
	GameRules:SetCustomGameSetupTimeout( 1 )
end

function CAddonTemplateGameMode:ExecuteOrderFilter( filterTable )
	local orderType = filterTable["order_type"]
	local target = EntIndexToHScript( filterTable["entindex_target"] ) 
	local unit = EntIndexToHScript( filterTable["units"]["0"] )
	local ability = EntIndexToHScript( filterTable["entindex_ability"] )

	--pr(filterTable)

	if unit:IsRealHero() and unit:IsChanneling() then
		return false
	end

	return true
end


function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonTemplateGameMode:OnNPCSpawned( keys )
	local hero = EntIndexToHScript(keys.entindex)

	if hero:GetUnitName() == "npc_dota_hero_sven" and hero:GetLevel() == 1 then
		hero:AddExperience(200, false, true)
		hero:AddItemByName("ITEM_SVE_BLOCK")
		hero:AddItemByName("ITEM_SVE_ROLL")

		for i = 0, hero:GetAbilityCount()-1 do
			local spell = hero:GetAbilityByIndex(i)
			if spell then spell:SetLevel(spell:GetMaxLevel()) end
		end
		hero:SetAbilityPoints(0)
	end
end