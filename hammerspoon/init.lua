--------------------------------------------------------------------------------
-- Hammerspoon Configuration with Dynamic Simulator Width
-- Left Screen: 
--   - Chrome ("Default") fills left portion (width = total width minus simulator's current width)
--   - Simulator occupies right portion at full height.
-- Middle Screen: VS Code full screen.
-- Right Screen: Vertical split (Docker, Finder, Chrome with "Profile 1").
--------------------------------------------------------------------------------

-- Turn off window shadows
hs.window.setShadows(false)

--------------------------------------------------------------------------------
-- Reload Configuration
--------------------------------------------------------------------------------

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
  hs.alert.show("Config reloaded!")
end)

--------------------------------------------------------------------------------
-- Debug: List All Detected Screens
--------------------------------------------------------------------------------

local function listScreens()
  print("Detected screens:")
  for i, scr in ipairs(hs.screen.allScreens()) do
    print("Screen " .. i .. ": " .. scr:name() .. " (ID: " .. tostring(scr:id()) .. ")")
  end
end

listScreens()

screenWatcher = hs.screen.watcher.new(function()
  print("Screen configuration changed:")
  listScreens()
end)
screenWatcher:start()

--------------------------------------------------------------------------------
-- Helper Function: Find Screen by Substring (Case-Insensitive)
--------------------------------------------------------------------------------

local function findScreenByName(substring)
  substring = string.lower(substring)
  for _, scr in ipairs(hs.screen.allScreens()) do
    if string.find(string.lower(scr:name()), substring, 1, true) then
      return scr
    end
  end
  return nil
end

--------------------------------------------------------------------------------
-- Application Launcher Shortcuts
--------------------------------------------------------------------------------

local applicationHotkeys = {
  c = 'Visual Studio Code',
  g = 'Google Chrome',
  s = 'Slack',
  d = 'Docker Desktop',
  f = 'Finder',
  p = 'Spotify',
  i = 'Simulator',
  m='Messages'
}

-- Simulator launch function: boots "iPhone 16 Pro" and opens Simulator.
local function launchSimulator()
  local simDevice = "iPhone 16 Pro"
  local bootCmd = "/usr/bin/xcrun simctl boot '" .. simDevice .. "'"
  print("Booting Simulator device with command: " .. bootCmd)
  os.execute(bootCmd)

  os.execute("open -a Simulator")
  hs.timer.usleep(2500000)  -- Wait 2.5 seconds

  local simApp = hs.application.get("Simulator")
  if simApp then
    hs.alert.show("Simulator launched with " .. simDevice)
    return simApp
  else
    hs.alert.show("Simulator failed to launch")
    return nil
  end
end

for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind({"cmd", "alt"}, key, function()
    if app == "Simulator" then
      launchSimulator()
    else
      hs.application.launchOrFocus(app)
    end
  end)
end

--------------------------------------------------------------------------------
-- Window Management (Arrow Keys)
--------------------------------------------------------------------------------

local function getFocusedWindow()
  local win = hs.window.focusedWindow()
  if not win then
    hs.alert.show("No window in focus")
    return nil
  end
  return win
end

hs.hotkey.bind({"cmd", "alt"}, "Left", function()
  local win = getFocusedWindow()
  if not win then return end
  local scr = win:screen()
  local f = scr:frame()
  win:setFrame({ x = f.x, y = f.y, w = f.w/2, h = f.h }, 0)
end)

hs.hotkey.bind({"cmd", "alt"}, "Right", function()
  local win = getFocusedWindow()
  if not win then return end
  local scr = win:screen()
  local f = scr:frame()
  win:setFrame({ x = f.x + f.w/2, y = f.y, w = f.w/2, h = f.h }, 0)
end)

hs.hotkey.bind({"cmd", "alt"}, "Up", function()
  local win = getFocusedWindow()
  if not win then return end
  local scr = win:screen()
  local f = scr:frame()
  win:setFrame({ x = f.x, y = f.y, w = f.w, h = f.h }, 0)
end)

hs.hotkey.bind({"cmd", "alt"}, "Down", function()
  local win = getFocusedWindow()
  if not win then return end
  local scr = win:screen()
  local f = scr:frame()
  local halfW = f.w/2
  local halfH = f.h/2
  win:setFrame({
    x = f.x + (f.w - halfW)/2,
    y = f.y + (f.h - halfH)/2,
    w = halfW,
    h = halfH
  }, 0)
end)

hs.hotkey.bind({"cmd", "alt"}, "-", function()
  local win = getFocusedWindow()
  if win then win:minimize() end
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "-", function()
  local minimized = hs.window.minimizedWindows()
  if #minimized > 0 then
    minimized[#minimized]:unminimize()
  end
end)

--------------------------------------------------------------------------------
-- App Layout Helpers
--------------------------------------------------------------------------------

-- Check if an application is running and has windows
local function appHasWindows(appName)
  local app = hs.application.get(appName)
  if not app then
    return false
  end
  
  local windows = app:allWindows()
  return #windows > 0
end

-- Get or launch an application's main window
local function getAppMainWindow(appName)
  local app = hs.application.get(appName)
  if not app then
    print("Launching " .. appName .. " because it's not running")
    hs.application.launchOrFocus(appName)
    local attempts = 0
    while not app and attempts < 10 do
      hs.timer.usleep(200000)
      app = hs.application.get(appName)
      attempts = attempts + 1
    end
  end
  
  if app then
    local win = app:mainWindow()
    if not win then
      local allWindows = app:allWindows()
      if #allWindows > 0 then
        win = allWindows[1]
      else
        print("No windows found for " .. appName .. ", creating a new one")
        app:selectMenuItem({"File", "New Window"})
        hs.timer.usleep(500000)
        win = app:mainWindow() or (app:allWindows()[1])
      end
    end
    
    if not win then
      hs.alert.show("Could not find or create window for " .. appName)
      return nil
    end
    return win
  else
    hs.alert.show("Could not launch " .. appName)
    return nil
  end
end

--------------------------------------------------------------------------------
-- Chrome Profile Launch Helpers
--------------------------------------------------------------------------------

-- Helper function to find Chrome window by profile
local function findChromeWindowByProfile(profileName)
  local chrome = hs.application.find("Google Chrome")
  if not chrome then 
    print("Chrome application not found")
    return nil 
  end
  
  print("Looking for Chrome window with profile: " .. profileName)
  print("Found " .. #chrome:allWindows() .. " Chrome windows")
  
  -- The Default profile windows won't have "Profile" in their titles
  if profileName == "Default" then
    for i, win in ipairs(chrome:allWindows()) do
      local title = win:title()
      print("Window " .. i .. " title: " .. (title or "nil"))
      if title and not string.find(title, " %- Profile ") then
        print("Found Default profile window: " .. title)
        return win
      end
    end
  else
    -- For other profiles, look for exact profile name match
    for i, win in ipairs(chrome:allWindows()) do
      local title = win:title()
      print("Window " .. i .. " title: " .. (title or "nil"))
      if title and string.find(title, " %- Profile " .. profileName) then
        print("Found Profile " .. profileName .. " window: " .. title)
        return win
      end
    end
  end
  print("No window found for profile: " .. profileName)
  return nil
end

-- Get or launch Chrome with a specific profile
local function getChromeProfileWindow(profileName)
  -- First check if a window with this profile already exists
  local existingWindow = findChromeWindowByProfile(profileName)
  if existingWindow then
    print("Found existing Chrome window for profile: " .. profileName)
    return existingWindow
  end
  
  -- If no existing window, launch a new one
  print("No existing Chrome window found for profile: " .. profileName .. ", launching new one")
  local command
  if profileName == "Default" then
    command = "open -n -a 'Google Chrome' --args --new-window"
  else
    command = "open -n -a 'Google Chrome' --args --profile-directory='Profile " .. profileName .. "' --new-window"
  end
  print("Launching Chrome with command: " .. command)
  os.execute(command)
  hs.timer.usleep(2000000)  -- Wait 2 seconds for Chrome to launch
  
  -- Try to find the window we just created
  return findChromeWindowByProfile(profileName)
end

--------------------------------------------------------------------------------
-- 3-Screen Development Setup
--------------------------------------------------------------------------------

local function setupThreeScreenDevelopment()
  print("Setting up 3-screen development layout...")
  for i, scr in ipairs(hs.screen.allScreens()) do
    print("During setup - Screen " .. i .. ": " .. scr:name() .. " (ID: " .. tostring(scr:id()) .. ")")
  end
  
  hs.timer.doAfter(2.0, function()
    local builtInScreen = findScreenByName("Built-in Retina")
    local phlScreen     = findScreenByName("PHL 245E1")
    local dellScreen    = findScreenByName("DELL P2423D")
    
    if not (builtInScreen and phlScreen and dellScreen) then
      hs.alert.show("One or more screens not detected correctly")
      print("Built-in screen: ", builtInScreen and builtInScreen:name() or "nil")
      print("PHL screen: ", phlScreen and phlScreen:name() or "nil")
      print("DELL screen: ", dellScreen and dellScreen:name() or "nil")
      return
    end
    
    -- Launch main apps
    local apps = { "Visual Studio Code", "Google Chrome", "Docker Desktop", "Finder" }
    for _, app in ipairs(apps) do
      hs.application.launchOrFocus(app)
      hs.timer.usleep(300000)
    end
    
        -- Check if Simulator is already running
    local simulatorApp = hs.application.get("Simulator")
    local simulatorWin = simulatorApp and simulatorApp:mainWindow()
    
    if not simulatorWin then
      print("Simulator not running, launching it")
      launchSimulator()
    else
      print("Simulator already running, using existing window")
    end
    hs.timer.usleep(1000000)
    
    hs.timer.doAfter(1.5, function()
      local builtInFrame = builtInScreen:frame()
      local rightFrame = dellScreen:frame()
      local sectionHeight = rightFrame.h / 3
      
      -- Get or launch Chrome windows for both profiles
      local chromeDefault = getChromeProfileWindow("Default")
      hs.timer.usleep(1000000)  -- Wait 1 second between operations
      local chromeProfile1 = getChromeProfileWindow("1")
      
      -- Wait a bit more before setting window positions
      hs.timer.doAfter(1.0, function()
        local simulatorWin = hs.application.get("Simulator") and hs.application.get("Simulator"):mainWindow()
        
        local simWidth
        if simulatorWin then
          local currentSimFrame = simulatorWin:frame()
          simWidth = currentSimFrame.w
        else
          simWidth = 400
        end
        
        -- Position Default Chrome on left screen
        if chromeDefault then
          chromeDefault:setFrame({
            x = builtInFrame.x,
            y = builtInFrame.y,
            w = builtInFrame.w - simWidth,
            h = builtInFrame.h
          }, 0)
        end
        
        -- Position Simulator
        if simulatorWin then
          simulatorWin:setFrame({
            x = builtInFrame.x + builtInFrame.w - simWidth,
            y = builtInFrame.y,
            w = simWidth,
            h = builtInFrame.h
          }, 0)
        end
        
        -- Get or launch Docker and Finder
        local docker = getAppMainWindow("Docker Desktop")
        local finder = getAppMainWindow("Finder")
        
        -- Position Docker and Finder
        if docker then
          docker:setFrame({
            x = rightFrame.x,
            y = rightFrame.y,
            w = rightFrame.w,
            h = sectionHeight
          }, 0)
        end
        
        if finder then
          finder:setFrame({
            x = rightFrame.x,
            y = rightFrame.y + sectionHeight,
            w = rightFrame.w,
            h = sectionHeight
          }, 0)
        end
        
        -- Position Profile 1 Chrome on right screen
        if chromeProfile1 then
          chromeProfile1:setFrame({
            x = rightFrame.x,
            y = rightFrame.y + (sectionHeight * 2),
            w = rightFrame.w,
            h = sectionHeight
          }, 0)
        end
      end)
    end)
  end)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "3", function()
  setupThreeScreenDevelopment()
end)

--------------------------------------------------------------------------------
-- Move Window to Next/Previous Screen
--------------------------------------------------------------------------------

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "right", function()
  local win = getFocusedWindow()
  if win then win:moveToScreen(win:screen():next()) end
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "left", function()
  local win = getFocusedWindow()
  if win then win:moveToScreen(win:screen():previous()) end
end)

--------------------------------------------------------------------------------
-- Single Monitor Setup 1 (cmd + option + control + m)
--------------------------------------------------------------------------------

local function setupSingleMonitorOne()
  print("Setting up single monitor layout 1...")
  
  local screen = hs.screen.mainScreen()
  local frame = screen:frame()
  
  -- Get Chrome Profile 1 first
  print("Getting Chrome Profile 1...")
  local chromeProfile1 = getChromeProfileWindow("1")
  hs.timer.usleep(1000000)  -- Wait 1 second
  
  -- Launch main apps
  local apps = { "Visual Studio Code", "Docker Desktop" }
  for _, app in ipairs(apps) do
    hs.application.launchOrFocus(app)
    hs.timer.usleep(300000)
  end
  
  -- Check if Simulator is already running
  local simulatorApp = hs.application.get("Simulator")
  local simulatorWin = simulatorApp and simulatorApp:mainWindow()
  
  if not simulatorWin then
    print("Simulator not running, launching it")
    launchSimulator()
  else
    print("Simulator already running, using existing window")
  end
  hs.timer.usleep(1000000)
  
  hs.timer.doAfter(1.5, function()
    -- Wait a bit more before setting window positions
    hs.timer.doAfter(1.0, function()
      -- Get simulator window
      local simulatorWin = hs.application.get("Simulator") and hs.application.get("Simulator"):mainWindow()
      
      -- Position Chrome Profile 1 on full screen first (so it's behind everything)
      if chromeProfile1 then
        chromeProfile1:setFrame({
          x = frame.x,
          y = frame.y,
          w = frame.w,
          h = frame.h
        }, 0)
        -- Ensure Chrome is behind other windows
        hs.timer.usleep(100000)
      end
      
      -- Get simulator width first (like in three-screen setup)
      local simWidth
      if simulatorWin then
        local currentSimFrame = simulatorWin:frame()
        simWidth = currentSimFrame.w
      else
        simWidth = 400
      end
      
      -- Calculate left side width ensuring no overlap
      local leftWidth = frame.w - simWidth
      
      -- Store the exact frame for left-side windows
      local leftSideFrame = {
        x = frame.x,
        y = frame.y,
        w = leftWidth,
        h = frame.h
      }
      
      -- Position VS Code and Docker using the exact same frame
      local codeWin = getAppMainWindow("Visual Studio Code")
      local dockerWin = getAppMainWindow("Docker Desktop")
      
      if codeWin then
        codeWin:setFrame(leftSideFrame, 0)
      end
      
      if dockerWin then
        dockerWin:setFrame(leftSideFrame, 0)
      end
      
      -- Position Simulator last (like in three-screen setup)
      if simulatorWin then
        simulatorWin:setFrame({
          x = frame.x + frame.w - simWidth,
          y = frame.y,
          w = simWidth,
          h = frame.h
        }, 0)
      end
      
      hs.alert.show("Single monitor layout 1 applied")
    end)
  end)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "m", function()
  setupSingleMonitorOne()
end)

--------------------------------------------------------------------------------
-- Single Monitor Setup 2 (cmd + option + control + w)
--------------------------------------------------------------------------------

local function setupSingleMonitorTwo()
  print("Setting up single monitor layout 2...")

  local screen = hs.screen.mainScreen()
  local screenFrame = screen:frame()

  -- Create a full screen rect using hs.geometry
  local fullScreenRect = hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h)
  print("Screen dimensions:", fullScreenRect.w, "x", fullScreenRect.h)

  -- Launch main apps if not already running, or focus them if they are
  local apps = { "Visual Studio Code", "Google Chrome", "Docker Desktop", "Finder" }
  for _, app in ipairs(apps) do
    hs.application.launchOrFocus(app)
    hs.timer.usleep(300000)
  end

  hs.timer.doAfter(1.5, function()
    -- For VS Code, ensure it's not in native full screen and then set frame directly
    local codeWin = getAppMainWindow("Visual Studio Code")
    if codeWin then
      codeWin:unmaximize() -- cancel any prior maximize state
      codeWin:setFrame(fullScreenRect, 0)
      hs.timer.doAfter(0.5, function()
        local actualFrame = codeWin:frame()
        print("VS Code dimensions after setting:", actualFrame.w, "x", actualFrame.h)
        if actualFrame.w ~= fullScreenRect.w or actualFrame.h ~= fullScreenRect.h then
          print("Dimensions mismatch, trying again...")
          codeWin:setFrame(fullScreenRect, 0)
        end
      end)
    else
      print("VS Code window not found.")
    end

    -- Handle other windows
    local chromeWin = getAppMainWindow("Google Chrome")
    local dockerWin = getAppMainWindow("Docker Desktop")
    local finderWin = getAppMainWindow("Finder")

    if chromeWin then
      chromeWin:setFrame(fullScreenRect, 0)
    end

    local halfWidth = math.floor(screenFrame.w / 2)

    if dockerWin then
      dockerWin:setFrame({
        x = screenFrame.x,
        y = screenFrame.y,
        w = halfWidth,
        h = screenFrame.h
      }, 0)
    end

    if finderWin then
      finderWin:setFrame({
        x = screenFrame.x + halfWidth,
        y = screenFrame.y,
        w = halfWidth,
        h = screenFrame.h
      }, 0)
    end

    hs.alert.show("Layout applied")
  end)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "w", function()
  setupSingleMonitorTwo()
end)




--------------------------------------------------------------------------------
-- Confirm Configuration is Loaded
--------------------------------------------------------------------------------

hs.alert.show("Hammerspoon config loaded with dynamic Simulator width and single monitor layouts")
print("Hammerspoon config loaded with separate Default Chrome (left) and Profile 1 (right), using dynamic Simulator width.")
print("Added single monitor layouts: cmd+alt+ctrl+m and cmd+alt+ctrl+w")
