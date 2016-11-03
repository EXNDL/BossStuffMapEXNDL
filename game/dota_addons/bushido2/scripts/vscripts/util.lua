function ApplyKnockback(target, center, distance, duration, height, should_stun)
	if IsValidEntity(center) then
		center = center:GetAbsOrigin()
	end

	if not center.x or not center.y then
		return
	end

	local knockbackTable = {
		center_x = center.x,
		center_y = center.y,
		center_z = center.z,
		knockback_duration = duration,
		knockback_distance = distance,
		knockback_height = height,
		should_stun = 0,
		duration = duration,
	}

	if should_stun then knockbackTable["should_stun"] = 1 end

	target:AddNewModifier(target, nil, "modifier_knockback", knockbackTable)
	if not should_stun then target:RemoveGesture( ACT_DOTA_FLAIL ); end
end