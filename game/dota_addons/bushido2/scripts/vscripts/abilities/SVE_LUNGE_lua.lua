SVE_LUNGE_lua = class({})

function SVE_LUNGE_lua:OnSpellStart() 
	self.phase = 1
	pr("wah")
end

function SVE_LUNGE_lua:GetChannelTime()
	if IsServer() then return 0.48 end
	return 0
end

function SVE_LUNGE_lua:OnChannelThink( tick )
	self.think = self.think and self.think + tick or 0

	if self.phase == 1 and self.think > 0.08 then
		pr(self.think)

		local caster = self:GetCaster()
		local point = caster:GetAbsOrigin() + caster:GetForwardVector()*-2
		local dash_distance = self:GetSpecialValueFor("dash_distance")
		local dash_duration = self:GetSpecialValueFor("dash_duration") 
		local dash_height = self:GetSpecialValueFor("dash_height") 

		ApplyKnockback(caster, point, dash_distance, dash_duration, dash_height)
		self.phase = 2
	end

	if self.phase == 2 and self.think > 0.16 then
		pr(self.think)

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
			--fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = caster:GetForwardVector() * speed,
			bProvidesVision = false,
		})

		self.phase = 3
	end

	if self.phase == 3 and self.think > 0.46 then
		pr(self.think)

		self:GetCaster():StartGesture( ACT_DOTA_IDLE )
		self.phase = 4
	end
end

function SVE_LUNGE_lua:OnProjectileHit( hTarget, vPosition )
	if hTarget == nil then return end

	ApplyDamage({
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
	})

	hTarget:EmitSound("Hero_Sven.Attack")
end

function SVE_LUNGE_lua:OnChannelFinish( bInterupt )
	self.think = nil
	self.phase = nil

	Timers(0.2, function() self:GetCaster():RemoveGesture( ACT_DOTA_IDLE ) end)
end

function SVE_LUNGE_lua:GetCastAnimation()
	return ACT_DOTA_CAST_ALACRITY
end

function SVE_LUNGE_lua:GetPlaybackRateOverride()
	return 1.25
end