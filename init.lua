vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

vim.opt.mouse = ""
vim.opt.hlsearch = false

-- LAZY
 -- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
        {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        {"nvim-lua/plenary.nvim"},
        {"MunifTanjim/nui.nvim"},
        {"nvim-tree/nvim-web-devicons"}
      },
      cmd = "Neotree",
      keys = {
        {
          "<leader>fe",
          function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
        },
        {
          "<leader>fE",
          function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
          end,
          desc = "Explorer NeoTree (cwd)",
        },
        { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
        { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
        {
          "<leader>ge",
          function()
            require("neo-tree.command").execute({ source = "git_status", toggle = true })
          end,
          desc = "Git Explorer",
        },
        {
          "<leader>be",
          function()
            require("neo-tree.command").execute({ source = "buffers", toggle = true })
          end,
          desc = "Buffer Explorer",
        },
      },
      deactivate = function()
        vim.cmd([[Neotree close]])
      end,
      init = function()
        vim.api.nvim_create_autocmd("BufEnter", {
          group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
          desc = "Start Neo-tree with directory",
          once = true,
          callback = function()
            if package.loaded["neo-tree"] then
              return
            else
              local stats = vim.uv.fs_stat(vim.fn.argv(0)) 
              if stats and stats.type == "directory" then
                require("neo-tree")
              end
            end
          end,
        })
      end,
      opts = {
        sources = { "filesystem", "buffers", "git_status" },
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        window = {
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["<space>"] = "none",
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.setreg("+", path, "c")
              end,
              desc = "Copy Path to Clipboard",
            },
            ["O"] = {
              function(state)
                require("lazy.util").open(state.tree:get_node().path, { system = true })
              end,
              desc = "Open with System Application",
            },
            ["P"] = { "toggle_preview", config = { use_float = false } },
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          git_status = {
            symbols = {
              unstaged = "󰄱",
              staged = "󰱒",
            },
          },
        },
      },
      config = function(_, opts)
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("TermClose", {
          pattern = "*lazygit",
          callback = function()
            if package.loaded["neo-tree.sources.git_status"] then
              require("neo-tree.sources.git_status").refresh()
            end
          end,
        })
      end,
    },
    {"neovim/nvim-lspconfig"},
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
        	{ "mason-org/mason.nvim", opts = {} },
        },
    },
   {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      opts = function()
        -- Register nvim-cmp lsp capabilities
        vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        local cmp = require("cmp")
        local defaults = require("cmp.config.default")()
        local auto_select = true
        return {
          auto_brackets = {}, -- configure any filetype to auto add brackets
          completion = {
            completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
          },
          preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
            ["<C-CR>"] = function(fallback)
              cmp.abort()
              fallback()
            end,
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),
          sources = cmp.config.sources({
            { name = "lazydev" },
            { name = "nvim_lsp" },
            { name = "path" },
          }, {
            { name = "buffer" },
          }),
          formatting = {
            format = function(_, item)
            local icons = {
                  Text = "[txt] ", Method = "[m()] ", Function = "[f()] ", Constructor = "[new] ",
                  Field = "[.] ", Variable = "[var] ", Class = "[C] ", Interface = "[I] ",
                  Module = "[mod] ", Property = "[p] ", Unit = "[u] ", Value = "[=] ",
                  Enum = "[E] ", Keyword = "[key] ", Snippet = "[<>] ", Color = "[#] ",
                  File = "[file] ", Reference = "[&] ", Folder = "[dir] ", EnumMember = "[e] ",
                  Constant = "[const] ", Struct = "[S] ", Event = "[!] ", Operator = "[+] ",
                  TypeParameter = "[T] "
              }

              if icons[item.kind] then
                item.kind = icons[item.kind] .. item.kind
              end

              local widths = {
                abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
              }

              for key, width in pairs(widths) do
                if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                  item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                end
              end

              return item
            end,
          },
          experimental = {
            -- only show ghost text when we show ai completions
            ghost_text = vim.g.ai_cmp and {
              hl_group = "CmpGhostText",
            } or false,
          },
          sorting = defaults.sorting,
        }
      end,
    },
    {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
    }
    },


  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("mason").setup()

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--fallback-style=WebKit",
    },
})

require("mason-lspconfig").setup {
    ensure_installed = { "clangd"},
    automatic_enable = true
}

vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({
        async = true,
        formatting_options = {
            tabSize = 4,
            insertSpaces = true,
        },
    })
end, { desc = "Formatear documento con LSP (4 espacios)" })

-- Diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        source = "always",
    },
})


