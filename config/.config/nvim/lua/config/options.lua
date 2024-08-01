-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd([[
  autocmd BufNewFile,BufRead *.go setl filetype=go tabstop=4 shiftwidth=4 noexpandtab
]])
