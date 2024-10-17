---@type LazySpec
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = false,
				debounce = 75,
				keymap = {
					accept_word = false,
					accept_line = false,
					accept = "<C-l>",
					next = "<C-]>",
					prev = "<C-[>",
					dismiss = "<C-e>",
				},
			},
			panel = {
				enabled = false,
			},
			filetypes = {
				norg = false,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			vim.g.copilot_proxy = vim.fn.getenv("http_proxy")
			vim.g.copilot_proxy_strict_ssl = false
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		version = "v2.*",
		cmd = "CopilotChat",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
		},
		build = "make tiktoken",
		opts = {
			model = "gpt-4o",
			mappings = {
				close = {
					insert = "",
				},
				complete = {
					insert = "",
				},
			},
			prompts = {
				CommitStaged = {
					prompt = "Write commit message for the change with commitizen convention. Make sure the message has maximum 50 characters.",
				},
			},
		},
		config = function(_, opts)
			require("CopilotChat.integrations.cmp").setup()
			require("CopilotChat").setup(opts)
		end,
		keys = {
			{
				"<leader>cc",
				mode = "n",
				function()
					require("CopilotChat").open()
				end,
				desc = "Copilot Chat",
			},
			{
				"<leader>ce",
				mode = "v",
				function()
					vim.cmd.CopilotChatExplain()
				end,
				desc = "Explain",
			},
			{
				"<leader>cr",
				mode = "v",
				function()
					vim.cmd.CopilotChatReview()
				end,
				desc = "Review",
			},
			{
				"<leader>cRc",
				mode = "n",
				function()
					local ns = vim.api.nvim_create_namespace("copilot_review")
					vim.diagnostic.reset(ns, 0)
				end,
				desc = "Clear Review",
			},
			{
				"<leader>cRh",
				mode = "n",
				function()
					local ns = vim.api.nvim_create_namespace("copilot_review")
					vim.diagnostic.hide(ns, 0)
				end,
				desc = "Hide Review",
			},
			{
				"<leader>cRs",
				mode = "n",
				function()
					local ns = vim.api.nvim_create_namespace("copilot_review")
					vim.diagnostic.show(ns, 0)
				end,
				desc = "Show Review",
			},
			{
				"<leader>co",
				mode = "v",
				function()
					vim.cmd.CopilotChatOptimize()
				end,
				desc = "Optimize",
			},
			{
				"<leader>cC",
				mode = "n",
				function()
					vim.cmd.CopilotChatCommitStaged()
				end,
				desc = "Commit",
				ft = "gitcommit",
			},
		},
	},
}
