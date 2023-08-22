return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				"folke/neodev.nvim",
				event = { "BufEnter *.lua" },
				opts = {},
			},
		},
		opts = function()
			return {
				default = {
					on_attach = require("utils.lsp").on_attach,
					handlers = require("utils.lsp").handlers(),
					flags = {
						debounce_text_changes = 150,
					},
				},
				---@type lspconfig.options
				servers = {
					lua_ls = {
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = {
									disable = { "undefined-doc-name" },
									globals = { "vim" },
								},
								workspace = {
									checkThirdParty = false,
								},
								telemetry = {
									enable = false,
								},
								format = {
									enabled = false,
								},
							},
						},
					},
					-- TODO: Configure pyright
					pyright = {},
					ruff_lsp = {
						on_attach = function(client, bufnr)
							client.server_capabilities.hoverProvider = false
							require("utils.lsp").on_attach(client, bufnr)
						end,
					},
					gopls = {
						settings = {
							gopls = {
								semanticTokens = true,
							},
						},
					},
					yamlls = {
						settings = {
							yaml = {
								schemaStore = {
									enable = true,
									url = "https://www.schemastore.org/api/json/catalog.json",
								},
							},
						},
					},
					jsonls = {
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = {
									enable = true,
								},
							},
						},
					},
					dockerls = {},
					marksman = {},
					terraformls = {},
					tflint = {},
					vimls = {},
				},
			}
		end,
		config = function(_, opts)
			local lspconfig = require("lspconfig")

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, opts.default)

			for server_name, server_opts in pairs(opts.servers) do
				lspconfig[server_name].setup(server_opts)
			end
		end,
	},
	{
		"williamboman/mason.nvim",
		build = function()
			vim.cmd.MasonUpdate()
		end,
		cmd = { "Mason", "MasonInstall", "MasonUninstall" },
		config = function()
			require("mason").setup()

			-- Run custom mason post install handlers
			require("mason-registry"):on(
				"package:install:success",
				vim.schedule_wrap(require("utils.lsp").mason_post_install)
			)
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lspconfig",
			"nvim-lua/plenary.nvim",
		},
		opts = function()
			local formatting = require("null-ls").builtins.formatting
			local diagnostics = require("null-ls").builtins.diagnostics
			return {
				sources = {
					formatting.black,
					formatting.ruff,
					formatting.stylua,
					formatting.gofmt,
					formatting.goimports,
					formatting.beautysh,
					formatting.fixjson,
					formatting.terraform_fmt,
					formatting.prettierd,
					diagnostics.zsh,
				},
			}
		end,
	},
}
