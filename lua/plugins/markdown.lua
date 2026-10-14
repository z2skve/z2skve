return {
    -- 1. Visor interactivo y formateo visual dentro del propio buffer de Neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown", "markdown.mdx" },
        opts = {
            heading = {
                enabled = true,
                sign = true,
                position = "overlay",
                icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            },
            code = {
                enabled = true,
                sign = true,
                style = "full",
                position = "left",
                language_pad = 0,
                disable_background = { "diff" },
                width = "full",
                border = "thin",
                above = "▄",
                below = "▀",
            },
            checkbox = {
                enabled = true,
                position = "inline",
                unchecked = { icon = "󰄱 " },
                checked = { icon = "󰱒 " },
            },
            pipe_table = {
                enabled = true,
                preset = "round",
                style = "full",
                cell = "padded",
            },
            bullet = {
                enabled = true,
                icons = { "●", "○", "◆", "◇" },
                right_pad = 1,
                highlight = "RenderMarkdownBullet",
            },
            latex = {
                enabled = true,
                converter = "latex2text",
                highlight = "RenderMarkdownMath",
                top_pad = 0,
                bottom_pad = 0,
            },
            callout = {
                note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
                tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
                important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
                warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
                caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
            },
        },
        init = function()
            -- Configurar conceallevel para que los elementos markdown se rendericen correctamente
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown", "markdown.mdx" },
                callback = function()
                    vim.opt_local.conceallevel = 2
                    vim.opt_local.concealcursor = "nc"
                end,
            })
        end,
        keys = {
            {
                "<leader>mr",
                "<cmd>RenderMarkdown toggle<cr>",
                desc = "Alternar visor Markdown en buffer",
                ft = "markdown",
            },
        },
    },

    -- 2. Visor y previsualización en vivo sincronizada en el navegador web
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_theme = "dark"
            vim.g.mkdp_refresh_slow = 0
            vim.g.mkdp_command_for_global = 0
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_open_ip = ""
            vim.g.mkdp_browser = ""
            vim.g.mkdp_echo_preview_url = 0
            vim.g.mkdp_page_title = "${name}"
        end,
        ft = { "markdown" },
        keys = {
            {
                "<leader>mp",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Alternar previsualización Markdown en navegador",
            },
        },
    },
}
