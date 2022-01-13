local ts_status, ts = pcall(require, 'nvim-treesitter.configs')
if(ts_status) then
  ts.setup {
    ensure_installed = {
      'bash',
      'c',
      'css',
      'dart',
      'go',
      'html',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'kotlin',
      'lua',
      'python',
      'rust',
      'toml',
      'vim',
      'yaml'
    },
    highlight = {
      enable = true,              -- false will disable the whole extension
      -- disable = { "c", "rust" },
      additional_vim_regex_highlighting = false,
    },
  }
end


