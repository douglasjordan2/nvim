local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<leader>ll', '<cmd>ALEFix prettier<cr>', { desc = 'Shopify Prettier current buffer. Needs prettier and Shopify prettier installed first.', silent = false})
vim.keymap.set('n', '>h', function()
  require('mini.diff').goto_hunk("next")
end, { desc = 'MiniDiff Next Hunk', silent = true })
vim.keymap.set('n', '<h', function()
  require('mini.diff').goto_hunk("prev")
end, { desc = 'MiniDiff Next Hunk', silent = true })
vim.keymap.set('n', '<leader>md', ':lua MiniDiff.toggle_overlay()<CR>', { desc = '[M]ini[D]iff toggle overlay', silent = true })

map('n', '<C-l>', '<C-i>') --------------------------------------------------------  remap C-i to C-l before remapping l

-- timeout
vim.opt.timeoutlen = 300

-- map leader
vim.g.mapleader = " "  ------------------------------------------------------------  set leader to SPACE
map('i', '<C-c>', '<ESC>')  -------------------------------------------------------  escape insert mode with CTRL+C

-- tabs
map('n', '<leader>tt', ':tabnew<CR>')  --------------------------------------------  new tab
map('n', '<C-k>', 'gT')  ----------------------------------------------------------  previous tab
map('n', '<C-h>', 'gt')  ----------------------------------------------------------  next tab

-- file exporer
map('n', '<leader>f', ':Oil<CR>')  ------------------------------------------------  open file explorer

-- open windows with CTRL + arrow keys
map('n', '<leader><down>', '<C-w>s')  ---------------------------------------------  open new window below
map('n', '<leader><right>', '<C-w>v')  --------------------------------------------  open new window right

-- move around splits using arrow keys
map('n', '<left>', '<C-w>h')  -----------------------------------------------------  move to the next window on the left
map('n', '<right>', '<C-w>l')  ----------------------------------------------------  move to the next window on the right
map('n', '<up>', '<C-w>k')  -------------------------------------------------------  move to the next window above:
map('n', '<down>', '<C-w>j')  -----------------------------------------------------  move to the next window below

-- change split orientation and size
map('n', '<leader>wv', '<C-w>t<C-w>K')  -------------------------------------------  change vertical to horizontal
map('n', '<leader>wh', '<C-w>t<C-w>H')  -------------------------------------------  change horizontal to vertical
map('n', '<leader>=', '<C-w>=')  --------------------------------------------------  even window sizes

-- cool things with text
map("v", "J", ":m '>+1<CR>gv=gv")  ------------------------------------------------  move all highlighted text down
map("v", "K", ":m '<-2<CR>gv=gv")  ------------------------------------------------  move all highlighted text up

-- cursor sanity
map("n", "J", "mbJ`b")  -----------------------------------------------------------  keep cursor in same place when combining lines with J
map("n", "<C-u>", "<C-u>zz")  -----------------------------------------------------  jump half page up and keep cursor in center
map("n", "<C-d>", "<C-d>zz")  -----------------------------------------------------  jump half page down and keep cursor in center
map("n", "n", "nzzzv")  -----------------------------------------------------------  keep search selection in center of screen - next
map("n", "N", "Nzzzv")  -----------------------------------------------------------  keep search selection in center of screen - previous

-- visual editor commands
map('n', '<leader>c', ':noh<CR>')  ------------------------------------------------  clear highlighting
map('n', '<leader><Tab>', 'ddO')  -------------------------------------------------  fix indent when at first char of new line betweeen brackets (etc)

-- file commands
map('n', '<leader>s', ':w<CR>')  --------------------------------------------------  save
map('n', '<leader>sa', ':wa<CR>')  ------------------------------------------------  save all
map('n', '<leader>q', ':q<CR>')  --------------------------------------------------  quit
map('n', '<leader>qq', ':qa<CR>')  ------------------------------------------------  quit all
map('n', '<leader>sqq', ':wqa<CR>')  ----------------------------------------------  save all and quit
map('n', '<leader>r', ':so %<CR>')  -----------------------------------------------  source
map('n', '<C-p>', ":%!npx prettier --stdin-filepath %<CR>")  ----------------------  format file
