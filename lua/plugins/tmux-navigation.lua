return {
  'christoomey/vim-tmux-navigator',
  lazy = false,
  config = function()
    vim.keymap.set('n', '<C-h>', '<cmd> TmuxNavigateLeft<cr>', { desc = 'Tmux: switch pane left' })
    vim.keymap.set('n', '<C-j>', '<cmd> TmuxNavigateDown<cr>', { desc = 'Tmux: switch pane down' })
    vim.keymap.set('n', '<C-k>', '<cmd> TmuxNavigateUp<cr>', { desc = 'Tmux: switch pane up' })
    vim.keymap.set('n', '<C-l>', '<cmd> TmuxNavigateRight<cr>', { desc = 'Tmux: switch pane right' })
  end,
}
