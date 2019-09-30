makeskeletons_lua = class({})

--------------------------------------------------------------------------------

function makeskeletons_lua:OnSpellStart()

	self.Skeletons = self.Skeletons + 1

	local unit = CreateUnitByName("npc_dota_dark_troll_warlord_skeleton_warrior", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	unit:SetDeathXP( 0 )
	unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

	unit.Owner = self:GetCaster();
	unit.IsSkeleton = true;

end

function makeskeletons_lua:OnUpgrade()

	if not self.Init then

		self.Init = true

		self.Skeletons = 0;
		ListenToGameEvent("entity_killed", makeskeletons_lua.WatchSkeletonDeaths, self)

	end

	self:StartSpawner()

end

function makeskeletons_lua:OnOwnerSpawned()

	self:StartSpawner()

end

function makeskeletons_lua:StartSpawner()

	self:SetThink("MakeSkeletons", self, self:GetCooldownTimeRemaining())

end

function makeskeletons_lua:ShouldSpawn()

	if not self:GetCaster():IsAlive() then return false end

	local maxskeletons = self:GetLevelSpecialValueFor("maxskeletons", (self:GetLevel() - 1))

	return self.Skeletons <= maxskeletons

end

function makeskeletons_lua:MakeSkeletons()

	if self:ShouldSpawn() then

		self:CastAbility()

	end

	if self:ShouldSpawn() then return self:GetCooldownTimeRemaining() end

end

function makeskeletons_lua:WatchSkeletonDeaths( event )

	local ent = EntIndexToHScript(event.entindex_killed)

	if ent.IsSkeleton and ent.Owner and ent.Owner == self:GetCaster() then

		self.Skeletons = self.Skeletons - 1

		if self:ShouldSpawn() then self:StartSpawner() end

	end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------