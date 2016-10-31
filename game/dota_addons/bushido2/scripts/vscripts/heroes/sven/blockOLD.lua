--[[Author: Pizzalol
	Date: 19.01.2015.
	Restores a set amount of mana to the target]]
function mana_restore( keys )
	local target = keys.caster
	local ability = keys.ability
	local mana_restore = ability:GetLevelSpecialValueFor("mana_restore", (ability:GetLevel() - 1))
	print "mana!"

	target:GiveMana(mana_restore)

end



--------------------------------------

