--[[ ============================================================================================================
	Author: Rook
	Date: February 15, 2015
	Called when Invoke is cast.  Stores cooldown information for the ability that was bound to D, and adds a new
	ability bound to F based on the order of the orbs around Invoker.
================================================================================================================= ]]
function invoker_retro_invoke_on_spell_start(keys)
	keys.caster:EmitSound("Hero_Invoker.Invoke")

	
	--[[The following code is for the modern Invoker that can invoke two spells, and is left here but commented out in case
		we decide to allow Invoker to invoke two spells.
		
	--Since cooldowns are tied to the ability but we don't have room to keep all the abilities on Invoker due to the
	--limited number of slots, keep track of the gametime of when abilities were last cast, which we can use to determine
	--if invoked spells should still be on cooldown from when they were last used.
	local ability_d = keys.caster:GetAbilityByIndex(4)
	local ability_d_name = ability_d:GetName()
	--Update keys.caster.invoke_ability_cooldown_remaining[ability_name] of the ability to be removed, so cooldowns can be tracked.
	--We cannot just store the gametime because the ability's maximum cooldown may have changed due to leveling up Invoker's orbs
	--by the time the ability is reinvoked.  Therefore, keys.caster.invoke_ability_gametime_removed[ability_name] is also stored.
	--Items like Refresher Orb should clear this list.
	if keys.caster.invoke_ability_cooldown_remaining == nil then
		keys.caster.invoke_ability_cooldown_remaining = {}
	end
	if keys.caster.invoke_ability_gametime_removed == nil then
		keys.caster.invoke_ability_gametime_removed = {}
	end
	keys.caster.invoke_ability_cooldown_remaining[ability_d_name] = ability_d:GetCooldownTimeRemaining()
	keys.caster.invoke_ability_gametime_removed[ability_d_name] = GameRules:GetGameTime() 
	
	--Shift the ability in the F slot to the D slot, and remove the ability that was in the F slot.
	keys.caster:RemoveAbility(ability_d_name)
	local ability_f = keys.caster:GetAbilityByIndex(5)
	local ability_f_name = ability_f:GetName()
	local ability_f_current_cooldown = ability_f:GetCooldownTimeRemaining()
	keys.caster:RemoveAbility(ability_f_name)
	keys.caster:AddAbility(ability_f_name)  --This will place the ability that was bound to F in the D slot.
	local new_ability_d = keys.caster:FindAbilityByName(ability_f_name)
	new_ability_d:StartCooldown(ability_f_current_cooldown)
	
	]]
	
	--Since cooldowns are tied to the ability but we don't have room to keep all the abilities on Invoker due to the
	--limited number of slots, keep track of the gametime of when abilities were last cast, which we can use to determine
	--if invoked spells should still be on cooldown from when they were last used.
	local old_spell_invoked = keys.caster:GetAbilityByIndex(4)
	local old_spell_invoked_name = old_spell_invoked:GetName()
	--Update keys.caster.invoke_ability_cooldown_remaining[ability_name] of the ability to be removed, so cooldowns can be tracked.
	--We cannot just store the gametime because the ability's maximum cooldown may have changed due to leveling up Invoker's orbs
	--by the time the ability is reinvoked.  Therefore, keys.caster.invoke_ability_gametime_removed[ability_name] is also stored.
	--Items like Refresher Orb should clear this list.
	if keys.caster.invoke_ability_cooldown_remaining == nil then
		keys.caster.invoke_ability_cooldown_remaining = {}
	end
	if keys.caster.invoke_ability_gametime_removed == nil then
		keys.caster.invoke_ability_gametime_removed = {}
	end
	keys.caster.invoke_ability_cooldown_remaining[old_spell_invoked_name] = old_spell_invoked:GetCooldownTimeRemaining()
	keys.caster.invoke_ability_gametime_removed[old_spell_invoked_name] = GameRules:GetGameTime() 
	
	--Remove the ability that was in the F slot.
	keys.caster:RemoveAbility(old_spell_invoked_name)
	
	--Add the invoked spell depending on the order of the invoked orbs.
	if keys.caster.invoked_orbs == nil then
		keys.caster.invoked_orbs = {}
	end
	if keys.caster.invoked_orbs[1] ~= nil and keys.caster.invoked_orbs[2] ~= nil and keys.caster.invoked_orbs[3] ~= nil then  --If three orbs have not been summoned, no spell will be invoked.
		if keys.caster.invoked_orbs[1]:GetName() == "invoker_retro_quas" then
			if keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_quas" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Quas Quas Quas
					keys.caster:AddAbility("invoker_retro_icy_path")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Quas Quas Wex
					keys.caster:AddAbility("invoker_retro_portal")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Quas Quas Exort
					keys.caster:AddAbility("invoker_retro_frost_nova")
				end
			elseif keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_wex" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Quas Wex Quas
					keys.caster:AddAbility("invoker_retro_betrayal")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Quas Wex Wex
					keys.caster:AddAbility("invoker_retro_tornado_blast")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Quas Wex Exort
					keys.caster:AddAbility("invoker_retro_levitation")
				end
			elseif keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_exort" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Quas Exort Quas
					keys.caster:AddAbility("invoker_retro_power_word")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Quas Exort Wex
					keys.caster:AddAbility("invoker_retro_invisibility_aura")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Quas Exort Exort
					keys.caster:AddAbility("invoker_retro_shroud_of_flames")
				end
			end
		elseif keys.caster.invoked_orbs[1]:GetName() == "invoker_retro_wex" then
			if keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_quas" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Wex Quas Quas
					keys.caster:AddAbility("invoker_retro_mana_burn")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Wex Quas Wex
					keys.caster:AddAbility("invoker_retro_emp")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Wex Quas Exort
					keys.caster:AddAbility("invoker_retro_soul_blast")
				end
			elseif keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_wex" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Wex Wex Quas
					keys.caster:AddAbility("invoker_retro_telelightning")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Wex Wex Wex
					keys.caster:AddAbility("invoker_retro_shock")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Wex Wex Exort
					keys.caster:AddAbility("invoker_retro_arcane_arts")
				end
			elseif keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_exort" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Wex Exort Quas
					keys.caster:AddAbility("invoker_retro_scout")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Wex Exort Wex
					keys.caster:AddAbility("invoker_retro_energy_ball")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Wex Exort Exort
					keys.caster:AddAbility("invoker_retro_lightning_shield")
				end
			end
		elseif keys.caster.invoked_orbs[1]:GetName() == "invoker_retro_exort" then
			if keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_quas" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Exort Quas Quas
					keys.caster:AddAbility("invoker_retro_chaos_meteor")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Exort Quas Wex
					keys.caster:AddAbility("invoker_retro_confuse")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Exort Quas Exort
					keys.caster:AddAbility("invoker_retro_disarm")
				end
			elseif keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_wex" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Exort Wex Quas
					keys.caster:AddAbility("invoker_retro_soul_reaver")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Exort Wex Wex
					keys.caster:AddAbility("invoker_retro_firestorm")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Exort Wex Exort
					keys.caster:AddAbility("invoker_retro_incinerate")
				end
			elseif keys.caster.invoked_orbs[2]:GetName() == "invoker_retro_exort" then
				if keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_quas" then  --Exort Exort Quas
					keys.caster:AddAbility("invoker_retro_deafening_blast")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_wex" then  --Exort Exort Wex
					keys.caster:AddAbility("invoker_retro_inferno")
				elseif keys.caster.invoked_orbs[3]:GetName() == "invoker_retro_exort" then  --Exort Exort Exort
					keys.caster:AddAbility("invoker_retro_firebolt")
				end
			end
		end
	end
	
	--Put the newly invoked ability on cooldown if it should still have a remaining cooldown from the last time it was invoked.
	local new_ability_f = keys.caster:GetAbilityByIndex(4)
	if new_ability_f ~= nil then
		new_ability_f:SetLevel(1)
		
		local new_ability_f_name = new_ability_f:GetName()
		if keys.caster.invoke_ability_cooldown_remaining[new_ability_f_name] ~= nil and keys.caster.invoke_ability_gametime_removed[new_ability_f_name] ~= nil and keys.caster.invoke_ability_cooldown_remaining[new_ability_f_name] ~= 0 then
			local current_game_time = GameRules:GetGameTime() 
			if keys.caster.invoke_ability_cooldown_remaining[new_ability_f_name] + keys.caster.invoke_ability_gametime_removed[new_ability_f_name] >= current_game_time then
				new_ability_f:StartCooldown(current_game_time - (keys.caster.invoke_ability_cooldown_remaining[new_ability_f_name] + keys.caster.invoke_ability_gametime_removed[new_ability_f_name]))
			end
		end
	end
end