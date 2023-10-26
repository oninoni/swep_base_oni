---------------------------------------
---------------------------------------
--           Oni SWEP Base           --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2021 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--  SWEP Oni Base | Client Viewmodel --
---------------------------------------

SWEP.UseHands = true

function SWEP:ResetBoneMod(ent)
	for boneId = 0, ent:GetBoneCount() - 1 do
		ent:ManipulateBonePosition(boneId, Vector())
		ent:ManipulateBoneAngles(boneId, Angle())
	end
end

function SWEP:CleanupViewModel()
	local owner = LocalPlayer()
	if not IsValid(owner) then
		return
	end

	local vm = owner:GetViewModel()
	if not IsValid(vm) then
		return
	end

	if istable(self.BoneManip) then
		self:ResetBoneMod(vm)
	end

	if IsValid(self.CustomViewModelEntity) then
		self.CustomViewModelEntity:Remove()
	end
end

function SWEP:Holster(weapon)
	self:CleanupViewModel()
end

function SWEP:OnRemove()
	self:CleanupViewModel()
end

net.Receive("OniBase.ResetViewModel", function()
	local weapon = net.ReadEntity()
	weapon:CleanupViewModel()
end)

function SWEP:ApplyBoneMod(ent)
	for boneName, boneData in pairs(self.BoneManip) do
		local boneId = ent:LookupBone(boneName)
		if not boneId then
			continue
		end

		if isvector(boneData.Pos) then
			ent:ManipulateBonePosition(boneId, boneData.Pos)
		end
		if isangle(boneData.Ang) then
			ent:ManipulateBoneAngles(boneId, boneData.Ang)
		end
	end
end

function SWEP:PostDrawViewModel(vm, weapon, ply)
	self.IsViewModelRendering = true

	if isstring(self.CustomViewModel) then
		if not IsValid(self.CustomViewModelEntity) then
			self.CustomViewModelEntity = ClientsideModel(self.CustomViewModel)
			if not IsValid(self.CustomViewModelEntity) then
				return
			end

			if istable(self.BoneManip) then
				self:ApplyBoneMod(vm)
			end

			self.CustomViewModelEntity:SetNoDraw(true)
			self.CustomViewModelEntity:SetModelScale(self.CustomViewModelScale)
		end

		local m = vm:GetBoneMatrix(vm:LookupBone(self.CustomViewModelBone))
		if not m then
			return
		end
		local pos, ang = LocalToWorld(self.CustomViewModelOffset, self.CustomViewModelAngle, m:GetTranslation(), m:GetAngles())

		self.CustomViewModelEntity:SetPos(pos)
		self.CustomViewModelEntity:SetAngles(ang)

		self.CustomViewModelEntity:SetSkin(self:GetSkin())
		self.CustomViewModelEntity:SetBodyGroups(self:GetNWString("Oni_base.bodyGroups"))

		self.CustomViewModelEntity:DrawModel()
	end

	if isfunction(self.DrawViewModelCustom) then
		self:DrawViewModelCustom(flags)
	end
end