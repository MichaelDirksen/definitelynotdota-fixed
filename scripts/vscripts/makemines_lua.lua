makemines_lua = class({})

--------------------------------------------------------------------------------

function makemines_lua:OnSpellStart()

	self.mines = self.mines + 1

	local unit = CreateUnitByName("npc_dota_techies_land_mine", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Ismine = true;

end

function makemines_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.mines = 0;
		ListenToGameEvent("entity_killed", makemines_lua.WatchmineDeaths, self)

	end

	self:StartSpawner()

end

function makemines_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makemines_lua:StartSpawner()

	self:SetThink("Makemines", self, self:GetCooldownTimeRemaining())

end

function makemines_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxmines = self:GetLevelSpecialValueFor("maxmines", (self:GetLevel() - 1))

	return self.mines <= maxmines

end

function makemines_lua:Makemines()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makemines_lua:WatchmineDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Ismine and ent.Owner and ent.Owner == self:GetCaster() then

		self.mines = self.mines - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------