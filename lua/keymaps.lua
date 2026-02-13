vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>", { desc = "[Ex]plore" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<M-j>", "<cmd>try | cnext | catch | cfirst | catch | endtry<cr>", { desc = "Quickfix: next item" })
vim.keymap.set(
	"n",
	"<M-k>",
	"<cmd>try | cprev | catch | clast | catch | endtry<cr>",
	{ desc = "Quickfix: previous item" }
)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting buffer" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
