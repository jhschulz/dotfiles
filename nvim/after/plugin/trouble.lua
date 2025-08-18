require('which-key').add({
    { '<leader>x', group = 'Diagnostics' },
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics Window' },
    { '<leader>xf', vim.diagnostic.open_float, desc = 'Diagnostics Float' },
})
