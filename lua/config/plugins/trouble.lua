return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Default settings
    auto_open = false, -- don't open automatically
    auto_close = false,
    use_diagnostic_signs = true,

    -- Customize how modes behave
    modes = {
      diagnostics = {
        -- group results by file (VSCode-like)
        groups = {
          { "filename", format = "{file_icon} {filename}" },
        },

        -- sort by severity (Errors → Warnings → Info → Hints)
        sort = { "severity", "pos" },
      },
    },
  },

  keys = function()
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    -- Main Problems Panel
    map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", opts)

    -- Filters (VSCode-like)
    map("n", "<leader>xe", "<cmd>Trouble diagnostics toggle severity=error<cr>", opts)
    map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle severity=warn<cr>", opts)
    map("n", "<leader>xi", "<cmd>Trouble diagnostics toggle severity=info<cr>", opts)
    map("n", "<leader>xh", "<cmd>Trouble diagnostics toggle severity=hint<cr>", opts)

    -- Quickfix / Location list
    map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", opts)
    map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", opts)
  end,
}
