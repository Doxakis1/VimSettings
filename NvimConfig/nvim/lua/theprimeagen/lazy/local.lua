
local local_plugins = {
    {
	"ThePrimeagen/harpoon",
    branch = "harpoon2", -- Tells Lazy to fetch the modern v2 branch from GitHub
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency for UI/hashing utilities
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      -- Basic recommended Harpoon v2 Keymaps
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Mark File" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Menu" })

      -- Jump to marked files 1 through 4
      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
    end,
    },
    {
	"ThePrimeagen/vim-apm",
    dir = nil, -- CRITICAL: Overrides any global configurations trying to force a local folder path
    config = function()
      local apm = require("vim-apm")
      
      -- Initialize the plugin with default settings
      apm:setup({})
      
      -- Define a keymap to toggle the performance/accuracy HUD monitor
      vim.keymap.set(
        "n", 
        "<leader>apm", 
        function() apm:toggle_monitor() end, 
        { desc = "Vim-APM: Toggle Monitor Overlay" }
      )
	end,
    },
}

return local_plugins

