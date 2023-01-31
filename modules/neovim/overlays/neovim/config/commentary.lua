vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.kdl',
    callback = function()
        vim.cmd('set filetype=kdl')
    end
})

vim.cmd('autocmd FileType kdl setlocal commentstring=//\\ %s')
