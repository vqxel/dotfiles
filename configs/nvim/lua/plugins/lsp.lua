return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- 1. Set up your custom verible arguments
      vim.lsp.config('verible', {
        cmd = { 'verible-verilog-ls', '--rules_config_search' },
      })

      -- 2. Set up format-on-save
      local format_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", { -- Use BufWritePre
        group = format_group,
        pattern = { "*.v", "*.sv" }, -- Target Verilog and SystemVerilog
        callback = function()
          vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        end,
      })
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "verible", "lua_ls" },
      automatic_enable = true,
    },
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
