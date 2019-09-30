makezombies1_lua = class({})

--------------------------------------------------------------------------------

function makezombies1_lua:OnSpellStart()

	self.zombies1 = self.zombies1 + 1

	local unit = CreateUnitByName("npc_dota_creature_basic_zombie", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Iszombie = true;

end

function makezombies1_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.zombies1 = 0;
		ListenToGameEvent("entity_killed", makezombies1_lua.WatchzombieDeaths, self)

	end

	self:StartSpawner()

end

function makezombies1_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makezombies1_lua:StartSpawner()

	self:SetThink("Makezombies1", self, self:GetCooldownTimeRemaining())

end

function makezombies1_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxzombies1 = self:GetLevelSpecialValueFor("maxzombies1", (self:GetLevel() - 1))

	return self.zombies1 <= maxzombies1

end

function makezombies1_lua:Makezombies1()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makezombies1_lua:WatchzombieDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Iszombie and ent.Owner and ent.Owner == self:GetCaster() then

		self.zombies1 = self.zombies1 - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------