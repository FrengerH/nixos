-- local colorscheme = "tokyonight-night"
-- local colorscheme = "dracula"
local colorscheme = "catppuccin"

if colorscheme == "catppuccin" then
    vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
    require("catppuccin").setup()
end


local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
