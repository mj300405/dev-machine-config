-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function starts_in_workspace()
  if vim.fn.argc(-1) == 0 then
    return true
  end

  local first_arg = vim.fn.argv(0)
  return first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1
end

if starts_in_workspace() then
  vim.schedule(function()
    pcall(function()
      local current = vim.api.nvim_get_current_buf()
      local current_name = vim.api.nvim_buf_get_name(current)
      local current_is_directory = current_name ~= "" and vim.fn.isdirectory(current_name) == 1

      if current_is_directory then
        vim.cmd("enew")
        vim.api.nvim_buf_delete(current, { force = true })
      end

      require("nvim-tree.api").tree.open()
    end)
  end)
end
