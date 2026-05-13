local Trove = getgenv().Trove
if Trove then
    Trove:Destroy()
end

local TroveModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sleitnick/RbxUtil/refs/heads/main/modules/trove/init.luau"))()
Trove = TroveModule.new()
getgenv().Trove = Trove

function GetUI()
    local Interface  = game:GetObjects("rbxassetid://139977655571357")[1]
    Interface.Parent = game.CoreGui

    Trove:Add(Interface)
    return Interface
end

local Interface = GetUI()
local Explorer, Properties = Interface.Explorer, Interface.Properties
local ExplorerContent, PropertiesContent = Explorer.Content, Properties.Content
local ExplorerItems, PropertiesItems = ExplorerContent.Items, PropertiesContent.Items

local SearchNav, TopNav = Explorer.SearchNav, Explorer.TopNav
local Options, SearchBox = SearchNav.Options, SearchNav.SearchBox
local CloseExplorer = TopNav.Close

local SoftExplorerRef   = ExplorerItems.Ancestor:Clone()
local SoftClassRef      = PropertiesItems.Class:Clone()
local SoftEntryRef      = PropertiesItems.Entry:Clone()

do 
    Properties.UIAspectRatioConstraint.AspectRatio = 0.84
    ExplorerContent.ClipsDescendants = true;
    ExplorerItems.Ancestor:Destroy(); PropertiesItems.Class:Destroy(); PropertiesItems.Entry:Destroy();
end


--[[
##################################################################################################################################
##################################################################################################################################
##################################################################################################################################
]]

local PropertyHandlers = {}
local PropertyWriters = {}

do
    PropertyHandlers.boolean = function(Object, Entry, Data)
        local EntryValue = Entry.EntryValue

        EntryValue.Value.Visible = false
        EntryValue.Checkbox.Visible = true

        local State = gethiddenproperty(Object, Data.Name)
        EntryValue.Checkbox.Enabled.Visible = State
    end

    PropertyHandlers.string = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Visible = true
        Entry.EntryValue.Checkbox.Visible = false
        Entry.EntryValue.Value.Text = tostring(Value)
    end

    PropertyHandlers.number = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Visible = true
        Entry.EntryValue.Checkbox.Visible = false
        Entry.EntryValue.Value.Text = tostring(Value)
    end

    PropertyHandlers.float = PropertyHandlers.number
    PropertyHandlers.double = PropertyHandlers.number
    PropertyHandlers.int = PropertyHandlers.number

    PropertyHandlers.Color3 = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Visible = true
        Entry.EntryValue.Checkbox.Visible = false

        Entry.EntryValue.Value.Text = string.format(
            "[%d, %d, %d]",
            Value.R * 255,
            Value.G * 255,
            Value.B * 255
        )

        local ColorDisplay = Entry.EntryValue:FindFirstChild("Color")
        if ColorDisplay then
            ColorDisplay.Visible = true
            ColorDisplay.BackgroundColor3 = Value
        end
    end

    PropertyHandlers.Vector3 = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = string.format(
            "%.2f, %.2f, %.2f",
            Value.X,
            Value.Y,
            Value.Z
        )
    end

    PropertyHandlers.Vector2 = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = string.format(
            "%.2f, %.2f",
            Value.X,
            Value.Y
        )
    end

    PropertyHandlers.UDim2 = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = string.format(
            "{%s, %s}, {%s, %s}",
            Value.X.Scale,
            Value.X.Offset,
            Value.Y.Scale,
            Value.Y.Offset
        )
    end

    PropertyHandlers.CFrame = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)
        local Position = Value.Position

        Entry.EntryValue.Value.Text = string.format(
            "%.2f, %.2f, %.2f",
            Position.X,
            Position.Y,
            Position.Z
        )
    end

    PropertyHandlers.EnumItem = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = Value.Name
    end

    PropertyHandlers.Instance = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        if Value then
            Entry.EntryValue.Value.Text = Value:GetFullName()
        else
            Entry.EntryValue.Value.Text = "nil"
        end
    end

    PropertyHandlers.BrickColor = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = Value.Name
        
        local ColorDisplay = Entry.EntryValue:FindFirstChild("Color")
        if ColorDisplay then
            ColorDisplay.Visible = true
            ColorDisplay.BackgroundColor3 = Value.Color
        end
    end

    PropertyHandlers.Rect = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = string.format(
            "%.0f, %.0f, %.0f, %.0f",
            Value.Min.X,
            Value.Min.Y,
            Value.Max.X,
            Value.Max.Y
        )
    end

    PropertyHandlers.PhysicalProperties = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        if Value then
            Entry.EntryValue.Value.Text = string.format(
                "D:%s F:%s E:%s",
                Value.Density,
                Value.Friction,
                Value.Elasticity
            )
        else
            Entry.EntryValue.Value.Text = "nil"
        end
    end

    PropertyHandlers.NumberSequence = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = tostring(#Value.Keypoints) .. " keypoints"
    end

    PropertyHandlers.ColorSequence = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = tostring(#Value.Keypoints) .. " keypoints"
    end

    PropertyHandlers.Axes = function(Object, Entry, Data)
        Entry.EntryValue.Value.Text = tostring(gethiddenproperty(Object, Data.Name))
    end

    PropertyHandlers.Faces = function(Object, Entry, Data)
        Entry.EntryValue.Value.Text = tostring(gethiddenproperty(Object, Data.Name))
    end

    PropertyHandlers.default = function(Object, Entry, Data)
        local Value = gethiddenproperty(Object, Data.Name)

        Entry.EntryValue.Value.Text = tostring(Value)
    end

    PropertyWriters.boolean = function(Object, Data, Entry)
        local Enabled = Entry.EntryValue.Checkbox.Enabled.Visible

        if Data.Read == false then
            sethiddenproperty(Object, Data.Name, Enabled)
        else
            Object[Data.Name] = Enabled
        end
    end

    PropertyWriters.string = function(Object, Data, Entry)
        local Value = Entry.EntryValue.Value.Text

        if Data.Read == false then
            sethiddenproperty(Object, Data.Name, Value)
        else
            Object[Data.Name] = Value
        end
    end

    PropertyWriters.number = function(Object, Data, Entry)
        local Number = tonumber(Entry.EntryValue.Value.Text)
        if not Number then
            return
        end

        if Data.Read == false then
            sethiddenproperty(Object, Data.Name, Number)
        else
            Object[Data.Name] = Number
        end
    end

    PropertyWriters.float = PropertyWriters.number
    PropertyWriters.double = PropertyWriters.number
    PropertyWriters.int = PropertyWriters.number

    PropertyWriters.Vector3 = function(Object, Data, Entry)
        local Text = Entry.EntryValue.Value.Text

        local X, Y, Z = Text:match("([^,]+),%s*([^,]+),%s*([^,]+)")
        X, Y, Z = tonumber(X), tonumber(Y), tonumber(Z)

        if not (X and Y and Z) then
            return
        end

        local Value = Vector3.new(X, Y, Z)

        if Data.Read == false then
            sethiddenproperty(Object, Data.Name, Value)
        else
            Object[Data.Name] = Value
        end
    end

    PropertyWriters.Color3 = function(Object, Data, Entry)
        local Text = Entry.EntryValue.Value.Text

        local R, G, B = Text:match("([^,]+),%s*([^,]+),%s*([^,]+)")
        R, G, B = tonumber(R), tonumber(G), tonumber(B)

        if not (R and G and B) then
            return
        end

        local Value = Color3.fromRGB(R, G, B)

        if Data.Read == false then
            sethiddenproperty(Object, Data.Name, Value)
        else
            Object[Data.Name] = Value
        end
    end

    PropertyWriters.EnumItem = function(Object, Data, Entry)
        local EnumType = Object[Data.Name]

        for _, Item in EnumType.EnumType:GetEnumItems() do
            if Item.Name == Entry.EntryValue.Value.Text then
                if Data.Read == false then
                    sethiddenproperty(Object, Data.Name, Item)
                else
                    Object[Data.Name] = Item
                end

                break
            end
        end
    end
    
    PropertyWriters.BrickColor = function(Object, Data, Entry)
        local Text = Entry.EntryValue.Value.Text
        local BrickCol = BrickColor.new(Text)

        if BrickCol then
            Object[Data.Name] = BrickCol
        end
    end

    PropertyWriters.default = function(Object, Data, Entry)
        local Value = Entry.EntryValue.Value.Text

        if Data.Read == false then
            sethiddenproperty(Object, Data.Name, Value)
        else
            Object[Data.Name] = Value
        end
    end
end

--[[
##################################################################################################################################
##################################################################################################################################
##################################################################################################################################
]]

local UserInputService = game:GetService("UserInputService")
local ReflectionService = game:GetService("ReflectionService")
local RunService        = game:GetService("RunService")

local HighlightsTrove = Trove.new()
local SelectionsTrove = Trove.new()
local PropertiesTrove = Trove.new()
local PriorityServices = {
    "Workspace";
    "Players";
    "Lighting";
    "MaterialService";
    "ReplicatedFirst";
    "ReplicatedStorage";
    "StarterGui";
    "CoreGui";
    "StarterPack";
    "StarterPlayer";
    "Teams",
    "SoundService"
}
local PriorityHeaders = {
    "Appearance",
    "Data",
    "Transform",
    "Pivot",
    "Behavior",
    "Control",
    "Game",
    "Jump Settings",
    "Collision",
    "Part",
    "Assembly",
    "AirProperties",
    "Networking",
    "Permissions",
    "Scripting",
    "Streaming",
    "Exposure"
}

local Nodes = {}
local Instances = {}
local Selections = {}

function ParseProperties(Properties)
	local List = {}
	for Index, Data in Properties do
        if Data.Display["DeprecationMessage"] ~= nil then
            continue
        end
        if Data.Permits["Read"] == nil and Data.Permits["Write"] == nil then
            continue
        end

		local Category = Data.Display.Category
		if not List[Category] then
			List[Category] = {}
		end
		table.insert(
			List[Category],
			{
				["Name"] = Data.Name,
				["Read"] = Data.Permits["Read"] ~= nil,
				["Write"] = Data.Permits["Write"] ~= nil,
				["Datatype"] = Data.Type.ScriptType
			}
		)
	end
	return List
end

local function DownloadAsset(AssetName)
    local Path = `Enxplorer/Images/{AssetName}.png`
    if isfile(Path) then
        return Path
    end

    local Good, Result = pcall(function()
        if request then
            local Response = request({
                Url = `https://raw.githubusercontent.com/Enxquity/ExplorerIcons/refs/heads/main/{AssetName}.png`;
                Method = "GET";
            })

            if Response and Response.StatusCode == 200 and Response.Body then
                return Response.Body
            end

            return nil
        end
    end)


    if not Good
        or not Result
        or #Result == 0
    then
        return nil
    end

    local WriteGood = pcall(writefile, Path, Result)
    if not WriteGood then
        return nil
    end

    return Path
end

function Sort(List, SortType)
    local SType = SortType or "Class"

    if SType == "Class" then
        local NewList = {}
        local ClassPriority = {"Camera", "Terrain", "Part", "MeshPart", "Model"}

        table.sort(List, function(A, B)
            local Last = A
            local Curr = B

            local PriorityLast = table.find(ClassPriority, Last.ClassName)
            local PriorityCurr = table.find(ClassPriority, Curr.ClassName)

            if PriorityLast and PriorityCurr then
                return PriorityLast < PriorityCurr
            end

            if PriorityLast then
                return true
            end

            if PriorityCurr then
                return false
            end

            return Last.ClassName < Curr.ClassName
        end)

        return List
    end
end

function CreateNode(Object, Depth)
    if Nodes[Object] then
        return
    end

    local Depth = Depth or 0
    local Node = {
        Instance = Object;
        Parent = Object.Parent;
        Children = {};
        Expanded = false;
        Depth = Depth;
    }
    Nodes[Object] = Node;

    for _, Child in Object:GetChildren() do
        table.insert(Node.Children, Child)
        CreateNode(Child, Depth + 1)
    end

    Node.Children = Sort(Node.Children)

    Node._ChildAdded = Object.ChildAdded:Connect(function(Child)
        local ParentNode = Nodes[Node.Parent]

        table.insert(Node.Children, Child)
        CreateNode(Child, Node.Depth + 1)
        Node.Children = Sort(Node.Children)

        if Node.Expanded or (ParentNode and ParentNode.Expanded) then
            RenderNodes()
        end
    end)

    Node._ChildRemoved = Object.ChildRemoved:Connect(function(Child)
        local Index = table.find(Node.Children, Child)

        if Index then
            table.remove(Node.Children, Index)
        end

        if Node.Expanded then
            RenderNodes()
        end
    end)
end

function CreateUI(Object)
    local NewInstanceRef = SoftExplorerRef:Clone()
    NewInstanceRef.Parent = ExplorerItems
    NewInstanceRef.Icon.Image = "rbxassetid://6035190886"

    task.spawn(function()
        local ClassIcon = DownloadAsset(Object.ClassName)
        if ClassIcon and NewInstanceRef.Parent ~= nil then
            local CustomImage = getcustomasset(ClassIcon)
            NewInstanceRef.Icon.Image = CustomImage
        end
    end)

    return NewInstanceRef
end

function GetVisibleNodes()
    local Visible = {}

    local function Visit(Object)
        local Node = Nodes[Object]
        if not Node then return end

        table.insert(Visible, Object)

        if Node.Expanded then
            for _, Child in Node.Children do
                Visit(Child)
            end
        end
    end

    for _, ServiceName in PriorityServices do
        local Service = game:GetService(ServiceName)

        if Nodes[Service] then
            Visit(Service)
        end
    end

    return Visible
end

function RenderNodes()
    local VisibleNodes = GetVisibleNodes()

    --// Remove any non-displayed instances or deleted instances
    for Object, UIInstance in Instances do
        if table.find(VisibleNodes, Object) == nil or Object.Parent == nil then
            UIInstance:Destroy()
            Instances[Object] = nil
        end
    end

    for Index, Object in VisibleNodes do
        local Node = Nodes[Object]

        local UI = Instances[Object]
        if not UI then
            UI = CreateUI(Object)
            Instances[Object] = UI

            UI.Toggle.Button.MouseButton1Click:Connect(function()
                Node.Expanded = not Node.Expanded
                RenderNodes()
            end)

            UI.Toggle.Button.MouseEnter:Connect(function()
                if UI.Toggle.ImageTransparency == 1 then return end
                UI.Toggle.Button.BackgroundTransparency = 0.9
            end)

            UI.Toggle.Button.MouseLeave:Connect(function()
                UI.Toggle.Button.BackgroundTransparency = 1
            end)

            UI.MouseEnter:Connect(function()
                HighlightsTrove:Clean()
                local NewHighlight = ExplorerContent.Highlight:Clone()
                NewHighlight.Parent = ExplorerContent
                
                HighlightsTrove:Add(NewHighlight)
                HighlightsTrove:Add(task.spawn(function()
                    while task.wait() do
                        NewHighlight.Position = UDim2.new(0, 0, 0, UI.AbsolutePosition.Y - ExplorerContent.AbsolutePosition.Y)
                    end
                end))
                task.delay(0.01, function()
                    NewHighlight.Visible = true
                end)

                NewHighlight.MouseButton1Click:Connect(function()
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        if #Selections == 0 then
                            return SelectNodes(Object)
                        end

                        SelectNodes(Selections[1], Object)
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        SelectNodes(Object, Object, true)
                    else
                        SelectNodes(Object)
                    end
                end)
            end)

            UI.MouseLeave:Connect(function()
                HighlightsTrove:Clean()
            end)
        end

        UI.Label.Text = Object.Name
        UI.Size = UDim2.fromScale(1, UI.Size.Y.Scale) - UDim2.fromScale((0.05 * Node.Depth), 0)
        UI.LayoutOrder = Index

        UI.Toggle.ImageTransparency = #Node.Children > 0 and 0 or 1
        UI.Toggle.Image = if Node.Expanded == true then "rbxassetid://70478037432292" else "rbxassetid://76611590900618" 
    end
end

function UpdateProperty(Object, Entry, Data)
    local Handler = PropertyHandlers[Data.Datatype] or PropertyHandlers.default
    Handler(Object, Entry, Data)
end

function ApplyProperty(Object, Data, Entry)
    if Data.Write == false then
        return
    end
    print("try apply")

    local Writer = PropertyWriters[Data.Datatype]
        or PropertyWriters.default

    local Success, Error = pcall(function()
        Writer(Object, Data, Entry)
    end)

    if not Success then
        warn(Error)
        UpdateProperty(Object, Entry, Data)
    end
end

function RenderProperties()
    if #Selections == 0 then
        return PropertiesTrove:Clean()
    end
    PropertiesTrove:Clean()

    local LastObject = Selections[#Selections]
    if not LastObject then
        return
    end

    local RawProperties = ReflectionService:GetPropertiesOfClass(LastObject.ClassName)
    local ParsedProperties    = ParseProperties(RawProperties)

    for Header, Props in ParsedProperties do
        if not table.find(PriorityHeaders, Header) then
            table.insert(PriorityHeaders, Header)
        end
    end

    for _, Header in PriorityHeaders do
        local Props = ParsedProperties[Header]
        if not Props then
            continue
        end

        local HeaderItems = {}
        local NewHeader = SoftClassRef:Clone()
        NewHeader.Parent = PropertiesItems
        NewHeader.Visible = true
        NewHeader.TextLabel.Text = Header
        NewHeader.LayoutOrder = #PropertiesItems:GetChildren()

        NewHeader.Toggle.MouseButton1Click:Connect(function()
            for _, Item in HeaderItems do
                Item.Visible = not Item.Visible
            end
        end)

        for Index, Data in Props do
            --[[local Exists = pcall(function()
                return gethiddenproperty(LastObject, Data.Name)
            end)
            if Exists == false then
                continue
            end--]]

            local NewEntry = SoftEntryRef:Clone()
            NewEntry.Parent = PropertiesItems
            NewEntry.Visible = true
            NewEntry.LayoutOrder = NewHeader.LayoutOrder + Index
            NewEntry.EntryValue.Value.Text = if Data.Read == false then tostring(gethiddenproperty(LastObject, Data.Name)) else tostring(LastObject[Data.Name])

            local function UpdateLength()
                local MaxLen = (15 + math.round((Properties.UIAspectRatioConstraint.AspectRatio - 0.84) * 10))
                if #Data.Name >= MaxLen then
                    Data.TruncatedName = Data.Name:sub(1, MaxLen - 3) .. "..."
                else
                    Data.TruncatedName = nil
                end
            end
            UpdateLength()

            NewEntry.EntryName.Value.Text = Data.TruncatedName or Data.Name
            NewEntry.EntryName.Value.TextColor3 = Data.Write == true and NewEntry.EntryName.Value.TextColor3 or Color3.fromRGB(100, 100, 100)
            NewEntry.EntryValue.Value.TextColor3 = Data.Write == true and NewEntry.EntryValue.Value.TextColor3 or Color3.fromRGB(100, 100, 100)

            UpdateProperty(LastObject, NewEntry, Data)
            PropertiesTrove:Add(LastObject:GetPropertyChangedSignal(Data.Name):Connect(function()
                UpdateProperty(LastObject, NewEntry, Data)
                RenderNodes()
            end))
            PropertiesTrove:Add(Properties.UIAspectRatioConstraint:GetPropertyChangedSignal("AspectRatio"):Connect(function()
                UpdateLength()
                NewEntry.EntryName.Value.Text = Data.TruncatedName or Data.Name
            end))

            if Data.Write ~= false then
                if Data.Datatype == "boolean" then
                    PropertiesTrove:Add(
                        NewEntry.EntryValue.Checkbox.MouseButton1Click:Connect(function()
                            local Enabled = NewEntry.EntryValue.Checkbox.Enabled
                            Enabled.Visible = not Enabled.Visible

                            ApplyProperty(LastObject, Data, NewEntry)
                        end)
                    )
                else
                    PropertiesTrove:Add(
                        NewEntry.EntryValue.Value.FocusLost:Connect(function(EnterPressed)
                            if not EnterPressed then
                                UpdateProperty(LastObject, NewEntry, Data)
                                return
                            end

                            ApplyProperty(LastObject, Data, NewEntry)
                        end)
                    )
                end
            end

            PropertiesTrove:Add(NewEntry)
            table.insert(HeaderItems, NewEntry)
        end

        PropertiesTrove:Add(NewHeader)
    end
end

function SelectNodes(ObjFrom, ObjTo, CTRL)
    local ObjTo = ObjTo or ObjFrom
    local VisibleNodes = GetVisibleNodes()

    local From, To;
    for Index, Object in VisibleNodes do
        if Object == ObjFrom then
            From = Index
        end

        if Object == ObjTo then
            To = Index
        end

        if From ~= nil and To ~= nil then
            break
        end
    end

    local Objects = {}
    local Step = if From <= To then 1 else -1
    for Index = From, To, Step do
        table.insert(Objects, VisibleNodes[Index])
    end

    SelectionsTrove:Clean()
    if CTRL == nil or CTRL == false then
        Selections = Objects
    else
        for _, Object in Selections do
            if table.find(Objects, Object) then
                table.remove(Objects, table.find(Objects, Object))
                continue
            end
            table.insert(Objects, Object)
        end
        Selections = Objects
    end

    for Index = 1, #Objects do
        local Object = Objects[Index]
        local UIObject = Instances[Object]

        if UIObject then
            local NewSelection = ExplorerContent.Selection:Clone()
            NewSelection.Parent = ExplorerContent.Selections

            SelectionsTrove:Add(NewSelection)
            SelectionsTrove:Add(task.spawn(function()
                while task.wait() do
                    if not UIObject.Parent then
                        NewSelection:Destroy()
                        break
                    end
                    NewSelection.Position = UDim2.new(0, 0, 0, UIObject.AbsolutePosition.Y - ExplorerContent.AbsolutePosition.Y)
                end
            end))
            task.delay(0.001, function()
                NewSelection.Visible = true
            end)
        end
    end

    RenderProperties()
end

local StartMouseX, StartRatio, LastRatio
local IsOnEdge, Resizing = false, false
Trove:Add(RunService.RenderStepped:Connect(function()
    local MouseLocation = UserInputService:GetMouseLocation()
    local FramePos = Properties.AbsolutePosition
    local FrameSize = Properties.AbsoluteSize

    local RightEdge = FramePos.X + FrameSize.X 

    if MouseLocation.X <= RightEdge + 12 and MouseLocation.X >= RightEdge then
        IsOnEdge = true
        UserInputService.MouseIcon = "rbxassetid://102777592278447"
    else
        IsOnEdge = false
        UserInputService.MouseIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
    end
end))

Trove:Add(UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then
		return
	end

    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        if IsOnEdge == true then
            StartMouseX = UserInputService:GetMouseLocation().X
            StartRatio = Properties.UIAspectRatioConstraint.AspectRatio
            LastRatio = StartRatio
            Resizing = true
            return
        end

        SelectionsTrove:Clean()
        Selections = {}

        RenderProperties()
    end
end))

Trove:Add(UserInputService.InputEnded:Connect(function(Input, GameProcessed)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Resizing = false
    end

	if GameProcessed then
		return
	end

    -- Next
end))

Trove:Add(UserInputService.InputChanged:Connect(function(Input)
	if not Resizing then return end
	if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

    local CurrentX = UserInputService:GetMouseLocation().X
    local Delta = CurrentX - StartMouseX

    local NewRatio = StartRatio + (Delta / 350)
    NewRatio = math.clamp(NewRatio, 0.84, 2)

    if NewRatio == 1 or NewRatio == 2 then
        StartMouseX = CurrentX
        StartRatio = NewRatio
    end

    Properties.UIAspectRatioConstraint.AspectRatio = NewRatio
    LastRatio = NewRatio
end))

for _, Service in PriorityServices do
    CreateNode(game:GetService(Service))
end
RenderNodes()
