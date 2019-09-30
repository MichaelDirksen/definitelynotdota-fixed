makedragons_lua = class({})

--------------------------------------------------------------------------------

function makedragons_lua:OnSpellStart()

	self.dragons = self.dragons + 1

	local unit = CreateUnitByName("npc_dota_neutral_rock_golem", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Isdragon = true;

end

function makedragons_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.dragons = 0;
		ListenToGameEvent("entity_killed", makedragons_lua.WatchdragonDeaths, self)

	end

	self:StartSpawner()

end

function makedragons_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makedragons_lua:StartSpawner()

	self:SetThink("Makedragons", self, self:GetCooldownTimeRemaining())

end

function makedragons_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxdragons = self:GetLevelSpecialValueFor("maxdragons", (self:GetLevel() - 1))

	return self.dragons <= maxdragons

end

function makedragons_lua:Makedragons()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makedragons_lua:WatchdragonDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Isdragon and ent.Owner and ent.Owner == self:GetCaster() then

		self.dragons = self.dragons - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------