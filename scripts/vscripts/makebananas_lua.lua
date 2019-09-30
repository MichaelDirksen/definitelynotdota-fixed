makebananas_lua = class({})

--------------------------------------------------------------------------------

function makebananas_lua:OnSpellStart()

	self.bananas = self.bananas + 1

	local unit = CreateUnitByName("item_banana", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Isbanana = true;

end

function makebananas_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.bananas = 0;
		ListenToGameEvent("entity_killed", makebananas_lua.WatchbananaDeaths, self)

	end

	self:StartSpawner()

end

function makebananas_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makebananas_lua:StartSpawner()

	self:SetThink("Makebananas", self, self:GetCooldownTimeRemaining())

end

function makebananas_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxbananas = self:GetLevelSpecialValueFor("maxbananas", (self:GetLevel() - 1))

	return self.bananas <= maxbananas

end

function makebananas_lua:Makebananas()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makebananas_lua:WatchbananaDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Isbanana and ent.Owner and ent.Owner == self:GetCaster() then

		self.bananas = self.bananas - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------