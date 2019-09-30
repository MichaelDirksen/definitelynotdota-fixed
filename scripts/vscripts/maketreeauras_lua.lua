maketreeauras_lua = class({})

--------------------------------------------------------------------------------

function maketreeauras_lua:OnSpellStart()

	self.treeauras = self.treeauras + 1

	local unit = CreateUnitByName("npc_dota_treeaura", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Istreeaura = true;

end

function maketreeauras_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.treeauras = 0;
		ListenToGameEvent("entity_killed", maketreeauras_lua.WatchtreeauraDeaths, self)

	end

	self:StartSpawner()

end

function maketreeauras_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function maketreeauras_lua:StartSpawner()

	self:SetThink("Maketreeauras", self, self:GetCooldownTimeRemaining())

end

function maketreeauras_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxtreeauras = self:GetLevelSpecialValueFor("maxtreeauras", (self:GetLevel() - 1))

	return self.treeauras <= maxtreeauras

end

function maketreeauras_lua:Maketreeauras()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function maketreeauras_lua:WatchtreeauraDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Istreeaura and ent.Owner and ent.Owner == self:GetCaster() then

		self.treeauras = self.treeauras - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------