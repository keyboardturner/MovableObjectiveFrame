local defaultsTable = {
	ObjectiveTracker = {scale = 1,},
}

local ObjTrackerOptionsPanel = CreateFrame("FRAME", "ObjTrackPanel");
ObjTrackerOptionsPanel.name = "MovableObjectiveFrame";

local ObjTrackerOptionsPanelHeadline = ObjTrackerOptionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
ObjTrackerOptionsPanelHeadline:SetFont(ObjTrackerOptionsPanelHeadline:GetFont(), 23);
ObjTrackerOptionsPanelHeadline:SetTextColor(0,1,0,1);
ObjTrackerOptionsPanelHeadline:ClearAllPoints();
ObjTrackerOptionsPanelHeadline:SetPoint("TOPLEFT", ObjTrackerOptionsPanel, "TOPLEFT",12,-12);
ObjTrackerOptionsPanelHeadline:SetText("Movable Objective Frame");

local ObjTrackerOptionsPanelVersion = ObjTrackerOptionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal");
ObjTrackerOptionsPanelVersion:SetFont(ObjTrackerOptionsPanelVersion:GetFont(), 12);
ObjTrackerOptionsPanelVersion:SetTextColor(1,1,1,1);
ObjTrackerOptionsPanelVersion:ClearAllPoints();
ObjTrackerOptionsPanelVersion:SetPoint("TOPLEFT", ObjTrackerOptionsPanel, "TOPLEFT",400,-21);
ObjTrackerOptionsPanelVersion:SetText("Version: " .. GetAddOnMetadata("MovableObjectiveFrame", "Version"));

local ObjTrackerScaleSlider = CreateFrame("Slider", "ObjTrackScaleSlider", ObjTrackerOptionsPanel, "OptionsSliderTemplate");
ObjTrackerScaleSlider:SetWidth(300);
ObjTrackerScaleSlider:SetHeight(15);
ObjTrackerScaleSlider:SetMinMaxValues(50,150);
ObjTrackerScaleSlider:SetValueStep(1);
ObjTrackerScaleSlider:ClearAllPoints();
ObjTrackerScaleSlider:SetPoint("TOPLEFT", ObjTrackerOptionsPanel, "TOPLEFT",12,-53);
getglobal(ObjTrackerScaleSlider:GetName() .. 'Low'):SetText('50');
getglobal(ObjTrackerScaleSlider:GetName() .. 'High'):SetText('150');
getglobal(ObjTrackerScaleSlider:GetName() .. 'Text'):SetText('Objective Frame Size');
ObjTrackerScaleSlider:SetScript("OnValueChanged", function()
	local scaleValue = getglobal(ObjTrackerScaleSlider:GetName()):GetValue() / 100;
	MofDB.ObjectiveTracker.scale = scaleValue;
	ObjectiveTrackerFrame:SetScale(scaleValue);
end)

InterfaceOptions_AddCategory(ObjTrackerOptionsPanel);


local ObjTrackerEventFrame = CreateFrame("Frame");
ObjTrackerEventFrame:RegisterEvent("ADDON_LOADED");
function ObjTrackerEventFrame:OnEvent(event,arg1)
	if event == "ADDON_LOADED" then
		if not MofDB then
			MofDB = defaultsTable;
		end
		if not MofDB.ObjectiveTracker.scale then
			MofDB.ObjectiveTracker.scale = defaultsTable.ObjectiveTracker.scale;
		end
		ObjTrackerScaleSlider:SetValue(MofDB.ObjectiveTracker.scale*100);
	end
end
ObjTrackerEventFrame:SetScript("OnEvent",ObjTrackerEventFrame.OnEvent);