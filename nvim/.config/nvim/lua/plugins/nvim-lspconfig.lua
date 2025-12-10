return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- Add any additional capability extensions here (cmp_nvim_lsp, etc.)
      -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      opts.servers = opts.servers or {}
      opts.servers.basedpyright = {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              exclude = {
                "**/node_modules/**",
                "**/__pycache__/**",
                "**/.mypy_cache/**",
                "**/.pytest_cache/**",
                "**/*.ipynb",
                "**/venv/**",
                "**/.venv/**",
              },
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "standard",
              useLibraryCodeForTypes = false,
              inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
                functionReturnTypes = true,
              },
              diagnosticSeverityOverrides = {
                reportUnusedVariable = "none",
                reportUndefinedVariable = "none",
                reportUnusedImport = "none",
              },
            },
          },
        },
      }
    end,
  },
}
