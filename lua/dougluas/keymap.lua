local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local closed_buffers = {}

local function is_terminal_buf(buf)
  return vim.bo[buf].buftype == "terminal"
end

local function confirm_close_modified(buf)
  return vim.fn.confirm(
    "Buffer " .. buf .. " has unsaved changes, are you sure you want to close it?", "&Yes\n&No", 2
  ) == 1
end

local function confirm_close_terminal(buf)
  return vim.fn.confirm(
    "Buffer " .. buf .. " has a process running, are you sure you want to close it?", "&Yes\n&No", 2
  ) == 1
end

function BufClose()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.bo[bufnr].modified
  local is_term = is_terminal_buf(bufnr)

  if modified then
    if not confirm_close_modified(bufnr) then
      return
    end
  end

  if is_term then
    if not confirm_close_terminal(bufnr) then
      return
    end
  end

  table.insert(closed_buffers, {
    name = vim.api.nvim_buf_get_name(bufnr),
    filetype = vim.bo[bufnr].filetype,
    cursor = vim.api.nvim_win_get_cursor(0)
  })

  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #buffers > 1 then
    vim.cmd("bd")
  else
    vim.cmd("q")
  end
end

function RestoreBuf()
  local last = table.remove(closed_buffers)
  if not last then
    print("No buffer to restore")
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(last.name))
  vim.bo.filetype = last.filetype
  vim.api.nvim_win_set_cursor(0, last.cursor)
end

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

-- buffers
map('n', '<C-b>', ':enew<CR>')  ---------------------------------------------------  new buffer
map('n', '<C-n>', ':bnext<CR>')  --------------------------------------------------  next buffer
map('n', '<leader>q', ':lua BufClose()<CR>')  -------------------------------------  quit buffer
map('n', '<leader>Q', ':lua RestoreBuf()<CR>')  -----------------------------------  restore buffer

-- term
map('n', '<C-t>', ':enew | term<CR>i')  -------------------------------------------  open new buffer with terminal
map('t', '<C-e>', '<C-\\><C-n>')  -------------------------------------------------  escape insert mode in term

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
map('n', '<leader>qq', ':qa<CR>')  ------------------------------------------------  quit all
map('n', '<leader>r', ':so %<CR>')  -----------------------------------------------  source
-- map('n', '<C-p>', ":%!npx prettier --stdin-filepath %<CR>")  ----------------------  format file

map('n', '<C-p>', '<cmd>ALEFix prettier<cr>', { desc = 'Shopify Prettier current buffer. Needs prettier and Shopify prettier installed first.', silent = false})

vim.keymap.set('n', '>h', function()
  require('mini.diff').goto_hunk("next")
end, { desc = 'MiniDiff Next Hunk', silent = true })

vim.keymap.set('n', '<h', function()
  require('mini.diff').goto_hunk("prev")
end, { desc = 'MiniDiff Next Hunk', silent = true })

vim.keymap.set('n', '<leader>md', ':lua MiniDiff.toggle_overlay()<CR>', { desc = '[M]ini[D]iff toggle overlay', silent = true })

