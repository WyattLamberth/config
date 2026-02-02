-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "**/work-log/log.md",
  callback = function()
    local timestamp = os.date("%Y-%m-%d %H:%M")
    local cmd = string.format(
      "cd %s && git add log.md && (git diff --cached --quiet || git commit -m 'Update: %s') && git push",
      vim.fn.expand("~/work-log"),
      timestamp
    )
    vim.fn.jobstart(cmd, {
      detach = true,
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.schedule(function()
            vim.notify("Work log pushed", vim.log.levels.INFO)
          end)
        else
          vim.schedule(function()
            vim.notify("Work log push failed (exit: " .. exit_code .. ")", vim.log.levels.WARN)
          end)
        end
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    if vim.fn.expand("%:p"):match("work%-log/log%.md") then
      vim.keymap.set('n', '<leader>nd', function()
        local date = os.date("%Y-%m-%d")
        local line = "## " .. date
        vim.api.nvim_buf_set_lines(0, 0, 0, false, {"", line, ""})
        vim.api.nvim_win_set_cursor(0, {4, 0})
      end, { buffer = true, desc = "New daily section" })

      vim.keymap.set('n', '<leader>nt', function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, {"- [ ] "})
        vim.api.nvim_win_set_cursor(0, {row + 1, 6})
        vim.cmd("startinsert!")
      end, { buffer = true, desc = "New todo item" })
    end
  end,
})
