# pico-boa.nvim
A Micropython plugin for Vim

## Add Lua functionality
Add this to your nvim config
```
local boa = require('pico-boa')
vim.keymap.set("n", "<leader>pp", function() boa.setup() end)
```
