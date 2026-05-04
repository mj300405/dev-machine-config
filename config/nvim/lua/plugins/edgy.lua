return {
  "folke/edgy.nvim",
  opts = {
    left = {
      -- Claude/Codex terminal side panels
      {
        ft = "snacks_terminal",
        title = "%{b:snacks_terminal.id}: %{b:term_title}",
        size = { width = 45 },
        filter = function(_buf, win)
          return vim.w[win].snacks_win and vim.w[win].snacks_win.position == "left"
        end,
      },
    },
    right = {
      -- File explorer
      {
        title = "Files",
        ft = "NvimTree",
        size = { width = 40 },
        pinned = true,
        open = "NvimTreeToggle",
      },
      -- Outline/Symbols
      {
        title = "Outline",
        ft = "Outline",
        pinned = true,
        open = "Outline",
      },
    },
    bottom = {
      -- Terminal
      {
        ft = "snacks_terminal",
        title = "%{b:snacks_terminal.id}: %{b:term_title}",
        size = { height = 0.25 },
        filter = function(_buf, win)
          return vim.w[win].snacks_win and vim.w[win].snacks_win.position == "bottom"
        end,
      },
      -- Trouble diagnostics
      { ft = "trouble", title = "Problems" },
      -- Git
      { ft = "git", title = "Git" },
    },
  },
}
