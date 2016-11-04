function TargetTrigger( keys )
	local item				= keys.ability
	local caster			= keys.caster
	local target 			= keys.target


	local item = target:GetItemInSlot(0)
	--pr( item:GetName() )
	--pr( item:GetMoveParent():GetName() )

	target:DropItemAtPositionImmediate(item,target:GetAbsOrigin())

	--item:SetParent(caster, "")
	item:SetOwner(caster) 

	caster.ring = item

	--pr(item:GetContainer())

	--pr(item:GetContainer():GetContainedItem()) 
	UTIL_Remove(item:GetContainer()) 

	--pr(item)

	local mt = getmetatable(item:GetContainer())
	pr(mt)

	--item:OnSpellStart()
end

function ItemTrigger( keys )
	local item				= keys.ability
	local caster			= keys.caster


	if caster.ring then 
		--pr(caster.ring)
		caster.ring:OnSpellStart() 
	end

	SendToServerConsole("script_reload")
end