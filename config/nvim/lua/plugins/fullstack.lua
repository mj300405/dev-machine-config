return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "vtsls",
        "eslint-lsp",
        "tailwindcss-language-server",
        "json-lsp",
        "yaml-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "html-lsp",
        "css-lsp",
        "lua-language-server",
        "prettier",
        "stylua",
        "shfmt",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", desc = "File Git History" },
    },
  },

  {
    "nvim-neotest/neotest-jest",
    dependencies = { "nvim-neotest/neotest" },
  },

  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npm test --",
          jestConfigFile = function(file)
            if vim.fn.filereadable(vim.fn.getcwd() .. "/jest.config.ts") == 1 then
              return vim.fn.getcwd() .. "/jest.config.ts"
            end
            if vim.fn.filereadable(vim.fn.getcwd() .. "/jest.config.js") == 1 then
              return vim.fn.getcwd() .. "/jest.config.js"
            end
            return nil
          end,
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
    },
  },
}
