vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- "super necessary"
  {
    "letieu/btw.nvim",
    config = function()
      require('btw').setup()
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      ---@class snacks.animate.Config
      ---@field easing? snacks.animate.easing|snacks.animate.easing.Fn
      animate = {
        ---@type snacks.animate.Duration|number
        duration = 20, -- ms per step
        easing = "linear",
        fps = 60, -- frames per second. Global setting for all animations
      },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      },
      ---@class snacks.picker.Config
      ---@field source? string source name and config to use
      ---@field pattern? string|fun(picker:snacks.Picker):string pattern used to filter items by the matcher
      ---@field search? string|fun(picker:snacks.Picker):string search string used by finders
      ---@field cwd? string current working directory
      ---@field live? boolean when true, typing will trigger live searches
      ---@field limit? number when set, the finder will stop after finding this number of items. useful for live searches
      ---@field ui_select? boolean set `vim.ui.select` to a snacks picker
      --- Source definition
      ---@field items? snacks.picker.finder.Item[] items to show instead of using a finder
      ---@field format? snacks.picker.format|string format function or preset
      ---@field finder? snacks.picker.finder|string finder function or preset
      ---@field preview? snacks.picker.preview|string preview function or preset
      ---@field matcher? snacks.picker.matcher.Config matcher config
      ---@field sort? snacks.picker.sort|snacks.picker.sort.Config sort function or config
      --- UI
      ---@field win? snacks.picker.win.Config
      ---@field layout? snacks.picker.layout.Config|string|{}|fun(source:string):(snacks.picker.layout.Config|string)
      ---@field icons? snacks.picker.icons
      ---@field prompt? string prompt text / icon
      --- Preset options
      ---@field previewers? snacks.picker.preview.Config
      ---@field sources? snacks.picker.sources.Config|{}
      ---@field layouts? table<string, snacks.picker.layout.Config>
      --- Actions
      ---@field actions? table<string, snacks.picker.Action.spec> actions used by keymaps
      ---@field confirm? snacks.picker.Action.spec shortcut for confirm action
      ---@field auto_confirm? boolean automatically confirm if there is only one item
      ---@field main? snacks.picker.main.Config main editor window config
      ---@field on_change? fun(picker:snacks.Picker, item:snacks.picker.Item) called when the cursor changes
      ---@field on_show? fun(picker:snacks.Picker) called when the picker is shown
      picker = {
        prompt = " ",
        sources = {},
        layout = {
          cycle = true,
          --- Use the default layout or vertical if the window is too narrow
          preset = function()
            return vim.o.columns >= 120 and "default" or "vertical"
          end,
        },
        ui_select = true, -- replace `vim.ui.select` with the snacks picker
        previewers = {
          file = {
            max_size = 1024 * 1024, -- 1MB
            max_line_length = 500,
          },
        },
        win = {
          -- input window
          input = {
            keys = {
              ["<Esc>"] = "close",
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<c-c>"] = { "close", mode = { "n", "i" } },
              ["<CR>"] = {"confirm", mode = {"n", "i"}},
              ["G"] = "list_bottom",
              ["gg"] = "list_top",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["/"] = "toggle_focus",
              ["q"] = "close",
              ["?"] = "toggle_help",
              ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
              ["<a-P>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<c-b>"] = { "cycle_win", mode = { "i", "n" } },
              ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
              ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
              ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
              ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
              ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
              ["<S-Right>"] = { "select_and_next", mode = { "i", "n" } },
              ["<S-Left>"] = { "select_and_prev", mode = { "i", "n" } },
              ["<Down>"] = { "list_down", mode = { "i", "n" } },
              ["<Up>"] = { "list_up", mode = { "i", "n" } },
              ["<c-j>"] = { "list_down", mode = { "i", "n" } },
              ["<c-k>"] = { "list_up", mode = { "i", "n" } },
              ["<c-n>"] = { "list_down", mode = { "i", "n" } },
              ["<c-p>"] = { "list_up", mode = { "i", "n" } },
              ["<S-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<S-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<a-I>"] = { "toggle_live", mode = { "i", "n" } },
              ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<ScrollWheelDown>"] = { "list_scroll_wheel_down", mode = { "i", "n" } },
              ["<ScrollWheelUp>"] = { "list_scroll_wheel_up", mode = { "i", "n" } },
              ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
              -- ["<c-q>"] = {
              --   function()
              --     print("hi there")
              --   end,
              --   mode = { "i", "n" }
              -- },
              ["<c-q>"] = { "qflist", mode = { "i", "n" } },
              ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
              ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            },
            b = {
              minipairs_disable = true,
            },
          },
          -- result list window
          list = {
            keys = {
              ["<CR>"] = "confirm",
              ["<C-c>"] = "close",
              ["gg"] = "list_top",
              ["G"] = "list_bottom",
              ["i"] = "focus_input",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["q"] = "close",
              ["<Tab>"] = "select_and_next",
              ["<S-Tab>"] = "select_and_prev",
              ["<S-Right>"] = "select_and_next",
              ["<S-Left>"] = "select_and_prev",
              ["<Down>"] = "list_down",
              ["<Up>"] = "list_up",
              ["<c-d>"] = "list_scroll_down",
              ["<c-u>"] = "list_scroll_up",
              ["zt"] = "list_scroll_top",
              ["zb"] = "list_scroll_bottom",
              ["zz"] = "list_scroll_center",
              ["/"] = "toggle_focus",
              ["<ScrollWheelDown>"] = "list_scroll_wheel_down",
              ["<ScrollWheelUp>"] = "list_scroll_wheel_up",
              ["<S-Down>"] = "preview_scroll_down",
              ["<S-Up>"] = "preview_scroll_up",
              ["<c-v>"] = "edit_vsplit",
              ["<c-s>"] = "edit_split",
              ["<c-j>"] = "list_down",
              ["<c-k>"] = "list_up",
              ["<c-n>"] = "list_down",
              ["<c-p>"] = "list_up",
              ["<c-b>"] = "cycle_win",
              ["<Esc>"] = "close",
            },
          },
          -- preview window
          preview = {
            minimal = false,
            wo = {
              cursorline = false,
              colorcolumn = "",
            },
            keys = {
              ["<Esc>"] = "close",
              ["<c-c>"] = "close",
              ["q"] = "close",
              ["i"] = "focus_input",
              ["<ScrollWheelDown>"] = "list_scroll_wheel_down",
              ["<ScrollWheelUp>"] = "list_scroll_wheel_up",
              ["<c-b>"] = "cycle_win",
              ["<a-m>"] = "toggle_maximize",
            },
          },
        },
        ---@class snacks.picker.icons
        icons = {
          indent = {
            vertical    = "│ ",
            middle = "├╴",
            last   = "└╴",
          },
          ui = {
            live        = "󰐰 ",
            selected    = "● ",
            -- selected = " ",
          },
          git = {
            commit = "󰜘 ",
          },
          diagnostics = {
            Error = " ",
            Warn  = " ",
            Hint  = " ",
            Info  = " ",
          },
          kinds = {
            Array         = " ",
            Boolean       = "󰨙 ",
            Class         = " ",
            Color         = " ",
            Control       = " ",
            Collapsed     = " ",
            Constant      = "󰏿 ",
            Constructor   = " ",
            Copilot       = " ",
            Enum          = " ",
            EnumMember    = " ",
            Event         = " ",
            Field         = " ",
            File          = " ",
            Folder        = " ",
            Function      = "󰊕 ",
            Interface     = " ",
            Key           = " ",
            Keyword       = " ",
            Method        = "󰊕 ",
            Module        = " ",
            Namespace     = "󰦮 ",
            Null          = " ",
            Number        = "󰎠 ",
            Object        = " ",
            Operator      = " ",
            Package       = " ",
            Property      = " ",
            Reference     = " ",
            Snippet       = "󱄽 ",
            String        = " ",
            Struct        = "󰆼 ",
            Text          = " ",
            TypeParameter = " ",
            Unit          = " ",
            Uknown        = " ",
            Value         = " ",
            Variable      = "󰀫 ",
          },
        },
      },
    },
    keys = {
      -- START picker keys
      { "<leader>b", function() Snacks.picker.buffers({
        ---@class snacks.picker.buffers.Config: snacks.picker.Config
        ---@field hidden? boolean show hidden buffers (unlisted)
        ---@field unloaded? boolean show loaded buffers
        ---@field current? boolean show current buffer
        ---@field nofile? boolean show `buftype=nofile` buffers
        ---@field sort_lastused? boolean sort by last used
        ---@field filter? snacks.picker.filter.Config
        finder = "buffers",
        format = "buffer",
        hidden = false,
        unloaded = true,
        current = false,
        sort_lastused = true,
      }) end, desc = "Buffers" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>fw", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection", mode = { "x" } },
      { "<leader>fW", function() Snacks.picker.grep_word() end, desc = "Word under cursor", mode = { "n" } },
      { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Quickfix List" },
      { "<leader>fM", function() Snacks.picker.man() end, desc = "Quickfix List" },
      { "<leader>fd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>fo", function() Snacks.picker.lsp_symbols() end, desc = "Find LSP Symbols" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      -- END picker keys
       { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>Bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>cR", function() Snacks.rename() end, desc = "Rename File" },
      { "<leader>;",  function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },

  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      -- relative numbers on mini.files
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowUpdate',
        callback = function(args) vim.wo[args.data.win_id].relativenumber = true end,
      })

      require('mini.extra').setup()
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.fuzzy').setup()
      require('mini.git').setup()
      require('mini.diff').setup({
        view = {
          style = 'number',
          priority = 199,
        },
        mappings = {
          -- Apply hunks inside a visual/operator region
          apply = 'gh',

          -- Reset hunks inside a visual/operator region
          reset = 'gH',

          -- Hunk range textobject to be used inside operator
          textobject = 'gh',

          -- Go to hunk range in corresponding direction
          goto_first = 'HH',
          goto_prev = '', -- commented these as they were assigned in visual too. eww 
          goto_next = '',
          goto_last = 'H',
        },
        -- Various options
        options = {
          -- Diff algorithm. See `:h vim.diff()`.
          algorithm = 'histogram',

          -- Whether to use "indent heuristic". See `:h vim.diff()`.
          indent_heuristic = true,

          -- The amount of second-stage diff to align lines (in Neovim>=0.9)
          linematch = 60,

          -- Whether to wrap around edges during hunk navigation
          wrap_goto = true,
        },
      })
      -- require('mini.statusline').setup()
    end
  },

  -- colorscheme
  {
    'rmehri01/onenord.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onenord').setup({
        theme = 'dark',
        disable = {
          background = false
        },

        custom_highlights = {
          dark = {
            ["Normal"] = {
              bg = "#000",
            },

            ["NormalNC"] = {
              bg = "#000",
            }
          }
        }
      })
    end,
  },

  -- file explorer
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require('oil').setup({
        keymaps = {
          ["b"] = "actions.parent",
        }
      })
    end
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  },

  -- motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          jump_labels = true,
          label = { exclude = "hjkliIaArdcCvpPygSx" }
        },
        search = {
          enabled = false
        }
      }
    },
    keys = {
      {
        "<leader>K",
        mode = { "n" },
        function()
          -- More advanced example that also highlights diagnostics:
          require("flash").jump({
            matcher = function(win)
              ---@param diag Diagnostic
              return vim.tbl_map(function(diag)
                return {
                  pos = { diag.lnum + 1, diag.col },
                  end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                }
              end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
            end,
            action = function(match, state)
              vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, match.pos)
                vim.diagnostic.open_float()
              end)
              state:restore()
            end,
          })
        end,
        desc = "Flash search diagnostic"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      {
        "sw",
        mode = { "n", "x" },
        function()
          -- jump to word under cursor
          require("flash").jump({pattern = vim.fn.expand("<cword>")})
        end,
        desc = "Flash highlight word undor cursor"
      },
      {
        "ss",
        mode = { "n", "x" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash"
      },
      {
        "ss",
        mode = { "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash"
      },
      {
        "<leader>ss",
        mode = { "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter"
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<leader>t",
        mode = { "o", "x", "n" },
        function()
          local win = vim.api.nvim_get_current_win()
          local view = vim.fn.winsaveview()
          require("flash").jump({
            action = function(match, state)
              state:hide()
              vim.api.nvim_set_current_win(match.win)
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              require("flash").treesitter()
              vim.schedule(function()
                vim.api.nvim_set_current_win(win)
                vim.fn.winrestview(view)
              end)
            end,
          })
        end,
      },
    },
  },

  -- error handling
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
      modes = {
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
       "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- language extensions
  -- 'tpope/vim-liquid',
  -- 'pangloss/vim-javascript',
  -- 'leafgarland/typescript-vim',
  -- 'MaxMEllon/vim-jsx-pretty',
  -- 'peitalin/vim-jsx-typescript',
  -- 'neoclide/vim-jsx-improve',
  -- 'OlegGulevskyy/better-ts-errors.nvim',

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "c",
          "comment",
          "css",
          "dockerfile",
          "gitignore",
          "go",
          "graphql",
          "html",
          "http",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "liquid",
          "lua",
          "make",
          "nginx",
          "prisma",
          "regex",
          "rust",
          "scss",
          "tsx",
          "typescript",
          "vim",
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
        auto_install = true,

        indent = {
          enable = true
        },

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = { "markdown" },
        },
      })

      local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      treesitter_parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = {"src/parser.c", "src/scanner.c"},
          branch = "master",
        },
      }

      vim.treesitter.language.register("templ", "templ")
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
    },

    config = function()
      -- local cmp = require('cmp')
      local lspconfig = require("lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities())

      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ast_grep",
          "bashls",
          "biome",
          "clangd",
          "css_variables",
          "dockerls",
          "emmet_ls",
          "jsonls",
          "lua_ls",
          "rust_analyzer",
          "shopify_theme_ls",
          "superhtml",
          "tailwindcss",
          "ts_ls",
        },
        handlers = {
          function(server_name) -- default handler (optional)

            require("lspconfig")[server_name].setup {
              capabilities = capabilities,
            }
          end,

          ['rust_analyzer'] = function() end,

          ["lua_ls"] = function()
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                  }
                }
              }
            }
          end,
          ["emmet_ls"] = function()
            lspconfig.emmet_ls.setup {
              capabilities = capabilities,
              filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'liquid' },
              init_options = {
                html = {
                  options = {
                    -- for possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#l79-l267
                    ["bem.enabled"] = true,
                  },
                },
              },
            }
          end,
          --[[ ["rust_analyzer"] = function()
            lspconfig.emmet_ls.setup({
              capabilities = capabilities,
              filetypes = {"rust"},
              root_dir = 
            })
          end, ]]
        }
      })


      -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
      --
      -- cmp.setup({
      --   snippet = {
      --     expand = function(args)
      --       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      --     end,
      --   },
      --   mapping = cmp.mapping.preset.insert({
      --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      --     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      --     ["<C-Space>"] = cmp.mapping.complete(),
      --   }),
      --   sources = cmp.config.sources({
      --     { name = 'nvim_lsp' },
      --     { name = 'luasnip' }, -- For luasnip users.
      --   }, {
      --       { name = 'buffer' },
      --     })
      -- })

      vim.diagnostic.config({
        -- update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        virtual_text = false,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          vim.keymap.set('n', '<leader>ra', vim.lsp.buf.rename, { buffer = args.buf })
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { buffer = args.buf })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = args.buf })
          -- this is a key map to taggle virtual_text. Needs to read if it is currently true or false
          -- vim.keymap.set('n', 'ltd', function ()
          --
          -- end, { buffer = args.buf })
        end,
      })
    end
  },

  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  {
    'dense-analysis/ale',
    config = function()
      -- Configuration goes here.
      local g = vim.g

      g.ale_ruby_rubocop_auto_correct_all = 1

      g.ale_linters = {
        ruby = {'rubocop', 'ruby'},
        lua = {'lua_language_server'},
        liquid = 'all'
      }
    end
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- cmp sources plugins
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function ()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      -- local suggestion = require('supermaven-nvim.completion_preview')
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      cmp.setup ({
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
          -- ['<CR>'] = cmp.mapping.confirm {
          --   behavior = cmp.ConfirmBehavior.Replace,
          --   select = true,
          -- },
          ["<C-y>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                -- toggle_completion()
              else
                fallback()
              end
            end,
          }),
          -- ['<Tab>'] = cmp.mapping(function(fallback)
          --   if suggestion.has_suggestion() then
          --     suggestion.on_accept_suggestion()
          --     cmp.close()
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 's' }),
          -- ["<C-k>"] = cmp.mapping({
          --   i = function()
          --     if cmp.visible() then
          --       cmp.abort()
          --       toggle_completion()
          --     else
          --       cmp.complete()
          --       toggle_completion()
          --     end
          --   end,
          -- }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { name = "luasnip" },
          { name = "nvim_lua" },
          -- { name = "supermaven" },
          { name = "codeium" },
          -- { name = "orgmode" },
        },
        formatting = {
          format = function(entry, vim_item)
            -- this wiil remove duplicated completion items
            vim_item.dup = ({
              buffer = 0,
              nvim_lsp = 0,
              nvim_lua = 0,
              luasnip = 0,
              -- supermaven = 0,
            })[entry.source.name] or 0
            return vim_item
          end,
        },
        completion = {
          completeopt = "menu,menuone",
        },
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,PmenuSel:PmenuSel",
            side_padding = 1,
            scrollbar = false,
            border = border "CmpBorder",
          },
          documentation = {
            border = border "CmpDocBorder",
            winhighlight = "Normal:CmpDoc",
          },
        },
      })
    end
  },

  {
    "chipsenkbeil/org-roam.nvim",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        config = function() 
          require("orgmode").setup {
            org_startup_indented = true,
            org_indent_mode_turns_off_org_adapt_indentation = true,
            org_hide_leading_stars = true,
            org_indent_mode_turns_on_hiding_stars = true,
            org_id_ts_format = "%Y%m%d%H%M%S",
            org_id_method = "ts", -- uses timestamp as the id
            org_blank_before_new_entry = {
              heading = true,
              plain_list_item = false,
            },
            org_agenda_files = '~/orgfiles/**/*',
            org_default_notes_file = '~/orgfiles/inbox.org',
            mappings = {
              org = {
                org_meta_return = "<leader>n",
                org_deadline = "<leader>d",
              },
            }
          }
        end
      },
    },
    config = function()
      require("org-roam").setup({
        directory = "~/orgfiles",
        -- optional
        org_files = {
          org_agenda_files = '~/orgfiles/**/*',
          org_default_notes_file = '~/orgfiles/inbox.org',
        },
        templates = {
          d = {
            description = "default",
            template = "%?",
            target = "inbox/%[title].org",
          },
          P = {
            description = "people",
            template = "%?",
            target = "extras/people/%[title].org",
          },
          p = {
            description = "project",
            template = "%?",
            target = "projects/%[title].org",
          },
          m = {
            description = "meeting",
            template = "Meeting on %<%A, %m/%d/%Y at %I:%M%p>\n\n%?",
            target = "timestamps/meetings/%<%Y-%m-%d> %[title].org",
          },
          j = {
            description = 'journal',
            template = 'Journal entry for %<%A, %m/%d/%Y>\n\n%?',
            target = 'journals/%<%Y-%m-%d-%a>/%[title].org'
          }
        },
      })
    end
  },

  {
    'akinsho/org-bullets.nvim',
    config = function()
      require('org-bullets').setup()
    end
  },

  {
    'andreadev-it/orgmode-multi-key',
    event = "VeryLazy",
    config = function()
      require('orgmode-multi-key').setup()
    end
  }
})

require('dougluas')

