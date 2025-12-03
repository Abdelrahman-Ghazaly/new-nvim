return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
      'markdown', 'markdown_inline', 'query',
      'vim', 'vimdoc', 'dart', -- optional
    },

    auto_install = true,

    highlight = {
      enable = true,
      disable = function(lang, buf)
        if lang == "dart" then
          return false -- keep highlighting enabled
        end

        local max_filesize = 200 * 1024 -- 200 KB safer for larger Dart files
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },

    -- Dart specific performance tweaks
    indent = {
      enable = true,
      disable = { "dart" }, -- Treesitter indent for Dart is slow
    },

    incremental_selection = {
      enable = true,
      disable = { "dart" }, -- known to lag
    },

    textobjects = {
      disable = { "dart" }, -- you already set this
    },
  },
}
