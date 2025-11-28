local M = {}

function M.setup()
  -- set leader early so remaps can rely on it
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- disable some builtin providers for speed
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_python3_provider = 0

  require("config.core.options")
  require("config.core.remaps")
  require("config.core.custom")
end

return M
