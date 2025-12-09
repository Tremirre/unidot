return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      background = {
        dark = "dragon",
      },
      transparent = true,
      overrides = function(colors)
        return {
          ["@variable"] = { fg = "#93c1b0" },
        }
      end,
    })
  end,
}
