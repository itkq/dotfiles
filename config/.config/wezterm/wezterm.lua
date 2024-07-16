-- https://github.com/itkq/config/blob/deb4e805bc349a95aeaee86d0f5054ef9b29e031/config/.config/wezterm/wezterm.lua

local wezterm = require("wezterm")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.color_scheme = "Night Owl (Gogh)"
config.font = wezterm.font("Ocami")
config.font_size = 12.0

config.window_background_opacity = 0.93
config.scrollback_lines = 350000
config.enable_scroll_bar = true
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400
config.exit_behavior = "CloseOnCleanExit"

config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }
local act = wezterm.action
config.keys = {
	--- tmux-like config ---
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "|",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "t",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Next"),
	},
	{
		key = "p",
		mods = "ALT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "ALT",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "s",
		mods = "LEADER",
		-- https://zenn.dev/sankantsu/articles/e713d52825dbbb
		action = wezterm.action_callback(function(win, pane)
			local workspaces = {}
			for i, name in ipairs(wezterm.mux.get_workspace_names()) do
				table.insert(workspaces, {
					id = name,
					label = string.format("%d. %s", i, name),
				})
			end
			win:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(_, _, id, label)
						if not id and not label then
							wezterm.log_info("Workspace selection canceled")
						else
							win:perform_action(act.SwitchToWorkspace({ name = id }), pane)
						end
					end),
					title = "Select workspace",
					choices = workspaces,
					fuzzy = true,
				}),
				pane
			)
		end),
	},
	--- tmux config ---
}

-- https://github.com/wez/wezterm/issues/2979#issuecomment-1447519267
local hacky_user_commands = {
	["set-workspace-title"] = function(window, pane, cmd_context)
		wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), cmd_context.title)
	end,

	["attach-workspace"] = function(window, pane, cmd_context)
		window:perform_action(
			act.SwitchToWorkspace({
				name = cmd_context.title,
			}),
			pane
		)
	end,
}
wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "hacky-user-command" then
		local cmd_context = wezterm.json_parse(value)
		hacky_user_commands[cmd_context.cmd](window, pane, cmd_context)
		return
	end
end)

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	table.insert(cells, wezterm.mux.get_active_workspace())

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
	end

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		"#3c1361",
		"#52307c",
		"#663a82",
		"#7c5295",
		"#b491c8",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#c0c0c0"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

-- and finally, return the configuration to wezterm
return config
