local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require 'paq' {
  'savq/paq-nvim';                  -- Let Paq manage itself
  'neovim/nvim-lspconfig';
  'nvim-lua/plenary.nvim';
  'nvim-telescope/telescope.nvim';
  'jose-elias-alvarez/null-ls.nvim';
  'kosayoda/nvim-lightbulb';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/nvim-cmp';
  'nvim-lualine/lualine.nvim';
  'kyazdani42/nvim-web-devicons';
  'L3MON4D3/LuaSnip';
  'saadparwaiz1/cmp_luasnip';
  'bluz71/vim-moonfly-colors';
  'lewis6991/gitsigns.nvim';
  'nvim-treesitter/nvim-treesitter';
  'onsails/lspkind-nvim';
  -- 'lukas-reineke/indent-blankline.nvim';
}

vim.cmd [[colorscheme moonfly]]
vim.opt.termguicolors = true

local ll_status, lualine = pcall(require, "lualine")
if(ll_status) then
  lualine.setup{
	  options = {theme = 'moonfly'},
    tabline = {
      lualine_a = {
        {
          'buffers',
				}
      },
    },
  }
end

local gs_status, gitsigns = pcall(require, "gitsigns")
if(gs_status) then
  gitsigns.setup()
end

-- Setup autocompletion with nvim-cmp
local cmp_status, cmp = pcall(require, 'cmp')
if(cmp_status) then
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
		vim.cmd([[
		augroup LspFormatting
				autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
		augroup END
		]])
	end
  buf_set_keymap('n', '<space>]', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
end


-- Setup lspconfig.
local cmp_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if(cmp_lsp_status and lspconfig_status) then

  local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  lspconfig.bashls.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
  lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
  lspconfig.jsonls.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
  lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
  lspconfig.eslint.setup {
    capabilities = capabilities,
    on_attach = on_attach
  }
end

local lspkind_status, lspkind = pcall(require, "lspkind")
if(lspkind_status and cmp_status) then
  cmp.setup {
    formatting = {
      format = lspkind.cmp_format({with_text = true})
    }
  }
end

local nullls_status, nullls = pcall(require, "null-ls")
if(nullls_status) then
	nullls.setup({
		on_attach = on_attach,
		sources = {
			require("null-ls").builtins.formatting.sqlformat.with({args = {'-d', '    '}}),
			-- require("null-ls").builtins.formatting.stylua,
			-- require("null-ls").builtins.completion.spell,
		},
	})
end
