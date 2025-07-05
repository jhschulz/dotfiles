require('which-key').add({
    { '<leader>g', group = 'Git' },
    { '<leader>gn', '<cmd> Gitsigns nav_hunk next<cr>', desc = 'Next Hunk' },
    { '<leader>gp', '<cmd> Gitsigns nav_hunk prev<cr>', desc = 'Prev Hunk' },
    { '<leader>gs', '<cmd> Gitsigns preview_hunk_inline<cr>', desc = 'Show Hunk' },
    { '<leader>gh', '<cmd> Gitsigns stage_hunk<cr>', desc = 'Stage Hunk' },
    { '<leader>gb', '<cmd> Gitsigns stage_buffer<cr>', desc = 'Stage Buffer' },
})
