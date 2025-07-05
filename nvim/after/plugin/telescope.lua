local builtin = require('telescope.builtin')
local wk = require('which-key')

wk.add({
    { '<leader>f', group = 'Find' },
    { '<leader>ff', builtin.find_files, desc = 'Find Files' },
    { '<leader>fg', builtin.live_grep, desc = 'Live Grep' },
    { '<leader>fb', builtin.buffers, desc = 'Buffers' },
    { '<leader>fh', builtin.help_tags, desc = 'Help Tags' },
})
