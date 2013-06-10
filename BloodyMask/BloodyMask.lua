local addon, ns = ...
local BloodyMask = { }
ns.BloodyMask = BloodyMask

local BloodyMaskEventFrame = CreateFrame("Frame", "BloodyMaskEventFrame")
BloodyMaskEventFrame:RegisterEvent("ADDON_LOADED")

local BloodyMaskTextureFrame = CreateFrame("Frame", "BloodyMaskTextureFrame")
BloodyMaskTextureFrame:SetAllPoints(UIParent)
BloodyMaskTextureFrame:SetFrameStrata("Background")
BloodyMaskTextureFrame:SetFrameLevel(0)

local BloodyMaskTexture = BloodyMaskTextureFrame:CreateTexture("Texture", "Background")
BloodyMaskTexture:SetAllPoints(BloodyMaskTextureFrame)
BloodyMaskTexture:SetDrawLayer("Background", 0)

BloodyMaskVariables = {
	EnableAddon = true,
	EnableSounds = true,
	SoundChannel = "Master",
	Health1 = 0.90,
	Health2 = 0.75,
	Health3 = 0.60,
	Health4 = 0.45,
	Health5 = 0.30,
	Health6 = 0.15
}

local AddonPath = "Interface\\AddOns\\BloodyMask\\"

local PlayerHealthObjectives = {Percent = nil}

local function PlayerHealthGetObjective(HealthPercent)
	if HealthPercent then
		return "Percent"
	else
		return false
	end
end

function BloodyMask:OnLoad()
	PlayerHealthObjectives.Percent = UnitHealth("player") / UnitHealthMax("player")
	BloodyMask:RegisterEvents()
	BloodyMaskEventFrame:UnregisterEvent("ADDON_LOADED")
end

function BloodyMask:RegisterEvents()
	BloodyMaskEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	BloodyMaskEventFrame:RegisterEvent("UNIT_HEALTH")
	BloodyMaskEventFrame:RegisterEvent("UNIT_MAXHEALTH")
end

local function PlayerHealthState(HealthPercent)
	if HealthPercent >= BloodyMaskVariables.Health1 then
		return 1
	elseif HealthPercent < BloodyMaskVariables.Health1 and HealthPercent > BloodyMaskVariables.Health2 then
		return 2
	elseif HealthPercent < BloodyMaskVariables.Health2 and HealthPercent > BloodyMaskVariables.Health3 then
		return 3
	elseif HealthPercent < BloodyMaskVariables.Health3 and HealthPercent > BloodyMaskVariables.Health4 then
		return 4
	elseif HealthPercent < BloodyMaskVariables.Health4 and HealthPercent > BloodyMaskVariables.Health5 then
		return 5
	elseif HealthPercent < BloodyMaskVariables.Health5 and HealthPercent > BloodyMaskVariables.Health6 then
		return 6
	elseif HealthPercent < BloodyMaskVariables.Health6 and UnitIsDeadOrGhost("player") ~= 1 then
		return 7
	else
		return 10
	end
end

function BloodyMask:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local Addon = ...
		if Addon == "BloodyMask" then
			if BloodyMaskVariables.EnableAddon == true then
				BloodyMask:OnLoad()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" or event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
		local PlayerHealthPercent = UnitHealth("player") / UnitHealthMax("player")
		-- Textures
		if PlayerHealthPercent >= BloodyMaskVariables.Health1 then
			if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask1.tga" then
				BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask1.tga")
			end
		elseif PlayerHealthPercent < BloodyMaskVariables.Health1 and PlayerHealthPercent >= BloodyMaskVariables.Health2 then
			if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask2.tga" then
				BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask2.tga")
			end
		elseif PlayerHealthPercent < BloodyMaskVariables.Health2 and PlayerHealthPercent >= BloodyMaskVariables.Health3 then
			if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask3.tga" then
				BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask3.tga")
			end
		elseif PlayerHealthPercent < BloodyMaskVariables.Health3 and PlayerHealthPercent >= BloodyMaskVariables.Health4 then
			if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask4.tga" then
				BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask4.tga")
			end
		elseif PlayerHealthPercent < BloodyMaskVariables.Health4 and PlayerHealthPercent >= BloodyMaskVariables.Health5 then
			if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask5.tga" then
				BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask5.tga")
			end
		elseif PlayerHealthPercent < BloodyMaskVariables.Health5 and PlayerHealthPercent >= BloodyMaskVariables.Health6 then
			if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask6.tga" then
				BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask6.tga")
			end
		elseif PlayerHealthPercent < BloodyMaskVariables.Health6 then
			if UnitIsDeadOrGhost("player") ~= 1 then
				if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask7.tga" then
					BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask7.tga")
				end
			else
				if UnitIsGhost("player") ~= 1 then
					if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Mask8.tga" then
						BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Mask8.tga")
					end
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack4.mp3", BloodyMaskVariables.SoundChannel)
				else
					if BloodyMaskTexture:GetTexture() ~= "Interface/AddOns/BloodyMask/Textures/Dirt.tga" then
						BloodyMaskTexture:SetTexture(AddonPath.."Textures\\Dirt.tga")
					end
				end
			end
		end
		-- Sounds
		if BloodyMaskVariables.EnableSounds == true then
			local type = PlayerHealthGetObjective(PlayerHealthPercent)
			if type then
				if PlayerHealthState(PlayerHealthObjectives[type]) < PlayerHealthState(PlayerHealthPercent) and PlayerHealthState(PlayerHealthPercent) == 2 then
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack1.mp3", BloodyMaskVariables.SoundChannel)
				elseif PlayerHealthState(PlayerHealthObjectives[type]) < PlayerHealthState(PlayerHealthPercent) and PlayerHealthState(PlayerHealthPercent) == 3 then
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack1.mp3", BloodyMaskVariables.SoundChannel)
				elseif PlayerHealthState(PlayerHealthObjectives[type]) < PlayerHealthState(PlayerHealthPercent) and PlayerHealthState(PlayerHealthPercent) == 4 then
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack2.mp3", BloodyMaskVariables.SoundChannel)
				elseif PlayerHealthState(PlayerHealthObjectives[type]) < PlayerHealthState(PlayerHealthPercent) and PlayerHealthState(PlayerHealthPercent) == 5 then
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack2.mp3", BloodyMaskVariables.SoundChannel)
				elseif PlayerHealthState(PlayerHealthObjectives[type]) < PlayerHealthState(PlayerHealthPercent) and PlayerHealthState(PlayerHealthPercent) == 6 then
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack3.mp3", BloodyMaskVariables.SoundChannel)
				elseif PlayerHealthState(PlayerHealthObjectives[type]) < PlayerHealthState(PlayerHealthPercent) and PlayerHealthState(PlayerHealthPercent) == 7 then
					PlaySoundFile(AddonPath.."Sounds\\MaskCrack3.mp3", BloodyMaskVariables.SoundChannel)
				end
				PlayerHealthObjectives[type] = PlayerHealthPercent
			end
		end
	end
end

if BloodyMaskVariables.EnableAddon == true then
	BloodyMaskEventFrame:SetScript("OnEvent", BloodyMask.OnEvent)
end