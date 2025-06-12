if vim.g.neovide then
  return {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode {},
        status.component.git_branch(),
        status.component.file_info(),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp {
          lsp_progress = false,
        },
        status.component.virtual_env(),
        status.component.treesitter(),
        status.component.mode { surround = { separator = "right" } },
      }
    end,
  }
else
  return {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = {
        -- add new user interface icon
        icons = {
          VimIcon = "",
          ScrollText = "",
        },
        -- modify variables used by heirline but not defined in the setup call directly
        status = {
          -- define the separators between each section
          separators = {
            left = { "", "" }, -- separator for the left side of the statusline
            right = { " ", "" }, -- separator for the right side of the statusline
            tab = { "", "" },
          },
          -- add new colors that can be used by heirline
          colors = function(hl)
            local get_hlgroup = require("astroui").get_hlgroup
            -- use helper function to get highlight group properties
            hl.blank_bg = get_hlgroup("Folded").fg
            hl.file_info_bg = get_hlgroup("Visual").bg
            hl.nav_icon_bg = get_hlgroup("String").fg
            hl.nav_fg = hl.nav_icon_bg
            hl.folder_icon_bg = get_hlgroup("Error").fg
            return hl
          end,
          attributes = {
            mode = { bold = true },
          },
          icon_highlights = {
            file_icon = {
              statusline = false,
            },
          },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astroui.status"
        opts.statusline = {
          -- default highlight for the entire statusline
          hl = { fg = "fg", bg = "bg" },
          -- each element following is a component in astroui.status module

          -- add the vim mode component
          status.component.mode {
            -- enable mode text with padding as well as an icon before it
            mode_text = {
              icon = { kind = "VimIcon", padding = { right = 2, left = 2 } },
            },
            -- surround the component with a separators
            surround = {
              -- it's a left element, so use the left separator
              separator = "left",
              -- set the color of the surrounding based on the current mode using astronvim.utils.status module
              color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
            },
          },
          -- we want an empty space here so we can use the component builder to make a new section with just an empty string
          status.component.builder {
            { provider = "" },
            -- define the surrounding separator and colors to be used inside of the component
            -- and the color to the right of the separated out section
            surround = {
              separator = "left",
              color = { main = "blank_bg", right = "file_info_bg" },
            },
          },
          -- add a section for the currently opened file information
          status.component.file_info {
            -- enable the file_icon and disable the highlighting based on filetype
            filename = { fallback = "Empty" },
            -- disable some of the info
            filetype = false,
            file_read_only = false,
            -- add padding
            padding = { right = 1 },
            -- define the section separator
            surround = { separator = "left", condition = false },
          },
          status.component.git_branch {
            padding = { left = 1 },
          },
          status.component.git_diff {},
          status.component.fill(),
          status.component.fill(),
          status.component.fill(),
          status.component.diagnostics { surround = { separator = "right" } },
          status.component.lsp {
            lsp_progress = false,
            surround = { separator = "right" },
          },
          {
            status.component.builder {
              { provider = require("astroui").get_icon "FolderOpen" },
              padding = { left = 1 },
              hl = { fg = require("colors").carpYellow },
              surround = {
                separator = "right",
                color = { main = "file_info_bg", right = "file_info_bg" },
              },
            },
            status.component.file_info {
              filename = {
                fname = function(nr) return vim.fn.getcwd(nr) end,
                padding = { left = 1 },
              },
              filetype = false,
              file_icon = false,
              file_modified = false,
              file_read_only = false,
              surround = {
                separator = "none",
                color = "file_info_bg",
                condition = false,
              },
            },
          },
          status.component.builder {
            { provider = "" },
            -- define the surrounding separator and colors to be used inside of the component
            -- and the color to the right of the separated out section
            surround = {
              separator = "right",
              color = {
                main = require("colors").lotusBlue4,
                right = require("colors").lotusBlue4,
                left = "file_info_bg",
              },
            },
          },
          {
            status.component.builder {
              { provider = require("astroui").get_icon "ScrollText" },
              padding = { right = 1, left = 1 },
              hl = { fg = "bg" },
              surround = {
                separator = "right",
                color = { main = require("colors").lotusBlue5, left = require("colors").lotusBlue4 },
              },
            },
            status.component.nav {
              percentage = { padding = { right = 2 } },
              hl = { fg = "bg" },
              ruler = false,
              scrollbar = false,
              surround = { separator = "none", color = require("colors").lotusBlue5 },
            },
          },
        }
      end,
    },
  }
end
