local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"
config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Brewer (base16)"
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 13
config.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}
config.default_domain = "WSL:Ubuntu-24.04"

config.term = "xterm-256color"
config.scrollback_lines = 10000

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "r", mods = "LEADER", action = wezterm.action.ReloadConfiguration },
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "w", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "W",
		mods = "LEADER|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new workspace name",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{ key = "[", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(-1) },
	{ key = "]", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(1) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
	},
}

return config
