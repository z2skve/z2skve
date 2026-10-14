return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterNativeHighlight", { clear = true }),
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
