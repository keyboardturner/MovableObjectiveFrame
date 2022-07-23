local defaultsTable = {
	ObjectiveTracker = {show = true, checked = true, scale = 100, x = 1900, y = 0, height = 475, point = "TOPRIGHT", relativePoint = "TOPRIGHT"},
}

local function makeFrameMovable(frame,button)
	frame:SetMovable(true);
	frame:EnableMouse(true);
	frame:SetUserPlaced(true);
	frame:RegisterForDrag("LeftButton", "RightButton");
	
	frame:SetMinResize(235,100);
	frame:SetMaxResize(235,0);
	frame:SetResizable(true);
	frame:SetClampedToScreen(true);
	frame:SetClampRectInsets(-30, -1, -1, -1);
	
	frame:SetScript("OnMouseDown", function(self, button)
		if MofDB.ObjectiveTracker.checked then
			if button == "LeftButton" and not self.isMoving then
				Mixin(self, BackdropTemplateMixin);
				frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = -30, right = -1, top = -1, bottom = -1 }});
				frame:SetBackdropColor(1,.71,.75,.5);
				self:StartMoving();
				self.isMoving = true;
			end
			if button == "RightButton" and not self.isMoving then
				Mixin(self, BackdropTemplateMixin);
				frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = -30, right = -1, top = -1, bottom = -1 }});
				frame:SetBackdropColor(1,.71,.75,.5);
				self:StartSizing();
				self.isMoving = true;
			end
		end
	end);
	frame:SetScript("OnMouseUp", function(self)
		Mixin(self, BackdropTemplateMixin);
		frame:SetBackdropColor(0,0,0,0);
		self:StopMovingOrSizing();
		self.isMoving = false;
		local point, relativeTo, relativePoint, xOfs, yOfs = ObjectiveTrackerFrame:GetPoint();
		--[[ debug
		DEFAULT_CHAT_FRAME:AddMessage("point: " .. point)
		--DEFAULT_CHAT_FRAME:AddMessage("relativeTo: " .. relativeTo) -- this tends to break shit
		DEFAULT_CHAT_FRAME:AddMessage("relativePoint: " .. relativePoint)
		DEFAULT_CHAT_FRAME:AddMessage("x: " .. xOfs)
		DEFAULT_CHAT_FRAME:AddMessage("y: " .. yOfs)
		DEFAULT_CHAT_FRAME:AddMessage("height: " .. ObjectiveTrackerFrame:GetHeight())
		]]
		ObjectiveTrackerFrame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs);
		MofDB.ObjectiveTracker.point = point;
		MofDB.ObjectiveTracker.relativePoint = relativePoint;
		MofDB.ObjectiveTracker.x = xOfs;
		MofDB.ObjectiveTracker.y = yOfs;
		MofDB.ObjectiveTracker.height = ObjectiveTrackerFrame:GetHeight();
	end);
end

makeFrameMovable(ObjectiveTrackerFrame);

ObjectiveTrackerBlocksFrame:HookScript("OnUpdate", function(self)
	if MofDB then
		if MofDB.ObjectiveTracker.show == false then
			self:Hide()
			ObjectiveTrackerFrame.HeaderMenu.Title:Show()
		else
			self:Show()
			ObjectiveTrackerFrame.HeaderMenu.Title:Hide()
		end
	end
 end);

 ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:HookScript("OnClick", function()
	if MofDB.ObjectiveTracker.show == true then
		MofDB.ObjectiveTracker.show = false;
		ObjectiveTrackerBlocksFrame:Hide();
		ObjectiveTrackerFrame.HeaderMenu.Title:Show();
	else
		MofDB.ObjectiveTracker.show = true;
		ObjectiveTrackerBlocksFrame:Show();
	end
 end);


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

local ObjTrackerCheckbox = CreateFrame("CheckButton", "ObjTrackCheckbox", ObjTrackerOptionsPanel, "UICheckButtonTemplate");
ObjTrackerCheckbox:ClearAllPoints();
ObjTrackerCheckbox:SetPoint("TOPLEFT", 12, -80);
getglobal(ObjTrackCheckbox:GetName().."Text"):SetText("Objective Frame movable & resizable");

ObjTrackerCheckbox:SetScript("OnClick", function(self)
	if ObjTrackerCheckbox:GetChecked() then
		MofDB.ObjectiveTracker.checked = true;
	else
		MofDB.ObjectiveTracker.checked = false;
	end
end);
InterfaceOptions_AddCategory(ObjTrackerOptionsPanel);


local ObjTrackerEventFrame = CreateFrame("Frame");
ObjTrackerEventFrame:RegisterEvent("ADDON_LOADED");
function ObjTrackerEventFrame:OnEvent(event,arg1)
	if event == "ADDON_LOADED" then
		local point, relativeTo, relativePoint, xOfs, yOfs = ObjectiveTrackerFrame:GetPoint();
		if not MofDB then
			MofDB = defaultsTable;
		end
		if not MofDB.ObjectiveTracker.scale then
			MofDB.ObjectiveTracker.scale = defaultsTable.ObjectiveTracker.scale;
		end
		
		ObjTrackerScaleSlider:SetValue(MofDB.ObjectiveTracker.scale*100);
		ObjTrackerCheckbox:SetChecked(MofDB.ObjectiveTracker.checked);
		
		if not MofDB.ObjectiveTracker.point and MofDB.ObjectiveTracker.relativePoint and MofDB.ObjectiveTracker.x and MofDB.ObjectiveTracker.y then
			MofDB.ObjectiveTracker.point = defaultsTable.ObjectiveTracker.point;
			MofDB.ObjectiveTracker.relativePoint = defaultsTable.ObjectiveTracker.relativePoint;
			MofDB.ObjectiveTracker.x = defaultsTable.ObjectiveTracker.x;
			MofDB.ObjectiveTracker.y = defaultsTable.ObjectiveTracker.y;
			ObjectiveTrackerFrame:SetPoint(MofDB.ObjectiveTracker.point, relativeTo, MofDB.ObjectiveTracker.relativePoint, MofDB.ObjectiveTracker.x, MofDB.ObjectiveTracker.y);
		end
		if MofDB.ObjectiveTracker.point and MofDB.ObjectiveTracker.relativePoint and MofDB.ObjectiveTracker.x and MofDB.ObjectiveTracker.y then
			ObjectiveTrackerFrame:SetPoint(MofDB.ObjectiveTracker.point, relativeTo, MofDB.ObjectiveTracker.relativePoint, MofDB.ObjectiveTracker.x, MofDB.ObjectiveTracker.y);
		end
		if not MofDB.ObjectiveTracker.height then
			MofDB.ObjectiveTracker = defaultsTable.ObjectiveTracker.height;
		end
		if MofDB.ObjectiveTracker.height then
			ObjectiveTrackerFrame:SetHeight(MofDB.ObjectiveTracker.height);
		end
		--[[ debug
		DEFAULT_CHAT_FRAME:AddMessage("point: " .. point)
		--DEFAULT_CHAT_FRAME:AddMessage("relativeTo: " .. relativeTo) -- this tends to break shit
		DEFAULT_CHAT_FRAME:AddMessage("relativePoint: " .. relativePoint)
		DEFAULT_CHAT_FRAME:AddMessage("x: " .. xOfs .. " db value: " .. MofDB.ObjectiveTracker.x)
		DEFAULT_CHAT_FRAME:AddMessage("y: " .. yOfs .. " db value: " .. MofDB.ObjectiveTracker.y)
		DEFAULT_CHAT_FRAME:AddMessage("height: " .. ObjectiveTrackerFrame:GetHeight() .. " db value: " .. MofDB.ObjectiveTracker.height)
		]]
	end
end
ObjTrackerEventFrame:SetScript("OnEvent",ObjTrackerEventFrame.OnEvent);