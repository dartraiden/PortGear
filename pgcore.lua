local a,d=...
local e,f={},{}
local PG=CreateFrame('frame',a)
d.gear,d.gearinsets,d.portgearequipped={},{},{}

function f.CacheSets(gearsetonly)
	if not C_EquipmentSet.CanUseEquipmentSets() then return end
	for _,v1 in next,C_EquipmentSet.GetEquipmentSetIDs() do
		if (select(4,C_EquipmentSet.GetEquipmentSetInfo(v1))) then
			d.set=true
			d.gearset=v1
			d.portgearequipped={}
		end
		if not gearsetonly then
			for _,v2 in next,C_EquipmentSet.GetItemIDs(v1) do
				if d.gearinsets[v2] then
					tinsert(d.gearinsets[v2],v1,true)
				else
					d.gearinsets[v2]={[v1]=true}
				end
			end
		end
	end
end -- cache all set gear and current set

function f.EquipOriginalItem()
	if d.portgearused and not d.combat and not InCombatLockdown() then
		if GetInventoryItemLink('player',d.portgearused)==d.gear[d.portgearused] then
			d.portgearequipped[d.portgearused]=nil
			d.portgearused=nil
		else
			EquipItemByName(d.gear[d.portgearused],d.portgearused)
			C_Timer.After(1,f.EquipOriginalItem) -- loop to ensure original is equipped
		end
	end
end -- equip original item after using a teleport item

function f.SetGear(silent)
	for i=1,19 do d.gear[i]=GetInventoryItemLink('player',i) end
	d.portgearequipped={}
	if silent~='silent' then print("|cffff0000"..a..":|r saved current gear") end
end -- cache all current gear, assuming all normally worn even if port gear

function e.PLAYER_LOGIN()
	f.CacheSets()
	f.SetGear('silent')
	SLASH_PORTGEAR1='/pg'
	SLASH_PORTGEAR2='/portgear'
	SlashCmdList.PORTGEAR=f.SetGear -- manual refresh of all current gear
	PG:UnregisterEvent('PLAYER_LOGIN')
end

function e.BAG_UPDATE_COOLDOWN()
	for k in next,d.portgearequipped do
		local _,cd=GetInventoryItemCooldown('player',k)
		if cd and cd>31 then
			d.portgearused=k
			f.EquipOriginalItem()
		end
	end
end -- watch item cooldowns for port gear usage

function e.EQUIPMENT_SETS_CHANGED() d.gearinsets={} f.CacheSets() end -- cache gear set changes

function e.PLAYER_EQUIPMENT_CHANGED(slot)
	f.CacheSets(true)
	local id=GetInventoryItemID('player',slot)
	local link=GetInventoryItemLink('player',slot)
	if d.portgear[id] and (not d.gearinsets[id] or not d.gearinsets[id][d.gearset]) and link~=d.gear[slot] then
		d.portgearequipped[slot]=true
	else
		d.gear[slot]=link
		d.portgearequipped[slot]=nil
	end
end -- cache non-port gear, port gear not normally worn, and current set after item change

function e.PLAYER_REGEN_DISABLED() d.combat=true end
function e.PLAYER_REGEN_ENABLED() d.combat=false f.EquipOriginalItem() end -- track combat and swap if needed

PG:RegisterEvent('PLAYER_LOGIN')
PG:RegisterEvent('BAG_UPDATE_COOLDOWN')
PG:RegisterEvent('EQUIPMENT_SETS_CHANGED')
PG:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
PG:RegisterEvent('PLAYER_REGEN_DISABLED')
PG:RegisterEvent('PLAYER_REGEN_ENABLED')
PG:SetScript('OnEvent',function(_,event,...)e[event](...)end)