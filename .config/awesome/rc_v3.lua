-- ST.x's Awesome 3 configuration file
-- Updated: 03/11/2008                     

io.stderr:write("\n\n\r::: Awesome Loaded :::\r\n\n")
require("awful")
require("tabulous")
require("beautiful")
require("wicked")


---------------------------------------------------------------------------
-- {{{ Variable definitions
theme_path = "/home/stxza/.config/awesome/themes/default"
home = '/home/stxza/.config/awesome'
icondir = '/home/stxza/.config/awesome/icons/'
terminal = "urxvtc"
browser = "swiftweasel"
modkey = "Mod4"

layouts =
{
    "tile",
    "tilebottom",
    "floating"
    --"tile",
    --"tileleft",
    --"tilebottom",
    --"tiletop",
    --"fairh",
    --"fairv",
    --"magnifier",
    --"max",
    --"spiral",
    --"dwindle",
    --"floating"
}

floatapps =
{
	["Gimp-2.6"] = true,
	["emesene"] = true,
    ["transmission"] = true
}

apptags =
{
    ["Swiftweasel"] = { screen = 1, tag = 2 },
    ["emesene"] = { screen = 1, tag = 2 },
    ["transmission"] = { screen = 1, tag = 2 },
    ["pcmanfm"] = { screen = 1, tag = 4 },
    ["geeqie"] = { screen = 1, tag = 6 },
	["gvim"] = { screen = 1, tag = 3 },
    ["geany"] = { screen = 1, tag = 3 },
	["Gimp-2.6"] = { screen = 1, tag = 5 }
}

use_titlebar = false
-- }}}


---------------------------------------------------------------------------
-- {{{ Appearance
beautiful.init(theme_path)
awful.beautiful.register(beautiful)
--tabulous.autotab_start()
-- }}}


---------------------------------------------------------------------------
-- {{{ Tags
tags = {}
tags[1] = {}
tags[1][1] = tag({ name = "1:T", layout = layouts[1], mwfact = 0.618033988769 })
tags[1][1].screen = 1
tags[1][2] = tag({ name = "2:W", layout = layouts[1] })
tags[1][2].screen = 1
tags[1][3] = tag({ name = "3:C", layout = layouts[2] })
tags[1][3].screen = 1
tags[1][4] = tag({ name = "4:PF", layout = layouts[1] })
tags[1][4].screen = 1
for tagnumber = 5, 6 do
    tags[1][tagnumber] = tag({ name = tagnumber, layout = layouts[3] })
    tags[1][tagnumber].screen = 1
end
tags[1][1].selected = true
-- }}}


---------------------------------------------------------------------------
-- {{{ Markup
-- TODO:
-- Update Widgets with these!
function setBg(color, text)
    return '<bg color="'..color..'" />'..text
end

function setFg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end

function setBgFg(bgcolor, fgcolor, text)
    return '<bg color="'..bgcolor..'" /><span color="'..fgcolor..'">'..text..'</span>'
end

function setFont(font, text)
    return '<span font_desc="'..font..'">'..text..'</span>'
end
-- }}}


---------------------------------------------------------------------------
-- {{{ Widgets
-- Taglist
taglist = widget({ type = "taglist", name = "taglist" })
taglist:mouse_add(mouse({}, 1, function (object, tag) awful.tag.viewonly(tag) end))
taglist:mouse_add(mouse({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end))
taglist:mouse_add(mouse({}, 3, function (object, tag) tag.selected = not tag.selected end))
taglist:mouse_add(mouse({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end))
taglist:mouse_add(mouse({ }, 4, awful.tag.viewnext))
taglist:mouse_add(mouse({ }, 5, awful.tag.viewprev))
taglist.label = awful.widget.taglist.label.all

-- Layout Box
layoutbox = {}
layoutbox = widget({ type = "textbox", name = "layoutbox", align = "left" })
layoutbox:mouse_add(mouse({ }, 1, function () awful.layout.inc(layouts, 1) end))
layoutbox:mouse_add(mouse({ }, 3, function () awful.layout.inc(layouts, -1) end))
layoutbox:mouse_add(mouse({ }, 4, function () awful.layout.inc(layouts, 1) end))
layoutbox:mouse_add(mouse({ }, 5, function () awful.layout.inc(layouts, -1) end))
layoutbox.text = "<bg image=\"/usr/share/awesome/icons/layouts/tilew.png\" resize=\"true\"/>"

-- Task List
tasklist = widget({ type = "tasklist", name = "tasklist" })
tasklist:mouse_add(mouse({ }, 1, function (object, c) c:focus_set(); c:raise() end))
tasklist:mouse_add(mouse({ }, 4, function () awful.client.focusbyidx(1) end))
tasklist:mouse_add(mouse({ }, 5, function () awful.client.focusbyidx(-1) end))
tasklist.label = awful.widget.tasklist.label.currenttags

-- Sys Tray
systray = widget({ type = "systray", name = "systray", align = "right" })

-- Awesome Version
awever = widget({ type = "textbox", name = "awever", align = "left" })
awever.text = "[<span color='white'>" ..AWESOME_VERSION.. "</span>]"

-- Awesome Logo
iconbox = widget ({ type = "textbox", name = "iconbox", align= "left" })
iconbox:mouse_add(mouse({ }, 1, function () awful.spawn(terminal .. " -T \"Manual awesome\" -e man awesome") end))
iconbox.text =  "<bg image=\"" .. icondir .. "awesome_blk.png\" resize=\"true\"/>"

-- Time & Date
datewidget = widget({ type = "textbox", name = "datewidget", align = "right" })
wicked.register(datewidget, "date", '<span color="cyan">%T</span> %d/%m/%y ')

-- Promptbox
promptbox = widget({ type = "textbox", name = "promptbox", align = "left" })

-- Space
space = widget({ type = "textbox", name = "space", align = "right" })
space.text = " "
-- alternatively
spacer = " "
-- wrap
wrapleft = "("
wrapright = ")"

-- Separator
separator = widget({ type="textbox", name = "separator", align = "right" })
separator.text =  "<bg image=\"" .. icondir .. "separators/link2.png\" resize=\"true\"/>"

-- CPU Graph
cpugraphwidget = widget({ type = "graph", name = "cpugraphwidget", align = "right" })
cpugraphwidget.width = 50
cpugraphwidget.height = 0.60
cpugraphwidget.grow = "left"
cpugraphwidget:plot_properties_set("cpu", {
    fg = "#E4E4E4",
    fg_center = "#727272",
    fg_end = "#7DA1FF",
    vertical_gradient = false
})
wicked.register(cpugraphwidget, "cpu", "$1", 5, "cpu")

-- CPU Percentage
cpuwidget = widget({ type = "textbox", name = "cpuwidget", align = "right" })
wicked.register(cpuwidget, "cpu", function (widget, args)
    return "<span color='#ADD8E6'>CPU</span> "..args[1].."-"..args[2].."% "  
end, 3)

-- CPU Temp/Freq & GPU Temps
temps = widget({ type = "textbox", name = "temps", align = "right" })
wicked.register(temps, "function", function (widget, args)
	local c0 = io.popen("sensors | grep \"Core 0:\" | awk -F \"+\" '{print $2}' | awk -F \"°\" '{print $1}'")
	local c1 = io.popen("sensors | grep \"Core 1:\" | awk -F \"+\" '{print $2}' | awk -F \"°\" '{print $1}'")
    local gT = io.popen("nvidia-settings -q all | egrep -m1 'GPUCoreTemp' | awk '{print $4}' | cut -d'.' -f1")
    local pL = io.popen("nvidia-settings -q all | egrep -m1 '.*Level' | awk '{print $4}' | cut -d'.' -f1")
    local CF = io.open("/proc/cpuinfo"):read("*a"):match("cpu MHz%s*:%s*([^%s]*)")
    local C0 = c0:read() 
    local C1 = c1:read() 
    local GT = gT:read() 
    local PL = pL:read()
    --c0:close() c1:close() gT:close() pL:close()
    return "<span color='#CCEBF5'>"..tonumber(CF).."</span>MHz <span color='#FFA7A7'>CT</span> "..tonumber(C0).."<span color='white'>~</span>"..tonumber(C1).."°C <span color='#45FF9E'>GPU</span> "..GT.."°C PL"..PL.." "
end, 15)

-- Memory
memwidget = widget({ type = "textbox", name = "memwidget", align = "right" })
wicked.register(memwidget, "mem", ' <span color="#B995C0">MEM</span> $2Mb/$3Mb ', 5)

-- HDD Stats
hddwidget = widget({ type = "textbox", name = "hddwidget", align = "right" })
wicked.register(hddwidget, "fs", ' <span color="#F5D9B1">HD</span> <span color="#CF8383">RT</span> ${/ usep}% <span color="#A4BEDE">HM</span> ${/home usep}% U ', 15)

-- NetTraffic
netwidget = widget({ type = "textbox", name = "netwidget", align = "right" })
wicked.register(netwidget, "net",
 ' <span color="#B1F5B1">NT</span> <span color="#B995C0">D</span> ${wlan0 down} <span color="#959DC0">U</span> ${wlan0 up} ',
 5, nil, 2)

-- Wireless Widget for Wlan0
wlanwidget = widget({ type = "textbox", name = "wlanwidget", align = "right" })
function wlaninfo()
	local iw = io.popen("/usr/sbin/iwconfig wlan0")
	local iw_text = iw:read('*a')
	io.close(iw)
	
	local essid = string.match(iw_text, "ESSID:\"(.*)\" ")
    if essid:match("seynthanmain") then
		essid = "smain"
    end
	wireless = essid
	
	local low, hi = string.match(iw_text, "Link Quality=(%d+)/(%d+)")
    qual = (low / hi) * 100

	return ""..spacer.."<span color='#77ADFF'>WFI</span>"..spacer..""..wireless..""..spacer.."("..qual.."%)"..spacer..""
end
wicked.register(wlanwidget, wlaninfo, function(widget, args)
    return args[1]
end, 20)

-- Volume
volumewidget = widget({ type = "progressbar", name = "volumewidget",  align = "right" })
volumewidget.width = 50
volumewidget.height = 0.65
volumewidget.ticks_count = 15
wicked.register(volumewidget, "function", function (widget, args)
    local f = io.popen("amixer get Master | grep Mono: | cut -d [ -f2 | cut -d % -f1")
    local l = f:read()
    f:close()
    return l
end, 10, "volume")
volumewidget:mouse_add(mouse({ }, 1, function () awful.spawn(terminal .. " -T Alsamixer -e alsamixer") end))
volumewidget:mouse_add(mouse({ }, 4, function () awful.spawn("amixer set Master 2%+") end))
volumewidget:mouse_add(mouse({ }, 5, function () awful.spawn("amixer set Master 2%-") end))

-- Battery
battwidget = widget({ type = "textbox", name = "battwidget", align = "right" })
function batteryInfo()
    local capacity = io.open("/proc/acpi/battery/BAT0/info"):read("*a"):match("last full capacity:%s+(%d+)")
    local current = io.open("/proc/acpi/battery/BAT0/state"):read("*a"):match("remaining capacity:%s+(%d+)")
    local state = io.open("/proc/acpi/battery/BAT0/state"):read("*a")
    local remainrate = io.open("/proc/acpi/battery/BAT0/state"):read("*a"):match("remaining capacity:%s+(%d+)")
    local presrate = io.open("/proc/acpi/battery/BAT0/state"):read("*a"):match("present rate:%s+(%d+)")
    battery = ((current * 100) / capacity)
    bat = math.floor(battery * 10 ^ 2) / 10 ^ 2
    bat = string.format("%d", bat)
    remaintime = (remainrate / presrate)
    hours = string.match(remaintime, "(%d+).")
    mins = (remaintime - hours) * 60
    time_left = string.format("%d:%d", hours, mins)
    
    if state:match("charged") then
        dir = "="
        bat = "100"
        time_left = ""
    elseif state:match("discharging") then
        dir = "v"
        time_left = string.format("(%d:%02d)", hours, mins)
    else
        dir = "^"
        time_left = ""
    end
    return "<span color='#F0AC8F'> BAT</span>"..spacer..""..dir..""..bat..""..dir..""..spacer..""..time_left..""
end
wicked.register(battwidget, batteryInfo, function(widget, args)
    return args[1]
end, 20)

-- Pacman Widget
pacwidget = widget({ type = "textbox", name = "pacwidget", align = "right" })
function pacinfo()
    local yaoSy = io.popen("yaourt -Sy")
    local pu = io.popen("pacman --query --upgrades")
	local pu_text = pu:read("*a")
	io.close(pu)
    io.close(yaoSy)
	
	local pacup = string.match(pu_text, "Targets %((%d+)%)")
	
	if pu_text:match("no upgrades found.") then
		pacman = "0"
	else
		pacman = pacup
	end	
	return ""..spacer.."<span color='pink'>PAC</span>"..spacer..""..pacman..""..spacer..""
end
wicked.register(pacwidget, pacinfo, function(widget, args)
    return args[1]
end, 1800)


---------------------------------------------------------------------------
-- {{{ Top Statusbar
topstatusbar = {}
topstatusbar = statusbar({ position = "top", height = 14, name = "topstatusbar", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
topstatusbar:widgets({
    --iconbox,
    --space,
	taglist,
    space,
    cpuwidget,
	temps,
    separator,
	memwidget,
    separator,
    hddwidget,
    separator,
    netwidget,
    separator,
    wlanwidget,
    separator,
    battwidget
})
topstatusbar.screen = 1
-- }}}


---------------------------------------------------------------------------
-- {{{ Taskbar
taskbar = {}
taskbar = statusbar({ position = "bottom", height = 14, name = "taskbar", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
taskbar:widgets({
    layoutbox,
    promptbox,
    tasklist,
    space,
    volumewidget,
    space,
    datewidget,
    separator,
    pacwidget,
    separator,
    systray
})
taskbar.screen = 1
-- }}}


---------------------------------------------------------------------------
-- {{{ Mouse bindings
awesome.mouse_add(mouse({ }, 3, function () awful.spawn(terminal) end))
awesome.mouse_add(mouse({ }, 4, awful.tag.viewnext))
awesome.mouse_add(mouse({ }, 5, awful.tag.viewprev))
-- }}}


---------------------------------------------------------------------------
-- {{{ Key bindings
-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.movetotag(tags[sel.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.toggletag(tags[sel.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "Return", function () awful.spawn(terminal) end):add()
keybinding({ modkey }, "e", function () awful.spawn("emesene") end):add()
keybinding({ modkey }, "f", function () awful.spawn("swiftweasel") end):add()
keybinding({ modkey }, "g", function () awful.spawn("geany") end):add()
keybinding({ modkey }, "p", function () awful.spawn("pcmanfm") end):add()
keybinding({ modkey, "Control" }, "r", awesome.restart):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ modkey, "Shift" }, "c", function () client.focus_get():kill() end):add()
keybinding({ modkey }, "j", function () awful.client.focus(1); client.focus_get():raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focus(-1);  client.focus_get():raise() end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () client.focus_get():swap(awful.client.master()) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
    awful.prompt.run({ prompt = "Run: " }, promptbox, awful.spawn, awful.completion.bash,
os.getenv("HOME") .. "/.cache/awesome/history") end):add()
keybinding({ modkey }, "F4", function ()
    awful.prompt.run({ prompt = "Run Lua code: " }, promptbox, awful.eval, awful.prompt.bash,
os.getenv("HOME") .. "/.cache/awesome/history_eval") end):add()
keybinding({ modkey, "Ctrl" }, "i", function ()
    if mypromptbox.text then
        mypromptbox.text = nil
    else
        mypromptbox.text = nil
        if client.focus.class then
            mypromptbox.text = "Class: " .. client.focus.class .. " "
        end
        if client.focus.instance then
            mypromptbox.text = mypromptbox.text .. "Instance: ".. client.focus.instance .. " "
        end
        if client.focus.role then
            mypromptbox.text = mypromptbox.text .. "Role: ".. client.focus.role
        end
    end
end):add()

--- Tabulous, tab manipulation
keybinding({ modkey, "Control" }, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)

    if not tabbedview then
        tabbedview = tabulous.tabindex_get(nextclient)

        if not tabbedview then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus_get())
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end):add()

keybinding({ modkey, "Shift" }, "y", tabulous.untab):add()

keybinding({ modkey }, "y", function ()
   local tabbedview = tabulous.tabindex_get()

   if tabbedview then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()
keybinding({ modkey, 'Shift' }, "t", function ()
    local tabbedview = tabulous.tabindex_get()
    local clients = awful.client.getmarked()

    if not tabbedview then
        tabbedview = tabulous.tab_create(clients[1])
        table.remove(clients, 1)
    end

    for k,c in pairs(clients) do
        tabulous.tab(tabbedview, c)
    end

end):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
        function ()
            local screen = mouse.screen
            if tags[screen][i] then
                for k, c in pairs(awful.client.getmarked()) do
                    awful.client.movetotag(tags[screen][i], c)
                end
            end
    end):add()
end
-- }}}


---------------------------------------------------------------------------
-- {{{ Hooks
-- Hook function to execute when focusing a client.
function hook_focus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end

-- Hook function to execute when unfocusing a client.
function hook_unfocus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end

-- Hook function to execute when marking a client
function hook_marked(c)
    c.border_color = beautiful.border_marked
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c.border_color = beautiful.border_focus
end

-- Hook function to execute when the mouse is over a client.
function hook_mouseover(c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier" then
        c:focus_set()
    end
end

-- Hook function to execute when a new client appears.
function hook_manage(c)
    -- Set floating placement to be smart!
    c.floating_placement = "smart"
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:mouse_add(mouse({ }, 1, function (c) c:focus_set(); c:raise() end))
    c:mouse_add(mouse({ modkey }, 1, function (c) c:mouse_move() end))
    c:mouse_add(mouse({ modkey }, 3, function (c) c:mouse_resize() end))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    c:focus_set()

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
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

    -- Honor size hints
    c.honorsizehints = false
end

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    layoutbox.text =
        "<bg image=\"/usr/share/awesome/icons/layouts/" .. awful.layout.get(screen) .. "w.png\" resize=\"true\"/>"

    -- If no window has focus, give focus to the latest in history
    if not client.focus_get() then
        local c = awful.client.focus.history.get(screen, 0)
        if c then c:focus_set() end
    end

    -- Uncomment if you want mouse warping
    --[[
    local sel = client.focus_get()
    if sel then
        local c_c = sel.coords
        local m_c = mouse.coords

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords = { x = c_c.x + 5, y = c_c.y + 5}
            end
        end
    end
    ]]
end

-- Set up some hooks
awful.hooks.focus.register(hook_focus)
awful.hooks.unfocus.register(hook_unfocus)
awful.hooks.marked.register(hook_marked)
awful.hooks.unmarked.register(hook_unmarked)
awful.hooks.manage.register(hook_manage)
awful.hooks.mouseover.register(hook_mouseover)
awful.hooks.arrange.register(hook_arrange)
-- }}}
