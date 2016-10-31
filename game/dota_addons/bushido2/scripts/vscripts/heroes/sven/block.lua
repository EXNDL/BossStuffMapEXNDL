

function mana_restore( keys )
	local target = keys.caster
	local caster = keys.caster
	local ability = keys.ability
	local mana_restore = ability:GetLevelSpecialValueFor("mana_restore", (ability:GetLevel() - 1))
	keys.ability:ApplyDataDrivenModifier( caster, caster, 'modifier_bonus_armor_2', {} )
	print "mana!"
	caster:Stop()
	--local particleName = "particles/items3_fx/mango_active.vpcf"
	--CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_WORLDORIGIN, caster)
		local mango_particle = ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		--StartSoundEvent( "Hero_ChaosKnight.ChaosBolt.Impact", unit )
		--local soundEventName = "sounds/items/clarity_potion.vsnd"
		--StartSoundEvent( soundEventName, unit )
		caster:EmitSound("urien_block")
		--ParticleManager:SetParticleControl(pop_pfx, 0, target:GetAbsOrigin())
		--ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))

	target:GiveMana(mana_restore)
end

--[[

function isUnitFacingUnit(caster, target, angle)
  local casterFacing = caster:GetForwardVector()
  local casterToTarget = (target:GetOrigin() - caster:GetOrigin())
  casterFacing.z = 0
  casterToTarget.z = 0
  casterFacing = casterFacing:Normalized()
  casterToTarget = casterToTarget:Normalized()
print "this is actually doing something" --no i am not
  if math.acos(casterFacing:Dot(casterToTarget)) < math.rad(angle) then
  	  return true
	end
	return false 
end




function reflect( keys )
	-- Variables

	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local attacker = keys.attacker
	local attacker_location = attacker:GetAbsOrigin()
	local damageTaken = keys.DamageTaken

	print "reflect"
	--local caster_direction = caster:GetForwardVector())---this thing
	--local vectorA = attacker:GetOrigin() - caster:GetOrigin()

	-- Check if it's not already been hit
	if not caster.carapaced_units[ attacker:entindex() ] and not attacker:IsMagicImmune() then
		--attacker:SetHealth( attacker:GetHealth() - damageTaken )

	--if isUnitFacingUnit(caster, attacker, 60) then
		if (caster_location - attacker_location):Length() < 300 then
			keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_parry_stun", { } )
			attacker:Stop()
		--caster:SetHealth( caster:GetHealth() + damageTaken )
		caster:SetHealth(caster.oldHP)
		caster.carapaced_units[ attacker:entindex() ] = attacker
		end
	end
--end--direction
end



function parry_setup( keys )
	local caster = keys.caster
	caster.oldHP = caster:GetHealth()
	--print(caster.oldHP)
end


function parry( keys )
	keys.caster.carapaced_units = {}
end


]]