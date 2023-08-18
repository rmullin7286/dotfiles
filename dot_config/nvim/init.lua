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

