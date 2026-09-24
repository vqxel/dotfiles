return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    completion = {
      list = {
        selection = {
          -- preselect = true automatically highlights the first item in the popup menu
          preselect = true,
          -- auto_insert = false ensures it doesn't modify your text until you press Tab
          auto_insert = false,
        }
      }
    },

    keymap = {
      preset = 'enter', -- Disables default C-n/C-p mappings
--      ['C-n'] = { 'select_next', 'snippet_forward', 'fallback' },
--      ['C-s'] = { 'select_prev', 'snippet_backward', 'fallback' },
--      ['<Tab>'] = { 'accept', 'fallback' },
--      ['<C-a>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
