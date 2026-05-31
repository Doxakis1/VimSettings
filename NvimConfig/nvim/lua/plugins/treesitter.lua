if vim.g.treesitter_branch ~= 'main' then return {} end

-- on main branch, treesitter isn't started automatically
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  callback = function(event)
    local ignored_fts = {
      'snacks_dashboard',
      'snacks_notif',
      'snacks_input',
      'prompt', -- bt: snacks_picker_input
    }

    if vim.tbl_contains(ignored_fts, event.match) then return end

    -- make sure nvim-treesitter is loaded
    local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')

    -- no nvim-treesitter, maybe fresh install
    if not ok then return end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    nvim_treesitter.install({ lang }):await(function(err)
      if err then
        vim.notify('Treesitter install error for ft: ' .. ft .. ' err: ' .. err)
        return
      end

      pcall(vim.treesitter.start, event.buf)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end)
  end,
})

return {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = function()
      -- update parsers, if TSUpdate exists
      if vim.fn.exists(':TSUpdate') == 2 then vim.cmd('TSUpdate') end
    end,

    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {},
    config = function(_, opts)
      local ensure_installed = {
        'bash',
        'diff',
        'gitcommit',
        'html',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        "go",
        "c",
        "cpp",
        "rust",
        "python",
        "css",
        "php",
        "zig",
        "java",
        "typescript",
        "asm",
        "sql",
      }
      local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')
      if not ok then return end
      nvim_treesitter.install(ensure_installed)
    end
  }

-- vim: ts=2 sts=2 sw=2 et
