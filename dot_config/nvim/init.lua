-- set leader key to space
vim.g.mapleader = " "

-- bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("downloading lazy.nvim")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- set lines to automatically wrap at 120 characters
vim.opt.wrap = true
vim.opt.textwidth = 120

-- bind for toggling nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

-- binds for cycling through buffers
vim.keymap.set("n", "<Tab>", ":bnext<cr>")
vim.keymap.set("n", "<S-Tab>", ":bprev<cr>")

-- set tabs to 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- enable line numbers
vim.opt.number = true

-- shell specific configs
local shell_group = vim.api.nvim_create_augroup('Shell', { clear = true })

-- sets the filetype for bash files that don't have the .sh extension
vim.api.nvim_create_autocmd(
  { 'BufRead', 'BufNewFile' },
  {
    pattern = { '.bashrc', '.profile', '.bash_profile' },
    group = shell_group,
    command = 'set filetype sh'
  }
)
