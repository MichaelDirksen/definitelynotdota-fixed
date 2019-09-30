makerangedcreeps_lua = class({})

--------------------------------------------------------------------------------

function makerangedcreeps_lua:OnSpellStart()

	self.rangedcreeps = self.rangedcreeps + 1

	local unit = CreateUnitByName("npc_dota_creep_badguys_ranged", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Israngedcreep = true;

end

function makerangedcreeps_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.rangedcreeps = 0;
		ListenToGameEvent("entity_killed", makerangedcreeps_lua.WatchrangedcreepDeaths, self)

	end

	self:StartSpawner()

end

function makerangedcreeps_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makerangedcreeps_lua:StartSpawner()

	self:SetThink("Makerangedcreeps", self, self:GetCooldownTimeRemaining())

end

function makerangedcreeps_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxrangedcreeps = self:GetLevelSpecialValueFor("maxrangedcreeps", (self:GetLevel() - 1))

	return self.rangedcreeps <= maxrangedcreeps

end

function makerangedcreeps_lua:Makerangedcreeps()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makerangedcreeps_lua:WatchrangedcreepDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Israngedcreep and ent.Owner and ent.Owner == self:GetCaster() then

		self.rangedcreeps = self.rangedcreeps - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------