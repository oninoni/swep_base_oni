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
--    Copyright © 2020 Jan Ziegler   --
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

	vm:ManipulateBonePosition(vm:LookupBone("ValveBiped.cube3"), Vector(0, 0, 0))
	vm:ManipulateBoneAngles(vm:LookupBone("ValveBiped.Bip01_Spine"), Angle(0, 0, 0))

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
	if isstring(self.CustomViewModel) then
		if not IsValid(self.CustomViewModelEntity) then
			self.CustomViewModelEntity = ClientsideModel(self.CustomViewModel)
			if not IsValid(self.CustomViewModelEntity) then
				return
			end

			-- Removing Bugbait from Viewmodel
			vm:ManipulateBonePosition(vm:LookupBone("ValveBiped.cube3"), Vector(0, 0, 100))
			vm:ManipulateBoneAngles(vm:LookupBone("ValveBiped.Bip01_Spine"), Angle(0, 0, -20))

			self.CustomViewModelEntity:SetNoDraw(true)
			self.CustomViewModelEntity:SetModelScale(self.CustomScale)
		end

		local m = vm:GetBoneMatrix(vm:LookupBone(self.CustomViewModelBone))
		local pos, ang = LocalToWorld(self.CustomViewModelOffset, self.CustomViewModelAngle, m:GetTranslation(), m:GetAngles())

		self.CustomViewModelEntity:SetPos(pos)
		self.CustomViewModelEntity:SetAngles(ang)

		self.CustomViewModelEntity:DrawModel()
	end

	if isfunction(self.DrawViewModelCustom) then
		self:DrawViewModelCustom(flags)
	end
end