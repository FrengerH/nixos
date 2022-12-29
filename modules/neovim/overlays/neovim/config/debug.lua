local dap = require('dap')
local home = os.getenv("HOME")

vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F1>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition:'))<CR>")
vim.keymap.set("n", "<leader>do", ":lua require'dapui'.open()<CR>")
vim.keymap.set("n", "<leader>dc", ":lua require'dapui'.close()<CR>")

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { home .. '/.local/share/nvim/dap_servers/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9000,
    log = true,
    serverSourceRoot = '/var/www/',
    localSourceRoot = vim.fn.getcwd()
  }
}

require("dapui").setup()
