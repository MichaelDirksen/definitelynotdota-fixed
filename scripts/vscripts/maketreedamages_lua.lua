maketreedamages_lua = class({})

--------------------------------------------------------------------------------

function maketreedamages_lua:OnSpellStart()

	self.treedamages = self.treedamages + 1

	local unit = CreateUnitByName("npc_dota_treedamage", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Istreedamage = true;

end

function maketreedamages_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.treedamages = 0;
		ListenToGameEvent("entity_killed", maketreedamages_lua.WatchtreedamageDeaths, self)

	end

	self:StartSpawner()

end

function maketreedamages_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function maketreedamages_lua:StartSpawner()

	self:SetThink("Maketreedamages", self, self:GetCooldownTimeRemaining())

end

function maketreedamages_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxtreedamages = self:GetLevelSpecialValueFor("maxtreedamages", (self:GetLevel() - 1))

	return self.treedamages <= maxtreedamages

end

function maketreedamages_lua:Maketreedamages()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function maketreedamages_lua:WatchtreedamageDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Istreedamage and ent.Owner and ent.Owner == self:GetCaster() then

		self.treedamages = self.treedamages - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------