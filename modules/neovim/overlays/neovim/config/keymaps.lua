--Remap space as leader key
-- keymap("", "<Space>", "<Nop>")
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
vim.keymap.set("n", "<leader>pi", ":PlugInstall<cr>")
vim.keymap.set("n", "<leader>e", ":Ex<cr>")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<leader>a", function() require("harpoon.mark").add_file() end)
vim.keymap.set("n", "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end)

vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-;>", function() require("harpoon.ui").nav_file(4) end)

-- window movement remaps
-- keymap("n", "<a-h>", "<cmd>wincmd h<cr>")
-- keymap("n", "<a-j>", "<cmd>wincmd j<cr>")
-- keymap("n", "<a-k>", "<cmd>wincmd k<cr>")
-- keymap("n", "<a-l>", "<cmd>wincmd l<cr>")

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Insert --

-- Visual --
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- Visual Block --

-- Terminal --
