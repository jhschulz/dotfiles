local wk = require("which-key")
wk.add({
    { "J", ":m '>+1<CR>gv=gv", mode = "v" },
    { "K", ":m '<-2<CR>gv=gv", mode = "v" },
    { "<leader>fv", vim.cmd.Ex, desc = "File View" },
})
