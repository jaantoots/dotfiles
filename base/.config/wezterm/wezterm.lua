local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Default Dark (base16)'

config.keys = {
  {
    key = 't',
    mods = 'SHIFT|SUPER',
    action = wezterm.action.SpawnCommandInNewTab {
      domain = 'DefaultDomain',
      cwd = wezterm.home_dir,
    },
  },
}

return config
