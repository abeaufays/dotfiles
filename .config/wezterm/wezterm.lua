-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")

-- Load local config if it exists (machine-specific settings)
local ok, local_config = pcall(require, "local")
if ok and local_config then
  local_config(config)
end

-- Finally, return the configuration to wezterm:
return config
