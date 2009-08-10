-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = "/usr/share/awesome/themes/default/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Used later for various things
net_device = "wlan0"
spacertext = " "
spacerwidth = "4"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["pcalendar"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Firefox"] = { screen = 1, tag = 2 },
    ["Gran Paradiso"] = { screen = 1, tag = 2 },
    ["Thunderbird"] = { screen = 1, tag = 4 },
    ["Spicebird"] = { screen = 1, tag = 4}
    -- ["mocp"] = { screen = 2, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[1], tags[s][tagnumber])
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}

-- {{{ Wibox
-- My custom stuff first
tempwidget       = widget({ type = 'textbox'    , align = 'right' })
tempwidget.text = "0C"

mhzwidget        = widget({ type = 'textbox'    , align = 'right' })
mhzwidget.text = "0Mhz"

bandwidthwidget  = widget({ type = 'textbox'    , align = "right" })
bandwidthwidget.text = "0D | 0U"

ratewidget       = widget({ type = 'textbox'    , align = 'right' })
ratewidget.text = "0Mb/s"

essidwidget      = widget({ type = 'textbox'    , align = 'right' })
essidwidget.text = "Not-Associated"

lqwidget        = widget({ type = 'progressbar' , align = 'right' })
lqwidget.width          = 12
lqwidget.height         = 1
lqwidget.gap            = 0
lqwidget.border_padding = 1
lqwidget.border_width   = 1
lqwidget.ticks_count    = 5
lqwidget.ticks_gap      = 1
lqwidget.vertical       = true
lqwidget:bar_properties_set('lq', {
  fg        = 'green',
  fg_off    = 'gray20',
  reverse   = false,
  min_value = 0,
  max_value = 100
})

batterywidget   = widget({ type = 'progressbar', align = 'right' })
batterywidget.width          = 50
batterywidget.height         = .9
batterywidget.gap            = 1
batterywidget.border_padding = 0
batterywidget.border_width   = 1
batterywidget.ticks_count    = 10
batterywidget.ticks_gap      = 1
batterywidget.vertical       = false
batterywidget:bar_properties_set('bat', {
  fg        = 'green',
  fg_off    = 'red',
  reverse   = false,
  min_value = 0,
  max_value = 100
})

cpu0graphwidget = widget({ type = 'graph'      , align = 'right' })
cpu0graphwidget.height = 0.95
cpu0graphwidget.width = 45
cpu0graphwidget.border_color = 'gray80'
cpu0graphwidget.grow = 'left'
cpu0graphwidget:plot_properties_set('cpu', {
  fg = 'red',
  style ='line',
  fg_center = 'green',
  fg_end = 'cyan',
  vertical_gradient = false
})

membarwidget                = widget({ type = 'progressbar'   , align = 'right' })
membarwidget.width          = 10
membarwidget.height         = 1
membarwidget.gap            = 0
membarwidget.border_padding = 1
membarwidget.border_width   = 1
membarwidget.ticks_count    = 0
membarwidget.ticks_gap      = 0
membarwidget.vertical       = true
membarwidget:bar_properties_set('mem', {
  fg        = 'red',
  fg_center = 'red2',
  fg_end    = 'red3',
  fg_off    = 'black',
  reverse   = false,
  min_value = 0,
  max_value = 100
})

spacerwidget       = widget({ type = 'textbox', align = 'right' })
spacerwidget.width = spacerwidth
spacerwidget.text  = spacertext

-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. os.date("%a %b %d, %I:%M") .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c)
                                          if not c:isvisible() then
                                              awful.tag.viewonly(c:tags()[1])
                                          end
                                          client.focus = c
                                          c:raise()
                                      end),
                       button({ }, 3, function () if instance then instance:hide() end instance = awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function ()
                                          awful.client.focus.byidx(1)
                                          if client.focus then client.focus:raise() end
                                      end),
                       button({ }, 5, function ()
                                          awful.client.focus.byidx(-1)
                                          if client.focus then client.focus:raise() end
                                      end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { --mylauncher,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s],
                           essidwidget,
                           spacerwidget,
                           ratewidget,
                           lqwidget,
                           bandwidthwidget,
                           cpu0graphwidget,
                           membarwidget,
                           batterywidget,
                           mytextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings
globalkeys =
{
    key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    key({ modkey,           }, "Escape", awful.tag.history.restore),

    key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    key({ modkey, "Control" }, "Right", function () awful.screen.focus( 1)       end),
    key({ modkey, "Control" }, "Left", function () awful.screen.focus(-1)       end),
    key({ modkey,           }, "u", awful.client.urgent.jumpto),

    key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    key({ modkey, "Control" }, "r", awesome.restart),
    key({ modkey, "Shift"   }, "q", awesome.quit),

    key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    key({ modkey }, "F1",
        function ()
            awful.prompt.run({ prompt = "Run: " },
            mypromptbox[mouse.screen],
            awful.util.spawn, awful.completion.shell,
            awful.util.getdir("cache") .. "/history")
        end),

    key({ modkey }, "F4",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen],
            awful.util.eval, awful.prompt.bash,
            awful.util.getdir("cache") .. "/history_eval")
        end),
}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    key({ modkey }, "t", awful.client.togglemarked),
    key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
}

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys,
        key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end


for i = 1, keynumber do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
                 function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
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

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute
awful.hooks.timer.register(60, function ()
    mytextbox.text = "<b><small>"..os.date("%a %b %d, %I:%M").."</small></b>"
end)
-- }}}

-- {{ Custom functions
function splitbywhitespace(str)
  values = {}
  start = 1
  splitstart, splitend = string.find(str, ' ', start)
  while splitstart do
    m = string.sub(str, start, splitstart-1)
    if m:gsub(' ','') ~= '' then
      table.insert(values, m)
    end
    start = splitend+1
    splitstart, splitend = string.find(str, ' ', start)
  end
  m = string.sub(str, start)
  if m:gsub(' ','') ~= '' then
    table.insert(values, m)
  end
  return values
end

net_infos = {
  interfaces = {'eth0', 'wlan0'},
  eth0 = {
    status = 'down',
    bytes_up = 0,
    bytes_down = 0,
    rate_up = 0,
    rate_down = 0
  },
  wlan0 = {
    status = 'down',
    bytes_up = 0,
    bytes_down = 0,
    rate_up = 0,
    rate_down = 0
  },
}

function get_bw()
  local time_interval_s = 1
  local c_proc_net_dev = ''
  local proc_net_dev = io.open( '/proc/net/dev' )
  if proc_net_dev ~= nil then
    c_proc_net_dev = proc_net_dev:read( '*all' )
    proc_net_dev:close()
  end
  for nd = 1, #net_infos[ 'interfaces' ]  do
    local f = io.open('/sys/class/net/' .. net_infos[ 'interfaces' ][ nd ] .. '/operstate')
    net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'status' ] = 'down'
    if f ~= nil then
      net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'status' ] = string.match( f:read(), 'down' )
      f:close()
    end
    if c_proc_net_dev ~= '' then
      local current_bytes_up = 0
      local current_bytes_down = 0
      current_bytes_down, current_bytes_up = string.match( c_proc_net_dev, net_infos[ 'interfaces' ][ nd ] .. ':%s*(%d+)%s*%d+%s*%d+%s*%d+%s*%d+%s*%d+%s*%d+%s*%d+%s*(%d+)' )
      net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'rate_up' ] = ( current_bytes_up - net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'bytes_up' ] ) / time_interval_s
      net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'rate_down' ] = ( current_bytes_down - net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'bytes_down' ] ) / time_interval_s
      net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'bytes_up' ] = current_bytes_up
      net_infos[ net_infos[ 'interfaces' ][ nd ] ][ 'bytes_down' ] = current_bytes_down
    end
  end
  rx = string.format( '%.2f', net_infos[ net_device ][ 'rate_down' ] / 1024 ) 
  tx = string.format( '%.2f', net_infos[ net_device ][ 'rate_up' ] / 1024 ) 
  bandwidthwidget.text = "<small>"..rx.."D | "..tx.."U</small>"
end

cpu0_total  = 0
cpu0_active = 0

function get_cpu()
  local f = io.open('/proc/stat')
  for l in f:lines() do
    cpu_usage = splitbywhitespace(l)
    if      cpu_usage[1] == "cpu0" then
      total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
      active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
      diff_total    = total_new-cpu0_total
      diff_active   = active_new-cpu0_active
      usage_percent = math.floor(diff_active/diff_total*100)
      cpu0_total    = total_new
      cpu0_active   = active_new
      cpu0graphwidget:plot_data_add("cpu",usage_percent)
    elseif cpu_usage[1] == "cpu1" then
      total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
      active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
      diff_total    = total_new-cpu1_total
      diff_active   = active_new-cpu1_active
      usage_percent = math.floor(diff_active/diff_total*100)
      cpu1_total    = total_new
      cpu1_active   = active_new
      cpu1graphwidget:plot_data_add("cpu",usage_percent)
    end
  end
  f:close()
end

function get_mem()
  local mem_free, mem_total, mem_c, mem_b
  local mem_percent, swap_percent, line, f, count
  count = 0
  f = io.open("/proc/meminfo")
  line = f:read()
  while line and count < 4 do
    if line:match("MemFree:") then
      mem_free = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("MemTotal:") then
      mem_total = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("Cached:") then
      mem_c = string.match(line, "%d+")
      count = count + 1;
    elseif line:match("Buffers:") then
      mem_b = string.match(line, "%d+")
      count = count + 1;
    end
    line = f:read()
  end
  io.close(f)
  mem_percent = 100 * (mem_total - mem_free - mem_b - mem_c ) / mem_total;
  membarwidget:bar_data_add("mem",mem_percent)
end

function get_mhz()
  local f = io.open("/proc/cpuinfo")
  local line = f:read()
  while line do
    if line:match("cpu MHz") then
      mhz = string.match(line, "%d+")
    end
    line = f:read()
  end
  io.close(f)
  mhzwidget.text ="<small>"..mhz.."Mhz</small>"
end

function get_iwinfo_iwcfg()
  local f1 = io.popen("iwconfig " .. net_device)
  if not f1 then
    return
  else
    local iwOut = f1:read('*a')
    f1:close()
    st,en,proto = string.find(iwOut, '(802.11[%-]*%a*)')
    st,en,ssid = string.find(iwOut, 'ESSID[=:]"(.-)"', en)
    st,en,bitrate = string.find(iwOut, 'Bit Rate[=:]([%s%w%.]*%/%a+)', en)
    if (bitrate) then bitrate = string.gsub(bitrate, "%s", "") end
    st,en,linkq1,linkq2 = string.find(iwOut, 'Link Quality[=:](%d+)/(%d+)', en)
    st,en,signal = string.find(iwOut, 'Signal level[=:](%-%d+)', en)
    st,en,noise = string.find(iwOut, 'Noise level[=:](%-%d+)', en)
    if (linkq1 and linkq2) then linkq = math.floor(100*linkq1/linkq2) end
    return proto, ssid, bitrate, linkq, signal, noise
  end
end

function get_iwinfo()
  local proto, ssid, bitrate, linkq, signal, noise = get_iwinfo_iwcfg()
  ssid = ssid or "N/A"
  bitrate = bitrate or "N/A"
  --linkq = linkq or "N/A"
  signal = signal or "N/A"
  noise = noise or "N/A"
  proto = proto or "N/A"
  essidwidget.text = "<small>"..ssid.."</small>"
  ratewidget.text = bitrate
  if (linkq) then lqwidget:bar_data_add("lq",linkq ) end
end

function get_bat()
  local a = io.open("/sys/class/power_supply/BAT1/charge_full")
  for line in a:lines() do
    full = line
  end
  a:close()
  local b = io.open("/sys/class/power_supply/BAT1/charge_now")
  for line in b:lines() do
    now = line
  end
  b:close()
  batt=math.floor(now*100/full)
  batterywidget:bar_data_add("bat",batt )
end

function hook_1sec ()
  get_mhz()
  get_cpu()
  get_bw()  
end

function hook_5sec ()
  get_mem()
  get_bat()
  --    get_temp()
  get_iwinfo()
end

awful.hooks.timer.register(1, hook_1sec)
awful.hooks.timer.register(5, hook_5sec)

-- }}}
