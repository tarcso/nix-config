{ config, pkgs, ... }:
{
  imports = [
  ];
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;

    extraConfig = ''
      	filetype plugin indent on
      	syntax on
      	set number
      	set autoindent
      	set tabstop=4
      	set shiftwidth=4
      	set expandtab
      	set hlsearch
      	set mouse=a
      	set incsearch
      	set t_Co=256
      	let base16colorspace=256
      	set termguicolors
      	set noshowmode
      	set listchars=tab:→\ ,nbsp:+,space:·
      	set timeoutlen=250

      	hi! link @variable Normal

      	set pastetoggle=<F2>
      	 
      	let mapleader = ","
      	 
      	" Quitting, saving
      	nnoremap <leader>w <cmd>w<cr>
      	nnoremap <leader>W <cmd>w !sudo tee % >/dev/null<cr>
      	 
      	nnoremap <leader>q <cmd>q<cr>
      	nnoremap <leader>Q <cmd>q!<cr>
      	 
      	nnoremap <leader>x <cmd>x<cr>

      	" Buffers
      	nnoremap <silent><leader>, <cmd>b#<cr>

      	" Tabs
      	nnoremap <leader>t <cmd>tabnew<cr>

      	" Clipboard
      	nnoremap <leader>y "+y
      	nnoremap <leader>Y "*y

      	nnoremap <leader>p "+p
      	nnoremap <leader>P "*p

      	" Splitting
      	nnoremap <leader>v <cmd>vsplit<cr>
      	nnoremap <leader>s <cmd>split<cr>

      	" Window navigation
      	nnoremap <M-Left> <C-W>h
      	nnoremap <M-Right> <C-W>l
      	nnoremap <M-Up> <C-W>k
      	nnoremap <M-Down> <C-W>j

      	nnoremap <M-Left> <C-W>h
      	nnoremap <M-Right> <C-W>l
      	nnoremap <M-Up> <C-W>k
      	nnoremap <M-Down> <C-W>j

      	nnoremap <leader><Left> <C-W>H
      	nnoremap <leader><Right> <C-W>L
      	nnoremap <leader><Up> <C-W>K
      	nnoremap <leader><Down> <C-W>J

      	nnoremap <S-Left> <C-W>>
      	nnoremap <S-Right> <C-W><
      	nnoremap <S-Up> <C-W>-
      	nnoremap <S-Down> <C-W>+
    '';

    extraLuaConfig = ''
      	-- Ranger
      	vim.api.nvim_set_keymap('n', '<leader>ff', ':RangerEdit<CR>', { noremap = true, silent = true })

      	-- Telescope
      	vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<CR>', { noremap = true, silent = true })

      	-- Copilot
      	vim.g.copilot_no_tab_map = true
      	vim.g.copilot_assume_mapped = true
      	vim.g.copilot_tab_fallback = ""

      	vim.keymap.set('i', '<leader><tab>', 'copilot#Accept("<CR>")',
      	    { expr = true, noremap = true, silent = true, script = true, replace_keycodes = false })
    '';

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      ranger-vim
      copilot-vim

      nvim-lspconfig
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          		local cmp = require('cmp')

          		cmp.setup({
          		    snippet = {
          			expand = function(args)
          			    require('snippy').expand_snippet(args.body)
          			end,
          		    },
          		    sources = cmp.config.sources({
          			{ name = 'nvim_lsp' },
          		    }, {
          			{ name = 'buffer' },
          			{ name = 'snippy' },
          		    }),
          		    mapping = cmp.mapping.preset.insert({
          			['<C-Space>'] = cmp.mapping.complete(),
          			['<C-e>'] = cmp.mapping.close(),
          			['<Tab>'] = cmp.mapping.confirm({ select = true }),
          		    }),
          		})
          	'';
      }
      cmp-nvim-lsp
      neodev-nvim

      nvim-snippy
      cmp-snippy
      vim-snippets
    ];
  };

  xdg.configFile."nvim/init.lua".onChange = ''
    XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
    for server in $XDG_RUNTIME_DIR/nvim.*; do
      nvim --server $server --remote-send '<Esc>:source $MYVIMRC<CR>' &
    done
  '';
}
