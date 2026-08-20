vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({
        async = true
    })
end)

vim.keymap.set("n", "<leader>d", function ()
    vim.diagnostic.enable(!vim.diagnostic.is_enabled());
    print(vim.diagnostic.is_enabled())
end)
