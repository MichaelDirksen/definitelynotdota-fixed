maketreeslows_lua = class({})

--------------------------------------------------------------------------------

function maketreeslows_lua:OnSpellStart()

	self.treeslows = self.treeslows + 1

	local unit = CreateUnitByName("npc_dota_treeslow", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Istreeslow = true;

end

function maketreeslows_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.treeslows = 0;
		ListenToGameEvent("entity_killed", maketreeslows_lua.WatchtreeslowDeaths, self)

	end

	self:StartSpawner()

end

function maketreeslows_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function maketreeslows_lua:StartSpawner()

	self:SetThink("Maketreeslows", self, self:GetCooldownTimeRemaining())

end

function maketreeslows_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxtreeslows = self:GetLevelSpecialValueFor("maxtreeslows", (self:GetLevel() - 1))

	return self.treeslows <= maxtreeslows

end

function maketreeslows_lua:Maketreeslows()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function maketreeslows_lua:WatchtreeslowDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Istreeslow and ent.Owner and ent.Owner == self:GetCaster() then

		self.treeslows = self.treeslows - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------