return {
  "neovim/nvim-lspconfig",
  name = "lspconfig",
  config = function()
    local configs = require("lspconfig")

    -- C/C++
    configs.clangd.setup({
      on_attach = function()
        vim.keymap.set("n", "gh", ":ClangdSwitchSourceHeader<cr>", { silent = true })
      end,
    })

    -- Python
    configs.pyright.setup({})

    -- Golang
    configs.gopls.setup({
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
          gofumpt = true,
          completeUnimported = true,
          usePlaceholders = true,
        },
      },
    })
  end,
}
