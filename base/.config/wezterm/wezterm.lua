local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night"

config.keys = {
	{
		key = "t",
		mods = "SHIFT|SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			domain = "DefaultDomain",
			cwd = wezterm.home_dir,
		}),
	},
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wezterm/wezterm | "wezterm/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[["]?(pactum-ai)(/){1}([-\w\d\.]+)["]?]],
	format = "https://www.github.com/$1/$3",
})

return config
