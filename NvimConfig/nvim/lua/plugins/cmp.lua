return {
    "hrsh7th/nvim-cmp",
    name = "cmp",
    dependencies = {
        "hrsh7th/cmp-vsnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/vim-vsnip"
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
            sources = cmp.config.sources({
                {name = "nvim_lsp"},
                {name = "vsnip"}
            },
            {{name = "buffer"}}
            ),
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({
                    select = true
                }),
                --['<C-j>'] = cmp.mapping.select_next_item(),
                --['<C-k>'] = cmp.mapping.select_prev_item()
            })
        })
    end
}
