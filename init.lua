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
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
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


