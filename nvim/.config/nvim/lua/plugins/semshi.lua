return {
  "wookayin/semshi",
  ft = "python",
  build = ":UpdateRemotePlugins",
  config = function()
    vim.keymap.set("n", "<leader>rr", ":Semshi rename<CR>", { desc = "Rename variable under cursor" })
    vim.keymap.set("n", "<BS>", ":Semshi goto name next<CR>", { desc = "Go to next variable" })
    vim.keymap.set("n", "<S-BS>", ":Semshi goto name prev<CR>", { desc = "Go to previous variable" })
    vim.keymap.set("n", "<leader>gu", ":Semshi goto unresolved first<CR>", { desc = "Go to first unresolved variable" })
    vim.keymap.set(
      "n",
      "<leader>gp",
      ":Semshi goto parameterUnused first<CR>",
      { desc = "Go to first unused parameter" }
    )
    vim.keymap.set("n", "<leader>ee", ":Semshi error<CR>", { desc = "Show errors" })
    vim.keymap.set("n", "<leader>ge", ":Semshi goto error<CR>", { desc = "Go to error" })
  end,
}
