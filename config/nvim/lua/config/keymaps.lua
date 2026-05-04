-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function project_root()
  local ok, root = pcall(function()
    return LazyVim.root()
  end)

  return ok and root or vim.fn.getcwd()
end

vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal(nil, {
    cwd = project_root(),
    win = {
      position = "bottom",
      height = 0.28,
    },
  })
end, { desc = "Terminal (Bottom)" })

vim.keymap.set("n", "<leader>cx", function()
  Snacks.terminal({ "codex" }, {
    cwd = project_root(),
    auto_close = false,
    win = {
      position = "left",
      width = 0.3,
    },
  })
end, { desc = "Codex Side Panel" })
