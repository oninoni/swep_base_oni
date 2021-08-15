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
--       SWEP Oni Base | Client      --
---------------------------------------

include("shared.lua")
include("cl_viewmodel.lua")

SWEP.Category = ""
SWEP.DrawAmmo = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	if isfunction(self.InitializeCustom) then
		self:InitializeCustom()
	end
end

function SWEP:Deploy()
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:DrawWorldModel(flags)
	if self.CustomDrawWorldModel then
		local owner = self:GetOwner()
		if not IsValid(owner) then
			self:DrawModel(flags)

			return
		end

		if not IsValid(self.CustomWorldModelEntity) then
			self.CustomWorldModelEntity = ClientsideModel(self.WorldModel)
			if not IsValid(self.CustomWorldModelEntity) then
				return
			end

			self.CustomWorldModelEntity:SetNoDraw(true)
			self.CustomWorldModelEntity:SetModelScale(self.CustomScale)
		end

		local m = owner:GetBoneMatrix(owner:LookupBone(self.CustomWorldModelBone))
		local pos, ang = LocalToWorld(self.CustomWorldModelOffset, self.CustomWorldModelAngle, m:GetTranslation(), m:GetAngles())

		self.CustomWorldModelEntity:SetPos(pos)
		self.CustomWorldModelEntity:SetAngles(ang)

		self.CustomWorldModelEntity:DrawModel(flags)
	else
		self:DrawModel(flags)

		return
	end

	if isfunction(self.DrawWorldModelCustom) then
		self:DrawWorldModelCustom(flags)
	end
end