return {
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim",
    },
    build = function()
      require("gitlab.server").build(true)
    end,
    config = function()
      require("gitlab").setup({
        config_path = vim.fn.expand("~/config"),
      })
    end,
    keys = {
      { "<leader>glc", "<cmd>lua require('gitlab').create_mr()<cr>", desc = "Create MR" },
      { "<leader>glm", "<cmd>lua require('gitlab').merge()<cr>", desc = "Merge MR" },
      { "<leader>gla", "<cmd>lua require('gitlab').approve()<cr>", desc = "Approve MR" },
      { "<leader>glA", "<cmd>lua require('gitlab').revoke()<cr>", desc = "Revoke approval" },
      { "<leader>gld", "<cmd>lua require('gitlab').toggle_draft_mode()<cr>", desc = "Toggle draft" },
      { "<leader>gls", "<cmd>lua require('gitlab').summary()<cr>", desc = "MR summary" },
      { "<leader>glr", "<cmd>lua require('gitlab').review()<cr>", desc = "Open review" },
      { "<leader>glR", "<cmd>lua require('gitlab').close_review()<cr>", desc = "Close review" },
      { "<leader>glo", "<cmd>lua require('gitlab').choose_merge_request()<cr>", desc = "Pick MR" },
      { "<leader>glO", "<cmd>lua require('gitlab').choose_merge_request_by_username()<cr>", desc = "Pick MR by author" },
      { "<leader>glb", "<cmd>lua require('gitlab').open_in_browser()<cr>", desc = "Open in browser" },
      { "<leader>glu", "<cmd>lua require('gitlab').copy_mr_url()<cr>", desc = "Copy MR URL" },
      { "<leader>glC", "<cmd>lua require('gitlab').create_comment()<cr>", desc = "Add comment" },
      { "<leader>glM", "<cmd>lua require('gitlab').create_multiline_comment()<cr>", desc = "Multi-line comment" },
      { "<leader>glS", "<cmd>lua require('gitlab').create_comment_suggestion()<cr>", desc = "Suggest change" },
      { "<leader>gln", "<cmd>lua require('gitlab').create_note()<cr>", desc = "Add note" },
      { "<leader>glt", "<cmd>lua require('gitlab').toggle_discussions()<cr>", desc = "Toggle discussions" },
      { "<leader>glT", "<cmd>lua require('gitlab').move_to_discussion_tree_from_diagnostic()<cr>", desc = "Jump to discussion" },
      { "<leader>glP", "<cmd>lua require('gitlab').publish_all_drafts()<cr>", desc = "Publish drafts" },
      { "<leader>gl+r", "<cmd>lua require('gitlab').add_reviewer()<cr>", desc = "Add reviewer" },
      { "<leader>gl-r", "<cmd>lua require('gitlab').delete_reviewer()<cr>", desc = "Remove reviewer" },
      { "<leader>gl+a", "<cmd>lua require('gitlab').add_assignee()<cr>", desc = "Add assignee" },
      { "<leader>gl-a", "<cmd>lua require('gitlab').delete_assignee()<cr>", desc = "Remove assignee" },
      { "<leader>gl+l", "<cmd>lua require('gitlab').add_label()<cr>", desc = "Add label" },
      { "<leader>gl-l", "<cmd>lua require('gitlab').delete_label()<cr>", desc = "Remove label" },
      { "<leader>glp", "<cmd>lua require('gitlab').pipeline()<cr>", desc = "View pipeline" },
      { "<leader>glx", "<cmd>lua require('gitlab').refresh_data()<cr>", desc = "Refresh data" },
      { "<leader>gli", "<cmd>lua require('gitlab').print_settings()<cr>", desc = "Print settings" },
      { "<leader>gl/", "<cmd>lua require('gitlab').toggle_sort_method()<cr>", desc = "Toggle sort" },
    },
  },
}
