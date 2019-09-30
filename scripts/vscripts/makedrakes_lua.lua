makedrakes_lua = class({})

--------------------------------------------------------------------------------

function makedrakes_lua:OnSpellStart()

	self.drakes = self.drakes + 1

	local unit = CreateUnitByName("npc_dota_neutral_mud_golem", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Isdrake = true;

end

function makedrakes_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.drakes = 0;
		ListenToGameEvent("entity_killed", makedrakes_lua.WatchdrakeDeaths, self)

	end

	self:StartSpawner()

end

function makedrakes_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makedrakes_lua:StartSpawner()

	self:SetThink("Makedrakes", self, self:GetCooldownTimeRemaining())

end

function makedrakes_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxdrakes = self:GetLevelSpecialValueFor("maxdrakes", (self:GetLevel() - 1))

	return self.drakes <= maxdrakes

end

function makedrakes_lua:Makedrakes()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makedrakes_lua:WatchdrakeDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Isdrake and ent.Owner and ent.Owner == self:GetCaster() then

		self.drakes = self.drakes - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------