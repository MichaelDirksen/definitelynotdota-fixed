maketreetanks_lua = class({})

--------------------------------------------------------------------------------

function maketreetanks_lua:OnSpellStart()

	self.treetanks = self.treetanks + 1

	local unit = CreateUnitByName("npc_dota_treetank", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Istreetank = true;

end

function maketreetanks_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.treetanks = 0;
		ListenToGameEvent("entity_killed", maketreetanks_lua.WatchtreetankDeaths, self)

	end

	self:StartSpawner()

end

function maketreetanks_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function maketreetanks_lua:StartSpawner()

	self:SetThink("Maketreetanks", self, self:GetCooldownTimeRemaining())

end

function maketreetanks_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxtreetanks = self:GetLevelSpecialValueFor("maxtreetanks", (self:GetLevel() - 1))

	return self.treetanks <= maxtreetanks

end

function maketreetanks_lua:Maketreetanks()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function maketreetanks_lua:WatchtreetankDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Istreetank and ent.Owner and ent.Owner == self:GetCaster() then

		self.treetanks = self.treetanks - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------