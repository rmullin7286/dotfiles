-- leader key is space
vim.g.mapleader = ' '

-- settings were recommended for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- bootstrap lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print('downloading lazy.nvim')
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- declare packages
require('lazy').setup({
  {
    -- sets up language server and code completion
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- setup required language servers
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls' }
      }

      local lsp = require('lsp-zero').preset({})
      lsp.on_attach(function(_, bufnr)
        lsp.default_keymaps({buffer=bufnr})
      end)

      -- setup lua language for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      -- setup autocomplete
      require('cmp').setup()
      lsp.setup()
    end
  },
  {
    -- auto complete parentheses, brackets, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}
  },
  {
    -- filetree
    "nvim-tree/nvim-tree.lua",
    config = function()
      require('nvim-tree').setup()
    end
  }
})

-- bind for toggling nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>')

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
  {'BufRead', 'BufNewFile'},
  { 
    pattern={'.bashrc', '.profile', '.bash_profile'}, 
    group=shell_group,
    command='set filetype sh'
  }
)

-- Automatically adds a shebang to the top of a shell file on creation
-- Also automatically makes the file executable on buffer write
vim.api.nvim_create_autocmd(
  'BufNewFile',
  {
    group = shell_group,
    pattern = "*",
    callback = function (opts)
      local ft = vim.filetype.match({ buf = opts.buf })
      if ft == 'sh' then
        vim.api.nvim_put({'#!/usr/bin/env sh', ''}, "", false, true)
        vim.api.nvim_create_autocmd(
          'BufWritePost',
          {
            buffer = opts.buf,
            callback = function(opts) 
              vim.fn.system({'chmod', '+x', opts.file})
            end
          }
        )
      end
    end
  }
)

