function item_hand_of_midas_datadriven_on_spell_start(keys)
    keys.caster:ModifyGold(keys.BonusGold, true, 0)  --Give the player a flat amount of reliable gold.
    
    --Start the particle and sound.
    local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster)  
    ParticleManager:SetParticleControlEnt(midas_particle, 1, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), false)
end