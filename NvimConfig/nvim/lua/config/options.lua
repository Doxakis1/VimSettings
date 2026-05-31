vim.opt.history = 500
vim.opt.wrap = false
vim.opt.cmdheight = 1
vim.opt.hidden = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.foldcolumn = "1"
vim.opt.number = true
vim.opt.background = "dark"
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.linebreak = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.cin = true
vim.opt.cursorline = true
vim.api.nvim_set_option("clipboard","unnamedplus") 

vim.cmd("syntax enable")
vim.cmd("colorscheme murphy")

-- Copy to system clipboard on yank (xclip)
local copy_group = vim.api.nvim_create_augroup("CopyOnYank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = copy_group,
  callback = function()
    if vim.v.event.regname == "+" then
      local text = table.concat(vim.v.event.regcontents, "\n")
      vim.fn.system("xclip -selection clipboard", text)
    end
  end,
})

