-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
--
return {
  { "nvim-telescope/telescope-file-browser.nvim" },
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },
  {
    "simrat39/symbols-outline.nvim",
    enabled = false,
  },
  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  { "flash.nvim", enabled = false },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "rhysd/clever-f.vim" },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>", desc = "Copy Git Link" },
      {
        "<leader>gY",
        "<cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require('gitlinker.actions').open_in_browser})<cr>",
        desc = "Open Git Link",
      },
    },
    opts = {},
  },
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
      },
      {
        "<leader>fl",
        function()
          require("telescope.builtin").live_grep()
        end,
      },
      {
        "<leader>fs",
        function()
          require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
        end,
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
      },
      {
        "<leader>f=",
        function()
          require("telescope.builtin").resume()
        end,
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        terraformls = {},
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local nvim_lsp = require("lspconfig")
      nvim_lsp.denols.setup({
        on_attach = on_attach,
        root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
      })

      nvim_lsp.tsserver.setup({
        on_attach = on_attach,
        root_dir = nvim_lsp.util.root_pattern("package.json"),
        single_file_support = false,
      })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = function()
      local null_ls = require("null-ls")
      return {
        -- Primary Source of Truth is null-ls.
        sources = {
          -- -- JavaScript
          -- null_ls.builtins.formatting.prettierd.with({
          --   condition = function(utils)
          --     return not utils.root_has_file({ "biome.json", "biome.jsonc", "deno.json", "deno.jsonc" })
          --   end,
          -- }),
          -- Protocol Buffers
          null_ls.builtins.diagnostics.buf,
          null_ls.builtins.formatting.buf,
          -- Dockerfile
          null_ls.builtins.diagnostics.hadolint,
          -- GitHub Actions
          null_ls.builtins.diagnostics.actionlint,
          -- ShellScript
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "2" },
          }),
          -- Lua
          null_ls.builtins.formatting.stylua,
          -- not supported by mason
          -- Nix
          -- null_ls.builtins.formatting.nixfmt,
        },
        debug = true,
      }
    end,
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "diff",
        "dockerfile",
        "gitignore",
        "go",
        "graphql",
        "html",
        "javascript",
        "json",
        "jsonnet",
        "lua",
        "markdown",
        "markdown_inline",
        "proto",
        "python",
        "query",
        "regex",
        "ruby",
        "sql",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      -- opts.mapping = cmp.mapping.preset.insert({
      --   ["<C-p>"] = cmp.mapping.select_prev_item(),
      --   ["<C-n>"] = cmp.mapping.select_next_item(),
      --   ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      --   ["<C-f>"] = cmp.mapping.scroll_docs(4),
      --   ["<C-e>"] = cmp.mapping.abort(),
      --   ["<CR>"] = cmp.mapping.confirm({
      --     behavior = cmp.ConfirmBehavior.Replace,
      --     select = false,
      --   }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      -- })
      -- opts.sources = cmp.config.sources({
      --   { name = "nvim_lsp" },
      --   { name = "nvim_lsp_signature_help" },
      --   { name = "copilot" },
      --   { name = "vsnip" }, -- For vsnip users.
      -- }, {
      --   { name = "buffer" },
      -- })
      -- opts.formatting = {
      --   format = lspkind.cmp_format({
      --     mode = "symbol",
      --     maxwidth = 50,
      --     ellipsis_char = "...",
      --   }),
      -- }
    end,
  },
}
