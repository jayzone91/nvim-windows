return {
  "neovim/nvim-lspconfig",
  lazy = true,
  event = "BufEnter",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          "luvit-meta/library",
        },
      },
      dependencies = "Bilal2453/luvit-meta",
    },
    { "j-hui/fidget.nvim", opts = {} },
    "b0o/SchemaStore.nvim",
    -- CMP
    {
      "hrsh7th/nvim-cmp",
      lazy = true,
      event = "BufEnter",
      dependencies = {
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip",
        {
          "L3MON4D3/LuaSnip",
          version = "v2.*",
          build = (not vim.uv.os_uname().sysname:find("Windows") ~= nil)
              and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or nil,
        },
        "rafamadriz/friendly-snippets",
      },
    },
    -- Formatter
    {
      "stevearc/conform.nvim",
      event = "BufEnter",
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          markdown = { "prettierd" },
          html = { "prettierd" },
          css = { "prettierd" },
          scss = { "prettierd" },
          javascript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          json = { "prettierd" },
          php = { "php-cs-fixer" },
          python = { "isort", "black" },
          sql = { "sql-formatter" },
          zsh = { "beatysh" },
          -- Use the "*" filetype to run formatters on all filetypes.
          ["*"] = { "codespell" },
          -- Use the "_" filetype to run formatters on filetypes that don't
          -- have other formatters configured.
        },
        -- linters
        {
          "mfussenegger/nvim-lint",
          event = { "BufEnter", "InsertLeave" },
          config = function()
            require("lint").linters_by_ft = {
              css = { "stylelint" },
              javascript = { "eslint" },
              typescript = { "eslint" },
              javascriptreact = { "eslint" },
              typescriptreact = { "eslint" },
              json = { "jsonlint" },
              html = { "htmlhint" },
              php = { "phpcs" },
              python = { "ruff" },
              markdown = { "markdownlint" },
              sql = { "sqlfluff" },
              lua = { "luacheck" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
              callback = function()
                require("lint").try_lint()
              end,
            })
          end,
        },
      },
      config = function(_, opts)
        require("conform").setup(opts)

        vim.api.nvim_create_autocmd("BufWritePre", {
          callback = function(args)
            require("conform").format({
              bufnr = args.buf,
              lsp_fallback = true,
              quiet = true,
              async = false,
            })
          end,
        })
      end,
    },
    -- Mason
    {
      "williamboman/mason.nvim",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
    },
  },
  opts = function()
    return {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local servers = {
      bashls = true,
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
      lua_ls = {
        settings = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enabled = true,
          },
          completion = {
            callSnippet = "replace",
          },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
      rust_analyzer = true,
      cssls = true,
      tsserver = true,
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      },
      emmet_ls = true,
      docker_compose_language_service = true,
      dockerls = true,
      html = true,
      intelephense = true,
      marksman = true,
      prismals = true,
      pyright = true,
      sqls = true,
      tailwindcss = true,
      taplo = true,
    }

    local linters = {
      "stylelint", -- css
      "eslint", -- ts, tsx, js, jsx
      "jsonlint", -- json
      "htmlhint", -- html
      "phpcs", -- php
      "ruff", -- python
      "markdownlint", -- markdown
      "sqlfluff", -- sql,
      "luacheck", -- lua
    }

    local formatters = {
      "stylua", -- lua formatter
      "prettierd", -- html, css, ts, tsx, js, jsx, scss, json, md formatter
      "php-cs-fixer", -- php formatter
      "isort", -- python import sorter
      "black", -- python formatter
      "sql-formatter", -- sql formatter
      "beautysh", -- zsh formatter
      "codespell", -- spelling
    }
    -- Mason
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    require("mason-lspconfig").setup()

    local servers_to_install = vim.tbl_filter(function(key)
      return servers[key]
    end, vim.tbl_keys(servers))

    local ensure_installed = {}

    vim.list_extend(ensure_installed, servers_to_install)
    vim.list_extend(ensure_installed, formatters)
    vim.list_extend(ensure_installed, linters)

    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
      auto_update = true,
      run_on_start = true,
      start_delay = 3000, -- 3 Seconds
      -- debounce_hours = 5, -- at least 5 hours between attempts to install/update
      integrations = {
        ["mason-lspconfig"] = true,
      },
    })

    -- CMP Config
    local lspkind = require("lspkind")
    lspkind.init()

    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinser",
      },
      snippet = {
        -- REQUIRED
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "lazydev", group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        ---@diagnostic disable-next-line:missing-fields
        {
          { name = "path" },
          { name = "buffer" },
        },
        ---@diagnostic disable-next-line:missing-fields
        {
          { name = "luasnip" },
          { name = "rg" },
        },
      },
      sorting = defaults.sorting,
    })

    -- LSP Config
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local lspconfig = require("lspconfig")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities(),
      opts.capabilities
    )

    for name, config in pairs(servers) do
      if config == true then
        config = {}
      end
      config = vim.tbl_deep_extend(
        "force",
        { capabilities = vim.deepcopy(capabilities) },
        { capabilities = capabilities },
        config
      )

      lspconfig[name].setup(config)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local client = assert(
          vim.lsp.get_client_by_id(args.data.client_id),
          "must have valid client"
        )

        local settings = servers[client.name]
        if type(settings) ~= "table" then
          settings = {}
        end

        local has_telescope, builtin = pcall(require, "telescope.builtin")
        if not has_telescope then
          return
        end

        vim.opt_local_omnifunc = "v:lua.vim.lsp.omnifunc"
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
        vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
        vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
        vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { buffer = 0 })
        vim.keymap.set("n", "rn", vim.lsp.buf.rename, { buffer = 0 })

        if settings.server_capabilities then
          for k, v in pairs(settings.server_capabilities) do
            if v == vim.NIL then
              v = nil
            end
            client.server_capabilities[k] = v
          end
        end
      end,
    })
  end,
}
