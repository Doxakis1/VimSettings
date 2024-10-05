vim.cmd("set number")
vim.cmd("set cin")
vim.cmd("syntax on")
vim.cmd("colorscheme elflord")
vim.cmd("set wildmenu")
vim.cmd("set path+=**")
vim.cmd("set wildmode=longest,list")
vim.cmd("set cc=80")
vim.cmd("set ignorecase")

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        --vim.keymap.set('n', '<Leader>R', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '??', vim.lsp.buf.hover, opts)
    end
})
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
