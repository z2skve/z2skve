return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            { "mason-org/mason-lspconfig.nvim" },
        },
        config = function()
            local servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--fallback-style=WebKit",
                    },
                },
                -- lua_ls = {},
                -- pyright = {},
            }

            -- Assign local configuration to each of the lsp servers
            for server, config in pairs(servers) do
                vim.lsp.config(server, config)
            end

            local ensure_installed = vim.tbl_keys(servers)
            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed,
                automatic_enable = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                callback = function(event)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf})
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf})
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf})
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf})
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf})
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf})
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf})
                end,
            })
        end,
    },
}
