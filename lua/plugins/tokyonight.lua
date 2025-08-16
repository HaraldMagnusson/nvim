function IsDiffMode()
	for _, arg in pairs(vim.v.argv) do
		if arg == "-d" then
			return true
		end
	end
	return false
end

return {
	"folke/tokyonight.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			styles = {
				comments = { italic = false },
			},
		})

		if IsDiffMode() then
			vim.cmd.colorscheme("wildcharm") -- use wildcharm for git diffs
		else
			vim.cmd.colorscheme("tokyonight-night")
		end
	end,
}
