return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  config = function()
    require("dressing").setup({
      select = {
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
      },
    })
  end,
}
