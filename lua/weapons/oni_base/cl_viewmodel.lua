---------------------------------------
---------------------------------------
--        Star Trek Utilities        --
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

function SWEP:CleanupViewModel()
	local owner = self:GetOwner()
	if not IsValid(owner) then
		return
	end
	if owner ~= LocalPlayer() then
		return
	end

	local vm = owner:GetViewModel()
	if not IsValid(vm) then
		return
	end

	if istable(self.BoneManip) then
		for boneName, boneData in pairs(self.BoneManip) do
			local boneId = vm:LookupBone(boneName)
			if not boneId then
				continue
			end

			if isvector(boneData.Pos) then
				vm:ManipulateBonePosition(boneId, Vector())
			end
			if isvector(boneData.Ang) then
				vm:ManipulateBoneAngles(boneId, Angle())
			end
		end
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

function SWEP:PostDrawViewModel(vm, weapon, ply)
	self.IsViewModelRendering = true

	if isstring(self.CustomViewModel) then
		if not IsValid(self.CustomViewModelEntity) then
			self.CustomViewModelEntity = ClientsideModel(self.CustomViewModel)
			if not IsValid(self.CustomViewModelEntity) then
				return
			end

			if istable(self.BoneManip) then
				for boneName, boneData in pairs(self.BoneManip) do
					local boneId = vm:LookupBone(boneName)
					if not boneId then
						continue
					end

					if isvector(boneData.Pos) then
						vm:ManipulateBonePosition(boneId, boneData.Pos)
					end
					if isvector(boneData.Ang) then
						vm:ManipulateBoneAngles(boneId, boneData.Ang)
					end
				end
			end

			self.CustomViewModelEntity:SetNoDraw(true)
			self.CustomViewModelEntity:SetModelScale(self.CustomScale)
		end

		local m = vm:GetBoneMatrix(vm:LookupBone(self.CustomViewModelBone))
		local pos, ang = LocalToWorld(self.CustomViewModelOffset, self.CustomViewModelAngle, m:GetTranslation(), m:GetAngles())

		self.CustomViewModelEntity:SetPos(pos)
		self.CustomViewModelEntity:SetAngles(ang)

		self.CustomViewModelEntity:SetSkin(self:GetSkin())

		self.CustomViewModelEntity:DrawModel()
	end

	if isfunction(self.DrawViewModelCustom) then
		self:DrawViewModelCustom(flags)
	end
end