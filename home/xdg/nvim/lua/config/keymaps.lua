-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

for k, v in pairs({
  [";"] = ":",
  [":"] = ";",
}) do
  keymap("n", k, v, opts)
end

for k, v in pairs({
  -- emacs
  ["<C-n>"] = "<Down>",
  ["<C-p>"] = "<Up>",
  ["<C-b>"] = "<Left>",
  ["<C-f>"] = "<Right>",
  ["<C-a>"] = "<Home>",
  ["<C-e>"] = "<End>",
  ["<C-d>"] = "<Del>",
}) do
  keymap("i", k, v, {})
end
vim.print("foo")
