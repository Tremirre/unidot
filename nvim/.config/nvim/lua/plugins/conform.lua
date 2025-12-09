return { -- Autoformat
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>fb",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat [B]uffer",
    },
  },
  opts = {
    notify_on_error = true,
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform can also run multiple formatters sequentially
      python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },

      htmldjango = { "djlint" },

      vue = { "prettierd" },
      html = { "prettierd" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },

      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
    },
  },
}
