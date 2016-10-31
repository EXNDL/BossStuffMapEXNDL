function physical_damage_peirce( keys )
playerHero = PlayerResource:GetPlayer(1):GetAssignedHero()
local damageTable = {
	victim = keys.target,
	attacker = keys.caster,
	damage = keys.ability:GetAbilityDamage(),
	damage_type = DAMAGE_TYPE_PHYSICAL,
}

ApplyDamage(damageTable)

end

--for k, v in pairs(keys) do
 -- print(k.." "..tostring(v))
--end