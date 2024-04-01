{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = neodev-nvim;
      type = "lua";
      config = /* lua */ ''
        require('neodev').setup()
      '';
    }
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = /* lua */ ''
        local lspconfig = require('lspconfig')
        function add_lsp(server, options)
          if not options["cmd"] then
            options["cmd"] = server["document_config"]["default_config"]["cmd"]
          end
          if not options["capabilities"] then
            options["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
          end

          -- if vim.fn.executable(options["cmd"][1]) == 1 then
          --   server.setup(options)
          -- end
          if server.setup then
            server.setup(options)
          end
        end

        add_lsp(lspconfig.dockerls, {})
        add_lsp(lspconfig.bashls, {})
        add_lsp(lspconfig.clangd, {})
        add_lsp(lspconfig.pylsp, {})
        add_lsp(lspconfig.lua_ls, {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              }
            }
          }
        })
        add_lsp(lspconfig.tsserver, {})
        add_lsp(lspconfig.nil_ls, {
          settings = {
            formatting = {
              command = { "nixpkgs-fmt" },
            }
          }
        })
      '';
    }
    # LSP support for embedded code blocks

    {
      plugin = otter-nvim;
      type = "lua";
      config = /* lua */ ''
        local otter = require('otter')
        otter.setup({
          lsp = {
            hover = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
            diagnostic_update_events = { "BufWritePost" },
          },
          buffers = {
            set_filetype = false,
            write_to_disk = false,
          },
          strip_wrapping_quote_characters = { "'", '"', "`" },
          handle_leading_whitespace = false,
        })
        otter.activate({"python", "lua", "typescript", "javascript", "bash", "dockerfile"}, true, true, )
      '';
    }
    rustaceanvim

    # snippets
    luasnip

    # completions
    cmp-nvim-lsp
    cmp_luasnip

    cmp-buffer
    cmp-path
    {
      plugin = cmp-git;
      type = "lua";
      config = /* lua */ ''
        require('cmp_git').setup({})
      '';
    }

    # completion pictograms
    lspkind-nvim
    {
      plugin = nvim-cmp;
      type = "lua";
      config = /* lua */ ''
        local cmp = require('cmp')
        cmp.setup({
            formatting = {
              format = require('lspkind').cmp_format({
                before = function (entry, vim_item)
                  return vim_item
                end
              }),
            },
            snippet = {
                expand = function(args)
                    require('luasnip').expand_snippet(args.body)
                end,
            },
            sources = cmp.config.sources({
              { name = 'otter' },
              { name = 'nvim_lsp' },
            },
            {
              { name = 'luasnip' },
              { name = 'git' },
              { name = 'buffer', option = { get_bufnrs = vim.api.nvim_list_bufs }},
              { name = 'path' },
            }),
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.close(),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
            }),
        })
      '';
    }
  ];

  home.packages = with pkgs; [
    # LSP servers
    nodePackages.bash-language-server
    dockerfile-language-server-nodejs
    python311Packages.python-lsp-server
    nodePackages.typescript-language-server
    lua-language-server
    rust-analyzer
    nil
  ];
}
