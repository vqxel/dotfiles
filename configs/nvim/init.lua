vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.number = true
vim.o.showmatch = true
vim.o.mouse = 'a' -- enable mouse for all modes
vim.o.hlsearch = true -- highlight search results
vim.o.autoindent = true -- auto-indent new lines
vim.o.wildmode = 'longest,list' -- bash-like tab completion
vim.o.clipboard = 'unnamedplus' -- use system clipboard
vim.o.ttyfast = true -- Speed up scrolling

-- Enable filetype detection, plugins, and indentation
vim.cmd('filetype plugin indent on')
-- Enable syntax highlighting
vim.cmd('syntax on')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.diagnostic.config({
    float = {
        source = 'always',  -- Show the source of the diagnostic (e.g., 'luacheck')
        header = '',
        prefix = ' ',
    }
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {
    desc = 'Show line diagnostics (LSP)',
    silent = true
})

local highlight_group = vim.api.nvim_create_augroup('FloatHighlights', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*', -- Run for every colorscheme
    group = highlight_group,
    callback = function()
        -- Link the float's background to your normal editor background
        vim.cmd('highlight link NormalFloat Normal')
        
        -- Link the float's border to your comment color (usually a subtle grey)
        vim.cmd('highlight link FloatBorder Comment')

        -- Add transparency settings from your vimscript
        -- This makes your editor background transparent
        vim.cmd('highlight NonText guibg=NONE ctermbg=NONE')
        vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
        vim.cmd('highlight NormalNC guibg=NONE ctermbg=NONE')
        vim.cmd('highlight SignColumn guibg=NONE ctermbg=NONE')
        vim.cmd('highlight Pmenu guibg=NONE ctermbg=NONE')
        vim.cmd('highlight TabLine guibg=NONE ctermbg=NONE')
    end
})

require("config.lazy")

vim.cmd.colorscheme "catppuccin-frappe"
