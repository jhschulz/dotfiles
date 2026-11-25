return
{
    'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Install desired parsers asynchronously
    require('nvim-treesitter').install({ 'lua', 'python', 'javascript', 'rust' })

    -- Enable native Tree-sitter highlighting per filetype
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}

