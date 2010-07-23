-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widgets
--require("vicious")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(".config/awesome/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtcd"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
--------------
-- These should be in a table
--cpuvals = {}
--cpugraphs = {}
--get_cpu()

cpu0graphwidget = awful.widget.graph()
cpu0graphwidget:set_width(30)
cpu0graphwidget:set_height(18)
cpu0graphwidget:set_max_value(100)
cpu0graphwidget:set_background_color(beautiful.bg_normal)
cpu0graphwidget:set_border_color(beautiful.border_normal)
cpu0graphwidget:set_color(beautiful.fg_color)
cpu0graphwidget:set_gradient_colors({"red", "orange", "yellow", red = 4, orange = 3})
cpu0graphwidget:set_gradient_angle(50)

cpu1graphwidget = awful.widget.graph()
cpu1graphwidget:set_width(30)
cpu1graphwidget:set_height(18)
cpu1graphwidget:set_max_value(100)
cpu1graphwidget:set_background_color(beautiful.bg_normal)
cpu1graphwidget:set_border_color(beautiful.border_normal)
cpu1graphwidget:set_color(beautiful.fg_color)
cpu1graphwidget:set_gradient_colors({"red", "orange", "yellow", red = 2, orange = 3})
cpu1graphwidget:set_gradient_angle(30)

cpu2graphwidget = awful.widget.graph()
cpu2graphwidget:set_width(30)
cpu2graphwidget:set_height(18)
cpu2graphwidget:set_max_value(100)
cpu2graphwidget:set_background_color(beautiful.bg_normal)
cpu2graphwidget:set_border_color(beautiful.border_normal)
cpu2graphwidget:set_color(beautiful.fg_color)
cpu2graphwidget:set_gradient_colors({"red", "orange", "yellow", red = 2, orange = 3})
cpu2graphwidget:set_gradient_angle(-30)

cpu3graphwidget = awful.widget.graph()
cpu3graphwidget:set_width(30)
cpu3graphwidget:set_height(18)
cpu3graphwidget:set_max_value(100)
cpu3graphwidget:set_background_color(beautiful.bg_normal)
cpu3graphwidget:set_border_color(beautiful.border_normal)
cpu3graphwidget:set_color(beautiful.fg_color)
cpu3graphwidget:set_gradient_colors({"red", "orange", "yellow", red = 4, orange = 3})
cpu3graphwidget:set_gradient_angle(-50)

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %a %b %d, %l:%M%p ")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mylauncher,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        mylayoutbox[s],
        mytextclock,

        cpu0graphwidget.widget,
        cpu1graphwidget.widget,
        cpu2graphwidget.widget,
        cpu3graphwidget.widget,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "x", function () awful.util.spawn('slock') end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Multimedia keys
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 2dB-") end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 2dB+") end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({}, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
    awful.key({}, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    awful.key({}, "XF86AudioPlay", function () awful.util.spawn("mpc stop") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "y",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({ modkey }, "t",
        function ()
            awful.util.spawn('sleep 180 ; notify-send -u critical "TEA TIME" "Go get your tea"')
        end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)


-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    -- And Chromium on 2 as well.
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][2] } },
    -- Do the same for gajim, on 9.
    { rule = { class = "Gajim.py" },
      properties = { tag = tags[1][9] } },
    { rule = { name = "nona" },
      properties = { tag = tags[1][8] } },
    -- Useful for Gajim, if I can work out how.
    --awful.tag.setproperty(tags[s][9], "mwfact", 0.13)
}
-- }}}

-- {{{ Custom functions
--cpu = {}
cpu0_total  = 0
cpu0_active = 0
cpu1_total  = 0
cpu1_active = 0
cpu2_total  = 0
cpu2_active = 0
cpu3_total  = 0
cpu3_active = 0

timer_1second = timer({ timeout = 1 })
timer_1second:add_signal("timeout", function() get_cpu() end)
timer_1second:start()

--[[ Obsoleted?
function splitbywhitespace(str) --stolen from wicked.lua
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
--]]

function splitbywhitespace(str)
    local t = {}
    local function helper(word) table.insert(t, word) return "" end
    if not str:gsub("%w+", helper):find"%S" then return t end
end

function get_cpu()
  local f = io.open('/proc/stat')
  local limit_break = 1
  for l in f:lines() do
    local cpu = string.match(l, 'cpu%d+')
    --[[ This isn't ready yet.
    if cpunum then
        if not cpu[cpunum] then
            cpu[cpunum] = { active=0, total=0 }
        else
            local cpu_usage = splitbywhitespace(l)
            total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
            active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
            diff_total    = total_new-cpu0_total
            diff_active   = active_new-cpu0_active
            usage_percent = math.floor(diff_active/diff_total*100)
            cpu0_total    = total_new
            cpu0_active   = active_new
            cpu0graphwidget:add_value(usage_percent)
            -- Widgets should be in a table, it seems. ANYTHING can go in a table. :D
      end
    end
    --]]
    if cpu == "cpu0" then
          local cpu_usage = splitbywhitespace(l)
          total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
          active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
          diff_total    = total_new-cpu0_total
          diff_active   = active_new-cpu0_active
          usage_percent = math.floor(diff_active/diff_total*100)
          cpu0_total    = total_new
          cpu0_active   = active_new
          cpu0graphwidget:add_value(usage_percent)
    elseif cpu == "cpu1" then
          local cpu_usage = splitbywhitespace(l)
          total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
          active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
          diff_total    = total_new-cpu1_total
          diff_active   = active_new-cpu1_active
          usage_percent = math.floor(diff_active/diff_total*100)
          cpu1_total    = total_new
          cpu1_active   = active_new
          cpu1graphwidget:add_value(usage_percent)
    elseif cpu == "cpu2" then
          local cpu_usage = splitbywhitespace(l)
          total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
          active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
          diff_total    = total_new-cpu2_total
          diff_active   = active_new-cpu2_active
          usage_percent = math.floor(diff_active/diff_total*100)
          cpu2_total    = total_new
          cpu2_active   = active_new
          cpu2graphwidget:add_value(usage_percent)
    elseif cpu == "cpu3" then
          local cpu_usage = splitbywhitespace(l)
          total_new     = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]+cpu_usage[5]
          active_new    = cpu_usage[2]+cpu_usage[3]+cpu_usage[4]
          diff_total    = total_new-cpu3_total
          diff_active   = active_new-cpu3_active
          usage_percent = math.floor(diff_active/diff_total*100)
          cpu3_total    = total_new
          cpu3_active   = active_new
          cpu3graphwidget:add_value(usage_percent)
      end
    end
  f:close()
end

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
