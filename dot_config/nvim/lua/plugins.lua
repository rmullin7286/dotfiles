-- This module manages all plugins installed by lazy.nvim.

local installed_language_servers = {
  "lua_ls"
}

local installed_formatters = {
  "stylua"
}

return {
  -- catppuccin is the colorscheme that I use.
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })

      -- set as the colorscheme
      vim.cmd("colorscheme catppuccin")
    end
  },
  -- lsp-zero is a plugin that helps with easily setting up language server clients for neovim and creates keybindings
  -- for various functions such as "go to definition", "display pop-up info", "go to file", etc.
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  -- mason is an installer for various language servers, linters, formatters, etc.
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ensure_installed = installed_formatters
    }
  },
  -- nvim-cmp handles autocompletion dropdowns for various programming languages, integrated with their language
  -- servers.
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3M0N4D3/LuaSnip" },
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()
      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        lsp_zero.buffer_autoformat()
      end)

      -- setup language servers managed by mason
      require("mason-lspconfig").setup({
        ensure_installed = installed_language_servers,
        handlers = {
          -- default
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
          --specific language server settings go here
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })

      -- setup language servers not managed by mason
      require("lspconfig").hls.setup({
        filetypes = { "haskell", "lhaskell", "cabal" }
      })
    end,
  },
  -- This plugin adds autoclosing pairs for (), {}, "", etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
  -- This plugin adds a file browser to neovim. I've bound <leader>e to opening and closing it.
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" }
    },
    lazy = false,
    config = function()
      require('nvim-tree').setup({
        actions = {
          open_file = {
            quit_on_open = true
          }
        }
      })

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
    end
  },
  -- lua-line adds a nicer status line to neovim, as well as "tabs" for each open buffer
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = {
      tabline = {
        lualine_a = {
          {
            "buffers",
            use_mode_colors = true,
            symbols = {
              alternate_file = ""
            }
          }
        }
      }
    }
  },
  -- telescope is a pop-up fuzzy finder that can help with various search operations
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    end
  }
}
