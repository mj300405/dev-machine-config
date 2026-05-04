return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neogit").setup({
      kind = "vsplit",
      integrations = {
        diffview = true,
      },
      commit_editor = {
        kind = "split",
        show_staged_diff = true,
        staged_diff_split_kind = "vsplit",
      },
    })
  end,
  keys = {
    {
      "<leader>gg",
      function()
        require("neogit").open({ kind = "vsplit" })
        vim.cmd("vertical resize 45")
      end,
      desc = "Git Changes",
    },
    {
      "<leader>gs",
      function()
        require("neogit").open({ kind = "vsplit" })
        vim.cmd("vertical resize 45")
      end,
      desc = "Git Status",
    },
    {
      "<leader>gG",
      function()
        require("neogit").open({ kind = "tab" })
      end,
      desc = "Git Status (Tab)",
    },
    { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git Commit" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff Changes" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Git Diff Close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git Repo History" },
  },
}
