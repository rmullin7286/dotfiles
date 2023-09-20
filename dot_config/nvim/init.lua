-- leader key is space
vim.g.mapleader = ' '

-- colorscheme
vim.cmd('colorscheme habamax')

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
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      -- setup required language servers
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'lua_ls' }
      }

      local lsp = require('lsp-zero').preset({})
      lsp.on_attach(function(_, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
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
      require('nvim-tree').setup({
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      })
      -- autoclose when last window
      local function tab_win_closed(winnr)
        return function()
          local api = require "nvim-tree.api"
          local tabnr = vim.api.nvim_win_get_tabpage(winnr)
          local bufnr = vim.api.nvim_win_get_buf(winnr)
          local buf_info = vim.fn.getbufinfo(bufnr)[1]
          local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
          local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
          if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
            -- Close all nvim tree on :q
            if not vim.tbl_isempty(tab_bufs) then      -- and was not the last window (not closed automatically by code below)
              api.tree.close()
            end
          else                                                  -- else closed buffer was normal buffer
            if #tab_bufs == 1 then                              -- if there is only 1 buffer left in the tab
              local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
              if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
                vim.schedule(function()
                  if #vim.api.nvim_list_wins() == 1 then        -- if its the last buffer in vim
                    vim.cmd "quit"                              -- then close all of vim
                  else                                          -- else there are more tabs open
                    vim.api.nvim_win_close(tab_wins[1], true)   -- then close only the tab
                  end
                end)
              end
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function()
          local winnr = tonumber(vim.fn.expand("<amatch>"))
          vim.schedule_wrap(tab_win_closed(winnr))
        end,
        nested = true
      })
    end
  },
  {
    'vim-airline/vim-airline',
    config = function()
      vim.g['airline#extensions#tabline#enabled'] = 1
    end
  },
  {
    'vim-airline/vim-airline-themes',
    config = function()
      vim.g.airline_theme = 'deus'
    end
  }
})

-- bind for toggling nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>')

-- binds for cycling through buffers
vim.keymap.set('n', '<Tab>', ':bnext<cr>')
vim.keymap.set('n', '<S-Tab>', ':bprev<cr>')

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
