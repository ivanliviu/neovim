-- blue at top, line separating windows - adjust theme?
-- create zsh shorcuts for Documents, sahbox, vin config, etc.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- what makes spaces look better than tags? undo space aspect and use here
vim.g.have_nerd_font = true vim.opt.bri = true
vim.opt.cc = '89'
vim.opt.cole = 0
vim.opt.cul = true
vim.opt.et = false
vim.opt.ls = 3
vim.opt.fixeol = true
vim.opt.hid = true
vim.opt.ic = true
vim.opt.icm = 'split'
vim.opt.is = true
vim.opt.lcs = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.sb = true
vim.opt.scl = 'yes'
vim.opt.scs = true
vim.opt.si = true
vim.opt.smd = false
vim.opt.so = 999
vim.opt.spr = true
vim.opt.sts = 4
vim.opt.sw = 4
vim.opt.swf = false
vim.opt.tgc = true
vim.opt.tm = 300
vim.opt.ts = 4
vim.opt.udf = true
vim.opt.udir = vim.fn.stdpath 'data' .. '/undo'
vim.opt.ut = 250
vim.opt.wrap = true
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)

-- improve function naming
local function map(key, value, mode, opts)
	vim.keymap.set( -- noremap too?
		mode or 'n', key, value, vim.tbl_extend('force', { silent = true }, opts or {}))
end
local function map_cmd(key, value, mode) map(key, function() vim.cmd(value) end, mode) end
local function map_expr(key, value, mode) map(key, value, mode, { expr = true }) end
local function map_leader(key, value, mode) map('<leader>' .. key, value, mode) end
local function map_leader_cmd(key, value, mode) map_cmd('<leader>' .. key, value, mode) end

map(';', 'i', { 'n', 'v' })
map('j', 'h', { 'n', 'v' })
map_expr('i', "v:count == 0 ? 'gk' : 'k'", { 'n', 'v' }) -- dix/cix are a problem
map_expr('k', "v:count == 0 ? 'gj' : 'j'", { 'n', 'v' })
-- what's default for noremap? when's it needed?
map('<Space>', '<Nop>', { 'n', 'v' }, { noremap = true })
map('C', '\"_C') -- replacement with clipboard macro would be nice
map('R', '\"_R')
map('X', '\"_X')
map('c', '\"_c')
map('r', '\"_r')
map('s', '\"_s')
map('x', '\"_x')
map_cmd('<C-h>', 'che')
map_cmd('<Esc>', 'nohls')
map_cmd('<S-j>', 'BufferPrevious')
map_cmd('<S-l>', 'BufferNext')
map_cmd('<Tab>', 'BufferNext')
map_cmd('<S-Tab>', 'BufferPrevious')
map_cmd('Q', 'qa')
map_leader('d', vim.diagnostic.setloclist)
map_leader('j', '<C-w>h')
map_leader('k', '<C-w>j')
map_leader('i', '<C-w>k')
map_leader('l', '<C-w>l')
map_leader('p', ':!python<Space>')
map_leader_cmd('<Tab>', 'b#')
map_leader_cmd('c', '!cmake --build build')
map_leader_cmd('q', 'clo')
map_leader_cmd('r', 'BufferRestore')
map_leader_cmd('t', 'ToggleTerm')
map_leader_cmd('w', 'BufferClose')

vim.api.nvim_create_autocmd(
	'TextYankPost', { callback = function() vim.highlight.on_yank() end })

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then -- update to vim.uv.fs_stat?
	local result = vim.fn.system {
		'git',
		'clone',
		'--depth=1',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		lazypath,
	}
	if vim.v.shell_error ~= 0 then -- ~=??
		error('Error cloning lazy.nvim:\n' .. result)
	end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ -- Run :Lazy; some packages are not 'started'?
	'nvim-tree/nvim-tree.lua',
	{
		'nvim-tree/nvim-web-devicons',
		opts = {
			color_icons = true,
			default = true,
			override = {},
			override_by_extension = {},
			override_by_filename = {},
			override_by_operating_system = {},
			strict = false,
			variant = 'dark' }
	},
	{
		-- fully configure if chosen
		'nvim-lualine/lualine.nvim', -- bottom line
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			options = {
				icons_enabled = true,
				theme = {
					normal = {
						a = { fg = '#edfbc3', bg = '#1e1c24', gui = 'bold' },
						b = { fg = '#edfbc3', bg = '#1e1c24' },
						c = { fg = '#edfbc3', bg = '#1e1c24' },
					},
					insert = { a = { fg = '#edfbc3', bg = '#1e1c24', gui = 'bold' } },
					visual = { a = { fg = '#edfbc3', bg = '#1e1c24', gui = 'bold' } },
					replace = { a = { fg = '#edfbc3', bg = '#1e1c24', gui = 'bold' } },
					inactive = {
						a = { fg = '#edfbc3', bg = '#1e1c24', gui = 'bold' },
						b = { fg = '#edfbc3', bg = '#1e1c24' },
						c = { fg = '#edfbc3', bg = '#1e1c24' },
					},
				},
				component_separators = '|',
				section_separators = '',
			},
		},
	},
	{ 'github/copilot.vim', opts = {}, config = function() require('copilot').setup({}) end },
	{
		-- https://github.com/Mofiqul/dracula.nvim - check for all plugins
		-- what causes bright yellow on alignment?
		'Mofiqul/dracula.nvim',
		name = 'dracula',
		config = function()
			require('dracula').setup({
				colors = {
					bg = '#1e1c24', -- 255, 1/8, 1/8
					black = '#080020', -- 255, 1, 1/16
					bright_blue = '#d0c0ff', -- 255, 1, 7/8
					bright_cyan = '#c0ffff', -- 180, 1, 7/8
					bright_green = '#c0ffc0', -- 120, 1, 7/8
					bright_magenta = '#ffc0e0', -- 330, 1, 7/8
					bright_red = '#ffc0c0', -- 0, 1, 7/8
					bright_white = '#ffffff', -- 0, 1, 1
					bright_yellow = '#ffffc0', -- 60, 1, 7/8
					comment = '#bbb8c8', -- 255, 1/8, 3/4
					cyan = '#80ffff', -- 180, 1, 3/4
					fg = '#edfbc3', -- 0, 1, 1
					green = '#80ff80', -- 120, 1, 3/4
					gutter_fg = '#2d2a36', -- 255, 1/8, 3/16
					menu = '#2d2a36', -- 255, 1/8, 3/16
					nontext = '#3c3848', -- 255, 1/8, 1/4
					orange = '#ffc080', -- 30, 1, 3/4
					pink = '#ff80c0', -- 330, 1, 3/4
					purple = '#a080ff', -- 255, 1, 3/4
					red = '#ff8080', -- 0, 1, 3/4
					selection = '#3c3848', -- 255, 1/8, 1/4
					visual = '#3c3848', -- 255, 1/8, 1/4
					white = '#e7dfff', -- 255, 1, 15/16
					yellow = '#ffff80', -- 60, 1, 3/4
				},
				italic_comment = true,
				lualine_bg_color = '#ff0000', -- not working
				overrides = {},
				show_end_of_buffer = true,
				transparent_bg = true })
			vim.cmd 'colorscheme dracula'
		end
	},
	{
		-- configure fully, assuming it's the plugin I go with (awesome neovim)
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons' },
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			auto_hide = false,
			animation = true,
			tabpages = true,
			clickable = true,
			exclude_ft = {},
			exclude_name = {},
			focus_on_close = 'previous',
			insert_at_start = true,
		},
		version = '>=1.9.1',
	},
	'tpope/vim-fugitive', -- keymaps
	'tpope/vim-obsession', -- keymaps
	{
		-- fully configure, this must be the best
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE: If you are having trouble with this installation,
				--			 refer to the README for telescope-fzf-native for more instructions.
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
	},
	{
		-- fully configure if best/unique
		-- <leader><motion> often conflicts with mappings
		'chaoren/vim-wordmotion',
		config = function() vim.g.wordmotion_prefix ='<leader>' end,
	},
	{
		-- fully configure if best
		-- should maybe appear in buffer below? how to close easily?
		'akinsho/toggleterm.nvim', version = '*', config = true
	},
	{ 'numToStr/Comment.nvim', opts = {} }, -- configure if best
	{
		'okuuva/auto-save.nvim', -- fully configure if best
		opts = {
			enabled = true,
			execution_message = { message = '', dim = 0, cleaning_interval = 0 },
			trigger_events = {
				immediate_save = { "BufLeave", "FocusLost" },
				defer_save = { "InsertLeave", "TextChanged" },
				cancel_defered_save = { "InsertEnter" },
			},
			condition = function(buf)
				local fn = vim.fn
				local utils = require("auto-save.utils.data")
				if -- just return?
					fn.getbufvar(buf, "&modifiable") == 1 and
					utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
					return true
				end
				return false
			end,
			write_all_buffers = false,
			noautocmd = false,
			lockmarks = false,
			debounce_delay = 1000,
			debug = false }
	},
	{ "cappyzawa/trim.nvim", opts = {} },
	{
		-- fully configure if best, get C++, python, CMake, etc. support
		-- search 'lspconfig' below
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},
	{
		-- Autocompletion
		-- fully configure if best;	both tab and enter autocomplete
		-- only tab and allow going to next line
		-- can tab only once on new lines before suggestions show up and overtake the key press
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',
			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		-- probably unique? understand configuration and fully set up
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				vim.keymap.set({ 'n', 'v' }, ']c', function()
					if vim.wo.diff then
						return ']c'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
				vim.keymap.set({ 'n', 'v' }, '[c', function()
					if vim.wo.diff then
						return '[c'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
			end,
		},
	},
	{
		-- Add indentation guides even on blank lines
		-- fully configure if unique/best
		-- rainbow-delimiters.nvim integration probably worth at least looking into
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},
	{
		-- Highlight, edit, and navigate code
		-- primarily more/better code highlights
		-- fully configure if best; add cpp, etc.
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},
	-- consider below:
	-- require 'kickstart.plugins.autoformat',
	-- require 'kickstart.plugins.debug',
}, {}) -- what's this last {} about?

-- Arista
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	pattern = {"*.tac", "*.tin", "*.itin", "*.arx"},
	command = "setfiletype cpp"
})

vim.g.NERDCreateDefaultMappings = 1
vim.g.NERDSpaceDelims = 1
vim.g.NERDCompactSexyComs = 1
vim.g.NERDDefaultAlign = 'left'
vim.g.NERDAltDelims_cxx = 1
vim.g.NERDCommentEmptyLines = 0
vim.g.NERDTrimTrailingWhitespace = 0
vim.g.NERDToggleCheckAllLines = 1

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			-- Change cwd to the opened directory, not the current working directory
			cwd = vim.fn.expand('%:p:h')
		},
		live_grep = {
			theme = "dropdown",
			cwd = vim.fn.expand('%:p:h')
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require('telescope.builtin').live_grep({
			search_dirs = {git_root},
		})
	end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files)
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>')
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics)
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume)

-- Set the working directory to the directory where Vim was opened
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        -- Check if an argument was provided at startup
        local arg = vim.fn.argv(0)
        if arg ~= "" then
            -- Get the full path of the argument
            local path = vim.fn.fnamemodify(arg, ":p")
            if vim.fn.isdirectory(path) == 1 then
                -- If the argument is a directory, set it as the working directory
                vim.cmd("silent! lcd " .. path)
            else
                -- If the argument is a file, set its directory as the working directory
                local file_dir = vim.fn.fnamemodify(path, ":p:h")
                vim.cmd("silent! lcd " .. file_dir)
            end
        end
    end,
})

-- [[ Basic Keymaps ]]

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
	require('nvim-treesitter.configs').setup {
		ensure_installed = { 'cpp', 'lua', 'python', 'vimdoc', 'vim', 'bash' },

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = false,

		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<c-space>',
				node_incremental = '<c-space>',
				scope_incremental = '<c-s>',
				node_decremental = '<M-space>',
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
			swap = {
				enable = true,
				swap_next = {
					['<leader>a'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>A'] = '@parameter.inner',
				},
			},
		},
	}
end, 0)

-- Define the mapping globally using the Lua API
require("toggleterm").setup{
	size = 20,
	open_mapping = nil,
	shade_terminals = true,
	direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
	float_opts = {
		border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved' | 'rounded'
	}
}

-- [[ Configure LSP ]]
--	This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	-- See `:help K` for why this keymap
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	-- Lesser used LSP functionality
	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--	Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--	Add any additional override configuration in the following tables. They will be passed to
--	the `settings` field of the server config. You must look up that documentation yourself.
--
--	If you want to override the default filetypes that your language server will attach to you can
--	define the property 'filetypes' to the map in question.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		}
	end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- -- OR setup with some options
-- require("nvim-tree").setup({
--   sort = {
--     sorter = "case_sensitive",
--   },
--   view = {
--     width = 30,
--   },
--   renderer = {
--     group_empty = true,
--   },
--   filters = {
--     dotfiles = true,
--   },
-- })

vim.cmd('NvimTreeOpen')

-- Arista
-- vim.opt.colorcolumn = '85'
-- vim.api.nvim_create_autocmd('BufReadPre', {
-- 	pattern = '*',
-- 	callback = function()
-- 		local bufname = vim.fn.expand('%:p')
-- 		if vim.bo.buftype == '' and vim.bo.modifiable and vim.fn.filereadable(bufname) then
-- 			vim.fn.system('a p4 edit ' .. vim.fn.shellescape(bufname, true) .. ' >/dev/null 2>&1')
-- 		end
-- 	end })
-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
-- 	pattern = {"*.tac", "*.tin", "*.itin", "*.arx"},
-- 	command = "setfiletype cpp" })

map('S', ':%s//g<Left><Left>') -- overwritten if put at top?
