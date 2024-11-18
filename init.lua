-- Initialize Lazy.nvim
require("lazy").setup({
  -- Plugin Manager
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
  { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }, -- Fuzzy finder
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Correct hook for lazy.nvim
  },
  { "hrsh7th/nvim-cmp" }, -- Autocompletion plugin
  { "hrsh7th/cmp-nvim-lsp" }, -- LSP source for nvim-cmp
  { "neovim/nvim-lspconfig" }, -- Quickstart configurations for Nvim LSP
  { "kyazdani42/nvim-web-devicons"},
  { "nvim-lualine/lualine.nvim", requires = { "nvim-web-devicons" } }, -- Status line
  { "kyazdani42/nvim-tree.lua"}, -- File explorer
  { "windwp/nvim-autopairs" }, -- Auto close pairs
  { "nvim-orgmode/orgmode" }, -- Org mode support
  { "dracula/vim", as = "dracula" }, -- Dracula color scheme
  { "aserowy/tmux.nvim" },
  { "preservim/nerdcommenter" },
  {
    'mitchpaulus/autocorrect.vim',
    config = function()
        require('autocorrect_setup').setup()
    end
  },
})

-- Set wrapping (important)
vim.cmd("set linebreak")

-- Set the color scheme
vim.cmd("colorscheme dracula")

-- Basic settings
vim.o.number = true                  -- Show line numbers
vim.o.relativenumber = false          -- Relative line numbers
vim.o.expandtab = true               -- Use spaces instead of tabs
vim.o.shiftwidth = 4                  -- Shift 4 spaces when tab
vim.o.tabstop = 4                     -- Number of spaces tabs count for
vim.o.smartindent = true              -- Smart indentation

-- Configure tmux
local tmux = require("tmux")
tmux.setup()

-- Configure LSP
local lspconfig = require("lspconfig")
lspconfig.pyright.setup{}  -- Example for Python


-- Setup completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
})

-- Configure Telescope
local telescope = require("telescope")
telescope.setup{}

-- Configure Lualine
require('lualine').setup{
  options = {
    theme = 'dracula', -- Set the lualine theme to Dracula
    section_separators = '',
    component_separators = ''
  }
}

-- Configure Nvim Tree
require("nvim-tree").setup()
vim.cmd("split | term")
vim.cmd("wincmd J")
vim.cmd("wincmd k")
vim.cmd("wincmd j")
vim.cmd("NvimTreeOpen")
vim.cmd("NvimTreeResize 10")
vim.cmd [[
  augroup FocusTopRightPane
    autocmd!
    autocmd VimEnter * wincmd l " Move focus to the right pane
    autocmd VimEnter * resize 100
  augroup END
]]

-- Configure Autopairs
require('nvim-autopairs').setup{}

-- Additional key mappings can go here
local nvimrc = vim.fn.stdpath('config')
vim.cmd('source ' .. nvimrc .. '/nvimrc.vim')

vim.lsp.set_log_level("debug")
-- add typescript for treesitter
require'lspconfig'.ts_ls.setup{
  --root_dir = function(fname)
    ---- Set the root directory based on the presence of tsconfig.json, jsconfig.json, or .git
    --return vim.fn.expand('~/.config/nvim/typescript-config')  -- Fallback to the global config path
  --end,
  root_dir = function(fname)
    -- Check for tsconfig.json, jsconfig.json, or .git in the current directory
    local root_pattern = require'lspconfig'.util.root_pattern("tsconfig.json", "jsconfig.json", ".git")
    local root = root_pattern(fname)
    if root then
      return root
    end
    -- Fallback to the global config path
    return vim.fn.expand('~/.config/nvim/typescript-config')
  end,
  init_options = {
    preferences = {
      importModuleSpecifierPreference = 'relative', -- Other preferences can be added here
    }
  },
  on_attach = function(client, bufnr)
    -- Add your custom LSP mappings here, for example:
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  end
}
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true, -- Ensure it's enabled
  },
  ensure_installed = { "xml", "javascript", "python" },
}
vim.diagnostic.config({
  virtual_text = true, -- Show diagnostic messages inline
  signs = true,        -- Show signs in the gutter
  update_in_insert = true, -- Update diagnostics while typing
  underline = true,    -- Underline diagnostic issues
  severity_sort = true -- Sort diagnostics by severity
})


local map = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }

local modes = {'n', 'v'} -- normal and visual mode

for i in pairs(modes) do
        map(modes[i], '<C-_>', ':call nerdcommenter#Comment(0, "toggle")<CR>' , opts)
end

-- Function to indent selected lines
local function indent_selected_lines()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  for line = start_line, end_line do
    local current_line = vim.fn.getline(line)
    vim.fn.setline(line, "  " .. current_line) -- Adds two spaces to the beginning of the line
  end
end

-- Define a command for the function
vim.api.nvim_create_user_command('IndentSelected', indent_selected_lines, { range = true })

-- Keybind for visual mode and visual insert mode
vim.api.nvim_set_keymap('x', '<Tab>', ':IndentSelected<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Tab>', '<C-o>:IndentSelected<CR>', { noremap = true, silent = true })

-- Keybind for undo in normal mode
vim.api.nvim_set_keymap('n', '<C-z>', 'u', { noremap = true, silent = true })

-- Keybind for undo in insert mode
vim.api.nvim_set_keymap('i', '<C-z>', '<C-o>u', { noremap = true, silent = true })

-- Keybind for undo in normal mode
vim.api.nvim_set_keymap('n', '<C-y>', '<C-r>', { noremap = true, silent = true })

-- Keybind for undo in insert mode
vim.api.nvim_set_keymap('i', '<C-y>', '<C-o><C-r>', { noremap = true, silent = true })


