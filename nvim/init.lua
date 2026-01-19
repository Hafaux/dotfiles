-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 20

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Mouse support
vim.opt.mouse = "a"

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-----------------------------------------------------------
-- Colorscheme & transparency
-----------------------------------------------------------
---
vim.cmd.colorscheme("habamax")

-- Make background transparent 
vim.cmd [[
  hi Normal guibg=none ctermbg=none
  hi NormalFloat guibg=none ctermbg=none
  hi SignColumn guibg=none ctermbg=none
  hi LineNr guibg=none ctermbg=none
  hi EndOfBuffer guibg=none ctermbg=none
]]

-- Optional: make popups slightly transparent
vim.opt.winblend = 20
vim.opt.pumblend = 20

-----------------------------------------------------------
-- Keymaps
-----------------------------------------------------------
vim.g.mapleader = " "  -- Space as leader key
local map = vim.keymap.set

-- Easier window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Quickly save & quit
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")

vim.opt.timeoutlen = 300  -- milliseconds (default is 1000)

vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk", noremap = true })
vim.keymap.set("n", "<leader>i", "%", { desc = "Jump to matching bracket" })

vim.keymap.set("n", "<leader>e", ":Ex %:p:h<CR>", { desc = "Explore current file's folder" })

-- netrw
vim.g.netrw_banner = 0       -- Hide banner
vim.g.netrw_liststyle = 3    -- Tree-style view
vim.g.netrw_browse_split = 0 -- Open in same window
vim.g.netrw_winsize = 25     -- Explorer width
vim.g.netrw_altv = 1         -- Open splits to the right

