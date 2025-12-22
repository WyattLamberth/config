return {
  "numToStr/FTerm.nvim",
  keys = {
    { "<C-/>", function() require("FTerm").toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },
  },
  opts = {
    border = "rounded",
    dimensions = {
      height = 0.85,
      width = 0.85,
    },
  },
}
