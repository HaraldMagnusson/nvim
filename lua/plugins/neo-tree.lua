return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	keys = {
		{ "\\", ":Neotree reveal position=right<CR>", desc = "NeoTree reveal", silent = true },
		{ "<leader>e", ":Neotree position=current<CR>", desc = "Neotree [e]xplore", silent = true },
	},

	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		filesystem = {
			window = {
				mappings = {
					["\\"] = "close_window",
					["<space>"] = { "toggle_node", nowait = true },
				},
			},
			filtered_items = {
				always_show = {
					".gitignore",
				},
			},
			hijack_netrw_behavior = "open_current",
		},
	},
}
