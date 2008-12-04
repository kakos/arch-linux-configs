--[[    awesome 3 configuration file by STxza <seynthan.tx@gmail.com>
        based on Gigamo's config <gigamo@archlinux.us>
        only works with awesome-git newer than 20/10/08
        last update: 27/11/2008                                         ]]
        
io.stderr:write("\n\n\r::: Awesome Loaded :::\r\n\n")
-------------------------------------------------------------------------------------
--{{{ Imports

-- Load default libraries
require("awful")
require("beautiful")
require("naughty")
require("wicked")

--}}}
-------------------------------------------------------------------------------------
--{{{ Initialize some stuff

tags                = {}
statusbar           = {}
promptbox           = {}
layouticon          = {}
taglist             = {}
tasklist            = {}

--}}}
-------------------------------------------------------------------------------------
--{{{ Variables

modMask             = "Mod4"

-- Default apps
term                = "SHELL=/bin/zsh urxvtc"
browser             = "/usr/bin/swiftweasel"
fileManager         = "pcmanfm"

-- Theme
theme_path          = os.getenv("HOME").."/.config/awesome/themes/stxza"
-- Load Theme
beautiful.init(theme_path)
-- Titlebar
use_titlebar        = false

-- Volume
cardid = 0
channel = "Master"

-- The layouts we will use
layouts             = { "tile"
                      , "tileleft"
                      , "tilebottom"
                      , "tiletop"
                      , "fairh"
                      , "fairv"
                      , "magnifier"
                      , "max"
                      , "floating"
                      }

-- Text for the current layout
layoutText          = { ["tile"]        = "Tiled"
                      , ["tileleft"]    = "TileLeft"
                      , ["tilebottom"]  = "TileBottom"
                      , ["tiletop"]     = "TileTop"
                      , ["fairh"]       = "FairH"
                      , ["fairv"]       = "FairV"
                      , ["magnifier"]   = "Magnifier"
                      , ["max"]         = "Max"
                      , ["floating"]    = "Floating"
                      }

-- Apps that should be forced floating
floatApps           = { ["gimp"]         = true
                      , ["emesene"]      = true
                      , ["transmission"] = true
                      }

apptags             = { ["Swiftweasel"] = { screen = 1, tag = 2 }
                      , ["emesene"] = { screen = 1, tag = 2 }
                      , ["transmission"] = { screen = 1, tag = 2 }
                      , ["pcmanfm"] = { screen = 1, tag = 4 }
                      , ["geeqie"] = { screen = 1, tag = 6 }
                      , ["gvim"] = { screen = 1, tag = 3 }
                      , ["geany"] = { screen = 1, tag = 3 }
                      , ["Gimp"] = { screen = 1, tag = 5 }
                      }

--}}}
-------------------------------------------------------------------------------------
--{{{ Load functions

loadfile(awful.util.getdir("config").."/functions.lua")()

--}}}
-------------------------------------------------------------------------------------
--{{{ Menu
-- Popup menu when we rightclick the desktop

-- Submenu
awesomemenu         = { { "Manual", term .. " -e man awesome" }
                      , { "Edit config" , term.." -e vim "..awful.util.getdir("config").."/rc.lua" }
                      , { "Restart"     , awesome.restart }
                      , { "Quit"        , awesome.quit }
                      }
-- Main menu
mainmenu            = awful.menu.new({ items = { { "Terminal"    , term }
                                               , { "Swiftweasel" , browser }
                                               , { "PCManFM"     , fileManager }
                                               , { "Gvim"        , "gvim" }
                                               , { "Gimp"        , "gimp" }
                                               , { "Screen"      , term.." -e screen -RR" }
                                               , { "Awesome"     , awesomemenu, beautiful.awesome_icon }
                                               }
                                     })

launcher            = awful.widget.launcher({ image = beautiful.awesome_icon
                                            , menu = mainmenu 
                                           })

--}}}
-------------------------------------------------------------------------------------
--{{{ Tags

for s = 1, screen.count() do
    tags[s] = {}
    -- Give the first 3 tag special names
    tags[s][1] = tag({ name = "1-t", layout = layouts[1], mwfact = 0.618033988769 })
    tags[s][2] = tag({ name = "2-w", layout = layouts[1] })
    tags[s][3] = tag({ name = "3-d", layout = layouts[4], mwfact = 0.15 })
    -- Put them on the screen
    for tagnumber = 1, 3 do
        tags[s][tagnumber].screen = s
    end
    -- Automatically name the next 6 tags after their tag number and put them on the screen
    for tagnumber = 4, 6 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = layouts[1] })
        tags[s][tagnumber].screen = s
    end
    -- Select at least one tag
    tags[s][1].selected = true
end

--}}}
-------------------------------------------------------------------------------------
--{{{ Widgets
-- Please note the functions feeding some of the widgets are found in functions.lua
-- TODO: PacUpdates(Not that Useful), System Tray(for emesene, parcellite..)

-- Simple spacer we can use to get cleaner code
spacer = " "
-- Separator icon
separator = widget({ type = "imagebox", name = "separator", align = "right" })
separator.image = image(awful.util.getdir("config").."/icons/separators/link2.png")

-- Create the clock widget
clockwidget = widget({ type = "textbox", name = "clockwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our clock
clockInfo("%d/%m/%Y", "%T")

-- Create the wifi widget
wifiwidget = widget({ type = "textbox", name = "wifiwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our signal strength
wifiInfo("wlan0")

-- Create the battery widget
batterywidget = widget({ type = "textbox", name = "batterywidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our percentage
batteryInfo("BAT0")

-- Create the memory widget
memwidget = widget({ type = "textbox", name = "memwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our memory usage
memInfo()

-- Create the File Sys Usage widget
fswidget = widget({ type = 'textbox', name = 'fswidget', align = 'right' })
wicked.register(fswidget, wicked.widgets.fs, 
    spacer..setFg(beautiful.fg_focus, "/:")..'${/ usep}%'..spacer..setFg(beautiful.fg_focus, "~:")..'${/home usep}%'..spacer, 
15)

-- Create the CPU Usage, CPU Temps, GPU Temp widget
syswidget = widget({ type = 'textbox', name = 'syswidget', align = 'right' })
wicked.register(syswidget, 'cpu', sysInfo, 15, nil, 2)

-- Create the volume widget
volumewidget = widget({ type = 'textbox', name = 'volumewidget', align = 'right' })
wicked.register(volumewidget, getVol, "$1", 15)

-- Create a system tray
systray = widget({ type = "systray", name = "systray", align = "right" })

-- Initialize which buttons do what when clicking the taglist
taglist.buttons     = { button({ }          , 1, awful.tag.viewonly)
                      , button({ modMask }  , 1, awful.client.movetotag)
                      , button({ }          , 3, function (tag) tag.selected = not tag.selected end)
                      , button({ modMask }  , 3, awful.client.toggletag)
                      , button({ }          , 4, awful.tag.viewnext)
                      , button({ }          , 5, awful.tag.viewprev) 
                      }
-- Initialize which buttons do what when clicking the tasklist
tasklist.buttons    = { button({ }          , 1, function (c) client.focus = c; c:raise() end)
                      , button({ }          , 4, function () awful.client.focus.byidx(1) end)
                      , button({ }          , 5, function () awful.client.focus.byidx(-1) end) 
                      }

-- From here on, everything gets created for every screen
for s = 1, screen.count() do
    -- Promptbox (pops up with mod+r)
    promptbox[s] = widget({ type = "textbox", name = "promptbox"..s, align = "left" })
    -- Layout icon, which is actually the layouttext which we defined before
    layouticon[s] = widget({ type = "textbox", name = "layouticon" })
    -- Which buttons do what when clicking the layout text
    layouticon[s].buttons = { button({ }      , 1, function () awful.layout.inc(layouts, 1) end)
                            , button({ }      , 3, function () awful.layout.inc(layouts, -1) end)
                            , button({ }      , 4, function () awful.layout.inc(layouts, 1) end)
                            , button({ }      , 5, function () awful.layout.inc(layouts, -1) end) 
                            }
    -- Create the taglist
    taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the tasklist
    tasklist[s] = awful.widget.tasklist.new(function(c)
                                                if c == client.focus then 
                                                    return awful.widget.tasklist.label.currenttags(c, s)
                                                end
                                            end, tasklist.buttons)
 
    -- Finally, create the statusbar (called wibox), and set its properties
    statusbar[s] = wibox({
        position = "top", 
        height = "16", 
        name = "statusbar"..s, 
        fg = beautiful.fg_normal, 
        bg = beautiful.bg_normal, 
        border_color = beautiful.border_normal, 
        border_width = beautiful.border_width 
    })
    -- Add our widgets to the wibox
    statusbar[s].widgets = { launcher
                           , taglist[s]
                           , layouticon[s]
                           , tasklist[s]
                           , promptbox[s]
                           , separator
                           , syswidget
                           , separator
                           , memwidget
                           , separator
                           , fswidget
                           , separator
                           , wifiwidget
                           , separator
                           , batterywidget
                           , separator
                           , volumewidget
                           , separator
                           , clockwidget
                           , s == 1 and systray or nil
                           }
    -- Add it to each screen
    statusbar[s].screen = s
end

--}}}
-------------------------------------------------------------------------------------
--{{{ Bindings

-- What happens when we click the desktop
awesome.buttons({
    button({ }                      , 3         , function () mainmenu:toggle() end),
    button({ }                      , 4         , awful.tag.viewnext),
    button({ }                      , 5         , awful.tag.viewprev)
})

keynumber = 6
for i = 1, keynumber do
    -- Mod+F1-F6 focuses tag 1-6
    keybinding({ modMask }, "F"..i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end):add()
    -- Mod+Ctrl+F1-F6 additionally shows clients from tag 1-6
    keybinding({ modMask, "Control" }, "F"..i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            tags[screen][i].selected = not tags[screen][i].selected
        end
    end):add()
    -- Mod+Shift+F1-F6 moves the current client to tag 1-6
    keybinding({ modMask, "Shift" }, "F"..i,
    function ()
        if client.focus then
            if tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end
    end):add()
end
-- Shows or hides the statusbar
keybinding({ modMask }              , "b"       , function () 
    if statusbar[mouse.screen].screen == nil then 
        statusbar[mouse.screen].screen = mouse.screen
    else
        statusbar[mouse.screen].screen = nil
    end
end):add()
-- These should be straightforward...
keybinding({ modMask }              , "Left"    , awful.tag.viewprev):add()
keybinding({ modMask }              , "Right"   , awful.tag.viewnext):add()
keybinding({ modMask }              , "x"       , function () awful.util.spawn(term) end):add()
keybinding({ modMask }              , "f"       , function () awful.util.spawn(browser) end):add()
keybinding({ modMask }              , "p"       , function () awful.util.spawn(fileManager) end):add()
keybinding({ modMask }              , "e"       , function () awful.util.spawn("emesene") end):add()
keybinding({ modMask }              , "g"       , function () awful.util.spawn("geany") end):add()
keybinding({ modMask, "Control" }   , "r"       , function () promptbox[mouse.screen].text = awful.util.escape(awful.util.restart()) end):add()
keybinding({ modMask, "Shift" }     , "q"       , awesome.quit):add()
keybinding({ modMask }              , "m"       , awful.client.maximize):add()
keybinding({ modMask }              , "c"       , function () client.focus:kill() end):add()
keybinding({ modMask }              , "j"       , function () awful.client.focus.byidx(1); client.focus:raise() end):add()
keybinding({ modMask }              , "k"       , function () awful.client.focus.byidx(-1);  client.focus:raise() end):add()
keybinding({ modMask, "Control" }   , "space"   , awful.client.togglefloating):add()
keybinding({ modMask, "Control" }   , "Return"  , function () client.focus:swap(awful.client.master()) end):add()
keybinding({ modMask }              , "Tab"     , awful.client.focus.history.previous):add()
keybinding({ modMask }              , "u"       , awful.client.urgent.jumpto):add()
keybinding({ modMask, "Shift" }     , "r"       , function () client.focus:redraw() end):add()
keybinding({ modMask }              , "l"       , function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modMask }              , "h"       , function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modMask, "Shift" }     , "h"       , function () awful.tag.incnmaster(1) end):add()
keybinding({ modMask, "Shift" }     , "l"       , function () awful.tag.incnmaster(-1) end):add()
keybinding({ modMask, "Control" }   , "h"       , function () awful.tag.incncol(1) end):add()
keybinding({ modMask, "Control" }   , "l"       , function () awful.tag.incncol(-1) end):add()
keybinding({ modMask }              , "space"   , function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modMask, "Shift" }     , "space"   , function () awful.layout.inc(layouts, -1) end):add()
keybinding({ modMask }              , "r"       , function () awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen], awful.util.spawn, awful.completion.bash, os.getenv("HOME").."/.cache/awesome/history") end):add()

--}}}
-------------------------------------------------------------------------------------
--{{{ Hooks

-- Gets executed when focusing a client
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Gets executed when unfocusing a client
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Gets executed when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Gets executed when unmarking a client
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Gets executed when the mouse enters a client
awful.hooks.mouse_enter.register(function (c)
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Gets executed when a new client appears
awful.hooks.manage.register(function (c)
    -- Add mouse binds
    c:buttons({ button({ }, 1, function (c) client.focus = c; c:raise() end)
              , button({ modMask }, 1, function (c) c:mouse_move() end)
              , button({ modMask }, 3, function (c) c:mouse_resize() end)
              })
    
    -- Set border anyway
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating
    local cls = c.class
    local inst = c.instance
    if floatApps[cls] then
        c.floating = floatApps[cls]
    elseif floatApps[inst] then
        c.floating = floatApps[inst]
    end
    
    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end
    
    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c
    
    -- Prevent new clients from becoming master
    awful.client.setslave(c)

    -- Ignore size hints usually given out by terminals (prevent gaps between windows)
    c.honorsizehints = false
end)

-- Gets executed when arranging the screen (as in, tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    -- Set the layout text
    local layout = awful.layout.get(screen)
    if layout then
        layouticon[screen].text = returnLayoutText(awful.layout.get(screen))
    else
        layouticon[screen].text = nil
    end

    -- Give focus to the latest client in history if no window has focus
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Timed hooks for the widget functions
-- 1 second
awful.hooks.timer.register(1, function ()
    clockInfo("%d/%m/%Y", "%T")
end)

-- 5 seconds
awful.hooks.timer.register(15, function()
    memInfo()
    wifiInfo("wlan0")
end)

-- 20 seconds
awful.hooks.timer.register(20, function()
    batteryInfo("BAT0")
end)

--}}}
