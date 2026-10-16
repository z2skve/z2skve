local function run_current_file()
    vim.cmd("silent! write")

    local ft = vim.bo.filetype
    local file = vim.fn.expand("%")
    local file_no_ext = vim.fn.expand("%:r")
    local cmd = nil

    if ft == "c" then
        cmd = string.format("gcc -Wall -Wextra %s -o %s && ./%s", file, file_no_ext, file_no_ext)
    elseif ft == "cpp" then
        cmd = string.format("g++ -Wall -Wextra -std=c++17 %s -o %s && ./%s", file, file_no_ext, file_no_ext)
    elseif ft == "python" then
        cmd = string.format("python3 %s", file)
    elseif ft == "rust" then
        if vim.fn.filereadable("Cargo.toml") == 1 then
            cmd = "cargo run"
        else
            cmd = string.format("rustc %s -o %s && ./%s", file, file_no_ext, file_no_ext)
        end
    elseif ft == "sh" or ft == "bash" then
        cmd = string.format("bash %s", file)
    elseif ft == "html" then
        cmd = string.format("xdg-open %s", file)
    elseif ft == "javascript" then
        cmd = string.format("node %s", file)
    elseif ft == "typescript" then
        cmd = string.format("npx ts-node %s", file)
    elseif ft == "go" then
        cmd = string.format("go run %s", file)
    elseif ft == "java" then
        cmd = string.format("javac %s && java %s", file, vim.fn.expand("%:t:r"))
    else
        vim.notify("No run command configured for filetype: " .. ft, vim.log.levels.WARN)
        return
    end

    local Terminal = require("toggleterm.terminal").Terminal
    local runner = Terminal:new({
        cmd = cmd,
        direction = "float",
        close_on_exit = false,
        hidden = true,
    })
    runner:toggle()
end

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
        { "<leader>r", run_current_file, desc = "Compile and run current file" },
    },
    opts = {
        size = 15,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        close_on_exit = false,
        float_opts = {
            border = "curved",
            winblend = 0,
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        local function set_terminal_keymaps()
            local map_opts = { buffer = 0 }
            vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], map_opts)
            vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], map_opts)
            vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], map_opts)
            vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], map_opts)
            vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], map_opts)
        end

        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*toggleterm#*",
            callback = set_terminal_keymaps,
        })
    end,
}
