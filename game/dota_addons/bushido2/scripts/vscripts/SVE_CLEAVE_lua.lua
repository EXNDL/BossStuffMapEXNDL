SVE_CLEAVE_lua = class({})

function SVE_CLEAVE_lua:OnSpellStart() 
	pr("wah")
end

function SVE_CLEAVE_lua:GetChannelTime()
	if IsServer() then return 0.95 end
	return 0
end

function SVE_CLEAVE_lua:OnChannelThink( tick )
	if not self.attackComplete then
		self.think = self.think and self.think + tick or 0
		
		pr(self.think)
		if self.think > 0.3 then
			self.attackComplete = true

			local start_radius = self:GetSpecialValueFor("start_radius") 
			local end_radius = self:GetSpecialValueFor("end_radius") 
			local range = self:GetSpecialValueFor("range") 
			local speed = self:GetSpecialValueFor("speed")
			local caster = self:GetCaster()

			ProjectileManager:CreateLinearProjectile({
				Ability = self,
				vSpawnOrigin = caster:GetAbsOrigin(),
				fDistance = range,
				fStartRadius = start_radius,
				fEndRadius = end_radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = false,
				vVelocity = caster:GetForwardVector() * speed,
				bProvidesVision = false,
			})
			self.attackComplete = true
		end
	end
end

function SVE_CLEAVE_lua:OnProjectileHit( hTarget, vPosition )
	if hTarget == nil then return end

	hTarget:EmitSound("Hero_Sven.Attack")

	ApplyDamage({
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
	})
end

function SVE_CLEAVE_lua:OnChannelFinish( bInterupt )
	self.think = nil
	self.attackComplete = nil
end

function SVE_CLEAVE_lua:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function SVE_CLEAVE_lua:GetPlaybackRateOverride()
	return 1.5
end