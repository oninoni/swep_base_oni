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
--       SWEP Oni Base | Server      --
---------------------------------------

include("shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_viewmodel.lua")

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

util.AddNetworkString("OniBase.ResetViewModel")
hook.Add("PlayerDroppedWeapon", "OniBase.ResetViewModel", function(ply, weapon)
	if weapon.OniBase then
		net.Start("OniBase.ResetViewModel")
			net.WriteEntity(weapon)
		net.Send(ply)
	end
end)