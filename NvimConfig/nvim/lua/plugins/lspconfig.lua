return {
    "neovim/nvim-lspconfig",
    name = "lspconfig",
    config = function()
        local configs = require("lspconfig")
        configs.clangd.setup{
            on_attach = function()
                vim.keymap.set('n', 'gh', ':ClangdSwitchSourceHeader<cr>', { silent = true })
            end,
        }
		configs.pyright.setup{}
    end
}
