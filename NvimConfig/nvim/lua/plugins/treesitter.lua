return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "elixir", "heex", "go", "javascript", "html", "rust", "python", "toml", "dockerfile", "yaml", "make", "css", "scss", "typescript", "glsl" },
            sync_install = false,
            highlight = { enable = true },
        })
    end
}
