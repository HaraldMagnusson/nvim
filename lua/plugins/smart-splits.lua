return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	keys = {
		{ "<C-h>",   function() require("smart-splits").move_cursor_left() end,  desc = "Switch pane, left" },
		{ "<C-j>",   function() require("smart-splits").move_cursor_down() end,  desc = "Switch pane, down" },
		{ "<C-k>",   function() require("smart-splits").move_cursor_up() end,    desc = "Switch pane, up" },
		{ "<C-l>",   function() require("smart-splits").move_cursor_right() end, desc = "Switch pane, right" },

		{ "<C-S-h>", function() require("smart-splits").resize_left() end,       desc = "Resize pane, left" },
		{ "<C-S-j>", function() require("smart-splits").resize_down() end,       desc = "Resize pane, down" },
		{ "<C-S-k>", function() require("smart-splits").resize_up() end,         desc = "Resize pane, up" },
		{ "<C-S-l>", function() require("smart-splits").resize_right() end,      desc = "Resize pane, right" },
	},
	opts = {
		default_amount = 10,
		at_edge = "stop",
		log_level = "warn",
	},
}
