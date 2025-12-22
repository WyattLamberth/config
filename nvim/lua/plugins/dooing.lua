return {
  "atiladefreitas/dooing",
  keys = {
    { "<leader>td", "<cmd>Dooing<cr>", desc = "Todo list" },
  },
  opts = {
    save_path = vim.fn.stdpath("data") .. "/dooing_todos.json",
  },
}
