makezombies2_lua = class({})

--------------------------------------------------------------------------------

function makezombies2_lua:OnSpellStart()

	self.zombies2 = self.zombies2 + 1

	local unit = CreateUnitByName("npc_dota_creature_berserk_zombie", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Iszombie = true;

end

function makezombies2_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.zombies2 = 0;
		ListenToGameEvent("entity_killed", makezombies2_lua.WatchzombieDeaths, self)

	end

	self:StartSpawner()

end

function makezombies2_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makezombies2_lua:StartSpawner()

	self:SetThink("Makezombies2", self, self:GetCooldownTimeRemaining())

end

function makezombies2_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxzombies2 = self:GetLevelSpecialValueFor("maxzombies2", (self:GetLevel() - 1))

	return self.zombies2 <= maxzombies2

end

function makezombies2_lua:Makezombies2()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makezombies2_lua:WatchzombieDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Iszombie and ent.Owner and ent.Owner == self:GetCaster() then

		self.zombies2 = self.zombies2 - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------