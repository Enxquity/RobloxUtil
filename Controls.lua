--!strict

local UserInputService = game:GetService("UserInputService")

export type Device = "Keyboard" | "Controller" | "Mobile"
export type Control = {
	Name: string,
	Binds: {[Device]: Enum.KeyCode | Enum.UserInputType},

	Get: (self: Control) -> Enum.KeyCode | Enum.UserInputType?,
	Check: (self: Control, Input: InputObject) -> boolean,
}

local Controls = {}
local ControlClass = {}
ControlClass.__index = ControlClass

function Controls:GetInputDevice(): Device
	if UserInputService.GamepadEnabled then
		return "Controller"
	elseif UserInputService.TouchEnabled then
		return "Mobile"
	else
		return "Keyboard"
	end
end

function ControlClass.new(Name: string, Binds: {[Device]: Enum.KeyCode | Enum.UserInputType}): Control
	local self = setmetatable({}, ControlClass) :: any

	self.Name = Name
	self.Binds = Binds

	return self :: Control
end

function ControlClass:Get(): Enum.KeyCode | Enum.UserInputType?
	local Device = Controls:GetInputDevice()
	return self.Binds[Device]
end

function ControlClass:Check(Input: InputObject): boolean
	local Bind = self:Get()

	if not Bind then
		return false
	end

	return Input.UserInputType == Bind or Input.KeyCode == Bind
end

local Control = {new = ControlClass.new} 

Controls.Example = Control.new("Example", {
	Keyboard  	= Enum.UserInputType.MouseButton1,
	Controller 	= Enum.KeyCode.ButtonR2,
	Mobile     	= Enum.UserInputType.Touch,
}) :: Control

return Controls
