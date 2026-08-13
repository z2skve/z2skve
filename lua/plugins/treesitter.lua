return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallSync", "TSUpdateSync" },
    opts = {
        ensure_installed = {
            "c",
            "cpp",
            "lua",
            "bash",
            "json",
            "markdown",
            "markdown_inline",
            "python",
            "vim",
            "vimdoc",
        },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
