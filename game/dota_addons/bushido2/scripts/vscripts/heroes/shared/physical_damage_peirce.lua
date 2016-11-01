function physical_damage_peirce( keys )
	
	local damageTable = {
		victim = keys.target,
		attacker = keys.caster,
		damage = keys.ability:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}

	ApplyDamage(damageTable)
end