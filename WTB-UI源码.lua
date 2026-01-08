
if (game:GetService("CoreGui")):FindFirstChild("WTB") and (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then
	(game:GetService("CoreGui")).WTB:Destroy();
	(game:GetService("CoreGui")).ScreenGui:Destroy();
end;

_G.Primary = Color3.fromRGB(50, 50, 50);
_G.Dark = Color3.fromRGB(15, 15, 20);
_G.Third = Color3.fromRGB(220, 20, 60);
_G.Accent = Color3.fromRGB(138, 43, 226);
_G.White = Color3.fromRGB(240, 240, 240);

function CreateRounded(Parent, Size)
	local Rounded = Instance.new("UICorner");
	Rounded.Name = "Rounded";
	Rounded.Parent = Parent;
	Rounded.CornerRadius = UDim.new(0, Size);
end;

local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

function CreateGradientFrame(parent, colors, rotation)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.ZIndex = -1
	
	local colorSequenceKeypoints = {}
	for i, color in ipairs(colors) do
		table.insert(colorSequenceKeypoints, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
	end
	
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(colorSequenceKeypoints)
	gradient.Rotation = rotation or 0
	gradient.Parent = frame
	
	frame.Parent = parent
	return frame
end

function MakeDraggable(topbarobject, object)
	local Dragging = nil;
	local DragInput = nil;
	local DragStart = nil;
	local StartPosition = nil;
	
	local function Update(input)
		local Delta = input.Position - DragStart;
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y);
		local Tween = TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos});
		Tween:Play();
	end;
	
	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true;
			DragStart = input.Position;
			StartPosition = object.Position;
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false;
				end;
			end);
		end;
	end;
	
	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input;
		end;
	end);
	
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input);
		end;
	end);
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Parent = game.CoreGui;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

local OutlineButton = Instance.new("Frame");
OutlineButton.Name = "OutlineButton";
OutlineButton.Parent = ScreenGui;
OutlineButton.ClipsDescendants = true;
OutlineButton.BackgroundColor3 = _G.Dark;
OutlineButton.BackgroundTransparency = 0;
OutlineButton.Position = UDim2.new(0, 10, 0, 10);
OutlineButton.Size = UDim2.new(0, 50, 0, 50);
CreateRounded(OutlineButton, 12);

CreateGradientFrame(OutlineButton, {
	_G.Third,
	_G.Accent,
	_G.Third
}, 45)

local ImageButton = Instance.new("ImageButton");
ImageButton.Parent = OutlineButton;
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0);
ImageButton.Size = UDim2.new(0, 40, 0, 40);
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
ImageButton.BackgroundColor3 = _G.Dark;
ImageButton.ImageColor3 = _G.White;
ImageButton.ImageTransparency = 0;
ImageButton.BackgroundTransparency = 0;
ImageButton.Image = "https://raw.githubusercontent.com/Potato5466794/ZeroXHub/refs/heads/main/IMG_20260103_062921.png";
ImageButton.AutoButtonColor = false;
MakeDraggable(ImageButton, OutlineButton);
CreateRounded(ImageButton, 8);

local NotificationFrame = Instance.new("ScreenGui");
NotificationFrame.Name = "NotificationFrame";
NotificationFrame.Parent = game.CoreGui;
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global;

local NotificationList = {};

local function RemoveOldestNotification()
	if #NotificationList > 0 then
		local removed = table.remove(NotificationList, 1);
		removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
			removed[1]:Destroy();
		end);
	end;
end;

spawn(function()
	while wait() do
		if #NotificationList > 0 then
			wait(2.5);
			RemoveOldestNotification();
		end;
	end;
end);

local Update = {};

function Update:Notify(desc)
	local Frame = Instance.new("Frame");
	local Image = Instance.new("ImageLabel");
	local Title = Instance.new("TextLabel");
	local Desc = Instance.new("TextLabel");
	local OutlineFrame = Instance.new("Frame");
	
	OutlineFrame.Name = "OutlineFrame";
	OutlineFrame.Parent = NotificationFrame;
	OutlineFrame.ClipsDescendants = true;
	OutlineFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 1);
	OutlineFrame.BackgroundTransparency = 0.4;
	OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0);
	OutlineFrame.Size = UDim2.new(0, 412, 0, 72);
	CreateRounded(OutlineFrame, 12);

	CreateGradientFrame(OutlineFrame, {
		_G.Third,
		_G.Accent,
		_G.Third
	}, 45)
	
	Frame.Name = "Frame";
	Frame.Parent = OutlineFrame;
	Frame.ClipsDescendants = true;
	Frame.AnchorPoint = Vector2.new(0.5, 0.5);
	Frame.BackgroundColor3 = _G.Dark;
	Frame.BackgroundTransparency = 0.1;
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
	Frame.Size = UDim2.new(0, 400, 0, 60);
	CreateRounded(Frame, 10);
	
	Image.Name = "Icon";
	Image.Parent = Frame;
	Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	Image.BackgroundTransparency = 1;
	Image.Position = UDim2.new(0, 8, 0, 8);
	Image.Size = UDim2.new(0, 45, 0, 45);
	Image.Image = "https://raw.githubusercontent.com/Potato5466794/ZeroXHub/refs/heads/main/IMG_20260103_062921.pn";
	
	Title.Parent = Frame;
	Title.BackgroundColor3 = _G.Primary;
	Title.BackgroundTransparency = 1;
	Title.Position = UDim2.new(0, 55, 0, 14);
	Title.Size = UDim2.new(0, 10, 0, 20);
	Title.Font = Enum.Font.GothamBold;
	Title.Text = "ZeroX";
	Title.TextColor3 = _G.White;
	Title.TextSize = 16;
	Title.TextXAlignment = Enum.TextXAlignment.Left;
	
	Desc.Parent = Frame;
	Desc.BackgroundColor3 = _G.Primary;
	Desc.BackgroundTransparency = 1;
	Desc.Position = UDim2.new(0, 55, 0, 33);
	Desc.Size = UDim2.new(0, 10, 0, 10);
	Desc.Font = Enum.Font.GothamSemibold;
	Desc.TextTransparency = 0.3;
	Desc.Text = desc;
	Desc.TextColor3 = Color3.fromRGB(200, 200, 200);
	Desc.TextSize = 12;
	Desc.TextXAlignment = Enum.TextXAlignment.Left;
	
	OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.1, 0), "Out", "Quad", 0.4, true);
	table.insert(NotificationList, {OutlineFrame, desc});
end;

function Update:StartLoad()
	if not Update:LoadAnimation() then return end
	
	local Loader = Instance.new("ScreenGui");
	Loader.Parent = game.CoreGui;
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	Loader.DisplayOrder = 1000;
	
	local LoaderFrame = Instance.new("Frame");
	LoaderFrame.Name = "LoaderFrame";
	LoaderFrame.Parent = Loader;
	LoaderFrame.ClipsDescendants = true;
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5);
	LoaderFrame.BackgroundTransparency = 1;
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	LoaderFrame.Size = UDim2.new(0, 0, 0, 0);
	LoaderFrame.BorderSizePixel = 0;
	CreateRounded(LoaderFrame, 20);

	CreateGradientFrame(LoaderFrame, {
		Color3.fromRGB(15, 15, 20),
		Color3.fromRGB(30, 30, 40),
		Color3.fromRGB(15, 15, 20)
	}, 45)
	
	local MainLoaderFrame = Instance.new("Frame");
	MainLoaderFrame.Name = "MainLoaderFrame";
	MainLoaderFrame.Parent = LoaderFrame;
	MainLoaderFrame.ClipsDescendants = true;
	MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
	MainLoaderFrame.BackgroundTransparency = 1;
	MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	MainLoaderFrame.Size = UDim2.new(0, 0, 0, 0);
	MainLoaderFrame.BorderSizePixel = 0;
	CreateRounded(MainLoaderFrame, 15);
	
	local ParticleContainer = Instance.new("Frame");
	ParticleContainer.Name = "ParticleContainer";
	ParticleContainer.Parent = MainLoaderFrame;
	ParticleContainer.BackgroundTransparency = 1;
	ParticleContainer.Size = UDim2.new(1, 0, 1, 0);
	
	local TitleLoader = Instance.new("TextLabel");
	TitleLoader.Parent = MainLoaderFrame;
	TitleLoader.Text = "ZeroX";
	TitleLoader.Font = Enum.Font.FredokaOne;
	TitleLoader.TextSize = 50;
	TitleLoader.TextColor3 = _G.White;
	TitleLoader.BackgroundTransparency = 1;
	TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	TitleLoader.Position = UDim2.new(0.5, 0, 0.3, 0);
	TitleLoader.Size = UDim2.new(0.8, 0, 0.2, 0);
	TitleLoader.TextTransparency = 1;
	
	local DescriptionLoader = Instance.new("TextLabel");
	DescriptionLoader.Parent = MainLoaderFrame;
	DescriptionLoader.Text = "加载中";
	DescriptionLoader.Font = Enum.Font.Gotham;
	DescriptionLoader.TextSize = 15;
	DescriptionLoader.TextColor3 = _G.White;
	DescriptionLoader.BackgroundTransparency = 1;
	DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	DescriptionLoader.Position = UDim2.new(0.5, 0, 0.6, 0);
	DescriptionLoader.Size = UDim2.new(0.8, 0, 0.2, 0);
	DescriptionLoader.TextTransparency = 1;
	
	local LoadingBarBackground = Instance.new("Frame");
	LoadingBarBackground.Parent = MainLoaderFrame;
	LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 45);
	LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5);
	LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0);
	LoadingBarBackground.Size = UDim2.new(0, 0, 0.05, 0);
	LoadingBarBackground.ClipsDescendants = true;
	LoadingBarBackground.BorderSizePixel = 0;
	LoadingBarBackground.ZIndex = 2;
	LoadingBarBackground.BackgroundTransparency = 1;
	CreateRounded(LoadingBarBackground, 10);
	
	local LoadingBar = Instance.new("Frame");
	LoadingBar.Parent = LoadingBarBackground;
	LoadingBar.BackgroundColor3 = _G.Third;
	LoadingBar.Size = UDim2.new(0, 0, 1, 0);
	LoadingBar.ZIndex = 3;
	CreateRounded(LoadingBar, 10);
	
	local tweenService = game:GetService("TweenService");
	
	local entranceTween = TweenService:Create(LoaderFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0,
		Size = UDim2.new(0.6, 0, 0.7, 0)
	})
	
	local frameTween = TweenService:Create(MainLoaderFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0,
		Size = UDim2.new(0.9, 0, 0.9, 0)
	})
	
	local textTween1 = TweenService:Create(TitleLoader, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})
	
	local textTween2 = TweenService:Create(DescriptionLoader, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		TextTransparency = 0
	})
	
	local barBgTween = TweenService:Create(LoadingBarBackground, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0,
		Size = UDim2.new(0.7, 0, 0.05, 0)
	})
	
	entranceTween:Play()
	entranceTween.Completed:Wait()
	frameTween:Play()
	frameTween.Completed:Wait()
	textTween1:Play()
	textTween2:Play()
	barBgTween:Play()
	
	local function createParticle()
		local Particle = Instance.new("Frame");
		Particle.Parent = ParticleContainer;
		Particle.BackgroundColor3 = Color3.fromRGB(
			math.random(200, 255), 
			math.random(20, 80), 
			math.random(40, 100)
		);
		Particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8));
		Particle.Position = UDim2.new(math.random(), 0, math.random(), 0);
		Particle.AnchorPoint = Vector2.new(0.5, 0.5);
		CreateRounded(Particle, 100);
		
		local FloatTween = TweenService:Create(Particle, TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(math.random(), 0, math.random(), 0),
			Rotation = math.random(-360, 360),
			Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
		})
		
		local AlphaTween = TweenService:Create(Particle, TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			BackgroundTransparency = math.random(0.3, 0.8)
		})
		
		FloatTween:Play()
		AlphaTween:Play()
		
		FloatTween.Completed:Connect(function()
			Particle:Destroy()
		end)
	end
	
	spawn(function()
		while Loader.Parent do
			createParticle()
			wait(0.05)
		end
	end)
	
	local dotCount = 0;
	local running = true;
	
	local barTweenInfoPart1 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
	local barTweenPart1 = tweenService:Create(LoadingBar, barTweenInfoPart1, {
		Size = UDim2.new(0.4, 0, 1, 0)
	});
	
	local barTweenInfoPart2 = TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
	local barTweenPart2 = tweenService:Create(LoadingBar, barTweenInfoPart2, {
		Size = UDim2.new(1, 0, 1, 0)
	});
	
	barTweenPart1:Play();
	
	function Update:Loaded()
		barTweenPart2:Play();
	end;
	
	barTweenPart1.Completed:Connect(function()
		running = true;
		barTweenPart2.Completed:Connect(function()
			wait(0.5);
			running = false;
			DescriptionLoader.Text = "加载完成!";
			
			wait(1)
			
			local exitTween1 = TweenService:Create(TitleLoader, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				TextTransparency = 1
			})
			
			local exitTween2 = TweenService:Create(DescriptionLoader, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				TextTransparency = 1
			})
			
			local exitTween3 = TweenService:Create(LoadingBarBackground, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1
			})
			
			local exitTween4 = TweenService:Create(MainLoaderFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 0)
			})
			
			local exitTween5 = TweenService:Create(LoaderFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 0)
			})
			
			exitTween1:Play()
			exitTween2:Play()
			exitTween3:Play()
			exitTween4:Play()
			exitTween4.Completed:Wait()
			exitTween5:Play()
			exitTween5.Completed:Wait()
			Loader:Destroy();
		end);
	end);
	
	spawn(function()
		while running do
			dotCount = (dotCount + 1) % 4;
			local dots = string.rep(".", dotCount);
			DescriptionLoader.Text = "加载中" .. dots;
			wait(0.4);
		end;
	end);
end;

local SettingsLib = {
	SaveSettings = true,
	LoadAnimation = true
};

(getgenv()).LoadConfig = function()
	if readfile and writefile and isfile and isfolder then
		if not isfolder("WTB") then
			makefolder("WTB");
		end;
		if not isfolder("WTB/Library/") then
			makefolder("WTB/Library/");
		end;
		if not isfile(("WTB/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			writefile("WTB/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(SettingsLib));
		else
			local Decode = (game:GetService("HttpService")):JSONDecode(readfile("WTB/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
			for i, v in pairs(Decode) do
				SettingsLib[i] = v;
			end;
		end;
		print("Library Loaded!");
	else
		return warn("Status : Undetected Executor");
	end;
end;

(getgenv()).SaveConfig = function()
	if readfile and writefile and isfile and isfolder then
		if not isfile(("WTB/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			(getgenv()).Load();
		else
			local Decode = (game:GetService("HttpService")):JSONDecode(readfile("WTB/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
			local Array = {};
			for i, v in pairs(SettingsLib) do
				Array[i] = v;
			end;
			writefile("WTB/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(Array));
		end;
	else
		return warn("Status : Undetected Executor");
	end;
end;

(getgenv()).LoadConfig();

function Update:SaveSettings()
	if SettingsLib.SaveSettings then
		return true;
	end;
	return false;
end;

function Update:LoadAnimation()
	if SettingsLib.LoadAnimation then
		return true;
	end;
	return false;
end;

function Update:Window(Config)
	assert(Config.SubTitle, "v4");
	
	local WindowConfig = {
		Size = Config.Size,
		TabWidth = Config.TabWidth
	};
	
	local osfunc = {};
	local uihide = false;
	local abc = false;
	local currentpage = "";
	local keybind = keybind or Enum.KeyCode.RightControl;
	local yoo = string.gsub(tostring(keybind), "Enum.KeyCode.", "");
	
	WTB = Instance.new("ScreenGui");
	WTB.Name = "WTB";
	WTB.Parent = game.CoreGui;
	WTB.DisplayOrder = 999;
	
	local OutlineMain = Instance.new("Frame");
	OutlineMain.Name = "OutlineMain";
	OutlineMain.Parent = WTB;
	OutlineMain.ClipsDescendants = true;
	OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5);
	OutlineMain.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
	OutlineMain.BackgroundTransparency = 1;
	OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0);
	OutlineMain.Size = UDim2.new(0, 0, 0, 0);
	CreateRounded(OutlineMain, 18);

	CreateGradientFrame(OutlineMain, {
		_G.Third,
		_G.Accent,
		_G.Third
	}, 45)
	
	local Main = Instance.new("Frame");
	Main.Name = "Main";
	Main.Parent = OutlineMain;
	Main.ClipsDescendants = true;
	Main.AnchorPoint = Vector2.new(0.5, 0.5);
	Main.BackgroundColor3 = _G.Dark;
	Main.BackgroundTransparency = 1;
	Main.Position = UDim2.new(0.5, 0, 0.5, 0);
	Main.Size = UDim2.new(0, 0, 0, 0);
	CreateRounded(Main, 15);
	
	local BtnStroke = Instance.new("UIStroke");
	
	local DragButton = Instance.new("Frame");
	DragButton.Name = "DragButton";
	DragButton.Parent = Main;
	DragButton.Position = UDim2.new(1, 5, 1, 5);
	DragButton.AnchorPoint = Vector2.new(1, 1);
	DragButton.Size = UDim2.new(0, 15, 0, 15);
	DragButton.BackgroundColor3 = _G.Primary;
	DragButton.BackgroundTransparency = 1;
	DragButton.ZIndex = 10;
	
	local mouse = game.Players.LocalPlayer:GetMouse();
	local uis = game:GetService("UserInputService");
	
	local CircleDragButton = Instance.new("UICorner");
	CircleDragButton.Name = "CircleDragButton";
	CircleDragButton.Parent = DragButton;
	CircleDragButton.CornerRadius = UDim.new(0, 99);
	
	local Top = Instance.new("Frame");
	Top.Name = "Top";
	Top.Parent = Main;
	Top.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
	Top.Size = UDim2.new(1, 0, 0, 45);
	Top.BackgroundTransparency = 1;
	CreateRounded(Top, 8);
	
	local NameHub = Instance.new("TextLabel");
	NameHub.Name = "NameHub";
	NameHub.Parent = Top;
	NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	NameHub.BackgroundTransparency = 1;
	NameHub.RichText = true;
	NameHub.Position = UDim2.new(0, 20, 0.5, 0);
	NameHub.AnchorPoint = Vector2.new(0, 0.5);
	NameHub.Size = UDim2.new(0, 1, 0, 28);
	NameHub.Font = Enum.Font.GothamBold;
	NameHub.Text = "WTB";
	NameHub.TextSize = 22;
	NameHub.TextColor3 = _G.White;
	NameHub.TextXAlignment = Enum.TextXAlignment.Left;
	
	local nameHubSize = (game:GetService("TextService")):GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge));
	NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 28);
	
	local SubTitle = Instance.new("TextLabel");
	SubTitle.Name = "SubTitle";
	SubTitle.Parent = NameHub;
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	SubTitle.BackgroundTransparency = 1;
	SubTitle.Position = UDim2.new(0, nameHubSize.X + 10, 0.5, 0);
	SubTitle.Size = UDim2.new(0, 1, 0, 22);
	SubTitle.Font = Enum.Font.Gotham;
	SubTitle.AnchorPoint = Vector2.new(0, 0.5);
	SubTitle.Text = Config.SubTitle;
	SubTitle.TextSize = 14;
	SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180);
	
	local SubTitleSize = (game:GetService("TextService")):GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge));
	SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 22);
	
	local CloseButton = Instance.new("ImageButton");
	CloseButton.Name = "CloseButton";
	CloseButton.Parent = Top;
	CloseButton.BackgroundColor3 = _G.Primary;
	CloseButton.BackgroundTransparency = 1;
	CloseButton.AnchorPoint = Vector2.new(1, 0.5);
	CloseButton.Position = UDim2.new(1, -20, 0.5, 0);
	CloseButton.Size = UDim2.new(0, 24, 0, 24);
	CloseButton.Image = "rbxassetid://7743878857";
	CloseButton.ImageTransparency = 0;
	CloseButton.ImageColor3 = _G.White;
	CreateRounded(CloseButton, 6);
	
	local function showCloseDialog()
		local DialogOverlay = Instance.new("Frame");
		DialogOverlay.Name = "DialogOverlay";
		DialogOverlay.Parent = WTB;
		DialogOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		DialogOverlay.BackgroundTransparency = 0.7;
		DialogOverlay.Size = UDim2.new(1, 0, 1, 0);
		DialogOverlay.ZIndex = 1000;
		
		local DialogFrame = Instance.new("Frame");
		DialogFrame.Name = "DialogFrame";
		DialogFrame.Parent = DialogOverlay;
		DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5);
		DialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
		DialogFrame.Size = UDim2.new(0, 0, 0, 0);
		DialogFrame.BackgroundColor3 = _G.Dark;
		DialogFrame.ZIndex = 1001;
		CreateRounded(DialogFrame, 12);

		CreateGradientFrame(DialogFrame, {
			_G.Third,
			_G.Accent,
			_G.Third
		}, 45)
		
		local DialogTitle = Instance.new("TextLabel");
		DialogTitle.Parent = DialogFrame;
		DialogTitle.Text = "确认关闭";
		DialogTitle.Font = Enum.Font.GothamBold;
		DialogTitle.TextSize = 18;
		DialogTitle.TextColor3 = _G.White;
		DialogTitle.BackgroundTransparency = 1;
		DialogTitle.Position = UDim2.new(0, 20, 0, 20);
		DialogTitle.Size = UDim2.new(1, -40, 0, 30);
		DialogTitle.TextXAlignment = Enum.TextXAlignment.Left;
		DialogTitle.ZIndex = 1002;
		
		local DialogMessage = Instance.new("TextLabel");
		DialogMessage.Parent = DialogFrame;
		DialogMessage.Text = "你确定要关闭UI吗?";
		DialogMessage.Font = Enum.Font.Gotham;
		DialogMessage.TextSize = 14;
		DialogMessage.TextColor3 = Color3.fromRGB(200, 200, 200);
		DialogMessage.BackgroundTransparency = 1;
		DialogMessage.Position = UDim2.new(0, 20, 0, 60);
		DialogMessage.Size = UDim2.new(1, -40, 0, 40);
		DialogMessage.TextXAlignment = Enum.TextXAlignment.Left;
		DialogMessage.ZIndex = 1002;
		
		local ButtonContainer = Instance.new("Frame");
		ButtonContainer.Parent = DialogFrame;
		ButtonContainer.BackgroundTransparency = 1;
		ButtonContainer.Position = UDim2.new(0, 20, 1, -50);
		ButtonContainer.Size = UDim2.new(1, -40, 0, 30);
		ButtonContainer.ZIndex = 1002;
		
		local CancelButton = Instance.new("TextButton");
		CancelButton.Parent = ButtonContainer;
		CancelButton.Text = "取消";
		CancelButton.Font = Enum.Font.Gotham;
		CancelButton.TextSize = 14;
		CancelButton.TextColor3 = _G.White;
		CancelButton.BackgroundColor3 = _G.Primary;
		CancelButton.Size = UDim2.new(0.45, 0, 1, 0);
		CancelButton.Position = UDim2.new(0, 0, 0, 0);
		CancelButton.ZIndex = 1003;
		CreateRounded(CancelButton, 6);
		
		local ConfirmButton = Instance.new("TextButton");
		ConfirmButton.Parent = ButtonContainer;
		ConfirmButton.Text = "确定";
		ConfirmButton.Font = Enum.Font.Gotham;
		ConfirmButton.TextSize = 14;
		ConfirmButton.TextColor3 = _G.White;
		ConfirmButton.BackgroundColor3 = _G.Third;
		ConfirmButton.Size = UDim2.new(0.45, 0, 1, 0);
		ConfirmButton.Position = UDim2.new(0.55, 0, 0, 0);
		ConfirmButton.ZIndex = 1003;
		CreateRounded(ConfirmButton, 6);
		
		local entranceTween = TweenService:Create(DialogFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 300, 0, 150)
		})
		entranceTween:Play()
		
		CancelButton.MouseButton1Click:Connect(function()
			local exitTween = TweenService:Create(DialogFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0)
			})
			exitTween:Play()
			exitTween.Completed:Wait()
			DialogOverlay:Destroy()
		end)
		
		ConfirmButton.MouseButton1Click:Connect(function()
			local exitTween1 = TweenService:Create(OutlineMain, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			})
			
			local exitTween2 = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			})
			
			local dialogExit = TweenService:Create(DialogFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0)
			})
			
			dialogExit:Play()
			exitTween1:Play()
			exitTween2:Play()
			dialogExit.Completed:Wait()
			DialogOverlay:Destroy()
			exitTween1.Completed:Wait()
			WTB.Enabled = false;
		end)
	end
	
	CloseButton.MouseButton1Click:connect(showCloseDialog);
	
	local ResizeButton = Instance.new("ImageButton");
	ResizeButton.Name = "ResizeButton";
	ResizeButton.Parent = Top;
	ResizeButton.BackgroundColor3 = _G.Primary;
	ResizeButton.BackgroundTransparency = 1;
	ResizeButton.AnchorPoint = Vector2.new(1, 0.5);
	ResizeButton.Position = UDim2.new(1, -60, 0.5, 0);
	ResizeButton.Size = UDim2.new(0, 24, 0, 24);
	ResizeButton.Image = "rbxassetid://10734886735";
	ResizeButton.ImageTransparency = 0;
	ResizeButton.ImageColor3 = _G.White;
	CreateRounded(ResizeButton, 6);
	
	local BackgroundSettings = Instance.new("Frame");
	BackgroundSettings.Name = "BackgroundSettings";
	BackgroundSettings.Parent = OutlineMain;
	BackgroundSettings.ClipsDescendants = true;
	BackgroundSettings.Active = true;
	BackgroundSettings.AnchorPoint = Vector2.new(0, 0);
	BackgroundSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	BackgroundSettings.BackgroundTransparency = 1;
	BackgroundSettings.Position = UDim2.new(0, 0, 0, 0);
	BackgroundSettings.Size = UDim2.new(1, 0, 1, 0);
	BackgroundSettings.Visible = false;
	CreateRounded(BackgroundSettings, 18);
	
	local SettingsFrame = Instance.new("Frame");
	SettingsFrame.Name = "SettingsFrame";
	SettingsFrame.Parent = BackgroundSettings;
	SettingsFrame.ClipsDescendants = true;
	SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	SettingsFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
	SettingsFrame.BackgroundTransparency = 1;
	SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	SettingsFrame.Size = UDim2.new(0, 0, 0, 0);
	CreateRounded(SettingsFrame, 15);
	
	local CloseSettings = Instance.new("ImageButton");
	CloseSettings.Name = "CloseSettings";
	CloseSettings.Parent = SettingsFrame;
	CloseSettings.BackgroundColor3 = _G.Primary;
	CloseSettings.BackgroundTransparency = 1;
	CloseSettings.AnchorPoint = Vector2.new(1, 0);
	CloseSettings.Position = UDim2.new(1, -20, 0, 15);
	CloseSettings.Size = UDim2.new(0, 24, 0, 24);
	CloseSettings.Image = "rbxassetid://10747384394";
	CloseSettings.ImageTransparency = 0;
	CloseSettings.ImageColor3 = _G.White;
	CreateRounded(CloseSettings, 6);
	
	CloseSettings.MouseButton1Click:connect(function()
		local exitTween1 = TweenService:Create(BackgroundSettings, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		
		local exitTween2 = TweenService:Create(SettingsFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		})
		
		exitTween1:Play()
		exitTween2:Play()
		exitTween2.Completed:Wait()
		BackgroundSettings.Visible = false;
	end);
	
	local SettingsButton = Instance.new("ImageButton");
	SettingsButton.Name = "SettingsButton";
	SettingsButton.Parent = Top;
	SettingsButton.BackgroundColor3 = _G.Primary;
	SettingsButton.BackgroundTransparency = 1;
	SettingsButton.AnchorPoint = Vector2.new(1, 0.5);
	SettingsButton.Position = UDim2.new(1, -100, 0.5, 0);
	SettingsButton.Size = UDim2.new(0, 24, 0, 24);
	SettingsButton.Image = "rbxassetid://10734950020";
	SettingsButton.ImageTransparency = 0;
	SettingsButton.ImageColor3 = _G.White;
	CreateRounded(SettingsButton, 6);
	
	SettingsButton.MouseButton1Click:connect(function()
		BackgroundSettings.Visible = true;
		
		local entranceTween1 = TweenService:Create(BackgroundSettings, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.3
		})
		
		local entranceTween2 = TweenService:Create(SettingsFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
			Size = UDim2.new(0.7, 0, 0.7, 0)
		})
		
		entranceTween1:Play()
		entranceTween2:Play()
	end);
	
	local TitleSettings = Instance.new("TextLabel");
	TitleSettings.Name = "TitleSettings";
	TitleSettings.Parent = SettingsFrame;
	TitleSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	TitleSettings.BackgroundTransparency = 1;
	TitleSettings.Position = UDim2.new(0, 20, 0, 15);
	TitleSettings.Size = UDim2.new(1, 0, 0, 20);
	TitleSettings.Font = Enum.Font.GothamBold;
	TitleSettings.AnchorPoint = Vector2.new(0, 0);
	TitleSettings.Text = "库设置";
	TitleSettings.TextSize = 20;
	TitleSettings.TextColor3 = _G.White;
	TitleSettings.TextXAlignment = Enum.TextXAlignment.Left;
	
	local SettingsMenuList = Instance.new("Frame");
	SettingsMenuList.Name = "SettingsMenuList";
	SettingsMenuList.Parent = SettingsFrame;
	SettingsMenuList.ClipsDescendants = true;
	SettingsMenuList.AnchorPoint = Vector2.new(0, 0);
	SettingsMenuList.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
	SettingsMenuList.BackgroundTransparency = 1;
	SettingsMenuList.Position = UDim2.new(0, 0, 0, 50);
	SettingsMenuList.Size = UDim2.new(1, 0, 1, -70);
	CreateRounded(SettingsMenuList, 15);
	
	local ScrollSettings = Instance.new("ScrollingFrame");
	ScrollSettings.Name = "ScrollSettings";
	ScrollSettings.Parent = SettingsMenuList;
	ScrollSettings.Active = true;
	ScrollSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	ScrollSettings.Position = UDim2.new(0, 0, 0, 0);
	ScrollSettings.BackgroundTransparency = 1;
	ScrollSettings.Size = UDim2.new(1, 0, 1, 0);
	ScrollSettings.ScrollBarThickness = 3;
	ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y;
	CreateRounded(SettingsMenuList, 8);
	
	local SettingsListLayout = Instance.new("UIListLayout");
	SettingsListLayout.Name = "SettingsListLayout";
	SettingsListLayout.Parent = ScrollSettings;
	SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	SettingsListLayout.Padding = UDim.new(0, 8);
	
	local PaddingScroll = Instance.new("UIPadding");
	PaddingScroll.Name = "PaddingScroll";
	PaddingScroll.Parent = ScrollSettings;
	
	function CreateCheckbox(title, state, callback)
		local checked = state or false;
		local Background = Instance.new("Frame");
		Background.Name = "Background";
		Background.Parent = ScrollSettings;
		Background.ClipsDescendants = true;
		Background.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
		Background.BackgroundTransparency = 1;
		Background.Size = UDim2.new(1, 0, 0, 20);
		
		local Title = Instance.new("TextLabel");
		Title.Name = "Title";
		Title.Parent = Background;
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Title.BackgroundTransparency = 1;
		Title.Position = UDim2.new(0, 60, 0.5, 0);
		Title.Size = UDim2.new(1, -60, 0, 20);
		Title.Font = Enum.Font.Code;
		Title.AnchorPoint = Vector2.new(0, 0.5);
		Title.Text = title or "";
		Title.TextSize = 15;
		Title.TextColor3 = Color3.fromRGB(200, 200, 200);
		Title.TextXAlignment = Enum.TextXAlignment.Left;
		
		local Checkbox = Instance.new("ImageButton");
		Checkbox.Name = "Checkbox";
		Checkbox.Parent = Background;
		Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
		Checkbox.BackgroundTransparency = 0;
		Checkbox.AnchorPoint = Vector2.new(0, 0.5);
		Checkbox.Position = UDim2.new(0, 30, 0.5, 0);
		Checkbox.Size = UDim2.new(0, 20, 0, 20);
		Checkbox.Image = "rbxassetid://10709790644";
		Checkbox.ImageTransparency = 1;
		Checkbox.ImageColor3 = _G.White;
		CreateRounded(Checkbox, 5);
		
		Checkbox.MouseButton1Click:Connect(function()
			checked = not checked;
			if checked then
				TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					ImageTransparency = 0,
					BackgroundColor3 = _G.Third
				}):Play()
			else
				TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					ImageTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				}):Play()
			end;
			pcall(callback, checked);
		end);
		
		if checked then
			Checkbox.ImageTransparency = 0;
			Checkbox.BackgroundColor3 = _G.Third;
		else
			Checkbox.ImageTransparency = 1;
			Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
		end;
		pcall(callback, checked);
	end;
	
	function CreateButton(title, callback)
		local Background = Instance.new("Frame");
		Background.Name = "Background";
		Background.Parent = ScrollSettings;
		Background.ClipsDescendants = true;
		Background.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
		Background.BackgroundTransparency = 1;
		Background.Size = UDim2.new(1, 0, 0, 30);
		
		local Button = Instance.new("TextButton");
		Button.Name = "Button";
		Button.Parent = Background;
		Button.BackgroundColor3 = _G.Third;
		Button.BackgroundTransparency = 0;
		Button.Size = UDim2.new(0.8, 0, 0, 30);
		Button.Font = Enum.Font.Code;
		Button.Text = title or "按钮";
		Button.AnchorPoint = Vector2.new(0.5, 0);
		Button.Position = UDim2.new(0.5, 0, 0, 0);
		Button.TextColor3 = _G.White;
		Button.TextSize = 15;
		Button.AutoButtonColor = false;
		
		Button.MouseButton1Click:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3
			}):Play()
			wait(0.1)
			TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0
			}):Play()
			callback();
		end);
		
		CreateRounded(Button, 6);
	end;
	
	CreateCheckbox("保存设置", SettingsLib.SaveSettings, function(state)
		SettingsLib.SaveSettings = state;
		(getgenv()).SaveConfig();
	end);
	
	CreateCheckbox("加载动画", SettingsLib.LoadAnimation, function(state)
		SettingsLib.LoadAnimation = state;
		(getgenv()).SaveConfig();
	end);
	
	CreateButton("重置配置", function()
		if isfolder("WTB") then
			delfolder("WTB");
		end;
		Update:Notify("配置已重置!");
	end);
	
	local Tab = Instance.new("Frame");
	Tab.Name = "Tab";
	Tab.Parent = Main;
	Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
	Tab.Position = UDim2.new(0, 10, 0, Top.Size.Y.Offset);
	Tab.BackgroundTransparency = 1;
	Tab.Size = UDim2.new(0, 0, Config.Size.Y.Scale, 0);
	CreateRounded(Tab, 10);
	
	local BtnStroke = Instance.new("UIStroke");
	
	local ScrollTab = Instance.new("ScrollingFrame");
	ScrollTab.Name = "ScrollTab";
	ScrollTab.Parent = Tab;
	ScrollTab.Active = true;
	ScrollTab.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	ScrollTab.Position = UDim2.new(0, 0, 0, 0);
	ScrollTab.BackgroundTransparency = 1;
	ScrollTab.Size = UDim2.new(1, 0, 1, 0);
	ScrollTab.ScrollBarThickness = 0;
	ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y;
	CreateRounded(Tab, 10);
	
	local TabListLayout = Instance.new("UIListLayout");
	TabListLayout.Name = "TabListLayout";
	TabListLayout.Parent = ScrollTab;
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	TabListLayout.Padding = UDim.new(0, 2);
	
	local PPD = Instance.new("UIPadding");
	PPD.Name = "PPD";
	PPD.Parent = ScrollTab;
	
	local Page = Instance.new("Frame");
	Page.Name = "Page";
	Page.Parent = Main;
	Page.BackgroundColor3 = _G.Dark;
	Page.Position = UDim2.new(0, 0, 0, Top.Size.Y.Offset);
	Page.Size = UDim2.new(Config.Size.X.Scale, 0, Config.Size.Y.Scale, 0);
	Page.BackgroundTransparency = 1;
	CreateRounded(Page, 12);
	
	local MainPage = Instance.new("Frame");
	MainPage.Name = "MainPage";
	MainPage.Parent = Page;
	MainPage.ClipsDescendants = true;
	MainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	MainPage.BackgroundTransparency = 1;
	MainPage.Size = UDim2.new(1, 0, 1, 0);
	
	local PageList = Instance.new("Folder");
	PageList.Name = "PageList";
	PageList.Parent = MainPage;
	
	local UIPageLayout = Instance.new("UIPageLayout");
	UIPageLayout.Parent = PageList;
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	UIPageLayout.EasingDirection = Enum.EasingDirection.InOut;
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quint;
	UIPageLayout.FillDirection = Enum.FillDirection.Vertical;
	UIPageLayout.Padding = UDim.new(0, 10);
	UIPageLayout.TweenTime = 0.4;
	UIPageLayout.GamepadInputEnabled = false;
	UIPageLayout.ScrollWheelInputEnabled = false;
	UIPageLayout.TouchInputEnabled = false;
	
	MakeDraggable(Top, OutlineMain);
	
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Insert then
			if WTB.Enabled then
				local exitTween1 = TweenService:Create(OutlineMain, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1
				})
				
				local exitTween2 = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1
				})
				
				exitTween1:Play()
				exitTween2:Play()
				exitTween1.Completed:Wait()
				WTB.Enabled = false;
			else
				WTB.Enabled = true;
				local entranceTween1 = TweenService:Create(OutlineMain, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.3,
					Size = UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15)
				})
				
				local entranceTween2 = TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0,
					Size = WindowConfig.Size
				})
				
				entranceTween1:Play()
				entranceTween2:Play()
			end
		end;
	end);
	
	local Dragging = false;
	DragButton.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true;
		end;
	end);
	
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false;
		end;
	end);
	
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			OutlineMain.Size = UDim2.new(0, math.clamp(Input.Position.X - Main.AbsolutePosition.X + 15, WindowConfig.Size.X.Offset + 15, math.huge), 0, math.clamp(Input.Position.Y - Main.AbsolutePosition.Y + 15, WindowConfig.Size.Y.Offset + 15, math.huge));
			Main.Size = UDim2.new(0, math.clamp(Input.Position.X - Main.AbsolutePosition.X, WindowConfig.Size.X.Offset, math.huge), 0, math.clamp(Input.Position.Y - Main.AbsolutePosition.Y, WindowConfig.Size.Y.Offset, math.huge));
			Page.Size = UDim2.new(0, math.clamp(Input.Position.X - Page.AbsolutePosition.X - 8, WindowConfig.Size.X.Offset - Tab.Size.X.Offset - 25, math.huge), 0, math.clamp(Input.Position.Y - Page.AbsolutePosition.Y - 8, WindowConfig.Size.Y.Offset - Top.Size.Y.Offset - 10, math.huge));
			Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 0, math.clamp(Input.Position.Y - Tab.AbsolutePosition.Y - 8, WindowConfig.Size.Y.Offset - Top.Size.Y.Offset - 10, math.huge));
		end;
	end);
	
	ImageButton.MouseButton1Click:connect(function()
		if WTB.Enabled then
			local exitTween1 = TweenService:Create(OutlineMain, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			})
			
			local exitTween2 = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			})
			
			exitTween1:Play()
			exitTween2:Play()
			exitTween1.Completed:Wait()
			WTB.Enabled = false;
		else
			WTB.Enabled = true;
			local entranceTween1 = TweenService:Create(OutlineMain, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3,
				Size = UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15)
			})
			
			local entranceTween2 = TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0,
				Size = WindowConfig.Size
			})
			
			entranceTween1:Play()
			entranceTween2:Play()
		end
	end);
	
	spawn(function()
		wait(0.1)
		
		local entranceTween1 = TweenService:Create(OutlineMain, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.3,
			Size = UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15)
		})
		
		local entranceTween2 = TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
			Size = WindowConfig.Size
		})
		
		entranceTween1:Play()
		entranceTween2:Play()
		
		wait(0.5)
		local tabTween = TweenService:Create(Tab, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
			Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 15)
		})
		
		local pageTween = TweenService:Create(Page, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
			Position = UDim2.new(0, WindowConfig.TabWidth + 20, 0, Top.Size.Y.Offset),
			Size = UDim2.new(Config.Size.X.Scale, Config.Size.X.Offset - WindowConfig.TabWidth - 30, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 15)
		})
		
		local topTween = TweenService:Create(Top, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0
		})
		
		tabTween:Play()
		pageTween:Play()
		topTween:Play()
	end)
	
	local uitab = {};
	
	function uitab:Tab(text, img)
		local BtnStroke = Instance.new("UIStroke");
		local TabButton = Instance.new("TextButton");
		local title = Instance.new("TextLabel");
		local TUICorner = Instance.new("UICorner");
		local UICorner = Instance.new("UICorner");
		local Title = Instance.new("TextLabel");
		
		TabButton.Parent = ScrollTab;
		TabButton.Name = text .. "Unique";
		TabButton.Text = "";
		TabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
		TabButton.BackgroundTransparency = 1;
		TabButton.Size = UDim2.new(1, 0, 0, 35);
		TabButton.Font = Enum.Font.Nunito;
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		TabButton.TextSize = 12;
		TabButton.TextTransparency = 0.9;
		
		local SelectedTab = Instance.new("Frame");
		SelectedTab.Name = "SelectedTab";
		SelectedTab.Parent = TabButton;
		SelectedTab.BackgroundColor3 = _G.Third;
		SelectedTab.BackgroundTransparency = 0;
		SelectedTab.Size = UDim2.new(0, 3, 0, 0);
		SelectedTab.Position = UDim2.new(0, 0, 0.5, 0);
		SelectedTab.AnchorPoint = Vector2.new(0, 0.5);
		
		UICorner.CornerRadius = UDim.new(0, 100);
		UICorner.Parent = SelectedTab;
		
		Title.Parent = TabButton;
		Title.Name = "Title";
		Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
		Title.BackgroundTransparency = 1;
		Title.Position = UDim2.new(0, 30, 0.5, 0);
		Title.Size = UDim2.new(0, 100, 0, 30);
		Title.Font = Enum.Font.Roboto;
		Title.Text = text;
		Title.AnchorPoint = Vector2.new(0, 0.5);
		Title.TextColor3 = Color3.fromRGB(255, 255, 255);
		Title.TextTransparency = 0.4;
		Title.TextSize = 14;
		Title.TextXAlignment = Enum.TextXAlignment.Left;
		
		local IDK = Instance.new("ImageLabel");
		IDK.Name = "IDK";
		IDK.Parent = TabButton;
		IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		IDK.BackgroundTransparency = 1;
		IDK.ImageTransparency = 0.3;
		IDK.Position = UDim2.new(0, 7, 0.5, 0);
		IDK.Size = UDim2.new(0, 15, 0, 15);
		IDK.AnchorPoint = Vector2.new(0, 0.5);
		IDK.Image = img;
		
		CreateRounded(TabButton, 6);
		
		local MainFramePage = Instance.new("ScrollingFrame");
		MainFramePage.Name = text .. "_Page";
		MainFramePage.Parent = PageList;
		MainFramePage.Active = true;
		MainFramePage.BackgroundColor3 = _G.Dark;
		MainFramePage.Position = UDim2.new(0, 0, 0, 0);
		MainFramePage.BackgroundTransparency = 1;
		MainFramePage.Size = UDim2.new(1, 0, 1, 0);
		MainFramePage.ScrollBarThickness = 0;
		MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y;
		
		local zzzR = Instance.new("UICorner");
		zzzR.Parent = MainPage;
		zzzR.CornerRadius = UDim.new(0, 5);
		
		local UIPadding = Instance.new("UIPadding");
		local UIListLayout = Instance.new("UIListLayout");
		
		UIPadding.Parent = MainFramePage;
		UIListLayout.Padding = UDim.new(0, 3);
		UIListLayout.Parent = MainFramePage;
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
		
		TabButton.MouseButton1Click:Connect(function()
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1
					}):Play();
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 3, 0, 0)
					}):Play();
					TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					}):Play();
					TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						TextTransparency = 0.4
					}):Play();
				end;
			end;
			
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play();
			TweenService:Create(SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 3, 0, 15)
			}):Play();
			TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play();
			TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play();
			
			for i, v in next, PageList:GetChildren() do
				currentpage = string.gsub(TabButton.Name, "Unique", "") .. "_Page";
				if v.Name == currentpage then
					UIPageLayout:JumpTo(v);
				end;
			end;
		end);
		
		if abc == false then
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1
					}):Play();
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 3, 0, 0)
					}):Play();
					TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					}):Play();
					TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						TextTransparency = 0.4
					}):Play();
				end;
			end;
			
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play();
			TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 3, 0, 15)
			}):Play();
			TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play();
			TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play();
			
			UIPageLayout:JumpToIndex(1);
			abc = true;
		end;
		
		RunService.Stepped:Connect(function()
			pcall(function()
				MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y);
				ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y);
				ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y);
			end);
		end);
		
		local defaultSize = true;
		ResizeButton.MouseButton1Click:Connect(function()
			if defaultSize then
				defaultSize = false;
				OutlineMain:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Quint", 0.2, true);
				Main:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint", 0.4, true, function()
					Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 25, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quint", 0.4, true);
					Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quint", 0.4, true);
				end);
				OutlineMain:TweenSize(UDim2.new(1, -10, 1, -10), "Out", "Quint", 0.4, true);
				ResizeButton.Image = "rbxassetid://10734895698";
			else
				defaultSize = true;
				Main:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset, 0, WindowConfig.Size.Y.Offset), "Out", "Quint", 0.4, true, function()
					Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 25, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quint", 0.4, true);
					Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quint", 0.4, true);
				end);
				OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quint", 0.4, true);
				ResizeButton.Image = "rbxassetid://10734886735";
			end;
		end);
		
		local main = {};
		
		function main:Button(text, callback)
			local Button = Instance.new("Frame");
			local UICorner = Instance.new("UICorner");
			local TextLabel = Instance.new("TextLabel");
			local TextButton = Instance.new("TextButton");
			local UICorner_2 = Instance.new("UICorner");
			local Black = Instance.new("Frame");
			local UICorner_3 = Instance.new("UICorner");
			
			Button.Name = "Button";
			Button.Parent = MainFramePage;
			Button.BackgroundColor3 = _G.Primary;
			Button.BackgroundTransparency = 1;
			Button.Size = UDim2.new(1, 0, 0, 36);
			
			UICorner.CornerRadius = UDim.new(0, 5);
			UICorner.Parent = Button;
			
			local ImageLabel = Instance.new("ImageLabel");
			ImageLabel.Name = "ImageLabel";
			ImageLabel.Parent = TextButton;
			ImageLabel.BackgroundColor3 = _G.Primary;
			ImageLabel.BackgroundTransparency = 1;
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
			ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
			ImageLabel.Size = UDim2.new(0, 15, 0, 15);
			ImageLabel.Image = "rbxassetid://10734898355";
			ImageLabel.ImageTransparency = 0;
			ImageLabel.ImageColor3 = _G.White;
			
			CreateRounded(TextButton, 4);
			
			TextButton.Name = "TextButton";
			TextButton.Parent = Button;
			TextButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			TextButton.BackgroundTransparency = 0.8;
			TextButton.AnchorPoint = Vector2.new(1, 0.5);
			TextButton.Position = UDim2.new(1, -1, 0.5, 0);
			TextButton.Size = UDim2.new(0, 25, 0, 25);
			TextButton.Font = Enum.Font.Nunito;
			TextButton.Text = "";
			TextButton.TextXAlignment = Enum.TextXAlignment.Left;
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
			TextButton.TextSize = 15;
			
			TextLabel.Name = "TextLabel";
			TextLabel.Parent = Button;
			TextLabel.BackgroundColor3 = _G.Primary;
			TextLabel.BackgroundTransparency = 1;
			TextLabel.AnchorPoint = Vector2.new(0, 0.5);
			TextLabel.Position = UDim2.new(0, 20, 0.5, 0);
			TextLabel.Size = UDim2.new(1, -50, 1, 0);
			TextLabel.Font = Enum.Font.Cartoon;
			TextLabel.RichText = true;
			TextLabel.Text = text;
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
			TextLabel.TextColor3 = _G.White;
			TextLabel.TextSize = 15;
			TextLabel.ClipsDescendants = true;
			
			local ArrowRight = Instance.new("ImageLabel");
			ArrowRight.Name = "ArrowRight";
			ArrowRight.Parent = Button;
			ArrowRight.BackgroundColor3 = _G.Primary;
			ArrowRight.BackgroundTransparency = 1;
			ArrowRight.AnchorPoint = Vector2.new(0, 0.5);
			ArrowRight.Position = UDim2.new(0, 0, 0.5, 0);
			ArrowRight.Size = UDim2.new(0, 15, 0, 15);
			ArrowRight.Image = "rbxassetid://10709768347";
			ArrowRight.ImageTransparency = 0;
			ArrowRight.ImageColor3 = _G.White;
			
			Black.Name = "Black";
			Black.Parent = Button;
			Black.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
			Black.BackgroundTransparency = 1;
			Black.BorderSizePixel = 0;
			Black.Position = UDim2.new(0, 0, 0, 0);
			Black.Size = UDim2.new(1, 0, 0, 33);
			
			UICorner_3.CornerRadius = UDim.new(0, 5);
			UICorner_3.Parent = Black;
			
			TextButton.MouseButton1Click:Connect(function()
				TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.5
				}):Play()
				wait(0.1)
				TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.8
				}):Play()
				callback();
			end);
			
			TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
		end;
		
		function main:Toggle(text, config, desc, callback)
			config = config or false;
			local toggled = config;
			
			local Button = Instance.new("TextButton");
			Button.Name = "Button";
			Button.Parent = MainFramePage;
			Button.BackgroundColor3 = _G.Primary;
			Button.BackgroundTransparency = 1;
			Button.AutoButtonColor = false;
			Button.Font = Enum.Font.SourceSans;
			Button.Text = "";
			Button.TextColor3 = Color3.fromRGB(0, 0, 0);
			Button.TextSize = 11;
			CreateRounded(Button, 5);
			
			local Title2 = Instance.new("TextLabel");
			Title2.Parent = Button;
			Title2.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			Title2.BackgroundTransparency = 1;
			Title2.Size = UDim2.new(1, 0, 0, 35);
			Title2.Font = Enum.Font.Cartoon;
			Title2.Text = text;
			Title2.TextColor3 = _G.White;
			Title2.TextSize = 15;
			Title2.TextXAlignment = Enum.TextXAlignment.Left;
			Title2.AnchorPoint = Vector2.new(0, 0.5);
			
			local Desc = Instance.new("TextLabel");
			Desc.Parent = Title2;
			Desc.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
			Desc.BackgroundTransparency = 1;
			Desc.Position = UDim2.new(0, 0, 0, 22);
			Desc.Size = UDim2.new(0, 280, 0, 16);
			Desc.Font = Enum.Font.Gotham;
			
			if desc then
				Desc.Text = desc;
				Title2.Position = UDim2.new(0, 15, 0.5, -5);
				Desc.Position = UDim2.new(0, 0, 0, 22);
				Button.Size = UDim2.new(1, 0, 0, 46);
			else
				Title2.Position = UDim2.new(0, 15, 0.5, 0);
				Desc.Visible = false;
				Button.Size = UDim2.new(1, 0, 0, 36);
			end;
			
			Desc.TextColor3 = Color3.fromRGB(150, 150, 150);
			Desc.TextSize = 10;
			Desc.TextXAlignment = Enum.TextXAlignment.Left;
			
			local ToggleFrame = Instance.new("Frame");
			ToggleFrame.Name = "ToggleFrame";
			ToggleFrame.Parent = Button;
			ToggleFrame.BackgroundColor3 = _G.Dark;
			ToggleFrame.BackgroundTransparency = 1;
			ToggleFrame.Position = UDim2.new(1, -10, 0.5, 0);
			ToggleFrame.Size = UDim2.new(0, 35, 0, 20);
			ToggleFrame.AnchorPoint = Vector2.new(1, 0.5);
			
			local UICorner_5 = Instance.new("UICorner");
			UICorner_5.CornerRadius = UDim.new(0, 10);
			UICorner_5.Parent = ToggleFrame;
			
			local ToggleImage = Instance.new("TextButton");
			ToggleImage.Name = "ToggleImage";
			ToggleImage.Parent = ToggleFrame;
			ToggleImage.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			ToggleImage.BackgroundTransparency = 0.8;
			ToggleImage.Position = UDim2.new(0, 0, 0, 0);
			ToggleImage.AnchorPoint = Vector2.new(0, 0);
			ToggleImage.Size = UDim2.new(1, 0, 1, 0);
			ToggleImage.Text = "";
			ToggleImage.AutoButtonColor = false;
			CreateRounded(ToggleImage, 10);
			
			local Circle = Instance.new("Frame");
			Circle.Name = "Circle";
			Circle.Parent = ToggleImage;
			Circle.BackgroundColor3 = _G.White;
			Circle.BackgroundTransparency = 0;
			Circle.Position = UDim2.new(0, 3, 0.5, 0);
			Circle.Size = UDim2.new(0, 14, 0, 14);
			Circle.AnchorPoint = Vector2.new(0, 0.5);
			
			local UICorner_4 = Instance.new("UICorner");
			UICorner_4.CornerRadius = UDim.new(0, 10);
			UICorner_4.Parent = Circle;
			
			ToggleImage.MouseButton1Click:Connect(function()
				if toggled == false then
					toggled = true;
					TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, 17, 0.5, 0)
					}):Play()
					TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundColor3 = _G.Third,
						BackgroundTransparency = 0
					}):Play()
				else
					toggled = false;
					TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, 4, 0.5, 0)
					}):Play()
					TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(200, 200, 200),
						BackgroundTransparency = 0.8
					}):Play()
				end;
				pcall(callback, toggled);
			end);
			
			if config == true then
				toggled = true;
				Circle.Position = UDim2.new(0, 17, 0.5, 0);
				ToggleImage.BackgroundColor3 = _G.Third;
				ToggleImage.BackgroundTransparency = 0;
				pcall(callback, toggled);
			end;
			
			TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
		end;
		
		function main:Dropdown(text, option, var, callback)
			local isdropping = false;
			local Dropdown = Instance.new("Frame");
			local DropdownFrameScroll = Instance.new("Frame");
			local UICorner = Instance.new("UICorner");
			local UICorner_2 = Instance.new("UICorner");
			local UICorner_3 = Instance.new("UICorner");
			local UICorner_4 = Instance.new("UICorner");
			local DropTitle = Instance.new("TextLabel");
			local DropScroll = Instance.new("ScrollingFrame");
			local UIListLayout = Instance.new("UIListLayout");
			local UIPadding = Instance.new("UIPadding");
			local DropButton = Instance.new("TextButton");
			local HideButton = Instance.new("TextButton");
			local SelectItems = Instance.new("TextButton");
			local DropImage = Instance.new("ImageLabel");
			local UIStroke = Instance.new("UIStroke");
			
			Dropdown.Name = "Dropdown";
			Dropdown.Parent = MainFramePage;
			Dropdown.BackgroundColor3 = _G.Primary;
			Dropdown.BackgroundTransparency = 1;
			Dropdown.ClipsDescendants = false;
			Dropdown.Size = UDim2.new(1, 0, 0, 40);
			
			UICorner.CornerRadius = UDim.new(0, 5);
			UICorner.Parent = Dropdown;
			
			DropTitle.Name = "DropTitle";
			DropTitle.Parent = Dropdown;
			DropTitle.BackgroundColor3 = _G.Primary;
			DropTitle.BackgroundTransparency = 1;
			DropTitle.Size = UDim2.new(1, 0, 0, 30);
			DropTitle.Font = Enum.Font.Cartoon;
			DropTitle.Text = text;
			DropTitle.TextColor3 = _G.White;
			DropTitle.TextSize = 15;
			DropTitle.TextXAlignment = Enum.TextXAlignment.Left;
			DropTitle.Position = UDim2.new(0, 15, 0, 5);
			DropTitle.AnchorPoint = Vector2.new(0, 0);
			
			SelectItems.Name = "SelectItems";
			SelectItems.Parent = Dropdown;
			SelectItems.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
			SelectItems.TextColor3 = _G.White;
			SelectItems.BackgroundTransparency = 1;
			SelectItems.Position = UDim2.new(1, -5, 0, 5);
			SelectItems.Size = UDim2.new(0, 100, 0, 30);
			SelectItems.AnchorPoint = Vector2.new(1, 0);
			SelectItems.Font = Enum.Font.GothamMedium;
			SelectItems.AutoButtonColor = false;
			SelectItems.TextSize = 9;
			SelectItems.ZIndex = 1;
			SelectItems.ClipsDescendants = true;
			SelectItems.Text = "   选择项目";
			SelectItems.TextXAlignment = Enum.TextXAlignment.Left;
			
			local ArrowDown = Instance.new("ImageLabel");
			ArrowDown.Name = "ArrowDown";
			ArrowDown.Parent = Dropdown;
			ArrowDown.BackgroundColor3 = _G.Primary;
			ArrowDown.BackgroundTransparency = 1;
			ArrowDown.AnchorPoint = Vector2.new(1, 0);
			ArrowDown.Position = UDim2.new(1, -110, 0, 10);
			ArrowDown.Size = UDim2.new(0, 20, 0, 20);
			ArrowDown.Image = "rbxassetid://10709790948";
			ArrowDown.ImageTransparency = 0;
			ArrowDown.ImageColor3 = _G.White;
			
			CreateRounded(SelectItems, 5);
			CreateRounded(DropScroll, 5);
			
			DropdownFrameScroll.Name = "DropdownFrameScroll";
			DropdownFrameScroll.Parent = Dropdown;
			DropdownFrameScroll.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
			DropdownFrameScroll.BackgroundTransparency = 1;
			DropdownFrameScroll.ClipsDescendants = true;
			DropdownFrameScroll.Size = UDim2.new(1, 0, 0, 0);
			DropdownFrameScroll.Position = UDim2.new(0, 5, 0, 40);
			DropdownFrameScroll.Visible = false;
			DropdownFrameScroll.AnchorPoint = Vector2.new(0, 0);
			
			UICorner_4.Parent = DropdownFrameScroll;
			UICorner_4.CornerRadius = UDim.new(0, 5);
			
			DropScroll.Name = "DropScroll";
			DropScroll.Parent = DropdownFrameScroll;
			DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y;
			DropScroll.Active = true;
			DropScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			DropScroll.BackgroundTransparency = 1;
			DropScroll.BorderSizePixel = 0;
			DropScroll.Position = UDim2.new(0, 0, 0, 10);
			DropScroll.Size = UDim2.new(1, 0, 0, 80);
			DropScroll.AnchorPoint = Vector2.new(0, 0);
			DropScroll.ClipsDescendants = true;
			DropScroll.ScrollBarThickness = 3;
			DropScroll.ZIndex = 3;
			
			local PaddingDrop = Instance.new("UIPadding");
			PaddingDrop.PaddingLeft = UDim.new(0, 10);
			PaddingDrop.PaddingRight = UDim.new(0, 10);
			PaddingDrop.Parent = DropScroll;
			PaddingDrop.Name = "PaddingDrop";
			
			UIListLayout.Parent = DropScroll;
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			UIListLayout.Padding = UDim.new(0, 1);
			
			UIPadding.Parent = DropScroll;
			UIPadding.PaddingLeft = UDim.new(0, 5);
			
			for i, v in next, option do
				local Item = Instance.new("TextButton");
				local CRNRitems = Instance.new("UICorner");
				local UICorner_5 = Instance.new("UICorner");
				local ItemPadding = Instance.new("UIPadding");
				
				Item.Name = "Item";
				Item.Parent = DropScroll;
				Item.BackgroundColor3 = _G.Primary;
				Item.BackgroundTransparency = 1;
				Item.Size = UDim2.new(1, 0, 0, 30);
				Item.Font = Enum.Font.Nunito;
				Item.Text = tostring(v);
				Item.TextColor3 = _G.White;
				Item.TextSize = 13;
				Item.TextTransparency = 0.5;
				Item.TextXAlignment = Enum.TextXAlignment.Left;
				Item.ZIndex = 4;
				
				ItemPadding.Parent = Item;
				ItemPadding.PaddingLeft = UDim.new(0, 8);
				
				UICorner_5.Parent = Item;
				UICorner_5.CornerRadius = UDim.new(0, 5);
				
				local SelectedItems = Instance.new("Frame");
				SelectedItems.Name = "SelectedItems";
				SelectedItems.Parent = Item;
				SelectedItems.BackgroundColor3 = _G.Third;
				SelectedItems.BackgroundTransparency = 1;
				SelectedItems.Size = UDim2.new(0, 3, 0.4, 0);
				SelectedItems.Position = UDim2.new(0, -8, 0.5, 0);
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5);
				SelectedItems.ZIndex = 4;
				
				CRNRitems.Parent = SelectedItems;
				CRNRitems.CornerRadius = UDim.new(0, 999);
				
				if var then
					pcall(callback, var);
					SelectItems.Text = "   " .. var;
					activeItem = tostring(var);
					for i, v in next, DropScroll:GetChildren() do
						if v:IsA("TextButton") then
							local SelectedItems = v:FindFirstChild("SelectedItems");
							if activeItem == v.Text then
								v.BackgroundTransparency = 0.8;
								v.TextTransparency = 0;
								if SelectedItems then
									SelectedItems.BackgroundTransparency = 0;
								end;
							end;
						end;
					end;
				end;
				
				Item.MouseButton1Click:Connect(function()
					SelectItems.ClipsDescendants = true;
					callback(Item.Text);
					activeItem = Item.Text;
					for i, v in next, DropScroll:GetChildren() do
						if v:IsA("TextButton") then
							local SelectedItems = v:FindFirstChild("SelectedItems");
							if activeItem == v.Text then
								TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
									BackgroundTransparency = 0.8,
									TextTransparency = 0
								}):Play()
								if SelectedItems then
									TweenService:Create(SelectedItems, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
										BackgroundTransparency = 0
									}):Play()
								end;
							else
								TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
									BackgroundTransparency = 1,
									TextTransparency = 0.5
								}):Play()
								if SelectedItems then
									TweenService:Create(SelectedItems, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
										BackgroundTransparency = 1
									}):Play()
								end;
							end;
						end;
					end;
					SelectItems.Text = "   " .. Item.Text;
				end);
			end;
			
			DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y);
			
			SelectItems.MouseButton1Click:Connect(function()
				if isdropping == false then
					isdropping = true;
					TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.8,
						Size = UDim2.new(1, 0, 0, 145)
					}):Play()
					TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0,
						Size = UDim2.new(1, -10, 0, 100),
						Visible = true
					}):Play();
					TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Rotation = 180
					}):Play();
				else
					isdropping = false;
					TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.8,
						Size = UDim2.new(1, 0, 0, 40)
					}):Play()
					TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -10, 0, 0),
						Visible = false
					}):Play();
					TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Rotation = 0
					}):Play();
				end;
			end);
			
			TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
			
			local dropfunc = {};
			
			function dropfunc:Add(t)
				local Item = Instance.new("TextButton");
				local CRNRitems = Instance.new("UICorner");
				local UICorner_5 = Instance.new("UICorner");
				local ItemPadding = Instance.new("UIPadding");
				
				Item.Name = "Item";
				Item.Parent = DropScroll;
				Item.BackgroundColor3 = _G.Primary;
				Item.BackgroundTransparency = 1;
				Item.Size = UDim2.new(1, 0, 0, 30);
				Item.Font = Enum.Font.Nunito;
				Item.Text = tostring(t);
				Item.TextColor3 = _G.White;
				Item.TextSize = 13;
				Item.TextTransparency = 0.5;
				Item.TextXAlignment = Enum.TextXAlignment.Left;
				Item.ZIndex = 4;
				
				ItemPadding.Parent = Item;
				ItemPadding.PaddingLeft = UDim.new(0, 8);
				
				UICorner_5.Parent = Item;
				UICorner_5.CornerRadius = UDim.new(0, 5);
				
				local SelectedItems = Instance.new("Frame");
				SelectedItems.Name = "SelectedItems";
				SelectedItems.Parent = Item;
				SelectedItems.BackgroundColor3 = _G.Third;
				SelectedItems.BackgroundTransparency = 1;
				SelectedItems.Size = UDim2.new(0, 3, 0.4, 0);
				SelectedItems.Position = UDim2.new(0, -8, 0.5, 0);
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5);
				SelectedItems.ZIndex = 4;
				
				CRNRitems.Parent = SelectedItems;
				CRNRitems.CornerRadius = UDim.new(0, 999);
				
				Item.MouseButton1Click:Connect(function()
					callback(Item.Text);
					activeItem = Item.Text;
					for i, v in next, DropScroll:GetChildren() do
						if v:IsA("TextButton") then
							local SelectedItems = v:FindFirstChild("SelectedItems");
							if activeItem == v.Text then
								TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
									BackgroundTransparency = 0.8,
									TextTransparency = 0
								}):Play()
								if SelectedItems then
									TweenService:Create(SelectedItems, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
										BackgroundTransparency = 0
									}):Play()
								end;
							else
								TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
									BackgroundTransparency = 1,
									TextTransparency = 0.5
								}):Play()
								if SelectedItems then
									TweenService:Create(SelectedItems, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
										BackgroundTransparency = 1
									}):Play()
								end;
							end;
						end;
					end;
					SelectItems.Text = "   " .. Item.Text;
				end);
			end;
			
			function dropfunc:Clear()
				SelectItems.Text = "   选择项目";
				isdropping = false;
				DropdownFrameScroll.Visible = false;
				for i, v in next, DropScroll:GetChildren() do
					if v:IsA("TextButton") then
						v:Destroy();
					end;
				end;
			end;
			
			return dropfunc;
		end;
		
		function main:Slider(text, min, max, set, callback)
			local Slider = Instance.new("Frame");
			local slidercorner = Instance.new("UICorner");
			local sliderr = Instance.new("Frame");
			local sliderrcorner = Instance.new("UICorner");
			local ImageLabel = Instance.new("ImageLabel");
			local SliderStroke = Instance.new("UIStroke");
			local Title = Instance.new("TextLabel");
			local ValueText = Instance.new("TextLabel");
			local HAHA = Instance.new("Frame");
			local AHEHE = Instance.new("TextButton");
			local bar = Instance.new("Frame");
			local bar1 = Instance.new("Frame");
			local bar1corner = Instance.new("UICorner");
			local barcorner = Instance.new("UICorner");
			local circlebar = Instance.new("Frame");
			local UICorner = Instance.new("UICorner");
			local slidervalue = Instance.new("Frame");
			local valuecorner = Instance.new("UICorner");
			local TextBox = Instance.new("TextBox");
			local UICorner_2 = Instance.new("UICorner");
			local posto = Instance.new("UIStroke");
			
			Slider.Name = "Slider";
			Slider.Parent = MainFramePage;
			Slider.BackgroundColor3 = _G.Primary;
			Slider.BackgroundTransparency = 1;
			Slider.Size = UDim2.new(1, 0, 0, 35);
			
			slidercorner.CornerRadius = UDim.new(0, 5);
			slidercorner.Name = "slidercorner";
			slidercorner.Parent = Slider;
			
			sliderr.Name = "sliderr";
			sliderr.Parent = Slider;
			sliderr.BackgroundColor3 = _G.Primary;
			sliderr.BackgroundTransparency = 1;
			sliderr.Position = UDim2.new(0, 0, 0, 0);
			sliderr.Size = UDim2.new(1, 0, 0, 35);
			
			sliderrcorner.CornerRadius = UDim.new(0, 5);
			sliderrcorner.Name = "sliderrcorner";
			sliderrcorner.Parent = sliderr;
			
			Title.Parent = sliderr;
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0, 15, 0.5, 0);
			Title.Size = UDim2.new(1, 0, 0, 30);
			Title.Font = Enum.Font.Cartoon;
			Title.Text = text;
			Title.AnchorPoint = Vector2.new(0, 0.5);
			Title.TextColor3 = _G.White;
			Title.TextSize = 15;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			
			bar.Name = "bar";
			bar.Parent = sliderr;
			bar.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			bar.Size = UDim2.new(0, 100, 0, 4);
			bar.Position = UDim2.new(1, -10, 0.5, 0);
			bar.BackgroundTransparency = 1;
			bar.AnchorPoint = Vector2.new(1, 0.5);
			
			ValueText.Parent = bar;
			ValueText.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			ValueText.BackgroundTransparency = 1;
			ValueText.Position = UDim2.new(0, -38, 0.5, 0);
			ValueText.Size = UDim2.new(0, 30, 0, 30);
			ValueText.Font = Enum.Font.GothamMedium;
			ValueText.Text = set;
			ValueText.AnchorPoint = Vector2.new(0, 0.5);
			ValueText.TextColor3 = _G.White;
			ValueText.TextSize = 12;
			ValueText.TextXAlignment = Enum.TextXAlignment.Right;
			
			bar1.Name = "bar1";
			bar1.Parent = bar;
			bar1.BackgroundColor3 = _G.Third;
			bar1.BackgroundTransparency = 0;
			bar1.Size = UDim2.new(set / max, 0, 0, 4);
			
			bar1corner.CornerRadius = UDim.new(0, 5);
			bar1corner.Name = "bar1corner";
			bar1corner.Parent = bar1;
			
			barcorner.CornerRadius = UDim.new(0, 5);
			barcorner.Name = "barcorner";
			barcorner.Parent = bar;
			
			circlebar.Name = "circlebar";
			circlebar.Parent = bar1;
			circlebar.BackgroundColor3 = _G.White;
			circlebar.Position = UDim2.new(1, 0, 0, -5);
			circlebar.AnchorPoint = Vector2.new(0.5, 0);
			circlebar.Size = UDim2.new(0, 13, 0, 13);
			
			UICorner.CornerRadius = UDim.new(0, 100);
			UICorner.Parent = circlebar;
			
			valuecorner.CornerRadius = UDim.new(0, 2);
			valuecorner.Name = "valuecorner";
			valuecorner.Parent = slidervalue;
			
			local mouse = game.Players.LocalPlayer:GetMouse();
			local uis = game:GetService("UserInputService");
			
			if Value == nil then
				Value = set;
				pcall(function()
					callback(Value);
				end);
			end;
			
			TweenService:Create(sliderr, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
			
			TweenService:Create(bar, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
			
			local Dragging = false;
			
			circlebar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
				end;
			end);
			
			bar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
				end;
			end);
			
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false;
				end;
			end);
			
			UserInputService.InputChanged:Connect(function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					Value = math.floor((tonumber(max) - tonumber(min)) / 100 * bar1.AbsoluteSize.X + tonumber(min)) or 0;
					pcall(function()
						callback(Value);
					end);
					ValueText.Text = Value;
					bar1.Size = UDim2.new(0, math.clamp(Input.Position.X - bar1.AbsolutePosition.X, 0, 100), 0, 4);
					circlebar.Position = UDim2.new(0, math.clamp(Input.Position.X - bar1.AbsolutePosition.X - 5, 0, 100), 0, -5);
				end;
			end);
		end;
		
		function main:Textbox(text, disappear, callback)
			local Textbox = Instance.new("Frame");
			local TextboxCorner = Instance.new("UICorner");
			local TextboxLabel = Instance.new("TextLabel");
			local RealTextbox = Instance.new("TextBox");
			local UICorner = Instance.new("UICorner");
			local TextBoxIcon = Instance.new("ImageLabel");
			
			Textbox.Name = "Textbox";
			Textbox.Parent = MainFramePage;
			Textbox.BackgroundColor3 = _G.Primary;
			Textbox.BackgroundTransparency = 1;
			Textbox.Size = UDim2.new(1, 0, 0, 35);
			
			TextboxCorner.CornerRadius = UDim.new(0, 5);
			TextboxCorner.Name = "TextboxCorner";
			TextboxCorner.Parent = Textbox;
			
			TextboxLabel.Name = "TextboxLabel";
			TextboxLabel.Parent = Textbox;
			TextboxLabel.BackgroundColor3 = _G.Primary;
			TextboxLabel.BackgroundTransparency = 1;
			TextboxLabel.Position = UDim2.new(0, 15, 0.5, 0);
			TextboxLabel.Text = text;
			TextboxLabel.Size = UDim2.new(1, 0, 0, 35);
			TextboxLabel.Font = Enum.Font.Nunito;
			TextboxLabel.AnchorPoint = Vector2.new(0, 0.5);
			TextboxLabel.TextColor3 = _G.White;
			TextboxLabel.TextSize = 15;
			TextboxLabel.TextTransparency = 0;
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left;
			
			RealTextbox.Name = "RealTextbox";
			RealTextbox.Parent = Textbox;
			RealTextbox.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			RealTextbox.BackgroundTransparency = 1;
			RealTextbox.Position = UDim2.new(1, -5, 0.5, 0);
			RealTextbox.AnchorPoint = Vector2.new(1, 0.5);
			RealTextbox.Size = UDim2.new(0, 80, 0, 25);
			RealTextbox.Font = Enum.Font.Gotham;
			RealTextbox.Text = "";
			RealTextbox.TextColor3 = Color3.fromRGB(225, 225, 225);
			RealTextbox.TextSize = 11;
			RealTextbox.TextTransparency = 0;
			RealTextbox.ClipsDescendants = true;
			
			RealTextbox.FocusLost:Connect(function()
				callback(RealTextbox.Text);
			end);
			
			UICorner.CornerRadius = UDim.new(0, 5);
			UICorner.Parent = RealTextbox;
			
			TweenService:Create(Textbox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
			
			TweenService:Create(RealTextbox, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
		end;
		
		function main:Label(text)
			local Frame = Instance.new("Frame");
			local Label = Instance.new("TextLabel");
			local PaddingLabel = Instance.new("UIPadding");
			local labelfunc = {};
			
			Frame.Name = "Frame";
			Frame.Parent = MainFramePage;
			Frame.BackgroundColor3 = _G.Primary;
			Frame.BackgroundTransparency = 1;
			Frame.Size = UDim2.new(1, 0, 0, 30);
			
			Label.Name = "Label";
			Label.Parent = Frame;
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Label.BackgroundTransparency = 1;
			Label.Size = UDim2.new(1, -30, 0, 30);
			Label.Font = Enum.Font.Nunito;
			Label.Position = UDim2.new(0, 30, 0.5, 0);
			Label.AnchorPoint = Vector2.new(0, 0.5);
			Label.TextColor3 = Color3.fromRGB(225, 225, 225);
			Label.TextSize = 15;
			Label.Text = text;
			Label.TextXAlignment = Enum.TextXAlignment.Left;
			
			local ImageLabel = Instance.new("ImageLabel");
			ImageLabel.Name = "ImageLabel";
			ImageLabel.Parent = Frame;
			ImageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			ImageLabel.BackgroundTransparency = 1;
			ImageLabel.ImageTransparency = 0;
			ImageLabel.Position = UDim2.new(0, 10, 0.5, 0);
			ImageLabel.Size = UDim2.new(0, 14, 0, 14);
			ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
			ImageLabel.Image = "rbxassetid://10723415903";
			ImageLabel.ImageColor3 = Color3.fromRGB(200, 200, 200);
			
			function labelfunc:Set(newtext)
				Label.Text = newtext;
			end;
			
			return labelfunc;
		end;
		
		function main:Seperator(text)
			local Seperator = Instance.new("Frame");
			local Sep1 = Instance.new("TextLabel");
			local Sep2 = Instance.new("TextLabel");
			local Sep3 = Instance.new("TextLabel");
			local SepRadius = Instance.new("UICorner");
			
			Seperator.Name = "Seperator";
			Seperator.Parent = MainFramePage;
			Seperator.BackgroundColor3 = _G.Primary;
			Seperator.BackgroundTransparency = 1;
			Seperator.Size = UDim2.new(1, 0, 0, 36);
			
			Sep1.Name = "Sep1";
			Sep1.Parent = Seperator;
			Sep1.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep1.BackgroundTransparency = 0;
			Sep1.AnchorPoint = Vector2.new(0, 0.5);
			Sep1.Position = UDim2.new(0, 0, 0.5, 0);
			Sep1.Size = UDim2.new(0.15, 0, 0, 1);
			Sep1.BorderSizePixel = 0;
			Sep1.Text = "";
			
			local Grad1 = Instance.new("UIGradient");
			Grad1.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.4, _G.Third),
				ColorSequenceKeypoint.new(0.5, _G.Accent),
				ColorSequenceKeypoint.new(0.6, _G.Third),
				ColorSequenceKeypoint.new(1, _G.Dark)
			});
			Grad1.Parent = Sep1;
			
			Sep2.Name = "Sep2";
			Sep2.Parent = Seperator;
			Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep2.BackgroundTransparency = 1;
			Sep2.AnchorPoint = Vector2.new(0.5, 0.5);
			Sep2.Position = UDim2.new(0.5, 0, 0.5, 0);
			Sep2.Size = UDim2.new(1, 0, 0, 36);
			Sep2.Font = Enum.Font.GothamBold;
			Sep2.Text = text;
			Sep2.TextColor3 = _G.White;
			Sep2.TextSize = 14;
			
			Sep3.Name = "Sep3";
			Sep3.Parent = Seperator;
			Sep3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep3.BackgroundTransparency = 0;
			Sep3.AnchorPoint = Vector2.new(1, 0.5);
			Sep3.Position = UDim2.new(1, 0, 0.5, 0);
			Sep3.Size = UDim2.new(0.15, 0, 0, 1);
			Sep3.BorderSizePixel = 0;
			Sep3.Text = "";
			
			local Grad3 = Instance.new("UIGradient");
			Grad3.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.4, _G.Third),
				ColorSequenceKeypoint.new(0.5, _G.Accent),
				ColorSequenceKeypoint.new(0.6, _G.Third),
				ColorSequenceKeypoint.new(1, _G.Dark)
			});
			Grad3.Parent = Sep3;
		end;
		
		function main:Line()
			local Linee = Instance.new("Frame");
			local Line = Instance.new("Frame");
			local UIGradient = Instance.new("UIGradient");
			
			Linee.Name = "Linee";
			Linee.Parent = MainFramePage;
			Linee.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Linee.BackgroundTransparency = 1;
			Linee.Position = UDim2.new(0, 0, 0.119999997, 0);
			Linee.Size = UDim2.new(1, 0, 0, 20);
			
			Line.Name = "Line";
			Line.Parent = Linee;
			Line.BackgroundColor3 = Color3.new(125, 125, 125);
			Line.BorderSizePixel = 0;
			Line.Position = UDim2.new(0, 0, 0, 10);
			Line.Size = UDim2.new(1, 0, 0, 1);
			
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.4, _G.Third),
				ColorSequenceKeypoint.new(0.5, _G.Accent),
				ColorSequenceKeypoint.new(0.6, _G.Third),
				ColorSequenceKeypoint.new(1, _G.Dark)
			});
			UIGradient.Parent = Line;
		end;
		
		return main;
	end;
	
	return uitab;
end;

return Update;