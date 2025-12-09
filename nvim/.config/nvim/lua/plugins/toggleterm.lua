return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  keys = { { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" } },
  opts = {
    size = 20,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
  },
}
