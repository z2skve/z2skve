return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    keys = {
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Alternar Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end,          desc = "DAP: Iniciar / Continuar" },
        { "<F9>", function() require("dap").step_over() end,         desc = "DAP: Paso siguiente (Step Over)" },
        { "<leader>si", function() require("dap").step_into() end,         desc = "DAP: Entrar en función (Step Into)" },
        { "<leader>sO", function() require("dap").step_out() end,          desc = "DAP: Salir de función (Step Out)" },
        { "<leader>dq", function() require("dap").terminate() end,         desc = "DAP: Detener Depuración" },
        { "<leader>du", function() require("dapui").toggle() end,          desc = "DAP: Alternar Interfaz (UI)" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local dap_python = require("dap-python")

        -- 1. Inicializar la interfaz visual
        dapui.setup()

        -- 2. Conectar con el debugpy instalado por Mason
        local path_to_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        dap_python.setup(path_to_debugpy)

        -- 3. Abrir la UI automáticamente cuando inicie la depuración y cerrarla al terminar
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- 4. Iconos visuales bonitos para los Breakpoints
        vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DiagnosticError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DiagnosticWarn", linehl = "Visual", numhl = "" })
    end,
}
