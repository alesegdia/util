local lfs = require "lfs"

-- get all images in a path (there should be only images in this path)
wp_files = {}
wp_path = "/EDIT/THIS/PATH/"

for file in lfs.dir(wp_path) do
  if file:sub(1,1) ~= '.' then
	table.insert(wp_files,file)
  end
end

wp_index = 1
wp_timeout  = 600
 
-- setup the timer
wp_timer = timer { timeout = 5 }
wp_timer:connect_signal("timeout", function()
 
  -- set wallpaper to current index for all screens
  for s = 1, screen.count() do
    gears.wallpaper.maximized(wp_path .. wp_files[wp_index], s, true)
  end
 
  -- stop the timer (we don't need multiple instances running at the same time)
  wp_timer:stop()
 
  -- get next random index
  wp_index = math.random( 1, #wp_files)
 
  --restart the timer
  wp_timer.timeout = wp_timeout
  wp_timer:start()
end)
 
-- initial start when rc.lua is first run
wp_timer:start()


-- use this to bind manual cycle to a key (bound now to modkey + F12)
globalkeys = awful.util.table.join( globalkeys,
  awful.key( { modkey }, "F12", function() wp_timer:emit_signal("timeout") end ))
root.keys(globalkeys)

