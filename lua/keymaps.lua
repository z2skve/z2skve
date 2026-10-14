-- ==========================================================
-- Code formatting
-- ==========================================================
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({
        async = true,
    })
end, { desc = "Format buffer with LSP" })

-- ==========================================================
-- Diagnostic toggling
-- ==========================================================
vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    print("Diagnostics enabled: " .. tostring(vim.diagnostic.is_enabled()))
end, { desc = "Toggle diagnostics" })

-- ==========================================================
-- Visual mode auto-surround
-- ==========================================================
vim.keymap.set("x", "(", '"zc(<C-r>z)<Esc>', { desc = "Surround selection with ()" })
vim.keymap.set("x", ")", '"zc(<C-r>z)<Esc>', { desc = "Surround selection with ()" })

-- Remove visual mode collisions for [ and ] so they trigger instantly
pcall(vim.keymap.del, "x", "[n")
pcall(vim.keymap.del, "x", "[N")
pcall(vim.keymap.del, "x", "[%")
pcall(vim.keymap.del, "x", "]n")
pcall(vim.keymap.del, "x", "]N")
pcall(vim.keymap.del, "x", "]%")

-- Brackets
vim.keymap.set("x", "[", '"zc[<C-r>z]<Esc>', { desc = "Surround selection with []" })
vim.keymap.set("x", "]", '"zc[<C-r>z]<Esc>', { desc = "Surround selection with []" })

vim.keymap.set("x", "{", '"zc{<C-r>z}<Esc>', { desc = "Surround selection with {}" })
vim.keymap.set("x", "}", '"zc{<C-r>z}<Esc>', { desc = "Surround selection with {}" })

vim.keymap.set("x", '"', '\"zc"<C-r>z"<Esc>', { desc = 'Surround selection with ""' })
vim.keymap.set("x", "'", "\"zc'<C-r>z'<Esc>", { desc = "Surround selection with ''" })

-- ==========================================================
-- Recent files picker
-- ==========================================================
vim.keymap.set("n", "<leader>.", "<cmd>Telescope oldfiles<CR>", { desc = "Find recent files (Telescope)" })

