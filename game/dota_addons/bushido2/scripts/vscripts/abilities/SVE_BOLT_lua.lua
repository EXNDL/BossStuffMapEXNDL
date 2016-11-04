SVE_BOLT_lua = class({})
LinkLuaModifier( "modifier_sven_storm_bolt_lua", "abilities/modifier_sven_storm_bolt_lua", LUA_MODIFIER_MOTION_NONE )

function SVE_BOLT_lua:OnSpellStart() 
	pr("wah")
end

function SVE_BOLT_lua:GetChannelTime()
	if IsServer() then return 0.55 end
	return 0
end

function SVE_BOLT_lua:OnChannelThink( tick )
	if not self.attackComplete then
		self.think = self.think and self.think + tick or 0
		
		pr(self.think)
		if self.think > 0.13 then
			self.attackComplete = true

			local start_radius = self:GetSpecialValueFor("start_radius") 
			local end_radius = self:GetSpecialValueFor("end_radius") 
			local range = self:GetSpecialValueFor("range") 
			local speed = self:GetSpecialValueFor("speed")
			local caster = self:GetCaster()

			caster:EmitSound("Hero_Sven.StormBolt")

			self.bolt = ProjectileManager:CreateLinearProjectile({
				Ability = self,
				EffectName = "particles/units/heroes/hero_sven/linear_storm_boltpell_storm_bolt.vpcf",
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
				vVelocity = caster:GetForwardVector() * speed,
				bProvidesVision = false,
			})

			self.attackComplete = true
		end
	end
end

function SVE_BOLT_lua:OnProjectileHit( hTarget, vPosition )
	if hTarget == nil then return end

	ProjectileManager:DestroyLinearProjectile(self.bolt)
	self.bolt = nil

	local projectile_explosion = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", PATTACH_ABSORIGIN, hTarget )
	ParticleManager:SetParticleControlEnt(projectile_explosion, 1, hTarget, PATTACH_ABSORIGIN, "attach_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(projectile_explosion, 2, hTarget, PATTACH_ABSORIGIN, "attach_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(projectile_explosion, 3, hTarget, PATTACH_ABSORIGIN, "attach_origin", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(projectile_explosion, 4, hTarget, PATTACH_ABSORIGIN, "attach_origin", hTarget:GetAbsOrigin(), true)

	hTarget:EmitSound("Hero_Sven.StormBoltImpact")

	ApplyDamage({
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
	})

	local stun_duration = self:GetSpecialValueFor("stun_duration")
	hTarget:AddNewModifier( self:GetCaster(), self, "modifier_sven_storm_bolt_lua", { duration = stun_duration } )
end

function SVE_BOLT_lua:OnChannelFinish( bInterupt )
	self.think = nil
	self.attackComplete = nil
end

function SVE_BOLT_lua:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end

function SVE_BOLT_lua:GetPlaybackRateOverride()
	return 1.3
end