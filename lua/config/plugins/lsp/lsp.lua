return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
    { "folke/snacks.nvim",                   lazy = false },
  },

  config = function()
    require("blink.cmp")
    local snacks = require("snacks")

    ----------------------------------------------------------------------
    -- KEYMAPS (inside LspAttach)
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
          return
        end

        -- Autoformatting
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = ev.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
            end,
          })
        end

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end

        ------------------------------------------------------------------
        -- KEYMAPS (snacks.nvim version)
        ------------------------------------------------------------------

        -- Jumps
        map("n", "gd", function()
          snacks.picker.lsp_definitions()
        end, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gR", function()
          snacks.picker.lsp_references()
        end, "Go to references")
        map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "<leader>D", function()
          snacks.picker.lsp_type_definitions()
        end, "Type definition")

        -- Symbols
        map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
        map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")

        -- Actions
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

        -- Hover + Signature help
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>si", vim.lsp.buf.signature_help, "Signature help")

        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<leader>ed", function()
          snacks.picker.diagnostics({ bufnr = 0 })
        end, "Show buffer diagnostics")
        map("n", "<leader>q", function()
          snacks.picker.diagnostics()
        end, "Show all diagnostics")

        -- Tools
        map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")
      end,
    })

    ----------------------------------------------------------------------
    -- CAPABILITIES
    ----------------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

    ----------------------------------------------------------------------
    -- DIAGNOSTICS
    ----------------------------------------------------------------------
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    ----------------------------------------------------------------------
    -- DEFAULT LSP CONFIG (new API)
    ----------------------------------------------------------------------
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    ----------------------------------------------------------------------
    -- LUA SERVER (neodev aware)
    ----------------------------------------------------------------------
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = { checkThirdParty = false },
        },
      },
    })
  end,
}
