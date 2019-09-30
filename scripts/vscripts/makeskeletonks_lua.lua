makeskeletonks_lua = class({})

--------------------------------------------------------------------------------

function makeskeletonks_lua:OnSpellStart()

	self.skeletonks = self.skeletonks + 1

	local unit = CreateUnitByName("npc_dota_dark_troll_warlord_skeleton_king", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.Isskeletonk = true;

end

function makeskeletonks_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.skeletonks = 0;
		ListenToGameEvent("entity_killed", makeskeletonks_lua.WatchskeletonkDeaths, self)

	end

	self:StartSpawner()

end

function makeskeletonks_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makeskeletonks_lua:StartSpawner()

	self:SetThink("Makeskeletonks", self, self:GetCooldownTimeRemaining())

end

function makeskeletonks_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxskeletonks = self:GetLevelSpecialValueFor("maxskeletonks", (self:GetLevel() - 1))

	return self.skeletonks <= maxskeletonks

end

function makeskeletonks_lua:Makeskeletonks()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makeskeletonks_lua:WatchskeletonkDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.Isskeletonk and ent.Owner and ent.Owner == self:GetCaster() then

		self.skeletonks = self.skeletonks - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------